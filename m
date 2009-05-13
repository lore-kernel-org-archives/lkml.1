Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbZEMW6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbZEMW6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760772AbZEMW4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:56:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZEMW4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:56:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH 03/15] asm-generic: add generic sysv ipc headers
Date: Wed, 13 May 2009 22:56:26 +0000
Message-Id: <1242255398-23779-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242255398-23779-1-git-send-email-arnd@arndb.de>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/KI5+S37bXio36e5DfWS5WSrjFoSvqEkRa3bn
 J3BQ3je6A7T4UtgDCW9eDF43fL2XKU/aT111V6BzhWeLzYilZX
 ewKGqiHR76vklxC8tKzRA==
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

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/Kbuild     |    5 +++
 include/asm-generic/ipcbuf.h   |   33 ++++++++++++++++++++++
 include/asm-generic/msgbuf.h   |   47 +++++++++++++++++++++++++++++++
 include/asm-generic/sembuf.h   |   38 +++++++++++++++++++++++++
 include/asm-generic/shmbuf.h   |   59 ++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/shmparam.h |    6 ++++
 6 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/ipcbuf.h
 create mode 100644 include/asm-generic/msgbuf.h
 create mode 100644 include/asm-generic/sembuf.h
 create mode 100644 include/asm-generic/shmbuf.h
 create mode 100644 include/asm-generic/shmparam.h

diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index cbb4378..fd7a9c4 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -3,8 +3,13 @@ header-y += errno-base.h
 header-y += errno.h
 header-y += fcntl.h
 header-y += ioctl.h
+header-y += ipcbuf.h
 header-y += mman-common.h
+header-y += msgbuf.h
 header-y += poll.h
+header-y += sembuf.h
+header-y += shmbuf.h
+header-y += shmparam.h
 header-y += signal-defs.h
 header-y += statfs.h
 
diff --git a/include/asm-generic/ipcbuf.h b/include/asm-generic/ipcbuf.h
new file mode 100644
index 0000000..888ca1c
--- /dev/null
+++ b/include/asm-generic/ipcbuf.h
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
diff --git a/include/asm-generic/msgbuf.h b/include/asm-generic/msgbuf.h
new file mode 100644
index 0000000..aec850d
--- /dev/null
+++ b/include/asm-generic/msgbuf.h
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
diff --git a/include/asm-generic/sembuf.h b/include/asm-generic/sembuf.h
new file mode 100644
index 0000000..4cb2c13
--- /dev/null
+++ b/include/asm-generic/sembuf.h
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
diff --git a/include/asm-generic/shmbuf.h b/include/asm-generic/shmbuf.h
new file mode 100644
index 0000000..5768fa6
--- /dev/null
+++ b/include/asm-generic/shmbuf.h
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
diff --git a/include/asm-generic/shmparam.h b/include/asm-generic/shmparam.h
new file mode 100644
index 0000000..51a3852
--- /dev/null
+++ b/include/asm-generic/shmparam.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_GENERIC_SHMPARAM_H
+#define __ASM_GENERIC_SHMPARAM_H
+
+#define SHMLBA PAGE_SIZE	 /* attach addr a multiple of this */
+
+#endif /* _ASM_GENERIC_SHMPARAM_H */
-- 
1.6.0.4

