Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbYJQMlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbYJQMlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYJQMlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:41:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:22042 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbYJQMlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oBuREY7yS3c/PjTQ6HPJSAc1MTOpqxLgaCiXts/kYiwBvoPbnb3U1K7TWWnz5fsAyN
         nKUQDtXiqNUY+7gh/mibLAS4TYFCpbC2DPVJRdPyekEKQltiU03HfHnndKvQ/lK+DqKE
         +O5NQgPcf2X9KsW8XeqI0PYlcECS+BHN+kmr0=
Date: Fri, 17 Oct 2008 16:44:41 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 11/31] proc: move /proc/kmsg creation to fs/proc/kmsg.c
Message-ID: <20081017124441.GL22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From cc7092760336b7886f9e96631675ff934d9f1e01 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 4 Oct 2008 14:39:12 +0400
Subject: [PATCH 11/31] proc: move /proc/kmsg creation to fs/proc/kmsg.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/internal.h  |    1 -
 fs/proc/kmsg.c      |   12 +++++++++---
 fs/proc/proc_misc.c |    3 ---
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index d5bf4de..3e8aeb8 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -61,7 +61,6 @@ extern const struct file_operations proc_smaps_operations;
 extern const struct file_operations proc_clear_refs_operations;
 extern const struct file_operations proc_pagemap_operations;
 extern const struct file_operations proc_net_operations;
-extern const struct file_operations proc_kmsg_operations;
 extern const struct inode_operations proc_net_inode_operations;
 
 void free_proc_entry(struct proc_dir_entry *de);
diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index 9fd5df3..7ca7834 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -10,13 +10,12 @@
 #include <linux/time.h>
 #include <linux/kernel.h>
 #include <linux/poll.h>
+#include <linux/proc_fs.h>
 #include <linux/fs.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-#include "internal.h"
-
 extern wait_queue_head_t log_wait;
 
 extern int do_syslog(int type, char __user *bug, int count);
@@ -49,9 +48,16 @@ static unsigned int kmsg_poll(struct file *file, poll_table *wait)
 }
 
 
-const struct file_operations proc_kmsg_operations = {
+static const struct file_operations proc_kmsg_operations = {
 	.read		= kmsg_read,
 	.poll		= kmsg_poll,
 	.open		= kmsg_open,
 	.release	= kmsg_release,
 };
+
+static int __init proc_kmsg_init(void)
+{
+	proc_create("kmsg", S_IRUSR, NULL, &proc_kmsg_operations);
+	return 0;
+}
+module_init(proc_kmsg_init);
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 2dbe0aa..8ae7d38 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -607,9 +607,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-#ifdef CONFIG_PRINTK
-	proc_create("kmsg", S_IRUSR, NULL, &proc_kmsg_operations);
-#endif
 #ifdef CONFIG_FILE_LOCKING
 	proc_create("locks", 0, NULL, &proc_locks_operations);
 #endif
-- 
1.5.6.5

