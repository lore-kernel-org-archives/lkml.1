Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbXIYRqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbXIYRqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXIYRqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:46:45 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35194 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXIYRqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:46:45 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: randy.dunlap@oracle.com, akpm@linux-foundation.org,
       unionfs@filesystems.org, linux-kernel@vger.kernel.org,
       ezk@cs.sunysb.edu
Cc: ezk@cs.sunysb.edu, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/1] Unionfs: move poison #define into poison.h
Date: Tue, 25 Sep 2007 13:45:19 -0400
Message-Id: <1190742319943-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <20070925102637.79e1dc75.randy.dunlap@oracle.com>
References: <20070925102637.79e1dc75.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This also fixes a compile warning on 64-bit systems.

Cc: ezk@cs.sunysb.edu
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/debug.c     |   12 ++----------
 fs/unionfs/union.h     |    1 +
 include/linux/poison.h |    3 +++
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index f678534..aa6a76a 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -25,14 +25,6 @@
 		}							\
 	} while (0)
 
-#if BITS_PER_LONG == 32
-#define POISONED_PTR		((void*) 0x5a5a5a5a)
-#elif BITS_PER_LONG == 64
-#define POISONED_PTR		((void*) 0x5a5a5a5a5a5a5a5a)
-#else
-#error Unknown BITS_PER_LONG value
-#endif /* BITS_PER_LONG != known */
-
 /*
  * __unionfs_check_{inode,dentry,file} perform exhaustive sanity checking on
  * the fan-out of various Unionfs objects.  We check that no lower objects
@@ -93,7 +85,7 @@ void __unionfs_check_inode(const struct inode *inode,
 				printk(" Ci5: inode/linode=%p:%p bindex=%d "
 				       "istart/end=%d:%d\n", inode,
 				       lower_inode, bindex, istart, iend);
-			} else if (lower_inode == POISONED_PTR) {
+			} else if (lower_inode == UNIONFS_POISONED_PTR) {
 				/* freed inode! */
 				PRINT_CALLER(fname, fxn, line);
 				printk(" Ci6: inode/linode=%p:%p bindex=%d "
@@ -261,7 +253,7 @@ void __unionfs_check_dentry(const struct dentry *dentry,
 				printk(" CI5: dentry/linode=%p:%p bindex=%d "
 				       "istart/end=%d:%d\n", dentry,
 				       lower_inode, bindex, istart, iend);
-			} else if (lower_inode == POISONED_PTR) {
+			} else if (lower_inode == UNIONFS_POISONED_PTR) {
 				/* freed inode! */
 				PRINT_CALLER(fname, fxn, line);
 				printk(" CI6: dentry/linode=%p:%p bindex=%d "
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 9ec5f82..3b6881a 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -43,6 +43,7 @@
 #include <linux/fs_stack.h>
 #include <linux/magic.h>
 #include <linux/log2.h>
+#include <linux/poison.h>
 
 #include <asm/mman.h>
 #include <asm/system.h>
diff --git a/include/linux/poison.h b/include/linux/poison.h
index d93c300..c81118b 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -38,6 +38,9 @@
 /********** fs/jbd/journal.c **********/
 #define JBD_POISON_FREE	0x5b
 
+/********** fs/unionfs/debug.c **********/
+#define UNIONFS_POISONED_PTR	((void *) 0x75757575)
+
 /********** drivers/base/dmapool.c **********/
 #define	POOL_POISON_FREED	0xa7	/* !inuse */
 #define	POOL_POISON_ALLOCATED	0xa9	/* !initted */
-- 
1.5.2.2.238.g7cbf2f2

