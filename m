Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZDEAiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZDEAiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 20:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZDEAhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 20:37:55 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:55287 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZDEAhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 20:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bBYd8us/E0Rrcd1at+7Ju8cMYgqL8PkRwW/39Hvchnocysj/wbn9qyGmqOf+5EY0Xe
         B6ho1XrAdQSAdbUhKu16zCMS42cmXX/78ITAnGSngx1PBW3tkN7RPJEZcT1Hd6oz3HQ8
         gcYHCgQ72wmsZweC6kYLFS8NJchO3LHkmpqPk=
Date: Sun, 5 Apr 2009 04:37:48 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH] Staging: serqt_usb: switch to proc_fops
Message-ID: <20090405003748.GA26458@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
serqt_usb.c:441: error: unknown field 'read_proc' specified in initializer

tty_operations::read_proc was removed in 0f043a81e
(proc tty: remove struct tty_operations::read_proc)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/serqt_usb/serqt_usb.c |   63 ++++++++++++--------------------
 1 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/serqt_usb/serqt_usb.c b/drivers/staging/serqt_usb/serqt_usb.c
index 3b73c78..62ae5f7 100644
--- a/drivers/staging/serqt_usb/serqt_usb.c
+++ b/drivers/staging/serqt_usb/serqt_usb.c
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/version.h>
 #include <linux/uaccess.h>
+#include <linux/seq_file.h>
 
 /* Use our own dbg macro */
 /* #define DEBUG_ON */
@@ -288,8 +289,8 @@ static void serial_throttle(struct tty_struct *tty);
 static void serial_unthrottle(struct tty_struct *tty);
 static int serial_break(struct tty_struct *tty, int break_state);
 static int serial_chars_in_buffer(struct tty_struct *tty);
-static int serial_read_proc(char *page, char **start, off_t off, int count,
-			    int *eof, void *data);
+static int serial_proc_show(struct seq_file *m, void *v);
+static int serial_proc_open(struct inode *inode, struct file *file);
 
 static int qt_open(struct usb_serial_port *port, struct file *filp);
 static int BoxSetPrebufferLevel(struct usb_serial *serial);
@@ -427,6 +428,14 @@ static struct usb_driver serqt_usb_driver = {
 static struct ktermios *serial_termios[SERIAL_TTY_MINORS];
 static struct ktermios *serial_termios_locked[SERIAL_TTY_MINORS];
 
+static const struct file_operations serial_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= serial_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static const struct tty_operations serial_ops = {
 	.open = serial_open,
 	.close = serial_close,
@@ -438,7 +447,7 @@ static const struct tty_operations serial_ops = {
 	.unthrottle = serial_unthrottle,
 	.break_ctl = serial_break,
 	.chars_in_buffer = serial_chars_in_buffer,
-	.read_proc = serial_read_proc,
+	.proc_fops = &serial_proc_fops,
 	.tiocmset = serial_tiocmset,
 	.tiocmget = serial_tiocmget,
 };
@@ -2417,50 +2426,26 @@ exit:
 	return 0;
 }
 
-static int serial_read_proc(char *page, char **start, off_t off, int count,
-			    int *eof, void *data)
+static int serial_proc_show(struct seq_file *m, void *v)
 {
 	struct usb_serial *serial;
-	int length = 0;
 	int i;
-	off_t begin = 0;
 
-	mydbg("%s\n", __func__);
-	length += sprintf(page, "usbserinfo:1.0 driver:%s\n", DRIVER_VERSION);
-	for (i = 0; i < SERIAL_TTY_MINORS && length < PAGE_SIZE; ++i) {
+	seq_printf(m, "usbserinfo:1.0 driver:%s\n", DRIVER_VERSION);
+	for (i = 0; i < SERIAL_TTY_MINORS; i++) {
 		serial = get_serial_by_minor(i);
 		if (serial == NULL)
 			continue;
-
-		length += sprintf(page + length, "%d:\n", i);
-		length +=
-		    sprintf(page + length, " vendor:%04x product:%04x\n",
-			    serial->vendor, serial->product);
-		length +=
-		    sprintf(page + length, " num_ports:%d\n",
-			    serial->num_ports);
-		length +=
-		    sprintf(page + length, " port:%d\n", i - serial->minor + 1);
-
-/*
-		usb_make_path(serial->dev, tmp, sizeof(tmp));
-		length += sprintf (page+length, " path:%s", tmp);
-*/
-
-		length += sprintf(page + length, "\n");
-		if ((length + begin) > (off + count))
-			goto done;
-		if ((length + begin) < off) {
-			begin += length;
-			length = 0;
-		}
+		seq_printf(m, "%d:\n vendor:%04x product:%04x\n num_ports:%d\n"
+			   " port:%d\n", i, serial->vendor, serial->product,
+			   serial->num_ports, i - serial->minor + 1);
 	}
-	*eof = 1;
-done:
-	if (off >= (length + begin))
-		return 0;
-	*start = page + (off - begin);
-	return ((count < begin + length - off) ? count : begin + length - off);
+	return 0;
+}
+
+static int serial_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, serial_proc_show, NULL);
 }
 
 static int ioctl_serial_usb(struct inode *innod, struct file *filp, unsigned int cmd,
