Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZLFR6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZLFR6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbZLFR6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:58:31 -0500
Received: from www.tglx.de ([62.245.132.106]:58419 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010AbZLFR6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:58:30 -0500
Date: Sun, 6 Dec 2009 18:58:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] bkl core patches for 2.6.33
Message-ID: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest bkl-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git bkl-core-for-linus

Thanks,

	tglx

------------------>
Jonathan Corbet (2):
      pm_qos: remove BKL
      pm_qos: clean up racy global "name" variable

Thomas Gleixner (2):
      sys: Remove BKL from sys_reboot
      bkl: pushdown BKL locking to do_sysctl()


 arch/ia64/ia32/sys_ia32.c         |    2 --
 arch/mips/kernel/linux32.c        |    2 --
 arch/parisc/kernel/sys_parisc32.c |    2 --
 arch/powerpc/kernel/sys_ppc32.c   |    2 --
 arch/s390/kernel/compat_linux.c   |    2 --
 arch/sparc/kernel/sys_sparc32.c   |    2 --
 arch/x86/ia32/sys_ia32.c          |    2 --
 kernel/pm_qos_params.c            |   20 ++++++++------------
 kernel/sys.c                      |   14 +++++++-------
 kernel/sysctl.c                   |    6 ++++--
 10 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/arch/ia64/ia32/sys_ia32.c b/arch/ia64/ia32/sys_ia32.c
index 625ed8f..c0ed49c 100644
--- a/arch/ia64/ia32/sys_ia32.c
+++ b/arch/ia64/ia32/sys_ia32.c
@@ -1670,10 +1670,8 @@ sys32_sysctl (struct sysctl32 __user *args)
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-	lock_kernel();
 	ret = do_sysctl(namep, a32.nlen, oldvalp, (size_t __user *) &oldlen,
 			newvalp, (size_t) a32.newlen);
-	unlock_kernel();
 	set_fs(old_fs);
 
 	if (oldvalp && put_user (oldlen, (int __user *) compat_ptr(a32.oldlenp)))
diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 6242bc6..3744608 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -302,10 +302,8 @@ SYSCALL_DEFINE1(32_sysctl, struct sysctl_args32 __user *, args)
 		oldlenp = (size_t __user *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl((int __user *)A(tmp.name), tmp.nlen, (void __user *)A(tmp.oldval),
 			  oldlenp, (void __user *)A(tmp.newval), tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t __user *)addr) ||
diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
index 561388b..0d3bff2 100644
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -137,11 +137,9 @@ asmlinkage long sys32_sysctl(struct __sysctl_args32 __user *args)
 		oldlenp = (size_t *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl((int __user *)(u64)tmp.name, tmp.nlen,
 			  (void __user *)(u64)tmp.oldval, oldlenp,
 			  (void __user *)(u64)tmp.newval, tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t *)addr)) {
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index b97c2d6..934c0f9 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -555,11 +555,9 @@ asmlinkage long compat_sys_sysctl(struct __sysctl_args32 __user *args)
 			return -EFAULT;
 	}
 
-	lock_kernel();
 	error = do_sysctl(compat_ptr(tmp.name), tmp.nlen,
 			  compat_ptr(tmp.oldval), oldlenp,
 			  compat_ptr(tmp.newval), tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, oldlenp) ||
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 0debcec..ef9c2c1 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -562,10 +562,8 @@ asmlinkage long sys32_sysctl(struct __sysctl_args32 __user *args)
 		oldlenp = (size_t __user *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl(compat_ptr(tmp.name), tmp.nlen, compat_ptr(tmp.oldval),
 			  oldlenp, compat_ptr(tmp.newval), tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t __user *)addr) ||
diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index 04e28b2..6266ef0 100644
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -627,14 +627,12 @@ asmlinkage long sys32_sysctl(struct __sysctl_args32 __user *args)
 		oldlenp = (size_t __user *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl((int __user *)(unsigned long) tmp.name,
 			  tmp.nlen,
 			  (void __user *)(unsigned long) tmp.oldval,
 			  oldlenp,
 			  (void __user *)(unsigned long) tmp.newval,
 			  tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t __user *)addr) ||
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 9f55271..32a88e4 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -477,10 +477,8 @@ asmlinkage long sys32_sysctl(struct sysctl_ia32 __user *args32)
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-	lock_kernel();
 	ret = do_sysctl(namep, a32.nlen, oldvalp, (size_t __user *)&oldlen,
 			newvalp, (size_t) a32.newlen);
-	unlock_kernel();
 	set_fs(old_fs);
 
 	if (oldvalp && put_user(oldlen, (int __user *)compat_ptr(a32.oldlenp)))
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index dfdec52..3db49b9 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -29,7 +29,6 @@
 
 #include <linux/pm_qos_params.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/time.h>
@@ -344,37 +343,33 @@ int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
 }
 EXPORT_SYMBOL_GPL(pm_qos_remove_notifier);
 
-#define PID_NAME_LEN sizeof("process_1234567890")
-static char name[PID_NAME_LEN];
+#define PID_NAME_LEN 32
 
 static int pm_qos_power_open(struct inode *inode, struct file *filp)
 {
 	int ret;
 	long pm_qos_class;
+	char name[PID_NAME_LEN];
 
-	lock_kernel();
 	pm_qos_class = find_pm_qos_object_by_minor(iminor(inode));
 	if (pm_qos_class >= 0) {
 		filp->private_data = (void *)pm_qos_class;
-		sprintf(name, "process_%d", current->pid);
+		snprintf(name, PID_NAME_LEN, "process_%d", current->pid);
 		ret = pm_qos_add_requirement(pm_qos_class, name,
 					PM_QOS_DEFAULT_VALUE);
-		if (ret >= 0) {
-			unlock_kernel();
+		if (ret >= 0)
 			return 0;
-		}
 	}
-	unlock_kernel();
-
 	return -EPERM;
 }
 
 static int pm_qos_power_release(struct inode *inode, struct file *filp)
 {
 	int pm_qos_class;
+	char name[PID_NAME_LEN];
 
 	pm_qos_class = (long)filp->private_data;
-	sprintf(name, "process_%d", current->pid);
+	snprintf(name, PID_NAME_LEN, "process_%d", current->pid);
 	pm_qos_remove_requirement(pm_qos_class, name);
 
 	return 0;
@@ -385,13 +380,14 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 {
 	s32 value;
 	int pm_qos_class;
+	char name[PID_NAME_LEN];
 
 	pm_qos_class = (long)filp->private_data;
 	if (count != sizeof(s32))
 		return -EINVAL;
 	if (copy_from_user(&value, buf, sizeof(s32)))
 		return -EFAULT;
-	sprintf(name, "process_%d", current->pid);
+	snprintf(name, PID_NAME_LEN, "process_%d", current->pid);
 	pm_qos_update_requirement(pm_qos_class, name, value);
 
 	return  sizeof(s32);
diff --git a/kernel/sys.c b/kernel/sys.c
index 255475d..22ea955 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/utsname.h>
 #include <linux/mman.h>
-#include <linux/smp_lock.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/prctl.h>
@@ -349,6 +348,9 @@ void kernel_power_off(void)
 	machine_power_off();
 }
 EXPORT_SYMBOL_GPL(kernel_power_off);
+
+static DEFINE_MUTEX(reboot_mutex);
+
 /*
  * Reboot system call: for obvious reasons only root may call it,
  * and even root needs to set up some magic numbers in the registers
@@ -381,7 +383,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
 		cmd = LINUX_REBOOT_CMD_HALT;
 
-	lock_kernel();
+	mutex_lock(&reboot_mutex);
 	switch (cmd) {
 	case LINUX_REBOOT_CMD_RESTART:
 		kernel_restart(NULL);
@@ -397,20 +399,18 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
 	case LINUX_REBOOT_CMD_HALT:
 		kernel_halt();
-		unlock_kernel();
 		do_exit(0);
 		panic("cannot halt");
 
 	case LINUX_REBOOT_CMD_POWER_OFF:
 		kernel_power_off();
-		unlock_kernel();
 		do_exit(0);
 		break;
 
 	case LINUX_REBOOT_CMD_RESTART2:
 		if (strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1) < 0) {
-			unlock_kernel();
-			return -EFAULT;
+			ret = -EFAULT;
+			break;
 		}
 		buffer[sizeof(buffer) - 1] = '\0';
 
@@ -433,7 +433,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 		ret = -EINVAL;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&reboot_mutex);
 	return ret;
 }
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0d949c5..72040e5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1848,6 +1848,8 @@ int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *ol
 			return -EFAULT;
 	}
 
+	lock_kernel();
+
 	for (head = sysctl_head_next(NULL); head;
 			head = sysctl_head_next(head)) {
 		error = parse_table(name, nlen, oldval, oldlenp, 
@@ -1858,6 +1860,8 @@ int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *ol
 			break;
 		}
 	}
+
+	unlock_kernel();
 	return error;
 }
 
@@ -1873,10 +1877,8 @@ SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
 	if (error)
 		goto out;
 
-	lock_kernel();
 	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
 			  tmp.newval, tmp.newlen);
-	unlock_kernel();
 out:
 	return error;
 }
