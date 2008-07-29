Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYG2CD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYG2CD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYG2CDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:03:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:17607 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYG2CDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=j8fd/p7YhwetXP8Ed+lGJYKXRIC01tsdJoaNzGMdtRZH4E1bPaug2KdHwinCMrRh9H
         4UhUYmuouXT32H78fJBD6+FaDcC8IRetFa9mm00kYYbtlwfhyQILjW3pZDbctdow7SGj
         HTmgKsCOeqc7WCWjPEI/gx8Oy4mDSRVExr2yE=
Date: Tue, 29 Jul 2008 06:03:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/13] proc tty: switch sdio_uart to ->proc_fops
Message-ID: <20080729020356.GI3135@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/mmc/card/sdio_uart.c |   66 ++++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -33,6 +33,7 @@
 #include <linux/serial_reg.h>
 #include <linux/circ_buf.h>
 #include <linux/gfp.h>
+#include <linux/seq_file.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 
@@ -933,67 +934,66 @@ static int sdio_uart_tiocmset(struct tty_struct *tty, struct file *file,
 	return result;
 }
 
-static int sdio_uart_read_proc(char *page, char **start, off_t off,
-			       int count, int *eof, void *data)
+#ifdef CONFIG_PROC_FS
+static int sdio_uart_proc_show(struct seq_file *m, void *v)
 {
-	int i, len = 0;
-	off_t begin = 0;
+	int i;
 
-	len += sprintf(page, "serinfo:1.0 driver%s%s revision:%s\n",
+	seq_printf(m, "serinfo:1.0 driver%s%s revision:%s\n",
 		       "", "", "");
-	for (i = 0; i < UART_NR && len < PAGE_SIZE - 96; i++) {
+	for (i = 0; i < UART_NR; i++) {
 		struct sdio_uart_port *port = sdio_uart_port_get(i);
 		if (port) {
-			len += sprintf(page+len, "%d: uart:SDIO", i);
+			seq_printf(m, "%d: uart:SDIO", i);
 			if(capable(CAP_SYS_ADMIN)) {
-				len += sprintf(page + len, " tx:%d rx:%d",
+				seq_printf(m, " tx:%d rx:%d",
 					       port->icount.tx, port->icount.rx);
 				if (port->icount.frame)
-					len += sprintf(page + len, " fe:%d",
+					seq_printf(m, " fe:%d",
 						       port->icount.frame);
 				if (port->icount.parity)
-					len += sprintf(page + len, " pe:%d",
+					seq_printf(m, " pe:%d",
 						       port->icount.parity);
 				if (port->icount.brk)
-					len += sprintf(page + len, " brk:%d",
+					seq_printf(m, " brk:%d",
 						       port->icount.brk);
 				if (port->icount.overrun)
-					len += sprintf(page + len, " oe:%d",
+					seq_printf(m, " oe:%d",
 						       port->icount.overrun);
 				if (port->icount.cts)
-					len += sprintf(page + len, " cts:%d",
+					seq_printf(m, " cts:%d",
 						       port->icount.cts);
 				if (port->icount.dsr)
-					len += sprintf(page + len, " dsr:%d",
+					seq_printf(m, " dsr:%d",
 						       port->icount.dsr);
 				if (port->icount.rng)
-					len += sprintf(page + len, " rng:%d",
+					seq_printf(m, " rng:%d",
 						       port->icount.rng);
 				if (port->icount.dcd)
-					len += sprintf(page + len, " dcd:%d",
+					seq_printf(m, " dcd:%d",
 						       port->icount.dcd);
 			}
-			strcat(page, "\n");
-			len++;
+			seq_putc(m, '\n');
 			sdio_uart_port_put(port);
 		}
-
-		if (len + begin > off + count)
-			goto done;
-		if (len + begin < off) {
-			begin += len;
-			len = 0;
-		}
 	}
-	*eof = 1;
+	return 0;
+}
 
-done:
-	if (off >= len + begin)
-		return 0;
-	*start = page + (off - begin);
-	return (count < begin + len - off) ? count : (begin + len - off);
+static int sdio_uart_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sdio_uart_proc_show, NULL);
 }
 
+static const struct file_operations sdio_uart_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= sdio_uart_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
 static const struct tty_operations sdio_uart_ops = {
 	.open			= sdio_uart_open,
 	.close			= sdio_uart_close,
@@ -1007,7 +1007,9 @@ static const struct tty_operations sdio_uart_ops = {
 	.break_ctl		= sdio_uart_break_ctl,
 	.tiocmget		= sdio_uart_tiocmget,
 	.tiocmset		= sdio_uart_tiocmset,
-	.read_proc		= sdio_uart_read_proc,
+#ifdef CONFIG_PROC_FS
+	.proc_fops		= &sdio_uart_proc_fops,
+#endif
 };
 
 static struct tty_driver *sdio_uart_tty_driver;
-- 
1.5.4.5


