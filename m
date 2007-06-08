Return-Path: <linux-kernel-owner+w=401wt.eu-S938595AbXFHHjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938595AbXFHHjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967858AbXFHHYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:03 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55134 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967845AbXFHHYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:00 -0400
Message-Id: <20070608072202.761118000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh@veritas.com>,
       Egmont Koblinger <egmont@uhulinux.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 20/54] fix compat console unimap regression
Content-Disposition: inline; filename=fix-compat-console-unimap-regression.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Hugh Dickins <hugh@veritas.com>

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 fs/compat_ioctl.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--- linux-2.6.21.4.orig/fs/compat_ioctl.c
+++ linux-2.6.21.4/fs/compat_ioctl.c
@@ -1178,6 +1178,7 @@ static int vt_check(struct file *file)
 {
 	struct tty_struct *tty;
 	struct inode *inode = file->f_path.dentry->d_inode;
+	struct vc_data *vc;
 	
 	if (file->f_op->ioctl != tty_ioctl)
 		return -EINVAL;
@@ -1188,12 +1189,16 @@ static int vt_check(struct file *file)
 	                                                
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
@@ -1294,16 +1299,28 @@ static int do_unimap_ioctl(unsigned int 
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

-- 
