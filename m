Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbYGEC3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbYGEC3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 22:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYGEC3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 22:29:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:51905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYGEC3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 22:29:35 -0400
Date: Fri, 4 Jul 2008 19:29:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: akpm@linux-foundation.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: PATCH] fix potential latency issues in JBD's journal code
Message-ID: <20080704192929.2c4dd4ca@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 4 Jul 2008 19:26:16 -0700
Subject: [PATCH] fix potential latency issues in JBD's journal code
CC: akpm@linux-foundation.org
CC: jens.axboe@oracle.com

This is a follow-on to commit 18ce3751ccd488c78d3827e9f6bf54e6322676fb
(Properly notify block layer of sync writes)
which fixed some severe latency issues due to a "submit IO and then wait for it"
pattern, which got fixed by properly informing the block layer that the IOs in
question are going to be waited on immediately after a batch submission.

In the JBD layer, some of the core journal routines have the exact same pattern
of code, and... surprising (or not)... they're also not using the WRITE_SYNC
variant to inform the blocklayer.

This patch modifies two key places that submit IO that then immediately will
get waited on. The JBD code is slightly convoluted, but after some chasing of
abstraction layers, these instances seem to really be of this pattern.
There's one case in checkpoint.c which is another candidate, but I've not
been able to get my head around the code enough to verify that that one
really is of this pattern as well, so for now I'll leave that one as is.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/jbd/commit.c |    4 ++--
 fs/jbd/revoke.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 5a8ca61..0b348de 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -165,7 +165,7 @@ static void journal_do_submit_data(struct buffer_head **wbuf, int bufs)
 	for (i = 0; i < bufs; i++) {
 		wbuf[i]->b_end_io = end_buffer_write_sync;
 		/* We use-up our safety reference in submit_bh() */
-		submit_bh(WRITE, wbuf[i]);
+		submit_bh(WRITE_SYNC, wbuf[i]);
 	}
 }
 
@@ -622,7 +622,7 @@ start_journal_io:
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(WRITE, bh);
+				submit_bh(WRITE_SYNC, bh);
 			}
 			cond_resched();
 
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 1bb43e9..366ee20 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -616,7 +616,7 @@ static void flush_descriptor(journal_t *journal,
 	set_buffer_jwrite(bh);
 	BUFFER_TRACE(bh, "write");
 	set_buffer_dirty(bh);
-	ll_rw_block(SWRITE, 1, &bh);
+	ll_rw_block(SWRITE_SYNC, 1, &bh);
 }
 #endif
 
-- 
1.5.5.1


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
