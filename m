Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbYAZQGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbYAZQGO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbYAZP4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:56:37 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757257AbYAZP4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:56:34 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 26/52] [microblaze] IPC support
Date: Thu, 24 Jan 2008 16:03:01 +0100
Message-Id: <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/sys_microblaze.c |  331 +++++++++++++++++++++++++++++++
 include/asm-microblaze/ipc.h            |   18 ++
 include/asm-microblaze/ipcbuf.h         |   38 ++++
 3 files changed, 387 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/sys_microblaze.c
 create mode 100644 include/asm-microblaze/ipc.h
 create mode 100644 include/asm-microblaze/ipcbuf.h

diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
new file mode 100644
index 0000000..a14328f
--- /dev/null
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -0,0 +1,331 @@
+/*
+ * arch/microblaze/kernel/sys_microblaze.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ * Copyright (C) 2007 PetaLogix
+ *
+ * Authors:
+ * John Williams <john.williams@petalogix.com>
+ * Yasushi SHOJI <yashi@atmark-techno.com>
+ * Tetsuya OHKAWA <tetsuya@atmark-techno.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/syscalls.h>
+#include <linux/sem.h>
+#include <linux/msg.h>
+#include <linux/shm.h>
+#include <linux/stat.h>
+#include <linux/mman.h>
+#include <linux/sys.h>
+#include <linux/ipc.h>
+#include <linux/utsname.h>
+#include <linux/file.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+
+#include <asm/uaccess.h>
+#include <linux/ipc.h>
+#include <asm/semaphore.h>
+#include <asm/unistd.h>
+
+/*
+ * sys_ipc() is the de-multiplexer for the SysV IPC calls..
+ *
+ * This is really horribly ugly.
+ */
+int
+sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
+{
+	int version, ret;
+
+	version = call >> 16; /* hack for backward compatibility */
+	call &= 0xffff;
+
+	ret = -EINVAL;
+	switch (call) {
+	case SEMOP:
+		ret = sys_semop(first, (struct sembuf *)ptr, second);
+		break;
+	case SEMGET:
+		ret = sys_semget(first, second, third);
+		break;
+	case SEMCTL:
+	{
+		union semun fourth;
+
+		if (!ptr)
+			break;
+		if ((ret = access_ok(VERIFY_READ, ptr,
+					sizeof(long)) ? 0 : -EFAULT)
+			|| (ret = get_user(fourth.__pad, (void **)ptr)))
+			break;
+		ret = sys_semctl(first, second, third, fourth);
+		break;
+	}
+	case MSGSND:
+		ret = sys_msgsnd(first, (struct msgbuf *) ptr, second, third);
+		break;
+	case MSGRCV:
+		switch (version) {
+		case 0: {
+			struct ipc_kludge tmp;
+
+			if (!ptr)
+				break;
+			if ((ret = access_ok(VERIFY_READ, ptr,
+					sizeof(tmp)) ? 0 : -EFAULT)
+				|| (ret = copy_from_user(&tmp,
+						(struct ipc_kludge *) ptr,
+						sizeof(tmp))))
+				break;
+			ret = sys_msgrcv(first, tmp.msgp, second, tmp.msgtyp,
+					third);
+			break;
+			}
+		default:
+			ret = sys_msgrcv(first, (struct msgbuf *) ptr,
+					second, fifth, third);
+			break;
+		}
+		break;
+	case MSGGET:
+		ret = sys_msgget((key_t) first, second);
+		break;
+	case MSGCTL:
+		ret = sys_msgctl(first, second, (struct msqid_ds *) ptr);
+		break;
+	case SHMAT:
+		switch (version) {
+		default: {
+			ulong raddr;
+
+			if ((ret = access_ok(VERIFY_WRITE, (ulong *) third,
+					sizeof(ulong)) ? 0 : -EFAULT))
+				break;
+			ret = do_shmat(first, (char *) ptr, second, &raddr);
+			if (ret)
+				break;
+			ret = put_user(raddr, (ulong *) third);
+			break;
+			}
+		case 1:	/* iBCS2 emulator entry point */
+			if (!segment_eq(get_fs(), get_ds()))
+				break;
+			ret = do_shmat(first, (char *) ptr, second,
+					(ulong *) third);
+			break;
+		}
+		break;
+	case SHMDT:
+		ret = sys_shmdt((char *)ptr);
+		break;
+	case SHMGET:
+		ret = sys_shmget(first, second, third);
+		break;
+	case SHMCTL:
+		ret = sys_shmctl(first, second, (struct shmid_ds *) ptr);
+		break;
+	}
+
+	return ret;
+}
+
+long execve(const char *filename, char **argv, char **envp)
+{
+	struct pt_regs regs;
+	int ret;
+
+	memset(&regs, 0, sizeof(struct pt_regs));
+	local_save_flags(regs.msr);
+	ret = do_execve((char *)filename, (char __user * __user *)argv,
+			(char __user * __user *)envp, &regs);
+
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Save argc to the register structure for userspace.
+	 */
+	regs.r5 = ret; /* FIXME */
+
+	/*
+	 * We were successful. We won't be returning to our caller, but
+	 * instead to user space by manipulating the kernel stack.
+	 */
+	asm volatile ("addk	r5, r0, %0	\n\t"
+			"addk	r6, r0, %1	\n\t"
+			/* copy regs to top of stack */
+			"brlid	r15, memmove	\n\t"
+			"addik	r7, r0, %2	\n\t"
+			"brid	ret_to_user	\n\t"
+			/* reposition stack pointer */
+			"addk	r1, r0, r3	\n\t"
+			:
+			: "r" (task_pt_regs(current)),
+			"r" (&regs),
+			"i" (sizeof(regs))
+			: "r1", "r3", "r5", "r6", "r7", "r15", "memory");
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL(execve);
+
+asmlinkage int sys_vfork(struct pt_regs *regs)
+{
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->r1,
+						regs, 0, NULL, NULL);
+}
+
+asmlinkage int sys_clone(int flags, unsigned long stack, struct pt_regs *regs)
+{
+	if (!stack)
+		stack = regs->r1;
+	return do_fork(flags, stack, regs, 0, NULL, NULL);
+}
+
+asmlinkage int sys_execve(char __user *filenamei, char __user * __user *argv,
+			char __user * __user *envp, struct pt_regs *regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname(filenamei);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+	error = do_execve(filename, argv, envp, regs);
+	putname(filename);
+out:
+	return error;
+}
+
+asmlinkage int sys_pipe(unsigned long __user *fildes)
+{
+	int fd[2];
+	int error;
+
+	error = do_pipe(fd);
+	if (!error) {
+		if (copy_to_user(fildes, fd, 2*sizeof(int)))
+			error = -EFAULT;
+	}
+	return error;
+}
+
+static inline unsigned long
+do_mmap2(unsigned long addr, size_t len,
+	unsigned long prot, unsigned long flags,
+	unsigned long fd, unsigned long pgoff)
+{
+	struct file *file = NULL;
+	int ret = -EBADF;
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+	if (!(flags & MAP_ANONYMOUS))
+		if (!(file = fget(fd))) {
+			printk(KERN_INFO "no fd in mmap\r\n");
+			goto out;
+		}
+
+	down_write(&current->mm->mmap_sem);
+	ret = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	up_write(&current->mm->mmap_sem);
+	if (file)
+		fput(file);
+out:
+	return ret;
+}
+
+unsigned long sys_mmap2(unsigned long addr, size_t len,
+			unsigned long prot, unsigned long flags,
+			unsigned long fd, unsigned long pgoff)
+{
+	return do_mmap2(addr, len, prot, flags, fd, pgoff);
+}
+
+unsigned long sys_mmap(unsigned long addr, size_t len,
+			unsigned long prot, unsigned long flags,
+			unsigned long fd, off_t offset)
+{
+	int err = -EINVAL;
+
+	if (offset & ~PAGE_MASK) {
+		printk(KERN_INFO "no pagemask in mmap\r\n");
+		goto out;
+	}
+
+	err = do_mmap2(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+out:
+	return err;
+}
+
+int sys_uname(struct old_utsname *name)
+{
+	int err = -EFAULT;
+
+	down_read(&uts_sem);
+	if (name && !copy_to_user(name, utsname(), sizeof(*name)))
+		err = 0;
+	up_read(&uts_sem);
+	return err;
+}
+
+int sys_olduname(struct oldold_utsname *name)
+{
+	int error;
+
+	if (!name)
+		return -EFAULT;
+	if (!access_ok(VERIFY_WRITE, name, sizeof(struct oldold_utsname)))
+		return -EFAULT;
+
+	down_read(&uts_sem);
+	error = __copy_to_user(&name->sysname, utsname()->sysname,
+				__OLD_UTS_LEN);
+	error -= __put_user(0, name->sysname + __OLD_UTS_LEN);
+	error -= __copy_to_user(&name->nodename, utsname()->nodename,
+				__OLD_UTS_LEN);
+	error -= __put_user(0, name->nodename + __OLD_UTS_LEN);
+	error -= __copy_to_user(&name->release, utsname()->release,
+				__OLD_UTS_LEN);
+	error -= __put_user(0, name->release + __OLD_UTS_LEN);
+	error -= __copy_to_user(&name->version, utsname()->version,
+				__OLD_UTS_LEN);
+	error -= __put_user(0, name->version + __OLD_UTS_LEN);
+	error -= __copy_to_user(&name->machine, utsname()->machine,
+				__OLD_UTS_LEN);
+	error = __put_user(0, name->machine + __OLD_UTS_LEN);
+	up_read(&uts_sem);
+
+	error = error ? -EFAULT : 0;
+	return error;
+}
+
+/*
+ * Do a system call from kernel instead of calling sys_execve so we
+ * end up with proper pt_regs.
+ */
+int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+{
+	register const char *__a __asm__("r5") = filename;
+	register const void *__b __asm__("r6") = argv;
+	register const void *__c __asm__("r7") = envp;
+	register unsigned long __syscall __asm__("r12") = __NR_execve;
+	register unsigned long __ret __asm__("r3");
+	__asm__ __volatile__ ("brki r14, 0x8"
+			: "=r" (__ret), "=r" (__syscall)
+			: "1" (__syscall), "r" (__a), "r" (__b), "r" (__c)
+			: "r4", "r8", "r9",
+			"r10", "r11", "r14", "cc", "memory");
+	return __ret;
+}
diff --git a/include/asm-microblaze/ipc.h b/include/asm-microblaze/ipc.h
new file mode 100644
index 0000000..041b0eb
--- /dev/null
+++ b/include/asm-microblaze/ipc.h
@@ -0,0 +1,18 @@
+/*
+ * include/asm-microblaze/ipc.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_IPC_H
+#define _ASM_IPC_H
+
+#include <asm-generic/ipc.h>
+
+#endif /* _ASM_IPC_H */
+
+
diff --git a/include/asm-microblaze/ipcbuf.h b/include/asm-microblaze/ipcbuf.h
new file mode 100644
index 0000000..742768d
--- /dev/null
+++ b/include/asm-microblaze/ipcbuf.h
@@ -0,0 +1,38 @@
+/*
+ * include/asm-microblaze/ipcbuf.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_IPCBUF_H
+#define _ASM_IPCBUF_H
+
+/*
+ * The user_ipc_perm structure for m68k architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 32-bit mode_t and seq
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct ipc64_perm {
+	__kernel_key_t		key;
+	__kernel_uid32_t	uid;
+	__kernel_gid32_t	gid;
+	__kernel_uid32_t	cuid;
+	__kernel_gid32_t	cgid;
+	__kernel_mode_t		mode;
+	unsigned short		__pad1;
+	unsigned short		seq;
+	unsigned short		__pad2;
+	unsigned long		__unused1;
+	unsigned long		__unused2;
+};
+
+#endif /* _ASM_IPCBUF_H */
-- 
1.5.4.rc4.14.g6fc74

