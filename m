Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244Ab0AHJyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab0AHJyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 04:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489Ab0AHJy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 04:54:28 -0500
Received: from verein.lst.de ([213.95.11.210]:50231 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0AHJy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 04:54:26 -0500
Date: Fri, 8 Jan 2010 10:50:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: linux@arm.linux.org.uk, starvik@axis.com, jesper.nilsson@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.jp, takata@linux-m32r.org,
       geert@linux-m68k.org, zippel@linux-m68k.org, gerg@uclinux.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: [PATCH v2 3/3] generic sys_ipc wrapper
Message-ID: <20100108095023.GA29560@lst.de>
References: <20100106172152.GC17163@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106172152.GC17163@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always return -EINVAL for the iBCS2 special case in SHMAT, and add a
prototype to linux/syscalls.h


---

From: Christoph Hellwig <hch@lst.de>
Subject: generic sys_ipc wrapper


Add a generic implementation of the ipc demultiplexer syscall.  Except for
s390 and sparc64 all implementations of the sys_ipc are nearly identical.

There are slight differences in the types of the parameters, where mips
and powerpc as the only 64-bit architectures with sys_ipc use unsigned long
for the "third" argument as it gets casted to a pointer later, while it
traditionally is an "int" like most other paramters.  frv goes even further
and uses unsigned long for all parameters execept for "ptr" which is a pointer
type everywhere.  The change from int to unsigned long for "third" and back
to "int" for the others on frv should be fine due to the in-register calling
conventions for syscalls (we already had a similar issue with the generic
sys_ptrace), but I'd prefer to have the arch maintainers looks over this
in details.

Except for that h8300, m68k and m68knommu lack an impplementation of the
semtimedop sub call which this patch adds, and various architectures have
different strategies for the SHMAT version 1 case which apparently never
gets used - at least on i386 it seems superflous as the compat code on
x86-64 and ia64 doesn't even bother to implement it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/ipc/syscall.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/ipc/syscall.c	2010-01-08 10:33:20.828006175 +0100
@@ -0,0 +1,99 @@
+/*
+ * sys_ipc() is the old de-multiplexer for the SysV IPC calls.
+ *
+ * This is really horribly ugly, and new architectures should just wire up
+ * the individual syscalls instead.
+ */
+#include <linux/unistd.h>
+
+#ifdef __ARCH_WANT_SYS_IPC
+#include <linux/errno.h>
+#include <linux/ipc.h>
+#include <linux/shm.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+
+SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, int, second,
+		unsigned long, third, void __user *, ptr, long, fifth)
+{
+	int version, ret;
+
+	version = call >> 16; /* hack for backward compatibility */
+	call &= 0xffff;
+
+	switch (call) {
+	case SEMOP:
+		return sys_semtimedop(first, (struct sembuf __user *)ptr,
+				      second, NULL);
+	case SEMTIMEDOP:
+		return sys_semtimedop(first, (struct sembuf __user *)ptr,
+				      second,
+				      (const struct timespec __user *)fifth);
+
+	case SEMGET:
+		return sys_semget(first, second, third);
+	case SEMCTL: {
+		union semun fourth;
+		if (!ptr)
+			return -EINVAL;
+		if (get_user(fourth.__pad, (void __user * __user *) ptr))
+			return -EFAULT;
+		return sys_semctl(first, second, third, fourth);
+	}
+
+	case MSGSND:
+		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
+				  second, third);
+	case MSGRCV:
+		switch (version) {
+		case 0: {
+			struct ipc_kludge tmp;
+			if (!ptr)
+				return -EINVAL;
+
+			if (copy_from_user(&tmp,
+					   (struct ipc_kludge __user *) ptr,
+					   sizeof(tmp)))
+				return -EFAULT;
+			return sys_msgrcv(first, tmp.msgp, second,
+					   tmp.msgtyp, third);
+		}
+		default:
+			return sys_msgrcv(first,
+					   (struct msgbuf __user *) ptr,
+					   second, fifth, third);
+		}
+	case MSGGET:
+		return sys_msgget((key_t) first, second);
+	case MSGCTL:
+		return sys_msgctl(first, second, (struct msqid_ds __user *)ptr);
+
+	case SHMAT:
+		switch (version) {
+		default: {
+			unsigned long raddr;
+			ret = do_shmat(first, (char __user *)ptr,
+				       second, &raddr);
+			if (ret)
+				return ret;
+			return put_user(raddr, (unsigned long __user *) third);
+		}
+		case 1:
+			/*
+			 * This was the entry point for kernel-originating calls
+			 * from iBCS2 in 2.2 days.
+			 */
+			return -EINVAL;
+		}
+	case SHMDT:
+		return sys_shmdt((char __user *)ptr);
+	case SHMGET:
+		return sys_shmget(first, second, third);
+	case SHMCTL:
+		return sys_shmctl(first, second,
+				   (struct shmid_ds __user *) ptr);
+	default:
+		return -ENOSYS;
+	}
+}
+#endif
Index: linux-2.6/arch/arm/kernel/sys_arm.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/sys_arm.c	2010-01-08 10:30:18.351004169 +0100
+++ linux-2.6/arch/arm/kernel/sys_arm.c	2010-01-08 10:30:18.869022589 +0100
@@ -28,88 +28,6 @@
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
 
-#if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc(uint call, int first, int second, int third,
-		       void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop (first, (struct sembuf __user *)ptr, second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second,
-					(const struct timespec __user *)fifth);
-
-	case SEMGET:
-		return sys_semget (first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd(first, (struct msgbuf __user *) ptr, 
-				  second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-			if (copy_from_user(&tmp,(struct ipc_kludge __user *)ptr,
-					   sizeof (tmp)))
-				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv (first,
-					   (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget ((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl(first, second, (struct msqid_ds __user *)ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = do_shmat(first, (char __user *)ptr, second, &raddr);
-			if (ret)
-				return ret;
-			return put_user(raddr, (ulong __user *)third);
-		}
-		case 1: /* Of course, we don't support iBCS2! */
-			return -EINVAL;
-		}
-	case SHMDT: 
-		return sys_shmdt ((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget (first, second, third);
-	case SHMCTL:
-		return sys_shmctl (first, second,
-				   (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
-#endif
-
 /* Fork a new task - this creates a new program thread.
  * This is called indirectly via a small wrapper
  */
Index: linux-2.6/arch/arm/kernel/sys_oabi-compat.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/sys_oabi-compat.c	2010-01-08 10:29:59.752253940 +0100
+++ linux-2.6/arch/arm/kernel/sys_oabi-compat.c	2010-01-08 10:30:18.869022589 +0100
@@ -346,9 +346,6 @@ asmlinkage long sys_oabi_semop(int semid
 	return sys_oabi_semtimedop(semid, tsops, nsops, NULL);
 }
 
-extern asmlinkage int sys_ipc(uint call, int first, int second, int third,
-			      void __user *ptr, long fifth);
-
 asmlinkage int sys_oabi_ipc(uint call, int first, int second, int third,
 			    void __user *ptr, long fifth)
 {
Index: linux-2.6/arch/cris/kernel/sys_cris.c
===================================================================
--- linux-2.6.orig/arch/cris/kernel/sys_cris.c	2010-01-08 10:30:18.354003782 +0100
+++ linux-2.6/arch/cris/kernel/sys_cris.c	2010-01-08 10:30:18.870023205 +0100
@@ -33,81 +33,3 @@ sys_mmap2(unsigned long addr, unsigned l
 	/* bug(?): 8Kb pages here */
         return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
 }
-
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly. (same as arch/i386)
- */
-
-asmlinkage int sys_ipc (uint call, int first, int second,
-			int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop (first, (struct sembuf __user *)ptr, second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second,
-					(const struct timespec __user *)fifth);
-
-	case SEMGET:
-		return sys_semget (first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd (first, (struct msgbuf __user *) ptr, 
-				   second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-			
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr, 
-					   sizeof (tmp)))
-				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv (first,
-					   (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget ((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl (first, second, (struct msqid_ds __user *) ptr);
-
-	case SHMAT: {
-                ulong raddr;
-                ret = do_shmat (first, (char __user *) ptr, second, &raddr);
-                if (ret)
-                        return ret;
-                return put_user (raddr, (ulong __user *) third);
-        }
-	case SHMDT: 
-		return sys_shmdt ((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget (first, second, third);
-	case SHMCTL:
-		return sys_shmctl (first, second,
-				   (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
Index: linux-2.6/arch/frv/kernel/sys_frv.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/sys_frv.c	2010-01-08 10:29:59.784253336 +0100
+++ linux-2.6/arch/frv/kernel/sys_frv.c	2010-01-08 10:30:18.870023205 +0100
@@ -42,92 +42,3 @@ asmlinkage long sys_mmap2(unsigned long 
 	return sys_mmap_pgoff(addr, len, prot, flags, fd,
 			      pgoff >> (PAGE_SHIFT - 12));
 }
-
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage long sys_ipc(unsigned long call,
-			unsigned long first,
-			unsigned long second,
-			unsigned long third,
-			void __user *ptr,
-			unsigned long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second,
-				      (const struct timespec __user *)fifth);
-
-	case SEMGET:
-		return sys_semget (first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd (first, (struct msgbuf __user *) ptr,
-				   second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr,
-					   sizeof (tmp)))
-				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv (first,
-					   (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget ((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl (first, second, (struct msqid_ds __user *) ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = do_shmat (first, (char __user *) ptr, second, &raddr);
-			if (ret)
-				return ret;
-			return put_user (raddr, (ulong __user *) third);
-		}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				return -EINVAL;
-			/* The "(ulong *) third" is valid _only_ because of the kernel segment thing */
-			return do_shmat (first, (char __user *) ptr, second, (ulong *) third);
-		}
-	case SHMDT:
-		return sys_shmdt ((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget (first, second, third);
-	case SHMCTL:
-		return sys_shmctl (first, second,
-				   (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
Index: linux-2.6/arch/m32r/kernel/sys_m32r.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/sys_m32r.c	2010-01-08 10:29:59.798003900 +0100
+++ linux-2.6/arch/m32r/kernel/sys_m32r.c	2010-01-08 10:30:18.871253878 +0100
@@ -76,87 +76,6 @@ asmlinkage int sys_tas(int __user *addr)
 	return oldval;
 }
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc(uint call, int first, int second,
-		       int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      second, (const struct timespec __user *)fifth);
-	case SEMGET:
-		return sys_semget (first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
-		}
-
-	case MSGSND:
-		return sys_msgsnd (first, (struct msgbuf __user *) ptr,
-				   second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr,
-					   sizeof (tmp)))
-				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-			}
-		default:
-			return sys_msgrcv (first,
-					   (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget ((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl (first, second,
-				   (struct msqid_ds __user *) ptr);
-	case SHMAT: {
-		ulong raddr;
-
-		if (!access_ok(VERIFY_WRITE, (ulong __user *) third,
-				      sizeof(ulong)))
-			return -EFAULT;
-		ret = do_shmat (first, (char __user *) ptr, second, &raddr);
-		if (ret)
-			return ret;
-		return put_user (raddr, (ulong __user *) third);
-		}
-	case SHMDT:
-		return sys_shmdt ((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget (first, second, third);
-	case SHMCTL:
-		return sys_shmctl (first, second,
-				   (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
-
 asmlinkage int sys_uname(struct old_utsname __user * name)
 {
 	int err;
Index: linux-2.6/arch/m68k/kernel/sys_m68k.c
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/sys_m68k.c	2010-01-08 10:30:18.357003117 +0100
+++ linux-2.6/arch/m68k/kernel/sys_m68k.c	2010-01-08 10:30:18.872282920 +0100
@@ -41,87 +41,6 @@ asmlinkage long sys_mmap2(unsigned long 
 	return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
 }
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc (uint call, int first, int second,
-			int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	if (call <= SEMCTL)
-		switch (call) {
-		case SEMOP:
-			return sys_semop (first, ptr, second);
-		case SEMGET:
-			return sys_semget (first, second, third);
-		case SEMCTL: {
-			union semun fourth;
-			if (!ptr)
-				return -EINVAL;
-			if (get_user(fourth.__pad, (void __user *__user *) ptr))
-				return -EFAULT;
-			return sys_semctl (first, second, third, fourth);
-			}
-		default:
-			return -ENOSYS;
-		}
-	if (call <= MSGCTL)
-		switch (call) {
-		case MSGSND:
-			return sys_msgsnd (first, ptr, second, third);
-		case MSGRCV:
-			switch (version) {
-			case 0: {
-				struct ipc_kludge tmp;
-				if (!ptr)
-					return -EINVAL;
-				if (copy_from_user (&tmp, ptr, sizeof (tmp)))
-					return -EFAULT;
-				return sys_msgrcv (first, tmp.msgp, second,
-						   tmp.msgtyp, third);
-				}
-			default:
-				return sys_msgrcv (first, ptr,
-						   second, fifth, third);
-			}
-		case MSGGET:
-			return sys_msgget ((key_t) first, second);
-		case MSGCTL:
-			return sys_msgctl (first, second, ptr);
-		default:
-			return -ENOSYS;
-		}
-	if (call <= SHMCTL)
-		switch (call) {
-		case SHMAT:
-			switch (version) {
-			default: {
-				ulong raddr;
-				ret = do_shmat (first, ptr, second, &raddr);
-				if (ret)
-					return ret;
-				return put_user (raddr, (ulong __user *) third);
-			}
-			}
-		case SHMDT:
-			return sys_shmdt (ptr);
-		case SHMGET:
-			return sys_shmget (first, second, third);
-		case SHMCTL:
-			return sys_shmctl (first, second, ptr);
-		default:
-			return -ENOSYS;
-		}
-
-	return -EINVAL;
-}
-
 /* Convert virtual (user) address VADDR to physical address PADDR */
 #define virt_to_phys_040(vaddr)						\
 ({									\
Index: linux-2.6/arch/mips/kernel/syscall.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/syscall.c	2010-01-08 10:29:59.832272929 +0100
+++ linux-2.6/arch/mips/kernel/syscall.c	2010-01-08 10:30:18.872282920 +0100
@@ -407,94 +407,6 @@ _sys_sysmips(nabi_no_regargs struct pt_r
 }
 
 /*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, int, second,
-	unsigned long, third, void __user *, ptr, long, fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-		                      second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      second,
-				      (const struct timespec __user *)fifth);
-	case SEMGET:
-		return sys_semget(first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user *__user *) ptr))
-			return -EFAULT;
-		return sys_semctl(first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
-				  second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr,
-					   sizeof(tmp)))
-				return -EFAULT;
-			return sys_msgrcv(first, tmp.msgp, second,
-					  tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv(first,
-					  (struct msgbuf __user *) ptr,
-					  second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl(first, second,
-				  (struct msqid_ds __user *) ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			unsigned long raddr;
-			ret = do_shmat(first, (char __user *) ptr, second,
-				       &raddr);
-			if (ret)
-				return ret;
-			return put_user(raddr, (unsigned long __user *) third);
-		}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				return -EINVAL;
-			return do_shmat(first, (char __user *) ptr, second,
-				        (unsigned long *) third);
-		}
-	case SHMDT:
-		return sys_shmdt((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget(first, second, third);
-	case SHMCTL:
-		return sys_shmctl(first, second,
-				  (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
-
-/*
  * No implemented yet ...
  */
 SYSCALL_DEFINE3(cachectl, char *, addr, int, nbytes, int, op)
Index: linux-2.6/arch/mn10300/kernel/sys_mn10300.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/sys_mn10300.c	2010-01-08 10:30:17.671011822 +0100
+++ linux-2.6/arch/mn10300/kernel/sys_mn10300.c	2010-01-08 10:30:18.873253435 +0100
@@ -31,91 +31,3 @@ asmlinkage long old_mmap(unsigned long a
 		return -EINVAL;
 	return sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
 }
-
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage long sys_ipc(uint call, int first, int second,
-			int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      second,
-				      (const struct timespec __user *)fifth);
-	case SEMGET:
-		return sys_semget(first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl(first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
-				  second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr,
-					   sizeof(tmp)))
-				return -EFAULT;
-			return sys_msgrcv(first, tmp.msgp, second,
-					  tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv(first,
-					  (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl(first, second,
-				   (struct msqid_ds __user *) ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = do_shmat(first, (char __user *) ptr, second,
-				       &raddr);
-			if (ret)
-				return ret;
-			return put_user(raddr, (ulong *) third);
-		}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				return -EINVAL;
-			return do_shmat(first, (char __user *) ptr, second,
-					(ulong *) third);
-		}
-	case SHMDT:
-		return sys_shmdt((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget(first, second, third);
-	case SHMCTL:
-		return sys_shmctl(first, second,
-				  (struct shmid_ds __user *) ptr);
-	default:
-		return -EINVAL;
-	}
-}
Index: linux-2.6/arch/powerpc/include/asm/syscalls.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/syscalls.h	2010-01-08 10:29:59.865023189 +0100
+++ linux-2.6/arch/powerpc/include/asm/syscalls.h	2010-01-08 10:30:18.873253435 +0100
@@ -35,8 +35,6 @@ asmlinkage long sys_pipe2(int __user *fi
 asmlinkage long sys_rt_sigaction(int sig,
 		const struct sigaction __user *act,
 		struct sigaction __user *oact, size_t sigsetsize);
-asmlinkage int sys_ipc(uint call, int first, unsigned long second,
-		long third, void __user *ptr, long fifth);
 asmlinkage long ppc64_personality(unsigned long personality);
 asmlinkage int ppc_rtas(struct rtas_args __user *uargs);
 asmlinkage time_t sys64_time(time_t __user * tloc);
Index: linux-2.6/arch/powerpc/kernel/syscalls.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/syscalls.c	2010-01-08 10:29:59.883004390 +0100
+++ linux-2.6/arch/powerpc/kernel/syscalls.c	2010-01-08 10:30:18.874253213 +0100
@@ -42,100 +42,6 @@
 #include <asm/time.h>
 #include <asm/unistd.h>
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-int sys_ipc(uint call, int first, unsigned long second, long third,
-	    void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	ret = -ENOSYS;
-	switch (call) {
-	case SEMOP:
-		ret = sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      (unsigned)second, NULL);
-		break;
-	case SEMTIMEDOP:
-		ret = sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      (unsigned)second,
-				      (const struct timespec __user *) fifth);
-		break;
-	case SEMGET:
-		ret = sys_semget (first, (int)second, third);
-		break;
-	case SEMCTL: {
-		union semun fourth;
-
-		ret = -EINVAL;
-		if (!ptr)
-			break;
-		if ((ret = get_user(fourth.__pad, (void __user * __user *)ptr)))
-			break;
-		ret = sys_semctl(first, (int)second, third, fourth);
-		break;
-	}
-	case MSGSND:
-		ret = sys_msgsnd(first, (struct msgbuf __user *)ptr,
-				 (size_t)second, third);
-		break;
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-
-			ret = -EINVAL;
-			if (!ptr)
-				break;
-			if ((ret = copy_from_user(&tmp,
-						(struct ipc_kludge __user *) ptr,
-						sizeof (tmp)) ? -EFAULT : 0))
-				break;
-			ret = sys_msgrcv(first, tmp.msgp, (size_t) second,
-					  tmp.msgtyp, third);
-			break;
-		}
-		default:
-			ret = sys_msgrcv (first, (struct msgbuf __user *) ptr,
-					  (size_t)second, fifth, third);
-			break;
-		}
-		break;
-	case MSGGET:
-		ret = sys_msgget((key_t)first, (int)second);
-		break;
-	case MSGCTL:
-		ret = sys_msgctl(first, (int)second,
-				  (struct msqid_ds __user *)ptr);
-		break;
-	case SHMAT: {
-		ulong raddr;
-		ret = do_shmat(first, (char __user *)ptr, (int)second, &raddr);
-		if (ret)
-			break;
-		ret = put_user(raddr, (ulong __user *) third);
-		break;
-	}
-	case SHMDT:
-		ret = sys_shmdt((char __user *)ptr);
-		break;
-	case SHMGET:
-		ret = sys_shmget(first, (size_t)second, third);
-		break;
-	case SHMCTL:
-		ret = sys_shmctl(first, (int)second,
-				 (struct shmid_ds __user *)ptr);
-		break;
-	}
-
-	return ret;
-}
-
 static inline unsigned long do_mmap2(unsigned long addr, size_t len,
 			unsigned long prot, unsigned long flags,
 			unsigned long fd, unsigned long off, int shift)
Index: linux-2.6/arch/s390/kernel/entry.h
===================================================================
--- linux-2.6.orig/arch/s390/kernel/entry.h	2010-01-08 10:30:18.363003950 +0100
+++ linux-2.6/arch/s390/kernel/entry.h	2010-01-08 10:30:18.874253213 +0100
@@ -30,7 +30,7 @@ struct fadvise64_64_args;
 struct old_sigaction;
 
 long sys_mmap2(struct s390_mmap_arg_struct __user  *arg);
-long sys_ipc(uint call, int first, unsigned long second,
+long sys_s390_ipc(uint call, int first, unsigned long second,
 	     unsigned long third, void __user *ptr);
 long sys_s390_newuname(struct new_utsname __user *name);
 long sys_s390_personality(unsigned long personality);
Index: linux-2.6/arch/s390/kernel/sys_s390.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/sys_s390.c	2010-01-08 10:30:18.360004127 +0100
+++ linux-2.6/arch/s390/kernel/sys_s390.c	2010-01-08 10:30:18.875253759 +0100
@@ -64,7 +64,7 @@ out:
  *
  * This is really horribly ugly.
  */
-SYSCALL_DEFINE5(ipc, uint, call, int, first, unsigned long, second,
+SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, unsigned long, second,
 		unsigned long, third, void __user *, ptr)
 {
         struct ipc_kludge tmp;
Index: linux-2.6/arch/s390/kernel/syscalls.S
===================================================================
--- linux-2.6.orig/arch/s390/kernel/syscalls.S	2010-01-08 10:30:18.361004115 +0100
+++ linux-2.6/arch/s390/kernel/syscalls.S	2010-01-08 10:30:18.876254725 +0100
@@ -125,7 +125,7 @@ NI_SYSCALL							/* vm86old for i386 */
 SYSCALL(sys_wait4,sys_wait4,compat_sys_wait4_wrapper)
 SYSCALL(sys_swapoff,sys_swapoff,sys32_swapoff_wrapper)		/* 115 */
 SYSCALL(sys_sysinfo,sys_sysinfo,compat_sys_sysinfo_wrapper)
-SYSCALL(sys_ipc,sys_ipc,sys32_ipc_wrapper)
+SYSCALL(sys_s390_ipc,sys_s390_ipc,sys32_ipc_wrapper)
 SYSCALL(sys_fsync,sys_fsync,sys32_fsync_wrapper)
 SYSCALL(sys_sigreturn,sys_sigreturn,sys32_sigreturn)
 SYSCALL(sys_clone,sys_clone,sys_clone_wrapper)			/* 120 */
Index: linux-2.6/arch/sh/include/asm/syscalls.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/syscalls.h	2010-01-08 10:29:59.918003330 +0100
+++ linux-2.6/arch/sh/include/asm/syscalls.h	2010-01-08 10:30:18.877304579 +0100
@@ -11,8 +11,6 @@ asmlinkage int old_mmap(unsigned long ad
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long prot, unsigned long flags,
 			  unsigned long fd, unsigned long pgoff);
-asmlinkage int sys_ipc(uint call, int first, int second,
-		       int third, void __user *ptr, long fifth);
 asmlinkage int sys_uname(struct old_utsname __user *name);
 
 #ifdef CONFIG_SUPERH32
Index: linux-2.6/arch/sh/kernel/sys_sh.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/sys_sh.c	2010-01-08 10:29:59.942008971 +0100
+++ linux-2.6/arch/sh/kernel/sys_sh.c	2010-01-08 10:30:18.877304579 +0100
@@ -53,110 +53,6 @@ asmlinkage long sys_mmap2(unsigned long 
 	return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
 }
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc(uint call, int first, int second,
-		       int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	if (call <= SEMTIMEDOP)
-		switch (call) {
-		case SEMOP:
-			return sys_semtimedop(first,
-					      (struct sembuf __user *)ptr,
-					      second, NULL);
-		case SEMTIMEDOP:
-			return sys_semtimedop(first,
-				(struct sembuf __user *)ptr, second,
-			        (const struct timespec __user *)fifth);
-		case SEMGET:
-			return sys_semget (first, second, third);
-		case SEMCTL: {
-			union semun fourth;
-			if (!ptr)
-				return -EINVAL;
-			if (get_user(fourth.__pad, (void __user * __user *) ptr))
-				return -EFAULT;
-			return sys_semctl (first, second, third, fourth);
-			}
-		default:
-			return -EINVAL;
-		}
-
-	if (call <= MSGCTL)
-		switch (call) {
-		case MSGSND:
-			return sys_msgsnd (first, (struct msgbuf __user *) ptr,
-					  second, third);
-		case MSGRCV:
-			switch (version) {
-			case 0:
-			{
-				struct ipc_kludge tmp;
-
-				if (!ptr)
-					return -EINVAL;
-
-				if (copy_from_user(&tmp,
-					(struct ipc_kludge __user *) ptr,
-						   sizeof (tmp)))
-					return -EFAULT;
-
-				return sys_msgrcv (first, tmp.msgp, second,
-						   tmp.msgtyp, third);
-			}
-			default:
-				return sys_msgrcv (first,
-						   (struct msgbuf __user *) ptr,
-						   second, fifth, third);
-			}
-		case MSGGET:
-			return sys_msgget ((key_t) first, second);
-		case MSGCTL:
-			return sys_msgctl (first, second,
-					   (struct msqid_ds __user *) ptr);
-		default:
-			return -EINVAL;
-		}
-	if (call <= SHMCTL)
-		switch (call) {
-		case SHMAT:
-			switch (version) {
-			default: {
-				ulong raddr;
-				ret = do_shmat (first, (char __user *) ptr,
-						 second, &raddr);
-				if (ret)
-					return ret;
-				return put_user (raddr, (ulong __user *) third);
-			}
-			case 1:	/* iBCS2 emulator entry point */
-				if (!segment_eq(get_fs(), get_ds()))
-					return -EINVAL;
-				return do_shmat (first, (char __user *) ptr,
-						  second, (ulong *) third);
-			}
-		case SHMDT:
-			return sys_shmdt ((char __user *)ptr);
-		case SHMGET:
-			return sys_shmget (first, second, third);
-		case SHMCTL:
-			return sys_shmctl (first, second,
-					   (struct shmid_ds __user *) ptr);
-		default:
-			return -EINVAL;
-		}
-
-	return -EINVAL;
-}
-
 /* sys_cacheflush -- flush (part of) the processor cache.  */
 asmlinkage int sys_cacheflush(unsigned long addr, unsigned long len, int op)
 {
Index: linux-2.6/arch/sparc/kernel/sys_sparc_32.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/sys_sparc_32.c	2010-01-08 10:29:59.949003995 +0100
+++ linux-2.6/arch/sparc/kernel/sys_sparc_32.c	2010-01-08 10:30:18.879253989 +0100
@@ -98,119 +98,6 @@ out:
 	return error;
 }
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-
-asmlinkage int sys_ipc (uint call, int first, int second, int third, void __user *ptr, long fifth)
-{
-	int version, err;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	if (call <= SEMCTL)
-		switch (call) {
-		case SEMOP:
-			err = sys_semtimedop (first, (struct sembuf __user *)ptr, second, NULL);
-			goto out;
-		case SEMTIMEDOP:
-			err = sys_semtimedop (first, (struct sembuf __user *)ptr, second, (const struct timespec __user *) fifth);
-			goto out;
-		case SEMGET:
-			err = sys_semget (first, second, third);
-			goto out;
-		case SEMCTL: {
-			union semun fourth;
-			err = -EINVAL;
-			if (!ptr)
-				goto out;
-			err = -EFAULT;
-			if (get_user(fourth.__pad,
-				     (void __user * __user *)ptr))
-				goto out;
-			err = sys_semctl (first, second, third, fourth);
-			goto out;
-			}
-		default:
-			err = -ENOSYS;
-			goto out;
-		}
-	if (call <= MSGCTL) 
-		switch (call) {
-		case MSGSND:
-			err = sys_msgsnd (first, (struct msgbuf __user *) ptr, 
-					  second, third);
-			goto out;
-		case MSGRCV:
-			switch (version) {
-			case 0: {
-				struct ipc_kludge tmp;
-				err = -EINVAL;
-				if (!ptr)
-					goto out;
-				err = -EFAULT;
-				if (copy_from_user(&tmp, (struct ipc_kludge __user *) ptr, sizeof (tmp)))
-					goto out;
-				err = sys_msgrcv (first, tmp.msgp, second, tmp.msgtyp, third);
-				goto out;
-				}
-			case 1: default:
-				err = sys_msgrcv (first,
-						  (struct msgbuf __user *) ptr,
-						  second, fifth, third);
-				goto out;
-			}
-		case MSGGET:
-			err = sys_msgget ((key_t) first, second);
-			goto out;
-		case MSGCTL:
-			err = sys_msgctl (first, second, (struct msqid_ds __user *) ptr);
-			goto out;
-		default:
-			err = -ENOSYS;
-			goto out;
-		}
-	if (call <= SHMCTL) 
-		switch (call) {
-		case SHMAT:
-			switch (version) {
-			case 0: default: {
-				ulong raddr;
-				err = do_shmat (first, (char __user *) ptr, second, &raddr);
-				if (err)
-					goto out;
-				err = -EFAULT;
-				if (put_user (raddr, (ulong __user *) third))
-					goto out;
-				err = 0;
-				goto out;
-				}
-			case 1:	/* iBCS2 emulator entry point */
-				err = -EINVAL;
-				goto out;
-			}
-		case SHMDT: 
-			err = sys_shmdt ((char __user *)ptr);
-			goto out;
-		case SHMGET:
-			err = sys_shmget (first, second, third);
-			goto out;
-		case SHMCTL:
-			err = sys_shmctl (first, second, (struct shmid_ds __user *) ptr);
-			goto out;
-		default:
-			err = -ENOSYS;
-			goto out;
-		}
-	else
-		err = -ENOSYS;
-out:
-	return err;
-}
-
 int sparc_mmap_check(unsigned long addr, unsigned long len)
 {
 	if (ARCH_SUN4C &&
Index: linux-2.6/arch/um/sys-i386/syscalls.c
===================================================================
--- linux-2.6.orig/arch/um/sys-i386/syscalls.c	2010-01-08 10:30:18.368003679 +0100
+++ linux-2.6/arch/um/sys-i386/syscalls.c	2010-01-08 10:30:18.879253989 +0100
@@ -34,92 +34,6 @@ long sys_clone(unsigned long clone_flags
 	return ret;
 }
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-long sys_ipc (uint call, int first, int second,
-	     int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *) ptr,
-				      second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *) ptr,
-				      second,
-				      (const struct timespec __user *) fifth);
-	case SEMGET:
-		return sys_semget (first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd (first, (struct msgbuf *) ptr,
-				   second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge *) ptr,
-					   sizeof (tmp)))
-				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-		}
-		default:
-		        panic("msgrcv with version != 0");
-			return sys_msgrcv (first,
-					   (struct msgbuf *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget ((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl (first, second, (struct msqid_ds *) ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = do_shmat (first, (char *) ptr, second, &raddr);
-			if (ret)
-				return ret;
-			return put_user (raddr, (ulong *) third);
-		}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				return -EINVAL;
-			return do_shmat (first, (char *) ptr, second, (ulong *) third);
-		}
-	case SHMDT:
-		return sys_shmdt ((char *)ptr);
-	case SHMGET:
-		return sys_shmget (first, second, third);
-	case SHMCTL:
-		return sys_shmctl (first, second,
-				   (struct shmid_ds *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
-
 long sys_sigaction(int sig, const struct old_sigaction __user *act,
 			 struct old_sigaction __user *oact)
 {
Index: linux-2.6/arch/x86/include/asm/syscalls.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/syscalls.h	2010-01-08 10:30:18.364005055 +0100
+++ linux-2.6/arch/x86/include/asm/syscalls.h	2010-01-08 10:30:18.880254047 +0100
@@ -54,7 +54,6 @@ unsigned long sys_sigreturn(struct pt_re
 struct oldold_utsname;
 struct old_utsname;
 
-asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
 asmlinkage int sys_uname(struct old_utsname __user *);
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
 
Index: linux-2.6/ipc/Makefile
===================================================================
--- linux-2.6.orig/ipc/Makefile	2010-01-08 10:29:59.734004619 +0100
+++ linux-2.6/ipc/Makefile	2010-01-08 10:30:18.880254047 +0100
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_SYSVIPC_COMPAT) += compat.o
-obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o ipcns_notifier.o
+obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o ipcns_notifier.o syscall.o
 obj-$(CONFIG_SYSVIPC_SYSCTL) += ipc_sysctl.o
 obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
Index: linux-2.6/arch/h8300/kernel/sys_h8300.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/sys_h8300.c	2010-01-08 10:30:18.355012360 +0100
+++ linux-2.6/arch/h8300/kernel/sys_h8300.c	2010-01-08 10:30:18.881286091 +0100
@@ -26,94 +26,6 @@
 #include <asm/traps.h>
 #include <asm/unistd.h>
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc (uint call, int first, int second,
-			int third, void *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	if (call <= SEMCTL)
-		switch (call) {
-		case SEMOP:
-			return sys_semop (first, (struct sembuf *)ptr, second);
-		case SEMGET:
-			return sys_semget (first, second, third);
-		case SEMCTL: {
-			union semun fourth;
-			if (!ptr)
-				return -EINVAL;
-			if (get_user(fourth.__pad, (void **) ptr))
-				return -EFAULT;
-			return sys_semctl (first, second, third, fourth);
-			}
-		default:
-			return -EINVAL;
-		}
-	if (call <= MSGCTL) 
-		switch (call) {
-		case MSGSND:
-			return sys_msgsnd (first, (struct msgbuf *) ptr, 
-					  second, third);
-		case MSGRCV:
-			switch (version) {
-			case 0: {
-				struct ipc_kludge tmp;
-				if (!ptr)
-					return -EINVAL;
-				if (copy_from_user (&tmp,
-						    (struct ipc_kludge *)ptr,
-						    sizeof (tmp)))
-					return -EFAULT;
-				return sys_msgrcv (first, tmp.msgp, second,
-						   tmp.msgtyp, third);
-				}
-			default:
-				return sys_msgrcv (first,
-						   (struct msgbuf *) ptr,
-						   second, fifth, third);
-			}
-		case MSGGET:
-			return sys_msgget ((key_t) first, second);
-		case MSGCTL:
-			return sys_msgctl (first, second,
-					   (struct msqid_ds *) ptr);
-		default:
-			return -EINVAL;
-		}
-	if (call <= SHMCTL) 
-		switch (call) {
-		case SHMAT:
-			switch (version) {
-			default: {
-				ulong raddr;
-				ret = do_shmat (first, (char *) ptr,
-						 second, &raddr);
-				if (ret)
-					return ret;
-				return put_user (raddr, (ulong *) third);
-			}
-			}
-		case SHMDT: 
-			return sys_shmdt ((char *)ptr);
-		case SHMGET:
-			return sys_shmget (first, second, third);
-		case SHMCTL:
-			return sys_shmctl (first, second,
-					   (struct shmid_ds *) ptr);
-		default:
-			return -EINVAL;
-		}
-
-	return -EINVAL;
-}
-
 /* sys_cacheflush -- no support.  */
 asmlinkage int
 sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
Index: linux-2.6/arch/m68knommu/kernel/sys_m68k.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/kernel/sys_m68k.c	2010-01-08 10:30:18.358004152 +0100
+++ linux-2.6/arch/m68knommu/kernel/sys_m68k.c	2010-01-08 10:30:18.882254092 +0100
@@ -27,92 +27,6 @@
 #include <asm/cacheflush.h>
 #include <asm/unistd.h>
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc (uint call, int first, int second,
-			int third, void *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	if (call <= SEMCTL)
-		switch (call) {
-		case SEMOP:
-			return sys_semop (first, (struct sembuf *)ptr, second);
-		case SEMGET:
-			return sys_semget (first, second, third);
-		case SEMCTL: {
-			union semun fourth;
-			if (!ptr)
-				return -EINVAL;
-			if (get_user(fourth.__pad, (void **) ptr))
-				return -EFAULT;
-			return sys_semctl (first, second, third, fourth);
-			}
-		default:
-			return -EINVAL;
-		}
-	if (call <= MSGCTL) 
-		switch (call) {
-		case MSGSND:
-			return sys_msgsnd (first, (struct msgbuf *) ptr, 
-					  second, third);
-		case MSGRCV:
-			switch (version) {
-			case 0: {
-				struct ipc_kludge tmp;
-				if (!ptr)
-					return -EINVAL;
-				if (copy_from_user (&tmp,
-						    (struct ipc_kludge *)ptr,
-						    sizeof (tmp)))
-					return -EFAULT;
-				return sys_msgrcv (first, tmp.msgp, second,
-						   tmp.msgtyp, third);
-				}
-			default:
-				return sys_msgrcv (first,
-						   (struct msgbuf *) ptr,
-						   second, fifth, third);
-			}
-		case MSGGET:
-			return sys_msgget ((key_t) first, second);
-		case MSGCTL:
-			return sys_msgctl (first, second,
-					   (struct msqid_ds *) ptr);
-		default:
-			return -EINVAL;
-		}
-	if (call <= SHMCTL)
-		switch (call) {
-		case SHMAT:
-			switch (version) {
-			default: {
-				ulong raddr;
-				ret = do_shmat (first, ptr, second, &raddr);
-				if (ret)
-					return ret;
-				return put_user (raddr, (ulong __user *) third);
-			}
-			}
-		case SHMDT:
-			return sys_shmdt (ptr);
-		case SHMGET:
-			return sys_shmget (first, second, third);
-		case SHMCTL:
-			return sys_shmctl (first, second, ptr);
-		default:
-			return -ENOSYS;
-		}
-
-	return -EINVAL;
-}
-
 /* sys_cacheflush -- flush (part of) the processor cache.  */
 asmlinkage int
 sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
Index: linux-2.6/arch/sparc/kernel/sys_sparc_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/sys_sparc_64.c	2010-01-08 10:29:59.956003770 +0100
+++ linux-2.6/arch/sparc/kernel/sys_sparc_64.c	2010-01-08 10:30:18.883254149 +0100
@@ -427,7 +427,7 @@ out:
  * This is really horribly ugly.
  */
 
-SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, unsigned long, second,
+SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second,
 		unsigned long, third, void __user *, ptr, long, fifth)
 {
 	long err;
Index: linux-2.6/arch/sparc/kernel/systbls.h
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/systbls.h	2010-01-08 10:29:59.963003893 +0100
+++ linux-2.6/arch/sparc/kernel/systbls.h	2010-01-08 10:30:18.883254149 +0100
@@ -10,7 +10,7 @@ struct new_utsname;
 
 extern asmlinkage unsigned long sys_getpagesize(void);
 extern asmlinkage long sparc_pipe(struct pt_regs *regs);
-extern asmlinkage long sys_ipc(unsigned int call, int first,
+extern asmlinkage long sys_sparc_ipc(unsigned int call, int first,
 			       unsigned long second,
 			       unsigned long third,
 			       void __user *ptr, long fifth);
Index: linux-2.6/arch/sparc/kernel/systbls_64.S
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/systbls_64.S	2010-01-08 10:29:59.972003782 +0100
+++ linux-2.6/arch/sparc/kernel/systbls_64.S	2010-01-08 10:30:18.884281934 +0100
@@ -136,7 +136,7 @@ sys_call_table:
 /*200*/	.word sys_ssetmask, sys_nis_syscall, sys_newlstat, sys_uselib, sys_nis_syscall
 	.word sys_readahead, sys_socketcall, sys_syslog, sys_lookup_dcookie, sys_fadvise64
 /*210*/	.word sys_fadvise64_64, sys_tgkill, sys_waitpid, sys_swapoff, sys_sysinfo
-	.word sys_ipc, sys_nis_syscall, sys_clone, sys_ioprio_get, sys_adjtimex
+	.word sys_sparc_ipc, sys_nis_syscall, sys_clone, sys_ioprio_get, sys_adjtimex
 /*220*/	.word sys_nis_syscall, sys_ni_syscall, sys_delete_module, sys_ni_syscall, sys_getpgid
 	.word sys_bdflush, sys_sysfs, sys_nis_syscall, sys_setfsuid, sys_setfsgid
 /*230*/	.word sys_select, sys_nis_syscall, sys_splice, sys_stime, sys_statfs64
Index: linux-2.6/arch/x86/kernel/sys_i386_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/sys_i386_32.c	2010-01-08 10:30:18.364005055 +0100
+++ linux-2.6/arch/x86/kernel/sys_i386_32.c	2010-01-08 10:30:18.884281934 +0100
@@ -25,91 +25,6 @@
 #include <asm/syscalls.h>
 
 /*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc(uint call, int first, int second,
-			int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second,
-					(const struct timespec __user *)fifth);
-
-	case SEMGET:
-		return sys_semget(first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl(first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
-				   second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr,
-					   sizeof(tmp)))
-				return -EFAULT;
-			return sys_msgrcv(first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv(first,
-					   (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl(first, second, (struct msqid_ds __user *) ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = do_shmat(first, (char __user *) ptr, second, &raddr);
-			if (ret)
-				return ret;
-			return put_user(raddr, (ulong __user *) third);
-		}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				return -EINVAL;
-			/* The "(ulong *) third" is valid _only_ because of the kernel segment thing */
-			return do_shmat(first, (char __user *) ptr, second, (ulong *) third);
-		}
-	case SHMDT:
-		return sys_shmdt((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget(first, second, third);
-	case SHMCTL:
-		return sys_shmctl(first, second,
-				   (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
-
-/*
  * Old cruft
  */
 asmlinkage int sys_uname(struct old_utsname __user *name)
Index: linux-2.6/arch/arm/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/unistd.h	2010-01-08 10:30:18.349004054 +0100
+++ linux-2.6/arch/arm/include/asm/unistd.h	2010-01-08 10:30:18.885254334 +0100
@@ -447,6 +447,7 @@
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 #define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_UTIME
Index: linux-2.6/arch/cris/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/cris/include/asm/unistd.h	2010-01-08 10:30:18.354003782 +0100
+++ linux-2.6/arch/cris/include/asm/unistd.h	2010-01-08 10:30:18.886254741 +0100
@@ -352,6 +352,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
Index: linux-2.6/arch/frv/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/frv/include/asm/unistd.h	2010-01-08 10:29:59.792253936 +0100
+++ linux-2.6/arch/frv/include/asm/unistd.h	2010-01-08 10:30:18.887254309 +0100
@@ -354,6 +354,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 /* #define __ARCH_WANT_SYS_GETHOSTNAME */
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 /* #define __ARCH_WANT_SYS_SGETMASK */
 /* #define __ARCH_WANT_SYS_SIGNAL */
Index: linux-2.6/arch/h8300/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/h8300/include/asm/unistd.h	2010-01-08 10:30:18.355012360 +0100
+++ linux-2.6/arch/h8300/include/asm/unistd.h	2010-01-08 10:30:18.888281465 +0100
@@ -336,6 +336,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
Index: linux-2.6/arch/m32r/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/unistd.h	2010-01-08 10:29:59.811003949 +0100
+++ linux-2.6/arch/m32r/include/asm/unistd.h	2010-01-08 10:30:18.889298145 +0100
@@ -339,6 +339,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
Index: linux-2.6/arch/m68k/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/unistd.h	2010-01-08 10:30:18.360004127 +0100
+++ linux-2.6/arch/m68k/include/asm/unistd.h	2010-01-08 10:30:18.890254482 +0100
@@ -347,6 +347,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
Index: linux-2.6/arch/mips/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/unistd.h	2010-01-08 10:29:59.839004163 +0100
+++ linux-2.6/arch/mips/include/asm/unistd.h	2010-01-08 10:30:18.891254609 +0100
@@ -1004,6 +1004,7 @@
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_UTIME
Index: linux-2.6/arch/mn10300/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/unistd.h	2010-01-08 10:30:17.664011979 +0100
+++ linux-2.6/arch/mn10300/include/asm/unistd.h	2010-01-08 10:30:18.892282883 +0100
@@ -362,6 +362,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
Index: linux-2.6/arch/powerpc/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/unistd.h	2010-01-08 10:29:59.875003021 +0100
+++ linux-2.6/arch/powerpc/include/asm/unistd.h	2010-01-08 10:30:18.893255492 +0100
@@ -364,6 +364,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
Index: linux-2.6/arch/s390/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/unistd.h	2010-01-08 10:30:18.363003950 +0100
+++ linux-2.6/arch/s390/include/asm/unistd.h	2010-01-08 10:30:18.894254642 +0100
@@ -381,6 +381,7 @@
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_UTIME
Index: linux-2.6/arch/sh/include/asm/unistd_32.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/unistd_32.h	2010-01-08 10:29:59.925003313 +0100
+++ linux-2.6/arch/sh/include/asm/unistd_32.h	2010-01-08 10:30:18.895254699 +0100
@@ -357,6 +357,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
Index: linux-2.6/arch/sh/include/asm/unistd_64.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/unistd_64.h	2010-01-08 10:29:59.935003330 +0100
+++ linux-2.6/arch/sh/include/asm/unistd_64.h	2010-01-08 10:30:18.896254059 +0100
@@ -397,6 +397,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
Index: linux-2.6/arch/sparc/include/asm/unistd.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/unistd.h	2010-01-08 10:29:59.980021144 +0100
+++ linux-2.6/arch/sparc/include/asm/unistd.h	2010-01-08 10:30:18.897276326 +0100
@@ -432,7 +432,9 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
-#ifndef __32bit_syscall_numbers__
+#ifdef __32bit_syscall_numbers__
+#define __ARCH_WANT_SYS_IPC
+#else
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #endif
Index: linux-2.6/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/unistd_32.h	2010-01-08 10:30:18.370024467 +0100
+++ linux-2.6/arch/x86/include/asm/unistd_32.h	2010-01-08 10:30:18.898299780 +0100
@@ -354,6 +354,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h	2010-01-08 10:32:50.258253033 +0100
+++ linux-2.6/include/linux/syscalls.h	2010-01-08 10:34:31.211270575 +0100
@@ -684,6 +684,8 @@ asmlinkage long sys_shmat(int shmid, cha
 asmlinkage long sys_shmget(key_t key, size_t size, int flag);
 asmlinkage long sys_shmdt(char __user *shmaddr);
 asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
+asmlinkage long sys_ipc(unsigned int call, int first, unsigned long second,
+		long third, void __user *ptr, long fifth);
 
 asmlinkage long sys_mq_open(const char __user *name, int oflag, mode_t mode, struct mq_attr __user *attr);
 asmlinkage long sys_mq_unlink(const char __user *name);
