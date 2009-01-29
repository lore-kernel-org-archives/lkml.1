Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbZA2Rr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbZA2Rr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbZA2Rrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:47:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:17204 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600AbZA2Rrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:47:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QXe3Y2a3JlvrGHSMJEeLafhPRVCFcSuyGLKeNOvLsA1b4/Ls/IxOBdXvzaM7BCh56E
         7cdJ3QN400MnxCTmQnoiGvd1jmBU6T+b29u4DTuuLbNPdJ0rw8pq81M37yStdJslvSHA
         cFpceVr27TLK9jBg08OdZTD8yKOBQgfYH7NIk=
Date: Thu, 29 Jan 2009 20:53:17 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/17] proc tty: switch sdio_uart to ->proc_fops
Message-ID: <20090129175317.GJ21643@x200.localdomain>
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
 drivers/mmc/card/sdio_uart.c |   62 ++++++++++++++++++++---------------------
 1 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 78ad487..36a8d53 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/seq_file.h>
 #include <linux/serial_reg.h>
 #include <linux/circ_buf.h>
 #include <linux/gfp.h>
@@ -933,67 +934,64 @@ static int sdio_uart_tiocmset(struct tty_struct *tty, struct file *file,
 	return result;
 }
 
-static int sdio_uart_read_proc(char *page, char **start, off_t off,
-			       int count, int *eof, void *data)
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
 			sdio_uart_port_put(port);
-		}
-
-		if (len + begin > off + count)
-			goto done;
-		if (len + begin < off) {
-			begin += len;
-			len = 0;
+			seq_putc(m, '\n');
 		}
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
+
 static const struct tty_operations sdio_uart_ops = {
 	.open			= sdio_uart_open,
 	.close			= sdio_uart_close,
@@ -1007,7 +1005,7 @@ static const struct tty_operations sdio_uart_ops = {
 	.break_ctl		= sdio_uart_break_ctl,
 	.tiocmget		= sdio_uart_tiocmget,
 	.tiocmset		= sdio_uart_tiocmset,
-	.read_proc		= sdio_uart_read_proc,
+	.proc_fops		= &sdio_uart_proc_fops,
 };
 
 static struct tty_driver *sdio_uart_tty_driver;
-- 
1.5.6.5

