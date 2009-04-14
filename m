Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZDNJ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZDNJ6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZDNJ6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:58:20 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:50161 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZDNJ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:58:18 -0400
Date: Tue, 14 Apr 2009 11:57:00 +0200 (CEST)
From: Cedric Roux <sed@free.fr>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       mtk manpages <mtk.manpages@gmail.com>, linux-api@vger.kernel.org
Message-ID: <24571169.5910431239703020222.JavaMail.root@spooler2-g27.priv.proxad.net>
In-Reply-To: <427911.793301236157128303.JavaMail.root@spooler2-g27.priv.proxad.net>
Subject: [PATCH] [try 3] vt: add ioctl commands to /dev/vcsaN to get/put the
 current palette of the given tty
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.243.42]
X-Mailer: Zimbra 5.0.11_GA_2627.UBUNTU8 (ZimbraWebClient - FF2.0 (Win)/5.0.11_GA_2627.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cedric Roux <sed@free.fr>

A ioctl interface and two ioctl commands added to /dev/vcsaN
to get/put the current palette of the given tty.

Signed-off-by: Cedric Roux <sed@free.fr>
---
This patch exists because there is no way to get the current
installed palette of a given tty. The PIO_CMAP and GIO_CMAP
in vt_ioctl.c:vt_ioctl play with the global default colormap.
And /dev/vcsaN don't dump the palette through their read
interface. And since a user may change colors of a given
tty by escape sequences, one should be able to retrieve
the palette through /dev/vcsaN, leading to this patch.

Some points I am not fully confident with:
- vt.c:set_colormap is now used in vc_screen.c so cannot be static
  anymore.
  The goal of this patch is to allow read access to the palette,
  I can remove the PIO_CMAP case and make set_colormap static again.
  This case is there because /dev/vcsaN is read/write so the access
  to the palette should also be read/write. (Or I can do it
  differently, no problem, just tell me how.)
- the palette is returned as it is stored in the kernel, without
  taking into account color_table. So if a userland program
  gets an attribute for a given character, it won't match
  with the palette information. Say the user reads 0xXY through
  /dev/vcsa and takes Y as an index in the palette, it will return
  a bad color. One should do palette[color_table[Y]] to get the real
  color.
  Two "solutions" to this "problem" (it might be an non-issue):
    + export the palette by indexing with color_table:
      I don't like it.
    + let the userland program deal with that:
      the program may open a tty, send escape sequences to
      set the current color, write a character at a given position
      (through the tty, not /dev/vcs) and read back the attribute
      through /dev/vcsa this time. She will see what attribute
      corresponds to what color she sets by using escape sequences.
  If the color_table is non-mutable, all this is a non-issue.
  Userland programs just store the color_table and live with that.
  I've seen no code that modifies the color_table, so I bet it's
  non-mutable. (May it change in the future?)
- lock_kernel() is called. Maybe it's not necessary? I'm not
  confident enough. You decide.

diff -uprN -X linux-2.6.29.1/Documentation/dontdiff linux-2.6.29.1-vanilla/drivers/char/vc_screen.c linux-2.6.29.1/drivers/char/vc_screen.c
--- linux-2.6.29.1-vanilla/drivers/char/vc_screen.c	2009-04-02 22:55:27.000000000 +0200
+++ linux-2.6.29.1/drivers/char/vc_screen.c	2009-04-14 10:16:33.000000000 +0200
@@ -19,6 +19,8 @@
  * machek@k332.feld.cvut.cz - modified not to send characters to wrong console
  *	 - fixed some fatal off-by-one bugs (0-- no longer == -1 -> looping and looping and looping...)
  *	 - making it shorter - scr_readw are macros which expand in PRETTY long code
+ *
+ * Colormap put/get for /dev/vcsaN, Cedric Roux <sed@free.fr>, March 2009.
  */
 
 #include <linux/kernel.h>
@@ -470,11 +472,67 @@ vcs_open(struct inode *inode, struct fil
 	return ret;
 }
 
+static long
+vcs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	unsigned int currcons = iminor(file->f_path.dentry->d_inode);
+	struct vc_data *vc;
+	unsigned char pal[16*3];
+	long ret = 0;
+
+	/* access only defined for /dev/vcsaN, not /dev/vcsN */
+	if (currcons < 128)
+		return -ENOTTY;
+
+	lock_kernel();
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
+	unlock_kernel();
+
+	return ret;
+}
+
 static const struct file_operations vcs_fops = {
 	.llseek		= vcs_lseek,
 	.read		= vcs_read,
 	.write		= vcs_write,
 	.open		= vcs_open,
+	.unlocked_ioctl	= vcs_ioctl,
 };
 
 static struct class *vc_class;
diff -uprN -X linux-2.6.29.1/Documentation/dontdiff linux-2.6.29.1-vanilla/drivers/char/vt.c linux-2.6.29.1/drivers/char/vt.c
--- linux-2.6.29.1-vanilla/drivers/char/vt.c	2009-04-02 22:55:27.000000000 +0200
+++ linux-2.6.29.1/drivers/char/vt.c	2009-04-14 10:17:20.000000000 +0200
@@ -156,7 +156,6 @@ static void set_cursor(struct vc_data *v
 static void hide_cursor(struct vc_data *vc);
 static void console_callback(struct work_struct *ignored);
 static void blank_screen_t(unsigned long dummy);
-static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
 int default_utf8 = true;
@@ -3753,7 +3752,7 @@ void poke_blanked_console(void)
  *	Palettes
  */
 
-static void set_palette(struct vc_data *vc)
+void set_palette(struct vc_data *vc)
 {
 	WARN_CONSOLE_UNLOCKED();
 
diff -uprN -X linux-2.6.29.1/Documentation/dontdiff linux-2.6.29.1-vanilla/include/linux/vt_kern.h linux-2.6.29.1/include/linux/vt_kern.h
--- linux-2.6.29.1-vanilla/include/linux/vt_kern.h	2009-04-02 22:55:27.000000000 +0200
+++ linux-2.6.29.1/include/linux/vt_kern.h	2009-04-14 10:17:59.000000000 +0200
@@ -97,6 +97,7 @@ void reset_vc(struct vc_data *vc);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
 int vty_init(const struct file_operations *console_fops);
+void set_palette(struct vc_data *vc);
 
 /*
  * vc_screen.c shares this temporary buffer with the console write code so that
