Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbZCASmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbZCASmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 13:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZCASlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 13:41:51 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:51935 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbZCASlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 13:41:50 -0500
Date: Sun, 1 Mar 2009 19:40:26 +0100 (CET)
From: Cedric Roux <sed@free.fr>
To: linux-kernel@vger.kernel.org
Cc: mtk.manpages@gmail.com
Message-ID: <17015927.368551235932826484.JavaMail.root@spooler2-g27.priv.proxad.net>
Subject: [PATCH 1/1] vt: add ioctl commands to /dev/vcsaX to get/put the
 current palette of the given tty
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.243.41]
X-Mailer: Zimbra 5.0.11_GA_2627.UBUNTU8 (ZimbraWebClient - FF2.0 (Win)/5.0.11_GA_2627.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cedric Roux <sed@free.fr>

Adding a ioctl interface and two ioctl commands to /dev/vcsaX
to get/put the current palette of the given tty.

Signed-off-by: Cedric Roux <sed@free.fr>
---
This patch exists because there is no way to get the current
installed palette of a given tty. The PIO_CMAP and GIO_CMAP
in vt_ioctl.c:vt_ioctl play with the global default colormap.
And /dev/vcsaX don't dump the palette through their read
interface. And since a user may change colors of a given
tty by escape sequences, one should be able to retrieve
the palette through /dev/vcsaX, leading to this patch.

Some points I am not fully confident with:
- I am not sure about the return values in case of error.
- vt.c:set_colormap is now used in vc_screen.c so cannot be static
  anymore.
  The goal of this patch is to allow read access to the palette,
  I can remove the PIO_CMAP case and make set_colormap static again.
  This case is there because /dev/vcsaX is read/write so the access
  to the palette should also be read/write. (Or I can do it
  differently, no problem, just tell me how.)

(In case of formatting problem of this mail, I apologize.
I have a very bad mail access... Just tell me and I'll
do my best to resend something clean.)

diff -uprN -X linux-2.6.28/Documentation/dontdiff linux-2.6.28-vanilla/drivers/char/vc_screen.c linux-2.6.28/drivers/char/vc_screen.c
--- linux-2.6.28-vanilla/drivers/char/vc_screen.c	2008-12-24 23:26:37.000000000 +0000
+++ linux-2.6.28/drivers/char/vc_screen.c	2009-03-01 17:42:59.000000000 +0000
@@ -19,6 +19,8 @@
  * machek@k332.feld.cvut.cz - modified not to send characters to wrong console
  *	 - fixed some fatal off-by-one bugs (0-- no longer == -1 -> looping and looping and looping...)
  *	 - making it shorter - scr_readw are macros which expand in PRETTY long code
+ *
+ * Colormap put/get for /dev/vcsaX, Cedric Roux <sed@free.fr>, March 2009.
  */
 
 #include <linux/kernel.h>
@@ -470,11 +472,64 @@ vcs_open(struct inode *inode, struct fil
 	return ret;
 }
 
+static int
+vcs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+	  unsigned long arg)
+{
+	unsigned int currcons = iminor(inode);
+	struct vc_data *vc;
+	unsigned char pal[16*3];
+	int ret = 0;
+
+	/* access only defined for /dev/vcsaX, not /dev/vcsX */
+	if (currcons < 128)
+		return -ENOIOCTLCMD;
+
+	acquire_console_sem();
+
+	currcons &= 127;
+	if (currcons == 0)
+		currcons = fg_console;
+	else
+		currcons--;
+	if (!vc_cons_allocated(currcons)) {
+		ret = -ENXIO;
+		goto unlock_out;
+	}
+	vc = vc_cons[currcons].d;
+
+	switch (cmd) {
+	case PIO_CMAP:
+		if (copy_from_user(pal, (void __user *)arg, 16*3)) {
+			ret = -EFAULT;
+			goto unlock_out;
+		}
+		memcpy(vc->vc_palette, pal, 16*3);
+		set_palette(vc);
+		break;
+	case GIO_CMAP:
+		if (copy_to_user((void __user *)arg, vc->vc_palette, 16*3)) {
+			ret = -EFAULT;
+			goto unlock_out;
+		}
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+unlock_out:
+	release_console_sem();
+
+	return ret;
+}
+
 static const struct file_operations vcs_fops = {
 	.llseek		= vcs_lseek,
 	.read		= vcs_read,
 	.write		= vcs_write,
 	.open		= vcs_open,
+	.ioctl		= vcs_ioctl,
 };
 
 static struct class *vc_class;
diff -uprN -X linux-2.6.28/Documentation/dontdiff linux-2.6.28-vanilla/drivers/char/vt.c linux-2.6.28/drivers/char/vt.c
--- linux-2.6.28-vanilla/drivers/char/vt.c	2008-12-24 23:26:37.000000000 +0000
+++ linux-2.6.28/drivers/char/vt.c	2009-03-01 16:43:29.000000000 +0000
@@ -156,7 +156,6 @@ static void set_cursor(struct vc_data *v
 static void hide_cursor(struct vc_data *vc);
 static void console_callback(struct work_struct *ignored);
 static void blank_screen_t(unsigned long dummy);
-static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
 int default_utf8 = true;
@@ -3756,7 +3755,7 @@ void poke_blanked_console(void)
  *	Palettes
  */
 
-static void set_palette(struct vc_data *vc)
+void set_palette(struct vc_data *vc)
 {
 	WARN_CONSOLE_UNLOCKED();
 
diff -uprN -X linux-2.6.28/Documentation/dontdiff linux-2.6.28-vanilla/include/linux/vt_kern.h linux-2.6.28/include/linux/vt_kern.h
--- linux-2.6.28-vanilla/include/linux/vt_kern.h	2008-12-24 23:26:37.000000000 +0000
+++ linux-2.6.28/include/linux/vt_kern.h	2009-03-01 16:43:09.000000000 +0000
@@ -97,6 +97,7 @@ void reset_vc(struct vc_data *vc);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
 int vty_init(const struct file_operations *console_fops);
+void set_palette(struct vc_data *vc);
 
 /*
  * vc_screen.c shares this temporary buffer with the console write code so that
