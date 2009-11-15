Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZKOQEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZKOQEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 11:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZKOQEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 11:04:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbZKOQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 11:04:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 2/4] compat_ioctl: simplify calling of handlers
Date: Sun, 15 Nov 2009 16:04:08 +0000
Message-Id: <1258301050-26900-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258301050-26900-1-git-send-email-arnd@arndb.de>
References: <1258301050-26900-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/mjO6h4pgvRNG9zgF8B5kKoEeoH7UCM7zyKTo
 C3ZDMAeySyZDHobo02C9i658gc978tkoVGHKQezJZdR9pPGRA1
 JqplY/g3CkcTqcn+JBqDQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compat_ioctl array now contains only entries for ioctl numbers
that do not require a separate handler. By special-casing the
ULONG_IOCTL case in the do_ioctl_trans function, we can kill the
final use of a function pointer in the array.

   text    data     bss     dec     hex filename
   7539   13352    2080   22971    59bb before/fs/compat_ioctl.o
   7910    8552    2080   18542    486e after/fs/compat_ioctl.o

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c |   86 ++++++++++++++++++++++++-----------------------------
 1 files changed, 39 insertions(+), 47 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 4fa5313..d8039c3 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -115,12 +115,6 @@
 #include <asm/fbio.h>
 #endif
 
-static int do_ioctl32_pointer(unsigned int fd, unsigned int cmd,
-			      unsigned long arg, struct file *f)
-{
-	return sys_ioctl(fd, cmd, (unsigned long)compat_ptr(arg));
-}
-
 static int w_long(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
 	mm_segment_t old_fs = get_fs();
@@ -1055,25 +1049,13 @@ static int compat_ioctl_preallocate(struct file *file, unsigned long arg)
 #endif
 
 
-typedef int (*ioctl_trans_handler_t)(unsigned int, unsigned int,
-					unsigned long, struct file *);
-
 struct ioctl_trans {
 	unsigned long cmd;
-	ioctl_trans_handler_t handler;
 	struct ioctl_trans *next;
 };
 
-#define HANDLE_IOCTL(cmd,handler) \
-	{ (cmd), (ioctl_trans_handler_t)(handler) },
-
 /* pointer to compatible structure or no argument */
-#define COMPATIBLE_IOCTL(cmd) \
-	{ (cmd), do_ioctl32_pointer },
-
-/* argument is an unsigned long integer, not a pointer */
-#define ULONG_IOCTL(cmd) \
-	{ (cmd), (ioctl_trans_handler_t)sys_ioctl },
+#define COMPATIBLE_IOCTL(cmd) { (cmd), },
 
 /* ioctl should not be warned about even if it's not implemented.
    Valid reasons to use this:
@@ -1095,7 +1077,6 @@ COMPATIBLE_IOCTL(TCSETA)
 COMPATIBLE_IOCTL(TCSETAW)
 COMPATIBLE_IOCTL(TCSETAF)
 COMPATIBLE_IOCTL(TCSBRK)
-ULONG_IOCTL(TCSBRKP)
 COMPATIBLE_IOCTL(TCXONC)
 COMPATIBLE_IOCTL(TCFLSH)
 COMPATIBLE_IOCTL(TCGETS)
@@ -1105,7 +1086,6 @@ COMPATIBLE_IOCTL(TCSETSF)
 COMPATIBLE_IOCTL(TIOCLINUX)
 COMPATIBLE_IOCTL(TIOCSBRK)
 COMPATIBLE_IOCTL(TIOCCBRK)
-ULONG_IOCTL(TIOCMIWAIT)
 COMPATIBLE_IOCTL(TIOCGICOUNT)
 /* Little t */
 COMPATIBLE_IOCTL(TIOCGETD)
@@ -1127,7 +1107,6 @@ COMPATIBLE_IOCTL(TIOCSTI)
 COMPATIBLE_IOCTL(TIOCOUTQ)
 COMPATIBLE_IOCTL(TIOCSPGRP)
 COMPATIBLE_IOCTL(TIOCGPGRP)
-ULONG_IOCTL(TIOCSCTTY)
 COMPATIBLE_IOCTL(TIOCGPTN)
 COMPATIBLE_IOCTL(TIOCSPTLCK)
 COMPATIBLE_IOCTL(TIOCSERGETLSR)
@@ -1158,32 +1137,21 @@ COMPATIBLE_IOCTL(PRINT_RAID_DEBUG)
 COMPATIBLE_IOCTL(RAID_AUTORUN)
 COMPATIBLE_IOCTL(CLEAR_ARRAY)
 COMPATIBLE_IOCTL(ADD_NEW_DISK)
-ULONG_IOCTL(HOT_REMOVE_DISK)
 COMPATIBLE_IOCTL(SET_ARRAY_INFO)
 COMPATIBLE_IOCTL(SET_DISK_INFO)
 COMPATIBLE_IOCTL(WRITE_RAID_INFO)
 COMPATIBLE_IOCTL(UNPROTECT_ARRAY)
 COMPATIBLE_IOCTL(PROTECT_ARRAY)
-ULONG_IOCTL(HOT_ADD_DISK)
-ULONG_IOCTL(SET_DISK_FAULTY)
 COMPATIBLE_IOCTL(RUN_ARRAY)
 COMPATIBLE_IOCTL(STOP_ARRAY)
 COMPATIBLE_IOCTL(STOP_ARRAY_RO)
 COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
 COMPATIBLE_IOCTL(GET_BITMAP_FILE)
-ULONG_IOCTL(SET_BITMAP_FILE)
-/* Keyboard -- can be removed once tty3270 uses ops->compat_ioctl */
-ULONG_IOCTL(KDSIGACCEPT)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
-ULONG_IOCTL(KIOCSOUND)
-ULONG_IOCTL(KDMKTONE)
 COMPATIBLE_IOCTL(KDGKBTYPE)
-ULONG_IOCTL(KDSETMODE)
 COMPATIBLE_IOCTL(KDGETMODE)
-ULONG_IOCTL(KDSKBMODE)
 COMPATIBLE_IOCTL(KDGKBMODE)
-ULONG_IOCTL(KDSKBMETA)
 COMPATIBLE_IOCTL(KDGKBMETA)
 COMPATIBLE_IOCTL(KDGKBENT)
 COMPATIBLE_IOCTL(KDSKBENT)
@@ -1193,9 +1161,7 @@ COMPATIBLE_IOCTL(KDGKBDIACR)
 COMPATIBLE_IOCTL(KDSKBDIACR)
 COMPATIBLE_IOCTL(KDKBDREP)
 COMPATIBLE_IOCTL(KDGKBLED)
-ULONG_IOCTL(KDSKBLED)
 COMPATIBLE_IOCTL(KDGETLED)
-ULONG_IOCTL(KDSETLED)
 #ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
@@ -1241,7 +1207,6 @@ IGNORE_IOCTL(LOOP_CLR_FD)
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_EMULATED_HOST)
-ULONG_IOCTL(SG_SET_TRANSFORM)
 COMPATIBLE_IOCTL(SG_GET_TRANSFORM)
 COMPATIBLE_IOCTL(SG_SET_RESERVED_SIZE)
 COMPATIBLE_IOCTL(SG_GET_RESERVED_SIZE)
@@ -1478,8 +1443,6 @@ COMPATIBLE_IOCTL(SOUND_MIXER_GETLEVELS)
 COMPATIBLE_IOCTL(SOUND_MIXER_SETLEVELS)
 COMPATIBLE_IOCTL(OSS_GETVERSION)
 /* AUTOFS */
-ULONG_IOCTL(AUTOFS_IOC_READY)
-ULONG_IOCTL(AUTOFS_IOC_FAIL)
 COMPATIBLE_IOCTL(AUTOFS_IOC_CATATONIC)
 COMPATIBLE_IOCTL(AUTOFS_IOC_PROTOVER)
 COMPATIBLE_IOCTL(AUTOFS_IOC_EXPIRE)
@@ -1588,14 +1551,10 @@ COMPATIBLE_IOCTL(USBDEVFS_REAPURB32)
 COMPATIBLE_IOCTL(USBDEVFS_REAPURBNDELAY32)
 COMPATIBLE_IOCTL(USBDEVFS_CLEAR_HALT)
 /* NBD */
-ULONG_IOCTL(NBD_SET_SOCK)
-ULONG_IOCTL(NBD_SET_BLKSIZE)
-ULONG_IOCTL(NBD_SET_SIZE)
 COMPATIBLE_IOCTL(NBD_DO_IT)
 COMPATIBLE_IOCTL(NBD_CLEAR_SOCK)
 COMPATIBLE_IOCTL(NBD_CLEAR_QUE)
 COMPATIBLE_IOCTL(NBD_PRINT_DEBUG)
-ULONG_IOCTL(NBD_SET_SIZE_BLOCKS)
 COMPATIBLE_IOCTL(NBD_DISCONNECT)
 /* i2c */
 COMPATIBLE_IOCTL(I2C_SLAVE)
@@ -1833,6 +1792,43 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case LPSETTIMEOUT:
 		return lp_timeout_trans(fd, cmd, arg);
 	}
+
+	/*
+	 * These take an integer instead of a pointer as 'arg',
+	 * so we must not do a compat_ptr() translation.
+	 */
+	switch (cmd) {
+	/* Big T */
+	case TCSBRKP:
+	case TIOCMIWAIT:
+	case TIOCSCTTY:
+	/* RAID */
+	case HOT_REMOVE_DISK:
+	case HOT_ADD_DISK:
+	case SET_DISK_FAULTY:
+	case SET_BITMAP_FILE:
+	/* Big K */
+	case KDSIGACCEPT:
+	case KIOCSOUND:
+	case KDMKTONE:
+	case KDSETMODE:
+	case KDSKBMODE:
+	case KDSKBMETA:
+	case KDSKBLED:
+	case KDSETLED:
+	/* SG stuff */
+	case SG_SET_TRANSFORM:
+	/* AUTOFS */
+	case AUTOFS_IOC_READY:
+	case AUTOFS_IOC_FAIL:
+	/* NBD */
+	case NBD_SET_SOCK:
+	case NBD_SET_BLKSIZE:
+	case NBD_SET_SIZE:
+	case NBD_SET_SIZE_BLOCKS:
+		return do_vfs_ioctl(file, fd, cmd, arg);
+	}
+
 	return -ENOIOCTLCMD;
 }
 
@@ -1944,11 +1940,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 	goto out_fput;
 
  found_handler:
-	if (t->handler) {
-		error = t->handler(fd, cmd, arg, filp);
-		goto out_fput;
-	}
-
+	arg = (unsigned long)compat_ptr(arg);
  do_ioctl:
 	error = do_vfs_ioctl(filp, fd, cmd, arg);
  out_fput:
-- 
1.6.3.3

