Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbXEYXjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbXEYXjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXEYXjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:39:44 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37837 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbXEYXjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:39:43 -0400
Date: Sat, 26 May 2007 00:39:17 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Egmont Koblinger <egmont@uhulinux.hu>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH] fix compat console unimap regression
Message-ID: <Pine.LNX.4.64.0705260032250.25650@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAZWdtb250QHVodWxpbnV4Lmh1AGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAdG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmcAc3RhYmxlQGtlcm5lbC5vcmcA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why is it that since the 2f1a2ccb9c0de632ab07193becf5f7121794f6ae console
UTF-8 fixes went into 2.6.22-rc1, the PowerMac G5 shows only inverse video
question marks for the text on tty2-6? whereas tty1 is fine, and so is x86.

No fault of that patch: by removing the old fallback behaviour, it reveals
that 32-bit setfont running on 64-bit kernels has only really worked on
the current console, the rest getting faked by that inadequate fallback.

Bring the compat do_unimap_ioctl into line with the main one: PIO_UNIMAP
and GIO_UNIMAP apply to the specified tty, not redirected to fg_console.
Use the same checks, and most particularly, remember to check access_ok:
con_set_unimap and con_get_unimap are using __get_user and __put_user.

And the compat vt_check should ask for the same capability as the main
one, CAP_SYS_TTY_CONFIG rather than CAP_SYS_ADMIN.  Added in vt_ioctl's
vc_cons_allocated check for safety, though failure may well be impossible.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/compat_ioctl.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--- 2.6.22-rc2/fs/compat_ioctl.c	2007-05-13 05:40:57.000000000 +0100
+++ linux/fs/compat_ioctl.c	2007-05-25 21:25:34.000000000 +0100
@@ -1194,6 +1194,7 @@ static int vt_check(struct file *file)
 {
 	struct tty_struct *tty;
 	struct inode *inode = file->f_path.dentry->d_inode;
+	struct vc_data *vc;
 	
 	if (file->f_op->ioctl != tty_ioctl)
 		return -EINVAL;
@@ -1204,12 +1205,16 @@ static int vt_check(struct file *file)
 	                                                
 	if (tty->driver->ioctl != vt_ioctl)
 		return -EINVAL;
-	
+
+	vc = (struct vc_data *)tty->driver_data;
+	if (!vc_cons_allocated(vc->vc_num)) 	/* impossible? */
+		return -ENOIOCTLCMD;
+
 	/*
 	 * To have permissions to do most of the vt ioctls, we either have
-	 * to be the owner of the tty, or super-user.
+	 * to be the owner of the tty, or have CAP_SYS_TTY_CONFIG.
 	 */
-	if (current->signal->tty == tty || capable(CAP_SYS_ADMIN))
+	if (current->signal->tty == tty || capable(CAP_SYS_TTY_CONFIG))
 		return 1;
 	return 0;                                                    
 }
@@ -1310,16 +1315,28 @@ static int do_unimap_ioctl(unsigned int 
 	struct unimapdesc32 tmp;
 	struct unimapdesc32 __user *user_ud = compat_ptr(arg);
 	int perm = vt_check(file);
-	
-	if (perm < 0) return perm;
+	struct vc_data *vc;
+
+	if (perm < 0)
+		return perm;
 	if (copy_from_user(&tmp, user_ud, sizeof tmp))
 		return -EFAULT;
+	if (tmp.entries)
+		if (!access_ok(VERIFY_WRITE, compat_ptr(tmp.entries),
+				tmp.entry_ct*sizeof(struct unipair)))
+			return -EFAULT;
+	vc = ((struct tty_struct *)file->private_data)->driver_data;
 	switch (cmd) {
 	case PIO_UNIMAP:
-		if (!perm) return -EPERM;
-		return con_set_unimap(vc_cons[fg_console].d, tmp.entry_ct, compat_ptr(tmp.entries));
+		if (!perm)
+			return -EPERM;
+		return con_set_unimap(vc, tmp.entry_ct,
+						compat_ptr(tmp.entries));
 	case GIO_UNIMAP:
-		return con_get_unimap(vc_cons[fg_console].d, tmp.entry_ct, &(user_ud->entry_ct), compat_ptr(tmp.entries));
+		if (!perm && fg_console != vc->vc_num)
+			return -EPERM;
+		return con_get_unimap(vc, tmp.entry_ct, &(user_ud->entry_ct),
+						compat_ptr(tmp.entries));
 	}
 	return 0;
 }
