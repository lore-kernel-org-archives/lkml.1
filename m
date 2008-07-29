Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYG2CFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYG2CFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYG2CF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:05:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:17800 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbYG2CF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dOLXmijxd4ycLz68EAiGIfJ6gYkzlTIQqI4IwTTR1fV2tTOicfAZybzFNleKzrbhQy
         7MI7EbFUK1XYBhhzQ/iONUpnGcoYBMZl4Z4+aINNoiylJ2mGpYYWUIjH4JxkFarygJBa
         9AewNca1TxPbbyxdfXbpz5WQEfl2Qcjb6e1pA=
Date: Tue, 29 Jul 2008 06:05:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 11/13] proc tty: switch usb_serial to ->proc_fops
Message-ID: <20080729020533.GK3135@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/usb/serial/usb-serial.c |   63 +++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -26,6 +26,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
@@ -412,57 +413,53 @@ static int serial_break(struct tty_struct *tty, int break_state)
 	return 0;
 }
 
-static int serial_read_proc(char *page, char **start, off_t off, int count,
-							int *eof, void *data)
+#ifdef CONFIG_PROC_FS
+static int usb_serial_proc_show(struct seq_file *m, void *v)
 {
 	struct usb_serial *serial;
-	int length = 0;
 	int i;
-	off_t begin = 0;
 	char tmp[40];
 
 	dbg("%s", __func__);
-	length += sprintf(page, "usbserinfo:1.0 driver:2.0\n");
-	for (i = 0; i < SERIAL_TTY_MINORS && length < PAGE_SIZE; ++i) {
+	seq_printf(m, "usbserinfo:1.0 driver:2.0\n");
+	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
 		serial = usb_serial_get_by_index(i);
 		if (serial == NULL)
 			continue;
 
-		length += sprintf(page+length, "%d:", i);
+		seq_printf(m, "%d:", i);
 		if (serial->type->driver.owner)
-			length += sprintf(page+length, " module:%s",
+			seq_printf(m, " module:%s",
 				module_name(serial->type->driver.owner));
-		length += sprintf(page+length, " name:\"%s\"",
-				serial->type->description);
-		length += sprintf(page+length, " vendor:%04x product:%04x",
+		seq_printf(m, " name:\"%s\"", serial->type->description);
+		seq_printf(m, " vendor:%04x product:%04x",
 			le16_to_cpu(serial->dev->descriptor.idVendor),
 			le16_to_cpu(serial->dev->descriptor.idProduct));
-		length += sprintf(page+length, " num_ports:%d",
-							serial->num_ports);
-		length += sprintf(page+length, " port:%d",
-							i - serial->minor + 1);
+		seq_printf(m, " num_ports:%d", serial->num_ports);
+		seq_printf(m, " port:%d", i - serial->minor + 1);
 		usb_make_path(serial->dev, tmp, sizeof(tmp));
-		length += sprintf(page+length, " path:%s", tmp);
+		seq_printf(m, " path:%s", tmp);
 
-		length += sprintf(page+length, "\n");
-		if ((length + begin) > (off + count)) {
-			usb_serial_put(serial);
-			goto done;
-		}
-		if ((length + begin) < off) {
-			begin += length;
-			length = 0;
-		}
+		seq_putc(m, '\n');
 		usb_serial_put(serial);
 	}
-	*eof = 1;
-done:
-	if (off >= (length + begin))
-		return 0;
-	*start = page + (off-begin);
-	return (count < begin+length-off) ? count : begin+length-off;
+	return 0;
 }
 
+static int usb_serial_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, usb_serial_proc_show, NULL);
+}
+
+static const struct file_operations usb_serial_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= usb_serial_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
 static int serial_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -1092,7 +1089,9 @@ static const struct tty_operations serial_ops = {
 	.unthrottle =		serial_unthrottle,
 	.break_ctl =		serial_break,
 	.chars_in_buffer =	serial_chars_in_buffer,
-	.read_proc =		serial_read_proc,
+#ifdef CONFIG_PROC_FS
+	.proc_fops =		&usb_serial_proc_fops,
+#endif
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
 };
-- 
1.5.4.5


