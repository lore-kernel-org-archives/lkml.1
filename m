Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZGKHwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZGKHwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbZGKHwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:52:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43816 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbZGKHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:52:10 -0400
Date: Sat, 11 Jul 2009 09:52:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: -tip: block, fuse: Fix build error in fs/fuse/dev.c
Message-ID: <20090711075201.GA6517@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's upstream tree build (x86, 64-bit, allnoconfig+CONFIG_FUSE) 
failed with this build error:

  fs/fuse/dev.c: In function ‘request_end’:
  fs/fuse/dev.c:290: error: ‘BLK_RW_SYNC’ undeclared (first use in this function)
  fs/fuse/dev.c:290: error: (Each undeclared identifier is reported only once
  fs/fuse/dev.c:290: error: for each function it appears in.)
  fs/fuse/dev.c:291: error: ‘BLK_RW_ASYNC’ undeclared (first use in this function)

Due to commit:

  8aa7e84: Fix congestion_wait() sync/async vs read/write confusion

Creating a dependency of BDI callbacks on the BLK_RW_* constants,
while those constants are only defined if CONFIG_BLOCK is enabled.

Fix it the simplest way for now, by moving the definitions early
in blkdev.h (this cannot break anything), but the real fix would
be to split up blkdev.h into blkdev-types.h and blkdev-api.h and
make only the API definitions/declarations dependent on
CONFIG_BLOCK.

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/blkdev.h |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 49ae079..a3cdc6d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1,6 +1,14 @@
 #ifndef _LINUX_BLKDEV_H
 #define _LINUX_BLKDEV_H
 
+/*
+ * Definitions used on the !CONFIG_BLOCK case too:
+ */
+enum {
+	BLK_RW_ASYNC	= 0,
+	BLK_RW_SYNC	= 1,
+};
+
 #ifdef CONFIG_BLOCK
 
 #include <linux/sched.h>
@@ -70,11 +78,6 @@ enum rq_cmd_type_bits {
 	REQ_TYPE_ATA_PC,
 };
 
-enum {
-	BLK_RW_ASYNC	= 0,
-	BLK_RW_SYNC	= 1,
-};
-
 /*
  * For request of type REQ_TYPE_LINUX_BLOCK, rq->cmd[0] is the opcode being
  * sent down (similar to how REQ_TYPE_BLOCK_PC means that ->cmd[] holds a

