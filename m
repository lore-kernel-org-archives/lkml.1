Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbZHFNKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbZHFNKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbZHFNKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:10:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56359 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbZHFNKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:10:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/5] compat_ioctl: remove VT specific ioctl handlers
Date: Thu,  6 Aug 2009 15:09:29 +0200
Message-Id: <1249564170-18627-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249564170-18627-1-git-send-email-arnd@arndb.de>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+NQldAfEskto74dnoe0GnzG/VGPupM2ngcz8V
 ktJHbvxBqV0TBe920b+5TX12py1LbGrY2+aEcbmzGjdpasGPw9
 gMk44dFoAjT354YuQTf3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VT, tty3270 and UML console drivers now handle all of
these ioctls directly, so we can remove the handlers from
common code.

These are the only handlers that require the BKL because they
directly perform the ioctl action rather than just converting
the data structures. Once they are gone, we can remove the
BKL from the remaining ioctl conversion handlers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c |  211 -----------------------------------------------------
 1 files changed, 0 insertions(+), 211 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f28f070..5d800aa 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1039,161 +1039,6 @@ static int mt_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
 
 #endif /* CONFIG_BLOCK */
 
-#ifdef CONFIG_VT
-
-static int vt_check(struct file *file)
-{
-	struct tty_struct *tty;
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct vc_data *vc;
-	
-	if (file->f_op->unlocked_ioctl != tty_ioctl)
-		return -EINVAL;
-	                
-	tty = (struct tty_struct *)file->private_data;
-	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
-		return -EINVAL;
-	                                                
-	if (tty->ops->ioctl != vt_ioctl)
-		return -EINVAL;
-
-	vc = (struct vc_data *)tty->driver_data;
-	if (!vc_cons_allocated(vc->vc_num)) 	/* impossible? */
-		return -ENOIOCTLCMD;
-
-	/*
-	 * To have permissions to do most of the vt ioctls, we either have
-	 * to be the owner of the tty, or have CAP_SYS_TTY_CONFIG.
-	 */
-	if (current->signal->tty == tty || capable(CAP_SYS_TTY_CONFIG))
-		return 1;
-	return 0;                                                    
-}
-
-struct consolefontdesc32 {
-	unsigned short charcount;       /* characters in font (256 or 512) */
-	unsigned short charheight;      /* scan lines per character (1-32) */
-	compat_caddr_t chardata;	/* font data in expanded form */
-};
-
-static int do_fontx_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg, struct file *file)
-{
-	struct consolefontdesc32 __user *user_cfd = compat_ptr(arg);
-	struct console_font_op op;
-	compat_caddr_t data;
-	int i, perm;
-
-	perm = vt_check(file);
-	if (perm < 0) return perm;
-	
-	switch (cmd) {
-	case PIO_FONTX:
-		if (!perm)
-			return -EPERM;
-		op.op = KD_FONT_OP_SET;
-		op.flags = 0;
-		op.width = 8;
-		if (get_user(op.height, &user_cfd->charheight) ||
-		    get_user(op.charcount, &user_cfd->charcount) ||
-		    get_user(data, &user_cfd->chardata))
-			return -EFAULT;
-		op.data = compat_ptr(data);
-		return con_font_op(vc_cons[fg_console].d, &op);
-	case GIO_FONTX:
-		op.op = KD_FONT_OP_GET;
-		op.flags = 0;
-		op.width = 8;
-		if (get_user(op.height, &user_cfd->charheight) ||
-		    get_user(op.charcount, &user_cfd->charcount) ||
-		    get_user(data, &user_cfd->chardata))
-			return -EFAULT;
-		if (!data)
-			return 0;
-		op.data = compat_ptr(data);
-		i = con_font_op(vc_cons[fg_console].d, &op);
-		if (i)
-			return i;
-		if (put_user(op.height, &user_cfd->charheight) ||
-		    put_user(op.charcount, &user_cfd->charcount) ||
-		    put_user((compat_caddr_t)(unsigned long)op.data,
-				&user_cfd->chardata))
-			return -EFAULT;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-struct console_font_op32 {
-	compat_uint_t op;        /* operation code KD_FONT_OP_* */
-	compat_uint_t flags;     /* KD_FONT_FLAG_* */
-	compat_uint_t width, height;     /* font size */
-	compat_uint_t charcount;
-	compat_caddr_t data;    /* font data with height fixed to 32 */
-};
-                                        
-static int do_kdfontop_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg, struct file *file)
-{
-	struct console_font_op op;
-	struct console_font_op32 __user *fontop = compat_ptr(arg);
-	int perm = vt_check(file), i;
-	struct vc_data *vc;
-	
-	if (perm < 0) return perm;
-	
-	if (copy_from_user(&op, fontop, sizeof(struct console_font_op32)))
-		return -EFAULT;
-	if (!perm && op.op != KD_FONT_OP_GET)
-		return -EPERM;
-	op.data = compat_ptr(((struct console_font_op32 *)&op)->data);
-	op.flags |= KD_FONT_FLAG_OLD;
-	vc = ((struct tty_struct *)file->private_data)->driver_data;
-	i = con_font_op(vc, &op);
-	if (i)
-		return i;
-	((struct console_font_op32 *)&op)->data = (unsigned long)op.data;
-	if (copy_to_user(fontop, &op, sizeof(struct console_font_op32)))
-		return -EFAULT;
-	return 0;
-}
-
-struct unimapdesc32 {
-	unsigned short entry_ct;
-	compat_caddr_t entries;
-};
-
-static int do_unimap_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg, struct file *file)
-{
-	struct unimapdesc32 tmp;
-	struct unimapdesc32 __user *user_ud = compat_ptr(arg);
-	int perm = vt_check(file);
-	struct vc_data *vc;
-
-	if (perm < 0)
-		return perm;
-	if (copy_from_user(&tmp, user_ud, sizeof tmp))
-		return -EFAULT;
-	if (tmp.entries)
-		if (!access_ok(VERIFY_WRITE, compat_ptr(tmp.entries),
-				tmp.entry_ct*sizeof(struct unipair)))
-			return -EFAULT;
-	vc = ((struct tty_struct *)file->private_data)->driver_data;
-	switch (cmd) {
-	case PIO_UNIMAP:
-		if (!perm)
-			return -EPERM;
-		return con_set_unimap(vc, tmp.entry_ct,
-						compat_ptr(tmp.entries));
-	case GIO_UNIMAP:
-		if (!perm && fg_console != vc->vc_num)
-			return -EPERM;
-		return con_get_unimap(vc, tmp.entry_ct, &(user_ud->entry_ct),
-						compat_ptr(tmp.entries));
-	}
-	return 0;
-}
-
-#endif /* CONFIG_VT */
-
 static int do_smb_getmountuid(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
 	mm_segment_t old_fs = get_fs();
@@ -1864,7 +1709,6 @@ COMPATIBLE_IOCTL(TCGETS)
 COMPATIBLE_IOCTL(TCSETS)
 COMPATIBLE_IOCTL(TCSETSW)
 COMPATIBLE_IOCTL(TCSETSF)
-COMPATIBLE_IOCTL(TIOCLINUX)
 COMPATIBLE_IOCTL(TIOCSBRK)
 COMPATIBLE_IOCTL(TIOCCBRK)
 ULONG_IOCTL(TIOCMIWAIT)
@@ -1933,40 +1777,6 @@ COMPATIBLE_IOCTL(STOP_ARRAY_RO)
 COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
 COMPATIBLE_IOCTL(GET_BITMAP_FILE)
 ULONG_IOCTL(SET_BITMAP_FILE)
-/* Big K */
-COMPATIBLE_IOCTL(PIO_FONT)
-COMPATIBLE_IOCTL(GIO_FONT)
-COMPATIBLE_IOCTL(PIO_CMAP)
-COMPATIBLE_IOCTL(GIO_CMAP)
-ULONG_IOCTL(KDSIGACCEPT)
-COMPATIBLE_IOCTL(KDGETKEYCODE)
-COMPATIBLE_IOCTL(KDSETKEYCODE)
-ULONG_IOCTL(KIOCSOUND)
-ULONG_IOCTL(KDMKTONE)
-COMPATIBLE_IOCTL(KDGKBTYPE)
-ULONG_IOCTL(KDSETMODE)
-COMPATIBLE_IOCTL(KDGETMODE)
-ULONG_IOCTL(KDSKBMODE)
-COMPATIBLE_IOCTL(KDGKBMODE)
-ULONG_IOCTL(KDSKBMETA)
-COMPATIBLE_IOCTL(KDGKBMETA)
-COMPATIBLE_IOCTL(KDGKBENT)
-COMPATIBLE_IOCTL(KDSKBENT)
-COMPATIBLE_IOCTL(KDGKBSENT)
-COMPATIBLE_IOCTL(KDSKBSENT)
-COMPATIBLE_IOCTL(KDGKBDIACR)
-COMPATIBLE_IOCTL(KDSKBDIACR)
-COMPATIBLE_IOCTL(KDKBDREP)
-COMPATIBLE_IOCTL(KDGKBLED)
-ULONG_IOCTL(KDSKBLED)
-COMPATIBLE_IOCTL(KDGETLED)
-ULONG_IOCTL(KDSETLED)
-COMPATIBLE_IOCTL(GIO_SCRNMAP)
-COMPATIBLE_IOCTL(PIO_SCRNMAP)
-COMPATIBLE_IOCTL(GIO_UNISCRNMAP)
-COMPATIBLE_IOCTL(PIO_UNISCRNMAP)
-COMPATIBLE_IOCTL(PIO_FONTRESET)
-COMPATIBLE_IOCTL(PIO_UNIMAPCLR)
 #ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
@@ -1990,20 +1800,6 @@ COMPATIBLE_IOCTL(TUNSETOFFLOAD)
 COMPATIBLE_IOCTL(TUNSETTXFILTER)
 COMPATIBLE_IOCTL(TUNGETSNDBUF)
 COMPATIBLE_IOCTL(TUNSETSNDBUF)
-/* Big V */
-COMPATIBLE_IOCTL(VT_SETMODE)
-COMPATIBLE_IOCTL(VT_GETMODE)
-COMPATIBLE_IOCTL(VT_GETSTATE)
-COMPATIBLE_IOCTL(VT_OPENQRY)
-ULONG_IOCTL(VT_ACTIVATE)
-ULONG_IOCTL(VT_WAITACTIVE)
-ULONG_IOCTL(VT_RELDISP)
-ULONG_IOCTL(VT_DISALLOCATE)
-COMPATIBLE_IOCTL(VT_RESIZE)
-COMPATIBLE_IOCTL(VT_RESIZEX)
-COMPATIBLE_IOCTL(VT_LOCKSWITCH)
-COMPATIBLE_IOCTL(VT_UNLOCKSWITCH)
-COMPATIBLE_IOCTL(VT_GETHIFONTMASK)
 /* Little p (/dev/rtc, /dev/envctrl, etc.) */
 COMPATIBLE_IOCTL(RTC_AIE_ON)
 COMPATIBLE_IOCTL(RTC_AIE_OFF)
@@ -2602,13 +2398,6 @@ HANDLE_IOCTL(MTIOCPOS32, mt_ioctl_trans)
 #endif
 #define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,unsigned int)
 HANDLE_IOCTL(AUTOFS_IOC_SETTIMEOUT32, ioc_settimeout)
-#ifdef CONFIG_VT
-HANDLE_IOCTL(PIO_FONTX, do_fontx_ioctl)
-HANDLE_IOCTL(GIO_FONTX, do_fontx_ioctl)
-HANDLE_IOCTL(PIO_UNIMAP, do_unimap_ioctl)
-HANDLE_IOCTL(GIO_UNIMAP, do_unimap_ioctl)
-HANDLE_IOCTL(KDFONTOP, do_kdfontop_ioctl)
-#endif
 /* One SMB ioctl needs translations. */
 #define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
 HANDLE_IOCTL(SMB_IOC_GETMOUNTUID_32, do_smb_getmountuid)
-- 
1.6.3.3

