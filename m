Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZD0PIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZD0PIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbZD0PH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:07:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56224 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbZD0PHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:07:20 -0400
Message-Id: <20090427150318.542245635@arndb.de>
References: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 17:01:22 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, monstr@monstr.eu, linux-api@vger.kernel.org,
       linux-arch@vger.kernel.org, liqin.chen@sunplusct.com,
       Sam Ravnborg <sam@ravnborg.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [RFC 08/17] asm-generic: provide generic sysv ipc headers
Content-Disposition: inline; filename=0004-asm-generic-provide-generic-sysv-ipc-headers.patch
X-Provags-ID: V01U2FsdGVkX18wmQBfEyxMWVGMUCqYU5+IqC626jMw+7STpYD
 ALPYWiOH2/0ScpLXmQ/0jkVRgiUPw6BMAGVt0g6Zw0GF5ZxCsB
 RhyIUtaMNeumNWJbcMN5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ipc64 data structures were originally meant to
be architecture specific so that each architecture
could add their own optimizations for padding.

In the end, most of them just copied the x86 version,
and most got that wrong. UClibc expects the x86 anyway,
so we might just declare that the default and get
rid of the extra copies.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 include/asm-generic/Kbuild     |    5 	5 +	0 -	0 !
 include/asm-generic/ipcbuf.h   |   33 	33 +	0 -	0 !
 include/asm-generic/msgbuf.h   |   47 	47 +	0 -	0 !
 include/asm-generic/sembuf.h   |   38 	38 +	0 -	0 !
 include/asm-generic/shmbuf.h   |   59 	59 +	0 -	0 !
 include/asm-generic/shmparam.h |    6 	6 +	0 -	0 !
 6 files changed, 188 insertions(+)
 create mode 100644 include/asm-generic/ipcbuf.h
 create mode 100644 include/asm-generic/msgbuf.h
 create mode 100644 include/asm-generic/sembuf.h
 create mode 100644 include/asm-generic/shmbuf.h
 create mode 100644 include/asm-generic/shmparam.h

Index: linux-2.6/include/asm-generic/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-generic/Kbuild
+++ linux-2.6/include/asm-generic/Kbuild
@@ -2,9 +2,14 @@ header-y += errno-base.h
 header-y += errno.h
 header-y += fcntl.h
 header-y += ioctl.h
+header-y += ipcbuf.h
 header-y += mman-common.h
 header-y += mman.h
+header-y += msgbuf.h
 header-y += poll.h
+header-y += sembuf.h
+header-y += shmbuf.h
+header-y += shmparam.h
 header-y += signal-defs.h
 header-y += signal.h
 header-y += statfs.h
Index: linux-2.6/include/asm-generic/ipcbuf.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/ipcbuf.h
@@ -0,0 +1,33 @@
+#ifndef __ASM_GENERIC_IPCBUF_H
+#define __ASM_GENERIC_IPCBUF_H
+
+/*
+ * The generic ipc64_perm structure:
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * ipc64_perm was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * Pad space is left for:
+ * - 32-bit mode_t on architectures that only had 16 bit
+ * - 32-bit seq
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
+#endif /* __ASM_GENERIC_IPCBUF_H */
Index: linux-2.6/include/asm-generic/msgbuf.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/msgbuf.h
@@ -0,0 +1,47 @@
+#ifndef __ASM_GENERIC_MSGBUF_H
+#define __ASM_GENERIC_MSGBUF_H
+
+#include <asm/bitsperlong.h>
+/*
+ * generic msqid64_ds structure.
+ *
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * msqid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first three padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct msqid64_ds {
+	struct ipc64_perm msg_perm;
+	__kernel_time_t msg_stime;	/* last msgsnd time */
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused1;
+#endif
+	__kernel_time_t msg_rtime;	/* last msgrcv time */
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused2;
+#endif
+	__kernel_time_t msg_ctime;	/* last change time */
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused3;
+#endif
+	unsigned long  msg_cbytes;	/* current number of bytes on queue */
+	unsigned long  msg_qnum;	/* number of messages in queue */
+	unsigned long  msg_qbytes;	/* max number of bytes on queue */
+	__kernel_pid_t msg_lspid;	/* pid of last msgsnd */
+	__kernel_pid_t msg_lrpid;	/* last receive pid */
+	unsigned long  __unused4;
+	unsigned long  __unused5;
+};
+
+#endif /* __ASM_GENERIC_MSGBUF_H */
Index: linux-2.6/include/asm-generic/sembuf.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/sembuf.h
@@ -0,0 +1,38 @@
+#ifndef __ASM_GENERIC_SEMBUF_H
+#define __ASM_GENERIC_SEMBUF_H
+
+#include <asm/bitsperlong.h>
+
+/*
+ * The semid64_ds structure for x86 architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * semid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first two padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+struct semid64_ds {
+	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
+	__kernel_time_t	sem_otime;	/* last semop time */
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused1;
+#endif
+	__kernel_time_t	sem_ctime;	/* last change time */
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused2;
+#endif
+	unsigned long	sem_nsems;	/* no. of semaphores in array */
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+};
+
+#endif /* __ASM_GENERIC_SEMBUF_H */
Index: linux-2.6/include/asm-generic/shmbuf.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/shmbuf.h
@@ -0,0 +1,59 @@
+#ifndef __ASM_GENERIC_SHMBUF_H
+#define __ASM_GENERIC_SHMBUF_H
+
+#include <asm/bitsperlong.h>
+
+/*
+ * The shmid64_ds structure for x86 architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * shmid64_ds was originally meant to be architecture specific, but
+ * everyone just ended up making identical copies without specific
+ * optimizations, so we may just as well all use the same one.
+ *
+ * 64 bit architectures typically define a 64 bit __kernel_time_t,
+ * so they do not need the first two padding words.
+ * On big-endian systems, the padding is in the wrong place.
+ *
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct shmid64_ds {
+	struct ipc64_perm	shm_perm;	/* operation perms */
+	size_t			shm_segsz;	/* size of segment (bytes) */
+	__kernel_time_t		shm_atime;	/* last attach time */
+#if __BITS_PER_LONG != 64
+	unsigned long		__unused1;
+#endif
+	__kernel_time_t		shm_dtime;	/* last detach time */
+#if __BITS_PER_LONG != 64
+	unsigned long		__unused2;
+#endif
+	__kernel_time_t		shm_ctime;	/* last change time */
+#if __BITS_PER_LONG != 64
+	unsigned long		__unused3;
+#endif
+	__kernel_pid_t		shm_cpid;	/* pid of creator */
+	__kernel_pid_t		shm_lpid;	/* pid of last operator */
+	unsigned long		shm_nattch;	/* no. of current attaches */
+	unsigned long		__unused4;
+	unsigned long		__unused5;
+};
+
+struct shminfo64 {
+	unsigned long	shmmax;
+	unsigned long	shmmin;
+	unsigned long	shmmni;
+	unsigned long	shmseg;
+	unsigned long	shmall;
+	unsigned long	__unused1;
+	unsigned long	__unused2;
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+};
+
+#endif /* __ASM_GENERIC_SHMBUF_H */
Index: linux-2.6/include/asm-generic/shmparam.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/shmparam.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_GENERIC_SHMPARAM_H
+#define __ASM_GENERIC_SHMPARAM_H
+
+#define SHMLBA PAGE_SIZE	 /* attach addr a multiple of this */
+
+#endif /* _ASM_GENERIC_SHMPARAM_H */

-- 

