Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbZA2Rso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbZA2Rso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbZA2Rsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:48:32 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:59137 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbZA2Rsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:48:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YMXhTrlcjLgEKjvXz7aD5wQdBFal054G1i0FKmyud8LOijT53v045Rr+IfpT+pZQ4V
         6cTdO+pT1kHCeJSYSXWtGPNYqmdHcDmbFTbXcMa9FxIcyQdBpbq5eT4bP/HhOfAsr5Nh
         VJul48CqpQoKqF8qJDDJRxgS9fYMHvuLV8fq0=
Date: Thu, 29 Jan 2009 20:54:11 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/17] proc tty: switch usb-serial to ->proc_fops
Message-ID: <20090129175411.GL21643@x200.localdomain>
References: <20090129174830.GA21643@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129174830.GA21643@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/usb/serial/usb-serial.c |   58 ++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index cfcfd5a..7f0b2b0 100644
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
@@ -416,57 +417,52 @@ static int serial_break(struct tty_struct *tty, int break_state)
 	return 0;
 }
 
-static int serial_read_proc(char *page, char **start, off_t off, int count,
-							int *eof, void *data)
+static int serial_proc_show(struct seq_file *m, void *v)
 {
 	struct usb_serial *serial;
-	int length = 0;
 	int i;
-	off_t begin = 0;
 	char tmp[40];
 
 	dbg("%s", __func__);
-	length += sprintf(page, "usbserinfo:1.0 driver:2.0\n");
-	for (i = 0; i < SERIAL_TTY_MINORS && length < PAGE_SIZE; ++i) {
+	seq_puts(m, "usbserinfo:1.0 driver:2.0\n");
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
+		seq_printf(m, " name:\"%s\"",
 				serial->type->description);
-		length += sprintf(page+length, " vendor:%04x product:%04x",
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
 
+static int serial_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, serial_proc_show, NULL);
+}
+
+static const struct file_operations serial_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= serial_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int serial_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -1101,9 +1097,9 @@ static const struct tty_operations serial_ops = {
 	.unthrottle =		serial_unthrottle,
 	.break_ctl =		serial_break,
 	.chars_in_buffer =	serial_chars_in_buffer,
-	.read_proc =		serial_read_proc,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
+	.proc_fops =		&serial_proc_fops,
 };
 
 struct tty_driver *usb_serial_tty_driver;
-- 
1.5.6.5

