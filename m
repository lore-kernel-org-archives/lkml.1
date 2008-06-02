Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbYFBKpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbYFBKpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYFBKpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:45:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56054 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYFBKpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:45:14 -0400
X-AuditID: 0ac90650-abc8bba0000062df-a3-4843cf388882
Message-ID: <4843CF30.9050801@hitachi.com>
Date: Mon, 02 Jun 2008 19:45:04 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: akpm@linux-foundation.org, sct@redhat.com
Cc: adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz, jbacik@redhat.com,
       cmm@us.ibm.com, tytso@mit.edu, sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: [PATCH 2/5] jbd: ordered data integrity fix
References: <4843CE15.6080506@hitachi.com>
In-Reply-To: <4843CE15.6080506@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 2/5] jbd: ordered data integrity fix

In ordered mode, if a buffer being dirtied exists in the committing
transaction, we write the buffer to the disk, move it from the
committing transaction to the running transaction, then dirty it.
But we don't have to remove the buffer from the committing
transaction when the buffer couldn't be written out, otherwise it
would miss the error and the committing transaction would not abort.

This patch adds an error check before removing the buffer from the
committing transaction.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd/transaction.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6.26-rc4/fs/jbd/transaction.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/jbd/transaction.c
+++ linux-2.6.26-rc4/fs/jbd/transaction.c
@@ -954,9 +954,10 @@ int journal_dirty_data(handle_t *handle,
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_brelse = 0;
 	struct journal_head *jh;
+	int ret = 0;
 
 	if (is_handle_aborted(handle))
-		return 0;
+		return ret;
 
 	jh = journal_add_journal_head(bh);
 	JBUFFER_TRACE(jh, "entry");
@@ -1067,7 +1068,16 @@ int journal_dirty_data(handle_t *handle,
 				   time if it is redirtied */
 			}
 
-			/* journal_clean_data_list() may have got there first */
+			/*
+			 * We cannot remove the buffer with io error from the
+			 * committing transaction, because otherwise it would
+			 * miss the error and the commit would not abort.
+			 */
+			if (unlikely(!buffer_uptodate(bh))) {
+				ret = -EIO;
+				goto no_journal;
+			}
+
 			if (jh->b_transaction != NULL) {
 				JBUFFER_TRACE(jh, "unfile from commit");
 				__journal_temp_unlink_buffer(jh);
@@ -1108,7 +1118,7 @@ no_journal:
 	}
 	JBUFFER_TRACE(jh, "exit");
 	journal_put_journal_head(jh);
-	return 0;
+	return ret;
 }
 
 /**


