Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbYDRNhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbYDRNhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbYDRNh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:37:26 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34263 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbYDRNhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:37:24 -0400
X-AuditID: 0ac90647-ab7a0ba0000012c0-9a-4808a4127487
Message-ID: <4808A40E.7010200@hitachi.com>
Date: Fri, 18 Apr 2008 22:37:18 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: akpm@linux-foundation.org, sct@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: [PATCH 2/4] jbd: ordered data integrity fix
References: <48089B86.5020108@hitachi.com>
In-Reply-To: <48089B86.5020108@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 2/4] jbd: ordered data integrity fix

In ordered mode, if a buffer being dirtied exists in the committing
transaction, we write the buffer to the disk, move it from the
committing transaction to the running transaction, then dirty it.
But we don't have to remove the buffer from the committing
transaction when the buffer couldn't be written out, otherwise it
breaks the ordered mode rule.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd/transaction.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6.25/fs/jbd/transaction.c
===================================================================
--- linux-2.6.25.orig/fs/jbd/transaction.c
+++ linux-2.6.25/fs/jbd/transaction.c
@@ -941,9 +941,10 @@ int journal_dirty_data(handle_t *handle,
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_brelse = 0;
 	struct journal_head *jh;
+	int ret = 0;
 
 	if (is_handle_aborted(handle))
-		return 0;
+		return ret;
 
 	jh = journal_add_journal_head(bh);
 	JBUFFER_TRACE(jh, "entry");
@@ -1054,7 +1055,16 @@ int journal_dirty_data(handle_t *handle,
 				   time if it is redirtied */
 			}
 
-			/* journal_clean_data_list() may have got there first */
+			/*
+			 * We shouldn't remove the buffer from the committing
+			 * transaction if it has failed to be written.
+			 * Otherwise, it breaks the ordered mode rule.
+			 */
+			if (unlikely(!buffer_uptodate(bh))) {
+				ret = -EIO;
+				goto no_journal;
+			}
+
 			if (jh->b_transaction != NULL) {
 				JBUFFER_TRACE(jh, "unfile from commit");
 				__journal_temp_unlink_buffer(jh);
@@ -1095,7 +1105,7 @@ no_journal:
 	}
 	JBUFFER_TRACE(jh, "exit");
 	journal_put_journal_head(jh);
-	return 0;
+	return ret;
 }
 
 /**


