Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbZA2RtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbZA2RtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbZA2Rsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:48:54 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:38522 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbZA2Rsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:48:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qck5AZgfb2koqZoM3MqSVG6HYbmzsjG6HDbuMN25LKY9rn6dvb/oOlIrNDt8Y7Ju46
         rArGDuA5uSPyJO76xXWXWPkUx85IzxVnWheL2UBgRxRpAWqbLtW48UnIu71rg9M935ny
         Apjp+siTntuIKHfORe5WhHNbu2fsYgTIbzFuE=
Date: Thu, 29 Jan 2009 20:54:34 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/17] proc tty: switch ircomm to ->proc_fops
Message-ID: <20090129175434.GM21643@x200.localdomain>
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
 net/irda/ircomm/ircomm_tty.c |  256 +++++++++++++++++++++++-------------------
 1 files changed, 138 insertions(+), 118 deletions(-)

diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 086d5ef..811984d 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include <linux/termios.h>
 #include <linux/tty.h>
 #include <linux/interrupt.h>
@@ -72,8 +73,7 @@ static int ircomm_tty_control_indication(void *instance, void *sap,
 static void ircomm_tty_flow_indication(void *instance, void *sap,
 				       LOCAL_FLOW cmd);
 #ifdef CONFIG_PROC_FS
-static int ircomm_tty_read_proc(char *buf, char **start, off_t offset, int len,
-				int *eof, void *unused);
+static const struct file_operations ircomm_tty_proc_fops;
 #endif /* CONFIG_PROC_FS */
 static struct tty_driver *driver;
 
@@ -98,7 +98,7 @@ static const struct tty_operations ops = {
 	.hangup          = ircomm_tty_hangup,
 	.wait_until_sent = ircomm_tty_wait_until_sent,
 #ifdef CONFIG_PROC_FS
-	.read_proc       = ircomm_tty_read_proc,
+	.proc_fops       = &ircomm_tty_proc_fops,
 #endif /* CONFIG_PROC_FS */
 };
 
@@ -1245,150 +1245,170 @@ static void ircomm_tty_flow_indication(void *instance, void *sap,
 }
 
 #ifdef CONFIG_PROC_FS
-static int ircomm_tty_line_info(struct ircomm_tty_cb *self, char *buf)
+static void ircomm_tty_line_info(struct ircomm_tty_cb *self, struct seq_file *m)
 {
-	int  ret=0;
+	char sep;
 
-	ret += sprintf(buf+ret, "State: %s\n", ircomm_tty_state[self->state]);
+	seq_printf(m, "State: %s\n", ircomm_tty_state[self->state]);
 
-	ret += sprintf(buf+ret, "Service type: ");
+	seq_puts(m, "Service type: ");
 	if (self->service_type & IRCOMM_9_WIRE)
-		ret += sprintf(buf+ret, "9_WIRE");
+		seq_puts(m, "9_WIRE");
 	else if (self->service_type & IRCOMM_3_WIRE)
-		ret += sprintf(buf+ret, "3_WIRE");
+		seq_puts(m, "3_WIRE");
 	else if (self->service_type & IRCOMM_3_WIRE_RAW)
-		ret += sprintf(buf+ret, "3_WIRE_RAW");
+		seq_puts(m, "3_WIRE_RAW");
 	else
-		ret += sprintf(buf+ret, "No common service type!\n");
-	ret += sprintf(buf+ret, "\n");
-
-	ret += sprintf(buf+ret, "Port name: %s\n", self->settings.port_name);
-
-	ret += sprintf(buf+ret, "DTE status: ");
-	if (self->settings.dte & IRCOMM_RTS)
-		ret += sprintf(buf+ret, "RTS|");
-	if (self->settings.dte & IRCOMM_DTR)
-		ret += sprintf(buf+ret, "DTR|");
-	if (self->settings.dte)
-		ret--; /* remove the last | */
-	ret += sprintf(buf+ret, "\n");
-
-	ret += sprintf(buf+ret, "DCE status: ");
-	if (self->settings.dce & IRCOMM_CTS)
-		ret += sprintf(buf+ret, "CTS|");
-	if (self->settings.dce & IRCOMM_DSR)
-		ret += sprintf(buf+ret, "DSR|");
-	if (self->settings.dce & IRCOMM_CD)
-		ret += sprintf(buf+ret, "CD|");
-	if (self->settings.dce & IRCOMM_RI)
-		ret += sprintf(buf+ret, "RI|");
-	if (self->settings.dce)
-		ret--; /* remove the last | */
-	ret += sprintf(buf+ret, "\n");
-
-	ret += sprintf(buf+ret, "Configuration: ");
+		seq_puts(m, "No common service type!\n");
+	seq_putc(m, '\n');
+
+	seq_printf(m, "Port name: %s\n", self->settings.port_name);
+
+	seq_printf(m, "DTE status:");
+	sep = ' ';
+	if (self->settings.dte & IRCOMM_RTS) {
+		seq_printf(m, "%cRTS", sep);
+		sep = '|';
+	}
+	if (self->settings.dte & IRCOMM_DTR) {
+		seq_printf(m, "%cDTR", sep);
+		sep = '|';
+	}
+	seq_putc(m, '\n');
+
+	seq_puts(m, "DCE status:");
+	sep = ' ';
+	if (self->settings.dce & IRCOMM_CTS) {
+		seq_printf(m, "%cCTS", sep);
+		sep = '|';
+	}
+	if (self->settings.dce & IRCOMM_DSR) {
+		seq_printf(m, "%cDSR", sep);
+		sep = '|';
+	}
+	if (self->settings.dce & IRCOMM_CD) {
+		seq_printf(m, "%cCD", sep);
+		sep = '|';
+	}
+	if (self->settings.dce & IRCOMM_RI) {
+		seq_printf(m, "%cRI", sep);
+		sep = '|';
+	}
+	seq_putc(m, '\n');
+
+	seq_puts(m, "Configuration: ");
 	if (!self->settings.null_modem)
-		ret += sprintf(buf+ret, "DTE <-> DCE\n");
+		seq_puts(m, "DTE <-> DCE\n");
 	else
-		ret += sprintf(buf+ret,
-			       "DTE <-> DTE (null modem emulation)\n");
-
-	ret += sprintf(buf+ret, "Data rate: %d\n", self->settings.data_rate);
-
-	ret += sprintf(buf+ret, "Flow control: ");
-	if (self->settings.flow_control & IRCOMM_XON_XOFF_IN)
-		ret += sprintf(buf+ret, "XON_XOFF_IN|");
-	if (self->settings.flow_control & IRCOMM_XON_XOFF_OUT)
-		ret += sprintf(buf+ret, "XON_XOFF_OUT|");
-	if (self->settings.flow_control & IRCOMM_RTS_CTS_IN)
-		ret += sprintf(buf+ret, "RTS_CTS_IN|");
-	if (self->settings.flow_control & IRCOMM_RTS_CTS_OUT)
-		ret += sprintf(buf+ret, "RTS_CTS_OUT|");
-	if (self->settings.flow_control & IRCOMM_DSR_DTR_IN)
-		ret += sprintf(buf+ret, "DSR_DTR_IN|");
-	if (self->settings.flow_control & IRCOMM_DSR_DTR_OUT)
-		ret += sprintf(buf+ret, "DSR_DTR_OUT|");
-	if (self->settings.flow_control & IRCOMM_ENQ_ACK_IN)
-		ret += sprintf(buf+ret, "ENQ_ACK_IN|");
-	if (self->settings.flow_control & IRCOMM_ENQ_ACK_OUT)
-		ret += sprintf(buf+ret, "ENQ_ACK_OUT|");
-	if (self->settings.flow_control)
-		ret--; /* remove the last | */
-	ret += sprintf(buf+ret, "\n");
-
-	ret += sprintf(buf+ret, "Flags: ");
-	if (self->flags & ASYNC_CTS_FLOW)
-		ret += sprintf(buf+ret, "ASYNC_CTS_FLOW|");
-	if (self->flags & ASYNC_CHECK_CD)
-		ret += sprintf(buf+ret, "ASYNC_CHECK_CD|");
-	if (self->flags & ASYNC_INITIALIZED)
-		ret += sprintf(buf+ret, "ASYNC_INITIALIZED|");
-	if (self->flags & ASYNC_LOW_LATENCY)
-		ret += sprintf(buf+ret, "ASYNC_LOW_LATENCY|");
-	if (self->flags & ASYNC_CLOSING)
-		ret += sprintf(buf+ret, "ASYNC_CLOSING|");
-	if (self->flags & ASYNC_NORMAL_ACTIVE)
-		ret += sprintf(buf+ret, "ASYNC_NORMAL_ACTIVE|");
-	if (self->flags)
-		ret--; /* remove the last | */
-	ret += sprintf(buf+ret, "\n");
-
-	ret += sprintf(buf+ret, "Role: %s\n", self->client ?
-		       "client" : "server");
-	ret += sprintf(buf+ret, "Open count: %d\n", self->open_count);
-	ret += sprintf(buf+ret, "Max data size: %d\n", self->max_data_size);
-	ret += sprintf(buf+ret, "Max header size: %d\n", self->max_header_size);
+		seq_puts(m, "DTE <-> DTE (null modem emulation)\n");
+
+	seq_printf(m, "Data rate: %d\n", self->settings.data_rate);
+
+	seq_puts(m, "Flow control:");
+	sep = ' ';
+	if (self->settings.flow_control & IRCOMM_XON_XOFF_IN) {
+		seq_printf(m, "%cXON_XOFF_IN", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_XON_XOFF_OUT) {
+		seq_printf(m, "%cXON_XOFF_OUT", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_RTS_CTS_IN) {
+		seq_printf(m, "%cRTS_CTS_IN", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_RTS_CTS_OUT) {
+		seq_printf(m, "%cRTS_CTS_OUT", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_DSR_DTR_IN) {
+		seq_printf(m, "%cDSR_DTR_IN", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_DSR_DTR_OUT) {
+		seq_printf(m, "%cDSR_DTR_OUT", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_ENQ_ACK_IN) {
+		seq_printf(m, "%cENQ_ACK_IN", sep);
+		sep = '|';
+	}
+	if (self->settings.flow_control & IRCOMM_ENQ_ACK_OUT) {
+		seq_printf(m, "%cENQ_ACK_OUT", sep);
+		sep = '|';
+	}
+	seq_putc(m, '\n');
+
+	seq_puts(m, "Flags:");
+	sep = ' ';
+	if (self->flags & ASYNC_CTS_FLOW) {
+		seq_printf(m, "%cASYNC_CTS_FLOW", sep);
+		sep = '|';
+	}
+	if (self->flags & ASYNC_CHECK_CD) {
+		seq_printf(m, "%cASYNC_CHECK_CD", sep);
+		sep = '|';
+	}
+	if (self->flags & ASYNC_INITIALIZED) {
+		seq_printf(m, "%cASYNC_INITIALIZED", sep);
+		sep = '|';
+	}
+	if (self->flags & ASYNC_LOW_LATENCY) {
+		seq_printf(m, "%cASYNC_LOW_LATENCY", sep);
+		sep = '|';
+	}
+	if (self->flags & ASYNC_CLOSING) {
+		seq_printf(m, "%cASYNC_CLOSING", sep);
+		sep = '|';
+	}
+	if (self->flags & ASYNC_NORMAL_ACTIVE) {
+		seq_printf(m, "%cASYNC_NORMAL_ACTIVE", sep);
+		sep = '|';
+	}
+	seq_putc(m, '\n');
+
+	seq_printf(m, "Role: %s\n", self->client ? "client" : "server");
+	seq_printf(m, "Open count: %d\n", self->open_count);
+	seq_printf(m, "Max data size: %d\n", self->max_data_size);
+	seq_printf(m, "Max header size: %d\n", self->max_header_size);
 
 	if (self->tty)
-		ret += sprintf(buf+ret, "Hardware: %s\n",
+		seq_printf(m, "Hardware: %s\n",
 			       self->tty->hw_stopped ? "Stopped" : "Running");
-
-	ret += sprintf(buf+ret, "\n");
-	return ret;
 }
 
-
-/*
- * Function ircomm_tty_read_proc (buf, start, offset, len, eof, unused)
- *
- *
- *
- */
-static int ircomm_tty_read_proc(char *buf, char **start, off_t offset, int len,
-				int *eof, void *unused)
+static int ircomm_tty_proc_show(struct seq_file *m, void *v)
 {
 	struct ircomm_tty_cb *self;
-	int count = 0, l;
-	off_t begin = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ircomm_tty->hb_spinlock, flags);
 
 	self = (struct ircomm_tty_cb *) hashbin_get_first(ircomm_tty);
-	while ((self != NULL) && (count < 4000)) {
+	while (self != NULL) {
 		if (self->magic != IRCOMM_TTY_MAGIC)
 			break;
 
-		l = ircomm_tty_line_info(self, buf + count);
-		count += l;
-		if (count+begin > offset+len)
-			goto done;
-		if (count+begin < offset) {
-			begin += count;
-			count = 0;
-		}
-
+		ircomm_tty_line_info(self, m);
 		self = (struct ircomm_tty_cb *) hashbin_get_next(ircomm_tty);
 	}
-	*eof = 1;
-done:
 	spin_unlock_irqrestore(&ircomm_tty->hb_spinlock, flags);
+	return 0;
+}
 
-	if (offset >= count+begin)
-		return 0;
-	*start = buf + (offset-begin);
-	return ((len < begin+count-offset) ? len : begin+count-offset);
+static int ircomm_tty_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ircomm_tty_proc_show, NULL);
 }
+
+static const struct file_operations ircomm_tty_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ircomm_tty_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_PROC_FS */
 
 MODULE_AUTHOR("Dag Brattli <dagb@cs.uit.no>");
-- 
1.5.6.5

