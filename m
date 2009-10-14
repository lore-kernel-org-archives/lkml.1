Return-Path: <linux-kernel-owner+w=401wt.eu-S934814AbZJNQAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934814AbZJNQAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934790AbZJNQAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:00:34 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:37849 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934698AbZJNQAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:00:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] compat_ioctl: remove VT specific ioctl handlers
Date: Wed, 14 Oct 2009 17:59:34 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Greg KH <greg@kroah.com>
References: <20091010153314.827301943@linutronix.de>
In-Reply-To: <20091010153314.827301943@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910141759.35162.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VT driver now handles all of these ioctls directly, so
we can remove the handlers from common code.

These are the only handlers that require the BKL because they
directly perform the ioctl action rather than just converting
the data structures. Once they are gone, we can remove the
BKL from the remaining ioctl conversion handlers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c |  188 +----------------------------------------------------
 1 files changed, 1 insertions(+), 187 deletions(-)

I guess it makes sense to merge these two through the BKL removal
queue.

	Arnd <><

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f91fd51..40904c6 100644
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
@@ -1934,11 +1779,7 @@ COMPATIBLE_IOCTL(STOP_ARRAY_RO)
 COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
 COMPATIBLE_IOCTL(GET_BITMAP_FILE)
 ULONG_IOCTL(SET_BITMAP_FILE)
-/* Big K */
-COMPATIBLE_IOCTL(PIO_FONT)
-COMPATIBLE_IOCTL(GIO_FONT)
-COMPATIBLE_IOCTL(PIO_CMAP)
-COMPATIBLE_IOCTL(GIO_CMAP)
+/* Keyboard -- can be removed once tty3270 uses ops->compat_ioctl */
 ULONG_IOCTL(KDSIGACCEPT)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
@@ -1962,12 +1803,6 @@ COMPATIBLE_IOCTL(KDGKBLED)
 ULONG_IOCTL(KDSKBLED)
 COMPATIBLE_IOCTL(KDGETLED)
 ULONG_IOCTL(KDSETLED)
-COMPATIBLE_IOCTL(GIO_SCRNMAP)
-COMPATIBLE_IOCTL(PIO_SCRNMAP)
-COMPATIBLE_IOCTL(GIO_UNISCRNMAP)
-COMPATIBLE_IOCTL(PIO_UNISCRNMAP)
-COMPATIBLE_IOCTL(PIO_FONTRESET)
-COMPATIBLE_IOCTL(PIO_UNIMAPCLR)
 #ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
@@ -1991,20 +1826,6 @@ COMPATIBLE_IOCTL(TUNSETOFFLOAD)
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
@@ -2603,13 +2424,6 @@ HANDLE_IOCTL(MTIOCPOS32, mt_ioctl_trans)
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

