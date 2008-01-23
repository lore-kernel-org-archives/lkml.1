Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbYAWBAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbYAWBAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 20:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYAWBAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 20:00:22 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:37232 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751761AbYAWBAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 20:00:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=sMzRpq2Nqg+uJWJ01vHeIw5RmQKbL1qo47oCXzD5eT1I8oRF45EZZsn5FY75441Sl2I8RTyH8eK3wLsIbVdYlxPRIcLi3/LbkU5KtCNO5k+sqz4SeLAi+6o5RY6XL6CvtTuqSZhXNseGlPFFyG8Avv3K3uPKy0HBMJSVCUAKDI0=  ;
X-YMail-OSG: 9FZRbVcVM1ko3TDf4Fkawr38rElfUeldwDvJmnGYar8Fz5tK1yaYT5Oe8EyOx1Ys03osH8sWIQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RESEND] Minimal fix for private_list handling races
Date: Wed, 23 Jan 2008 12:00:02 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20080122171025.GB4485@duck.suse.cz>
In-Reply-To: <20080122171025.GB4485@duck.suse.cz>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TGplH81UAXcs723"
Message-Id: <200801231200.03016.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_TGplH81UAXcs723
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 23 January 2008 04:10, Jan Kara wrote:
>   Hi,
>
>   as I got no answer for a week, I'm resending this fix for races in
> private_list handling. Andrew, do you like them more than the previous
> version?

FWIW, I reviewed this, and it looks OK although I think some comments
would be in order.

What would be really nice is to avoid the use of b_assoc_buffers
completely in this function like I've attempted (untested). I don't
know if you'd actually call that an improvement...?

Couple of things I noticed while looking at this code.

- What is osync_buffers_list supposed to do? I couldn't actually
  work it out. Why do we care about waiting for these buffers on
  here that were added while waiting for writeout of other buffers
  to finish? Can we just remove it completely? I must be missing
  something.

- What are the get_bh(bh) things supposed to do? Protect the lifetime
  of a given bh while "lock" is dropped? That's nice, ignoring the
  fact that we brelse(bh) *before* taking the lock again... but isn't
  every single other buffer that we _have't_ elevated its reference
  exposed to exactly the same lifetime problem? IOW, either it is not
  required at all, or it is required for _all_ buffers? (my patch
  should fix this).

Hmm, now I remember why I rewrote this file :P

--Boundary-00=_TGplH81UAXcs723
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fs-fsync_buffers_list-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fs-fsync_buffers_list-fix.patch"

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -792,47 +792,53 @@ EXPORT_SYMBOL(__set_page_dirty_buffers);
  */
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 {
+	struct buffer_head *batch[16];
+	int i, idx, done;
 	struct buffer_head *bh;
-	struct list_head tmp;
 	int err = 0, err2;
 
-	INIT_LIST_HEAD(&tmp);
-
+again:
 	spin_lock(lock);
+	idx = 0;
 	while (!list_empty(list)) {
 		bh = BH_ENTRY(list->next);
 		__remove_assoc_queue(bh);
 		if (buffer_dirty(bh) || buffer_locked(bh)) {
-			list_add(&bh->b_assoc_buffers, &tmp);
-			if (buffer_dirty(bh)) {
-				get_bh(bh);
-				spin_unlock(lock);
-				/*
-				 * Ensure any pending I/O completes so that
-				 * ll_rw_block() actually writes the current
-				 * contents - it is a noop if I/O is still in
-				 * flight on potentially older contents.
-				 */
-				ll_rw_block(SWRITE, 1, &bh);
-				brelse(bh);
-				spin_lock(lock);
-			}
+			batch[idx++] = bh;
+			get_bh(bh);
 		}
+
+		if (idx == 16)
+			break;
 	}
+	done = list_empty(list);
+	spin_unlock(lock);
 
-	while (!list_empty(&tmp)) {
-		bh = BH_ENTRY(tmp.prev);
-		list_del_init(&bh->b_assoc_buffers);
-		get_bh(bh);
-		spin_unlock(lock);
+	for (i = 0; i < idx; i++) {
+		bh = batch[i];
+		if (buffer_dirty(bh)) {
+			/*
+			 * Ensure any pending I/O completes so
+			 * that ll_rw_block() actually writes
+			 * the current contents - it is a noop
+			 * if I/O is still in flight on
+			 * potentially older contents.
+			 */
+			ll_rw_block(SWRITE, 1, &bh);
+		}
+	}
+	for (i = 0; i < idx; i++) {
+		bh = batch[i];
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh))
 			err = -EIO;
 		brelse(bh);
-		spin_lock(lock);
 	}
+
+	idx = 0;
+	if (!done)
+		goto again;
 	
-	spin_unlock(lock);
 	err2 = osync_buffers_list(lock, list);
 	if (err)
 		return err;

--Boundary-00=_TGplH81UAXcs723--
