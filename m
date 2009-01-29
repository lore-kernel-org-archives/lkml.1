Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbZA2RsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbZA2RsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbZA2RsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:48:03 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:59137 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759604AbZA2RsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ok2pc61tkAc9cdNBnCzzsNYaX+2XWZVoUR43+tswsZups7Ssi8Xld3XyHJbD72BZIx
         vlOufTANxXdp9HOTYJB0cxOLbgsplfPr6gEEuge9B5UX3BswA45IOvkoRCKsxbDJcy4R
         0c2lI0CRZo0orMsd4LlXqo5jXPWGKD6vcrbVI=
Date: Thu, 29 Jan 2009 20:53:39 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/17] proc tty: switch serial_core to ->proc_fops
Message-ID: <20090129175339.GK21643@x200.localdomain>
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
 drivers/serial/serial_core.c |   76 ++++++++++++++++++++----------------------
 1 files changed, 36 insertions(+), 40 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 42f4e66..bf3c0e3 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -27,6 +27,8 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/console.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/serial_core.h>
 #include <linux/smp_lock.h>
 #include <linux/device.h>
@@ -1682,20 +1684,20 @@ static const char *uart_type(struct uart_port *port)
 
 #ifdef CONFIG_PROC_FS
 
-static int uart_line_info(char *buf, struct uart_driver *drv, int i)
+static void uart_line_info(struct seq_file *m, struct uart_driver *drv, int i)
 {
 	struct uart_state *state = drv->state + i;
 	int pm_state;
 	struct uart_port *port = state->port;
 	char stat_buf[32];
 	unsigned int status;
-	int mmio, ret;
+	int mmio;
 
 	if (!port)
-		return 0;
+		return;
 
 	mmio = port->iotype >= UPIO_MEM;
-	ret = sprintf(buf, "%d: uart:%s %s%08llX irq:%d",
+	seq_printf(m, "%d: uart:%s %s%08llX irq:%d",
 			port->line, uart_type(port),
 			mmio ? "mmio:0x" : "port:",
 			mmio ? (unsigned long long)port->mapbase
@@ -1703,8 +1705,8 @@ static int uart_line_info(char *buf, struct uart_driver *drv, int i)
 			port->irq);
 
 	if (port->type == PORT_UNKNOWN) {
-		strcat(buf, "\n");
-		return ret + 1;
+		seq_putc(m, '\n');
+		return;
 	}
 
 	if (capable(CAP_SYS_ADMIN)) {
@@ -1719,19 +1721,19 @@ static int uart_line_info(char *buf, struct uart_driver *drv, int i)
 			uart_change_pm(state, pm_state);
 		mutex_unlock(&state->mutex);
 
-		ret += sprintf(buf + ret, " tx:%d rx:%d",
+		seq_printf(m, " tx:%d rx:%d",
 				port->icount.tx, port->icount.rx);
 		if (port->icount.frame)
-			ret += sprintf(buf + ret, " fe:%d",
+			seq_printf(m, " fe:%d",
 				port->icount.frame);
 		if (port->icount.parity)
-			ret += sprintf(buf + ret, " pe:%d",
+			seq_printf(m, " pe:%d",
 				port->icount.parity);
 		if (port->icount.brk)
-			ret += sprintf(buf + ret, " brk:%d",
+			seq_printf(m, " brk:%d",
 				port->icount.brk);
 		if (port->icount.overrun)
-			ret += sprintf(buf + ret, " oe:%d",
+			seq_printf(m, " oe:%d",
 				port->icount.overrun);
 
 #define INFOBIT(bit, str) \
@@ -1753,45 +1755,39 @@ static int uart_line_info(char *buf, struct uart_driver *drv, int i)
 		STATBIT(TIOCM_RNG, "|RI");
 		if (stat_buf[0])
 			stat_buf[0] = ' ';
-		strcat(stat_buf, "\n");
 
-		ret += sprintf(buf + ret, stat_buf);
-	} else {
-		strcat(buf, "\n");
-		ret++;
+		seq_puts(m, stat_buf);
 	}
+	seq_putc(m, '\n');
 #undef STATBIT
 #undef INFOBIT
-	return ret;
 }
 
-static int uart_read_proc(char *page, char **start, off_t off,
-			  int count, int *eof, void *data)
+static int uart_proc_show(struct seq_file *m, void *v)
 {
-	struct tty_driver *ttydrv = data;
+	struct tty_driver *ttydrv = v;
 	struct uart_driver *drv = ttydrv->driver_state;
-	int i, len = 0, l;
-	off_t begin = 0;
+	int i;
 
-	len += sprintf(page, "serinfo:1.0 driver%s%s revision:%s\n",
+	seq_printf(m, "serinfo:1.0 driver%s%s revision:%s\n",
 			"", "", "");
-	for (i = 0; i < drv->nr && len < PAGE_SIZE - 96; i++) {
-		l = uart_line_info(page + len, drv, i);
-		len += l;
-		if (len + begin > off + count)
-			goto done;
-		if (len + begin < off) {
-			begin += len;
-			len = 0;
-		}
-	}
-	*eof = 1;
- done:
-	if (off >= len + begin)
-		return 0;
-	*start = page + (off - begin);
-	return (count < begin + len - off) ? count : (begin + len - off);
+	for (i = 0; i < drv->nr; i++)
+		uart_line_info(m, drv, i);
+	return 0;
 }
+
+static int uart_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, uart_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations uart_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= uart_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 #if defined(CONFIG_SERIAL_CORE_CONSOLE) || defined(CONFIG_CONSOLE_POLL)
@@ -2299,7 +2295,7 @@ static const struct tty_operations uart_ops = {
 	.break_ctl	= uart_break_ctl,
 	.wait_until_sent= uart_wait_until_sent,
 #ifdef CONFIG_PROC_FS
-	.read_proc	= uart_read_proc,
+	.proc_fops	= &uart_proc_fops,
 #endif
 	.tiocmget	= uart_tiocmget,
 	.tiocmset	= uart_tiocmset,
-- 
1.5.6.5

