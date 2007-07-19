Return-Path: <linux-kernel-owner+w=401wt.eu-S1763027AbXGSDHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763027AbXGSDHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbXGSDHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:07:31 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58403 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbXGSDHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:07:30 -0400
Subject: [PATCH] fix ext4/JBD2 build warnings
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, jrs@us.ibm.com
In-Reply-To: <469E8822.7000104@garzik.org>
References: <469E8822.7000104@garzik.org>
Content-Type: text/plain; charset=UTF-8
Organization: IBM Linux Technology Center
Date: Wed, 18 Jul 2007 20:07:31 -0700
Message-Id: <1184814451.19760.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 17:37 -0400, Jeff Garzik wrote:
> It seems jbd_debug() might need modification:
> 
Looking at the current linus-git tree jbd_debug() define in
include/linux/jbd2.h

extern u8 journal_enable_debug;

#define jbd_debug(n, f, a...)                                           \
        do {                                                            \
                if ((n) <= journal_enable_debug) {                      \
                        printk (KERN_DEBUG "(%s, %d): %s: ",            \
                                __FILE__, __LINE__, __FUNCTION__);      \
                        printk (f, ## a);                               \
                }                                                       \
        } while (0)
> fs/ext4/inode.c: In function ‘ext4_write_inode’:
> fs/ext4/inode.c:2906: warning: comparison is always true due to limited 
> range of data type
> 
> fs/jbd2/recovery.c: In function ‘jbd2_journal_recover’:
> fs/jbd2/recovery.c:254: warning: comparison is always true due to 
> limited range of data type
> fs/jbd2/recovery.c:257: warning: comparison is always true due to 
> limited range of data type
> 
> fs/jbd2/recovery.c: In function ‘jbd2_journal_skip_recovery’:
> fs/jbd2/recovery.c:301: warning: comparison is always true due to 
> limited range of data type
> 
Noticed all warnings are occurs when the debug level is 0. Then found
the "jbd2: Move jbd2-debug file to debugfs" patch
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0f49d5d019afa4e94253bfc92f0daca3badb990b

changed the jbd2_journal_enable_debug from int type to u8, makes the
jbd_debug comparision is always true when the debugging level is 0. Thus
the compile warning occurs. 

Thought about changing the jbd2_journal_enable_debug data type back to
int, but can't, because the jbd2-debug is moved to debug fs, where
calling debugfs_create_u8() to create the debugfs entry needs the value
to be u8 type.

Even if we changed the data type back to int, the code is still buggy,
kernel should not print jbd2 debug message if the
jbd2_journal_enable_debug is set to 0. But this is not the case.

The fix is change the level of debugging to 1. The same should fixed in
ext3/JBD, but currently ext3 jbd-debug via /proc fs is broken, so we
probably should fix it all together.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext4/inode.c    |    2 +-
 fs/jbd2/recovery.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.22/fs/ext4/inode.c
===================================================================
--- linux-2.6.22.orig/fs/ext4/inode.c	2007-07-18 19:23:58.000000000 -0700
+++ linux-2.6.22/fs/ext4/inode.c	2007-07-18 19:25:08.000000000 -0700
@@ -2903,7 +2903,7 @@ int ext4_write_inode(struct inode *inode
 		return 0;
 
 	if (ext4_journal_current_handle()) {
-		jbd_debug(0, "called recursively, non-PF_MEMALLOC!\n");
+		jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
 		dump_stack();
 		return -EIO;
 	}
Index: linux-2.6.22/fs/jbd2/recovery.c
===================================================================
--- linux-2.6.22.orig/fs/jbd2/recovery.c	2007-07-18 19:25:51.000000000 -0700
+++ linux-2.6.22/fs/jbd2/recovery.c	2007-07-18 19:26:13.000000000 -0700
@@ -251,10 +251,10 @@ int jbd2_journal_recover(journal_t *jour
 	if (!err)
 		err = do_one_pass(journal, &info, PASS_REPLAY);
 
-	jbd_debug(0, "JBD: recovery, exit status %d, "
+	jbd_debug(1, "JBD: recovery, exit status %d, "
 		  "recovered transactions %u to %u\n",
 		  err, info.start_transaction, info.end_transaction);
-	jbd_debug(0, "JBD: Replayed %d and revoked %d/%d blocks\n",
+	jbd_debug(1, "JBD: Replayed %d and revoked %d/%d blocks\n",
 		  info.nr_replays, info.nr_revoke_hits, info.nr_revokes);
 
 	/* Restart the log at the next transaction ID, thus invalidating
@@ -298,7 +298,7 @@ int jbd2_journal_skip_recovery(journal_t
 #ifdef CONFIG_JBD2_DEBUG
 		int dropped = info.end_transaction - be32_to_cpu(sb->s_sequence);
 #endif
-		jbd_debug(0,
+		jbd_debug(1,
 			  "JBD: ignoring %d transaction%s from the journal.\n",
 			  dropped, (dropped == 1) ? "" : "s");
 		journal->j_transaction_sequence = ++info.end_transaction;



