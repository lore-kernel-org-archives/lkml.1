Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbYGEFAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbYGEFAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 01:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYGEFAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 01:00:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:33940 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbYGEFAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 01:00:41 -0400
Date: Fri, 4 Jul 2008 22:00:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH] fix potential latency issues in JBD's journal code
Message-ID: <20080704220038.602c9c3c@infradead.org>
In-Reply-To: <20080704192929.2c4dd4ca@infradead.org>
References: <20080704192929.2c4dd4ca@infradead.org>
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

Helps if I send the patch that compiles ;)

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] fix potential latency issues in JBD's journal code

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
been able to get my head around the code enough to verify that this one
really is of this pattern.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/jbd/commit.c |    5 +++--
 fs/jbd/revoke.c |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 5a8ca61..f3bc0b0 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -15,6 +15,7 @@
 
 #include <linux/time.h>
 #include <linux/fs.h>
+#include <linux/bio.h>
 #include <linux/jbd.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -165,7 +166,7 @@ static void journal_do_submit_data(struct buffer_head **wbuf, int bufs)
 	for (i = 0; i < bufs; i++) {
 		wbuf[i]->b_end_io = end_buffer_write_sync;
 		/* We use-up our safety reference in submit_bh() */
-		submit_bh(WRITE, wbuf[i]);
+		submit_bh(WRITE_SYNC, wbuf[i]);
 	}
 }
 
@@ -622,7 +623,7 @@ start_journal_io:
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(WRITE, bh);
+				submit_bh(WRITE_SYNC, bh);
 			}
 			cond_resched();
 
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 1bb43e9..ce92dd5 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -67,6 +67,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/init.h>
+#include <linux/bio.h>
 #endif
 #include <linux/log2.h>
 
@@ -616,7 +617,7 @@ static void flush_descriptor(journal_t *journal,
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
