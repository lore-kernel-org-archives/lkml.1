Return-Path: <linux-kernel-owner+w=401wt.eu-S965685AbXAZOO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965685AbXAZOO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965689AbXAZOO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:14:58 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54481 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965685AbXAZOO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:14:57 -0500
Message-ID: <45BA0CDD.5070604@hitachi.com>
Date: Fri, 26 Jan 2007 23:14:53 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: akpm@osdl.org, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 3/4] coredump: add a sysctl parameter to disable the core dump
    omitting feature
References: <45BA0A93.30004@hitachi.com>
In-Reply-To: <45BA0A93.30004@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds kernel.core_flags_enable sysctl parameter, which allows
root user to disable the /proc/<pid>/core_flags feature globally.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/binfmt_elf.c         |    3 ++-
 fs/binfmt_elf_fdpic.c   |    3 ++-
 fs/exec.c               |    1 +
 include/linux/binfmts.h |    1 +
 include/linux/sysctl.h  |    1 +
 kernel/sysctl.c         |   11 +++++++++++
 6 files changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6.20-rc4-mm1/fs/exec.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/fs/exec.c
+++ linux-2.6.20-rc4-mm1/fs/exec.c
@@ -61,6 +61,7 @@
 int core_uses_pid;
 char core_pattern[128] = "core";
 int suid_dumpable = 0;
+unsigned int sysctl_core_flags_enable = 0x1;
 
 /* Protect dumpable and core_flags in each mm_struct from race condition.  */
 DEFINE_SPINLOCK(dump_bits_lock);
Index: linux-2.6.20-rc4-mm1/include/linux/sysctl.h
===================================================================
--- linux-2.6.20-rc4-mm1.orig/include/linux/sysctl.h
+++ linux-2.6.20-rc4-mm1/include/linux/sysctl.h
@@ -160,6 +160,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_CORE_FLAGS_ENABLE=77, /* int: enabled flags in core_flags */
 };
 
 
Index: linux-2.6.20-rc4-mm1/kernel/sysctl.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/kernel/sysctl.c
+++ linux-2.6.20-rc4-mm1/kernel/sysctl.c
@@ -69,6 +69,7 @@ extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
+extern unsigned int sysctl_core_flags_enable;
 extern int pid_max;
 extern int min_free_kbytes;
 extern int printk_ratelimit_jiffies;
@@ -354,6 +355,16 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+	{
+		.ctl_name	= KERN_CORE_FLAGS_ENABLE,
+		.procname	= "core_flags_enable",
+		.data		= &sysctl_core_flags_enable,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.ctl_name	= KERN_TAINTED,
Index: linux-2.6.20-rc4-mm1/include/linux/binfmts.h
===================================================================
--- linux-2.6.20-rc4-mm1.orig/include/linux/binfmts.h
+++ linux-2.6.20-rc4-mm1/include/linux/binfmts.h
@@ -81,6 +81,7 @@ extern int suid_dumpable;
 
 /* Core dump control flags */
 #define CORE_OMIT_ANON_SHARED 0x1  /* don't dump anonymous shared memory */
+extern unsigned int sysctl_core_flags_enable;
 
 extern int setup_arg_pages(struct linux_binprm * bprm,
 			   unsigned long stack_top,
Index: linux-2.6.20-rc4-mm1/fs/binfmt_elf.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/fs/binfmt_elf.c
+++ linux-2.6.20-rc4-mm1/fs/binfmt_elf.c
@@ -1597,7 +1597,8 @@ static int elf_core_dump(long signr, str
 	}
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
-	__set_dump_bits(core_flags, current->mm->core_flags);
+	__set_dump_bits(core_flags,
+			current->mm->core_flags & sysctl_core_flags_enable);
 
 	/* Write program headers for segments dump */
 	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
Index: linux-2.6.20-rc4-mm1/fs/binfmt_elf_fdpic.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/fs/binfmt_elf_fdpic.c
+++ linux-2.6.20-rc4-mm1/fs/binfmt_elf_fdpic.c
@@ -1703,7 +1703,8 @@ static int elf_fdpic_core_dump(long sign
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	__set_dump_bits(core_flags, current->mm->core_flags);
+	__set_dump_bits(core_flags,
+			current->mm->core_flags & sysctl_core_flags_enable;);
 
 	/* write program headers for segments dump */
 	for (



