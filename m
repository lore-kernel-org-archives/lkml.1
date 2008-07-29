Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYG2CEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYG2CEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYG2CEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:04:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:17628 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYG2CEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=J01se/OBLOZUmXzChTAFuhdh98D/EJCmuGknYvKtz4q6hKl727UVl55/D4z8YGdQU+
         yU9uR5JtoZvYYviKsA11WTXG3C5HWt+HVDJNDFHLXUML2nkT7TQYweawiEuQaGQfh4kK
         HzRPLMbZ68597RoxZQ4Xe6mcwa3ry5wDtE/04=
Date: Tue, 29 Jul 2008 06:04:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] proc tty: switch serial_core to ->proc_fops
Message-ID: <20080729020452.GJ3135@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/serial/serial_core.c |   78 +++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 42 deletions(-)

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
@@ -1701,20 +1703,20 @@ static const char *uart_type(struct uart_port *port)
 
 #ifdef CONFIG_PROC_FS
 
-static int uart_line_info(char *buf, struct uart_driver *drv, int i)
+static int uart_line_info(struct seq_file *m, struct uart_driver *drv, int i)
 {
 	struct uart_state *state = drv->state + i;
 	int pm_state;
 	struct uart_port *port = state->port;
 	char stat_buf[32];
 	unsigned int status;
-	int mmio, ret;
+	int mmio;
 
 	if (!port)
 		return 0;
 
 	mmio = port->iotype >= UPIO_MEM;
-	ret = sprintf(buf, "%d: uart:%s %s%08llX irq:%d",
+	seq_printf(m, "%d: uart:%s %s%08llX irq:%d",
 			port->line, uart_type(port),
 			mmio ? "mmio:0x" : "port:",
 			mmio ? (unsigned long long)port->mapbase
@@ -1722,8 +1724,8 @@ static int uart_line_info(char *buf, struct uart_driver *drv, int i)
 			port->irq);
 
 	if (port->type == PORT_UNKNOWN) {
-		strcat(buf, "\n");
-		return ret + 1;
+		seq_putc(m, '\n');
+		return 0;
 	}
 
 	if (capable(CAP_SYS_ADMIN)) {
@@ -1738,20 +1740,15 @@ static int uart_line_info(char *buf, struct uart_driver *drv, int i)
 			uart_change_pm(state, pm_state);
 		mutex_unlock(&state->mutex);
 
-		ret += sprintf(buf + ret, " tx:%d rx:%d",
-				port->icount.tx, port->icount.rx);
+		seq_printf(m, " tx:%d rx:%d", port->icount.tx, port->icount.rx);
 		if (port->icount.frame)
-			ret += sprintf(buf + ret, " fe:%d",
-				port->icount.frame);
+			seq_printf(m, " fe:%d", port->icount.frame);
 		if (port->icount.parity)
-			ret += sprintf(buf + ret, " pe:%d",
-				port->icount.parity);
+			seq_printf(m, " pe:%d", port->icount.parity);
 		if (port->icount.brk)
-			ret += sprintf(buf + ret, " brk:%d",
-				port->icount.brk);
+			seq_printf(m, " brk:%d", port->icount.brk);
 		if (port->icount.overrun)
-			ret += sprintf(buf + ret, " oe:%d",
-				port->icount.overrun);
+			seq_printf(m, " oe:%d", port->icount.overrun);
 
 #define INFOBIT(bit, str) \
 	if (port->mctrl & (bit)) \
@@ -1774,43 +1771,40 @@ static int uart_line_info(char *buf, struct uart_driver *drv, int i)
 			stat_buf[0] = ' ';
 		strcat(stat_buf, "\n");
 
-		ret += sprintf(buf + ret, stat_buf);
+		seq_puts(m, stat_buf);
 	} else {
-		strcat(buf, "\n");
-		ret++;
+		seq_putc(m, '\n');
 	}
 #undef STATBIT
 #undef INFOBIT
-	return ret;
+	return 0;
 }
 
-static int uart_read_proc(char *page, char **start, off_t off,
-			  int count, int *eof, void *data)
+static int uart_proc_show(struct seq_file *m, void *v)
 {
-	struct tty_driver *ttydrv = data;
+	struct tty_driver *ttydrv = m->private;
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
@@ -2313,7 +2307,7 @@ static const struct tty_operations uart_ops = {
 	.break_ctl	= uart_break_ctl,
 	.wait_until_sent= uart_wait_until_sent,
 #ifdef CONFIG_PROC_FS
-	.read_proc	= uart_read_proc,
+	.proc_fops	= &uart_proc_fops,
 #endif
 	.tiocmget	= uart_tiocmget,
 	.tiocmset	= uart_tiocmset,
-- 
1.5.4.5


