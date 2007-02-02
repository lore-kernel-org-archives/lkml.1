Return-Path: <linux-kernel-owner+w=401wt.eu-S933361AbXBBXvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361AbXBBXvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 18:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933377AbXBBXvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 18:51:35 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:61153 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361AbXBBXve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 18:51:34 -0500
Subject: [patch 1/1] PM: Adds remount fs ro at suspend
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org
From: akuster@mvista.com
Date: Fri, 02 Feb 2007 13:50:10 -1000
Message-Id: <20070202235132.EDBDF1C448@hermes.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This adds the ability for the file system to remounted as read only during a
system suspend.  Log the mount points so when the resume occurs, they can be 
remounted back to their original states. This is so in an advent of a power
failure, we try our best to keep data from being corrupted or lost.

Signed-of-by: Armin Kuster <AKuster@mvista.com>


---

 fs/super.c           |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/Kconfig |   11 ++++++++
 kernel/power/main.c  |   13 +++++++++
 kernel/power/power.h |    6 ++++
 4 files changed, 97 insertions(+)

diff -puN fs/super.c~suspend_fs_ro fs/super.c
--- linux-2.6_sdio/fs/super.c~suspend_fs_ro	2007-02-01 13:35:46.000000000 -1000
+++ linux-2.6_sdio-akuster/fs/super.c	2007-02-01 13:35:50.000000000 -1000
@@ -47,6 +47,70 @@ struct file_system_type *get_fs_type(con
 LIST_HEAD(super_blocks);
 DEFINE_SPINLOCK(sb_lock);
 
+#ifdef CONFIG_SUSPEND_REMOUNTFS
+/*
+ * Code to preserve filesystem data during suspend.
+ */
+
+struct suspremount {
+struct super_block *sb;
+struct suspremount *next;
+};
+
+static struct suspremount *suspremount_list;
+
+void suspend_remount_log_fs(struct super_block *sb)
+{
+	struct suspremount *remountp;
+
+	if ((remountp = (struct suspremount *)
+		kmalloc(sizeof(struct suspremount), GFP_KERNEL)) != NULL) {
+		remountp->sb = sb;
+		remountp->next = suspremount_list;
+		suspremount_list = remountp;
+	}
+}
+
+/*
+ * Remount filesystems prior to suspend, in case the
+ * power source is removed (ie, battery removed) or
+ * battery dies during suspend.
+ */
+
+void suspend_remount_all_fs_ro(void)
+{
+	suspremount_list = NULL;
+	emergency_remount();
+}
+EXPORT_SYMBOL(suspend_remount_all_fs_ro);
+
+void resume_remount_fs_rw(void)
+{
+	struct suspremount *remountp;
+
+	remountp = suspremount_list;
+
+	while (remountp != NULL) {
+		struct suspremount *tp;
+		struct super_block *sb;
+		int flags, ret;
+
+		sb = remountp->sb;
+		flags = 0;
+		if (sb->s_op && sb->s_op->remount_fs) {
+			ret = sb->s_op->remount_fs(sb, &flags, NULL);
+			if (ret) printk("resume_remount_rw: error %d\n", ret);
+		}
+
+		tp = remountp->next;
+		kfree(remountp);
+		remountp = tp;
+	}
+	suspremount_list = NULL;
+}
+EXPORT_SYMBOL(resume_remount_fs_rw);
+#endif
+
 /**
  *	alloc_super	-	create new superblock
  *	@type:	filesystem type superblock should belong to
@@ -613,6 +677,9 @@ int do_remount_sb(struct super_block *sb
 		unlock_super(sb);
 		if (retval)
 			return retval;
+#ifdef CONFIG_SUSPEND_REMOUNTFS
+		suspend_remount_log_fs(sb);
+#endif
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 	return 0;
diff -puN kernel/power/Kconfig~suspend_fs_ro kernel/power/Kconfig
--- linux-2.6_sdio/kernel/power/Kconfig~suspend_fs_ro	2007-02-01 13:52:42.000000000 -1000
+++ linux-2.6_sdio-akuster/kernel/power/Kconfig	2007-02-02 06:20:13.000000000 -1000
@@ -131,3 +131,14 @@ config SUSPEND_SMP
 	bool
 	depends on HOTPLUG_CPU && X86 && PM
 	default y
+
+config SUSPEND_REMOUNTFS
+	bool "Remount file system as ro on suspend"
+	depends on PM
+	default n
+	---help---
+	  Say Y here if you want to remount filesystems as read only
+	  prior to suspend, in case the power source is
+	  removed (ie, battery removed) or battery dies during suspend.
+	  Upon resume, file system mount state is restored.
+
diff -puN kernel/power/main.c~suspend_fs_ro kernel/power/main.c
--- linux-2.6_sdio/kernel/power/main.c~suspend_fs_ro	2007-02-01 13:57:56.000000000 -1000
+++ linux-2.6_sdio-akuster/kernel/power/main.c	2007-02-01 13:58:08.000000000 -1000
@@ -67,6 +67,16 @@ static int suspend_prepare(suspend_state
 	if (error)
 		goto Enable_cpu;
 
+#ifdef CONFIG_SUSPEND_REMOUNTFS
+	/*
+	* Remount filesystems prior to suspend, in case the
+	* power source is removed (ie, battery removed) or
+	* battery dies during suspend.
+	*/
+
+	suspend_remount_all_fs_ro();
+#endif
+
 	if (freeze_processes()) {
 		error = -EAGAIN;
 		goto Thaw;
@@ -97,6 +107,9 @@ static int suspend_prepare(suspend_state
 	if (pm_ops->finish)
 		pm_ops->finish(state);
  Thaw:
+#ifdef CONFIG_SUSPEND_REMOUNTFS
+	resume_remount_fs_rw();
+#endif
 	thaw_processes();
  Enable_cpu:
 	enable_nonboot_cpus();
diff -puN kernel/power/power.h~suspend_fs_ro kernel/power/power.h
--- linux-2.6_sdio/kernel/power/power.h~suspend_fs_ro	2007-02-01 13:58:49.000000000 -1000
+++ linux-2.6_sdio-akuster/kernel/power/power.h	2007-02-01 13:59:03.000000000 -1000
@@ -177,3 +177,9 @@ extern int suspend_enter(suspend_state_t
 struct timeval;
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
 				unsigned int, char *);
+
+/* remount file system read only on suspend
+ * and retore to rw on resume
+ */
+extern void suspend_remount_all_fs_ro(void);
+extern void resume_remount_fs_rw(void);
_
