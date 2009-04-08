Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZDHPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZDHPxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZDHPxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:53:00 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:35748 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbZDHPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:52:59 -0400
Date: Wed, 8 Apr 2009 17:52:00 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
       Janez Cufer <janez.cufer@cetrtapot.si>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>
Subject: Re: [PATCH] Fix broken compilation of Cris serial driver
Message-ID: <20090408155200.GL8115@axis.com>
References: <49DC7754.4030404@evidence.eu.com> <20090408105701.GH8115@axis.com> <20090408125122.GA2814@x200.localdomain> <20090408140003.GK8115@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408140003.GK8115@axis.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 04:00:04PM +0200, Jesper Nilsson wrote:
> On Wed, Apr 08, 2009 at 02:51:22PM +0200, Alexey Dobriyan wrote:
> > ->read_proc effectively went away.
> 
> ...so what do we use as a replacement, is it .proc_fops
> or anything else?

The following patch works for me, any comments on the solution?

CRISv10: Change serial driver proc-usage.

Commit 0f043a81ebe84be3576667f04fdda481609e3816 removes the
read_proc entry from struct tty_operations.

Rework the proc handling in the CRISv10 serial driver to use
proc_fops instead.


Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

--
 crisv10.c |  173 +++++++++++++++++++++++++++-----------------------------------
 1 file changed, 78 insertions(+), 95 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index e642c22..4719935 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -23,16 +23,18 @@ static char *serial_version = "$Revision: 1.25 $";
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <asm/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/bitops.h>
+#include <linux/seq_file.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
 #include <asm/system.h>
-#include <linux/delay.h>
 
 #include <arch/svinto.h>
 
@@ -456,7 +458,6 @@ static struct e100_serial rs_table[] = {
 
 #define NR_PORTS (sizeof(rs_table)/sizeof(struct e100_serial))
 
-static struct ktermios *serial_termios[NR_PORTS];
 #ifdef CONFIG_ETRAX_SERIAL_FAST_TIMER
 static struct fast_timer fast_timers[NR_PORTS];
 #endif
@@ -4220,151 +4221,132 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	return 0;
 }
 
+#ifdef CONFIG_PROC_FS
 /*
  * /proc fs routines....
  */
 
-static int line_info(char *buf, struct e100_serial *info)
+static void seq_line_info(struct seq_file *m, struct e100_serial *info)
 {
-	char	stat_buf[30];
-	int	ret;
 	unsigned long tmp;
 
-	ret = sprintf(buf, "%d: uart:E100 port:%lX irq:%d",
-		      info->line, (unsigned long)info->ioport, info->irq);
+	seq_printf(m, "%d: uart:E100 port:%lX irq:%d",
+		   info->line, (unsigned long)info->ioport, info->irq);
 
 	if (!info->ioport || (info->type == PORT_UNKNOWN)) {
-		ret += sprintf(buf+ret, "\n");
-		return ret;
+		seq_printf(m, "\n");
+		return;
 	}
 
-	stat_buf[0] = 0;
-	stat_buf[1] = 0;
-	if (!E100_RTS_GET(info))
-		strcat(stat_buf, "|RTS");
-	if (!E100_CTS_GET(info))
-		strcat(stat_buf, "|CTS");
-	if (!E100_DTR_GET(info))
-		strcat(stat_buf, "|DTR");
-	if (!E100_DSR_GET(info))
-		strcat(stat_buf, "|DSR");
-	if (!E100_CD_GET(info))
-		strcat(stat_buf, "|CD");
-	if (!E100_RI_GET(info))
-		strcat(stat_buf, "|RI");
-
-	ret += sprintf(buf+ret, " baud:%d", info->baud);
-
-	ret += sprintf(buf+ret, " tx:%lu rx:%lu",
+	seq_printf(m, " baud:%d", info->baud);
+	seq_printf(m, " tx:%lu rx:%lu",
 		       (unsigned long)info->icount.tx,
 		       (unsigned long)info->icount.rx);
 	tmp = CIRC_CNT(info->xmit.head, info->xmit.tail, SERIAL_XMIT_SIZE);
-	if (tmp) {
-		ret += sprintf(buf+ret, " tx_pend:%lu/%lu",
-			       (unsigned long)tmp,
-			       (unsigned long)SERIAL_XMIT_SIZE);
-	}
+	if (tmp)
+		seq_printf(m, " tx_pend:%lu/%lu",
+			   (unsigned long)tmp,
+			   (unsigned long)SERIAL_XMIT_SIZE);
 
-	ret += sprintf(buf+ret, " rx_pend:%lu/%lu",
-		       (unsigned long)info->recv_cnt,
-		       (unsigned long)info->max_recv_cnt);
+	seq_printf(m, " rx_pend:%lu/%lu",
+		   (unsigned long)info->recv_cnt,
+		   (unsigned long)info->max_recv_cnt);
 
 #if 1
 	if (info->port.tty) {
-
 		if (info->port.tty->stopped)
-			ret += sprintf(buf+ret, " stopped:%i",
-				       (int)info->port.tty->stopped);
+			seq_printf(m, " stopped:%i",
+				   (int)info->port.tty->stopped);
 		if (info->port.tty->hw_stopped)
-			ret += sprintf(buf+ret, " hw_stopped:%i",
-				       (int)info->port.tty->hw_stopped);
+			seq_printf(m, " hw_stopped:%i",
+				   (int)info->port.tty->hw_stopped);
 	}
 
 	{
 		unsigned char rstat = info->ioport[REG_STATUS];
-		if (rstat & IO_MASK(R_SERIAL0_STATUS, xoff_detect) )
-			ret += sprintf(buf+ret, " xoff_detect:1");
+		if (rstat & IO_MASK(R_SERIAL0_STATUS, xoff_detect))
+			seq_printf(m, " xoff_detect:1");
 	}
 
 #endif
 
-
-
-
 	if (info->icount.frame)
-		ret += sprintf(buf+ret, " fe:%lu",
-			       (unsigned long)info->icount.frame);
+		seq_printf(m, " fe:%lu", (unsigned long)info->icount.frame);
 
 	if (info->icount.parity)
-		ret += sprintf(buf+ret, " pe:%lu",
-			       (unsigned long)info->icount.parity);
+		seq_printf(m, " pe:%lu", (unsigned long)info->icount.parity);
 
 	if (info->icount.brk)
-		ret += sprintf(buf+ret, " brk:%lu",
-			       (unsigned long)info->icount.brk);
+		seq_printf(m, " brk:%lu", (unsigned long)info->icount.brk);
 
 	if (info->icount.overrun)
-		ret += sprintf(buf+ret, " oe:%lu",
-			       (unsigned long)info->icount.overrun);
+		seq_printf(m, " oe:%lu", (unsigned long)info->icount.overrun);
 
 	/*
 	 * Last thing is the RS-232 status lines
 	 */
-	ret += sprintf(buf+ret, " %s\n", stat_buf+1);
-	return ret;
+	if (!E100_RTS_GET(info))
+		seq_puts(m, "|RTS");
+	if (!E100_CTS_GET(info))
+		seq_puts(m, "|CTS");
+	if (!E100_DTR_GET(info))
+		seq_puts(m, "|DTR");
+	if (!E100_DSR_GET(info))
+		seq_puts(m, "|DSR");
+	if (!E100_CD_GET(info))
+		seq_puts(m, "|CD");
+	if (!E100_RI_GET(info))
+		seq_puts(m, "|RI");
+	seq_puts(m, "\n");
 }
 
-int rs_read_proc(char *page, char **start, off_t off, int count,
-		 int *eof, void *data)
+
+static int crisv10_proc_show(struct seq_file *m, void *v)
 {
-	int i, len = 0, l;
-	off_t	begin = 0;
+	int i;
 
-	len += sprintf(page, "serinfo:1.0 driver:%s\n",
-		       serial_version);
-	for (i = 0; i < NR_PORTS && len < 4000; i++) {
+	seq_printf(m, "serinfo:1.0 driver:%s\n", serial_version);
+
+	for (i = 0; i < NR_PORTS; i++) {
 		if (!rs_table[i].enabled)
 			continue;
-		l = line_info(page + len, &rs_table[i]);
-		len += l;
-		if (len+begin > off+count)
-			goto done;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
-		}
+		seq_line_info(m, &rs_table[i]);
 	}
 #ifdef DEBUG_LOG_INCLUDED
 	for (i = 0; i < debug_log_pos; i++) {
-		len += sprintf(page + len, "%-4i %lu.%lu ", i, debug_log[i].time, timer_data_to_ns(debug_log[i].timer_data));
-		len += sprintf(page + len, debug_log[i].string, debug_log[i].value);
-		if (len+begin > off+count)
-			goto done;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
-		}
+		seq_printf(m, "%-4i %lu.%lu ",
+			 i, debug_log[i].time,
+			 timer_data_to_ns(debug_log[i].timer_data));
+		seq_printf(m, debug_log[i].string, debug_log[i].value);
 	}
-	len += sprintf(page + len, "debug_log %i/%i  %li bytes\n",
-		       i, DEBUG_LOG_SIZE, begin+len);
+	seq_printf(m, "debug_log %i/%i\n", i, DEBUG_LOG_SIZE);
 	debug_log_pos = 0;
 #endif
+	return 0;
+}
 
-	*eof = 1;
-done:
-	if (off >= len+begin)
-		return 0;
-	*start = page + (off-begin);
-	return ((count < begin+len-off) ? count : begin+len-off);
+static int crisv10_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, crisv10_proc_show, NULL);
 }
 
+static const struct file_operations crisv10_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= crisv10_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
+
 /* Finally, routines used to initialize the serial driver. */
 
-static void
-show_serial_version(void)
+static void show_serial_version(void)
 {
 	printk(KERN_INFO
-	       "ETRAX 100LX serial-driver %s, (c) 2000-2004 Axis Communications AB\r\n",
+	       "ETRAX 100LX serial-driver %s, "
+	       "(c) 2000-2004 Axis Communications AB\r\n",
 	       &serial_version[11]); /* "$Revision: x.yy" */
 }
 
@@ -4388,13 +4370,14 @@ static const struct tty_operations rs_ops = {
 	.break_ctl = rs_break,
 	.send_xchar = rs_send_xchar,
 	.wait_until_sent = rs_wait_until_sent,
-	.read_proc = rs_read_proc,
 	.tiocmget = rs_tiocmget,
-	.tiocmset = rs_tiocmset
+	.tiocmset = rs_tiocmset,
+#ifdef CONFIG_PROC_FS
+	.proc_fops = &crisv10_proc_fops,
+#endif
 };
 
-static int __init
-rs_init(void)
+static int __init rs_init(void)
 {
 	int i;
 	struct e100_serial *info;


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
