Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbZA2RpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbZA2RpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbZA2Rof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:44:35 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:32910 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454AbZA2Rod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:44:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=abcrIUwTZZfBlseK4CE9Cm2Ei6n+OrEGZVik9qAV9HCrxW0SFLIv+XvFLA2Uy0nZ9q
         dj8Y39tZ/6YhfUVqvLuCc5VQs3I4ZVOfkf9aytS05HHEtwlYH7Bz9jbwylonyOXQNqGy
         c5dka6aDv7UGskPK9tSIXoDr3r4Ff5IQHOIBs=
Date: Thu, 29 Jan 2009 20:50:15 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/17] proc tty: switch synclink_cs to ->proc_fops
Message-ID: <20090129175015.GE21643@x200.localdomain>
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
 drivers/char/pcmcia/synclink_cs.c |   73 +++++++++++++++++--------------------
 1 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index dc073e1..b1b6cfc 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -51,6 +51,7 @@
 #include <linux/ptrace.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
@@ -2619,13 +2620,12 @@ cleanup:
  * /proc fs routines....
  */
 
-static inline int line_info(char *buf, MGSLPC_INFO *info)
+static inline void line_info(struct seq_file *m, MGSLPC_INFO *info)
 {
 	char	stat_buf[30];
-	int	ret;
 	unsigned long flags;
 
-	ret = sprintf(buf, "%s:io:%04X irq:%d",
+	seq_printf(m, "%s:io:%04X irq:%d",
 		      info->device_name, info->io_base, info->irq_level);
 
 	/* output current serial signal states */
@@ -2649,75 +2649,70 @@ static inline int line_info(char *buf, MGSLPC_INFO *info)
 		strcat(stat_buf, "|RI");
 
 	if (info->params.mode == MGSL_MODE_HDLC) {
-		ret += sprintf(buf+ret, " HDLC txok:%d rxok:%d",
+		seq_printf(m, " HDLC txok:%d rxok:%d",
 			      info->icount.txok, info->icount.rxok);
 		if (info->icount.txunder)
-			ret += sprintf(buf+ret, " txunder:%d", info->icount.txunder);
+			seq_printf(m, " txunder:%d", info->icount.txunder);
 		if (info->icount.txabort)
-			ret += sprintf(buf+ret, " txabort:%d", info->icount.txabort);
+			seq_printf(m, " txabort:%d", info->icount.txabort);
 		if (info->icount.rxshort)
-			ret += sprintf(buf+ret, " rxshort:%d", info->icount.rxshort);
+			seq_printf(m, " rxshort:%d", info->icount.rxshort);
 		if (info->icount.rxlong)
-			ret += sprintf(buf+ret, " rxlong:%d", info->icount.rxlong);
+			seq_printf(m, " rxlong:%d", info->icount.rxlong);
 		if (info->icount.rxover)
-			ret += sprintf(buf+ret, " rxover:%d", info->icount.rxover);
+			seq_printf(m, " rxover:%d", info->icount.rxover);
 		if (info->icount.rxcrc)
-			ret += sprintf(buf+ret, " rxcrc:%d", info->icount.rxcrc);
+			seq_printf(m, " rxcrc:%d", info->icount.rxcrc);
 	} else {
-		ret += sprintf(buf+ret, " ASYNC tx:%d rx:%d",
+		seq_printf(m, " ASYNC tx:%d rx:%d",
 			      info->icount.tx, info->icount.rx);
 		if (info->icount.frame)
-			ret += sprintf(buf+ret, " fe:%d", info->icount.frame);
+			seq_printf(m, " fe:%d", info->icount.frame);
 		if (info->icount.parity)
-			ret += sprintf(buf+ret, " pe:%d", info->icount.parity);
+			seq_printf(m, " pe:%d", info->icount.parity);
 		if (info->icount.brk)
-			ret += sprintf(buf+ret, " brk:%d", info->icount.brk);
+			seq_printf(m, " brk:%d", info->icount.brk);
 		if (info->icount.overrun)
-			ret += sprintf(buf+ret, " oe:%d", info->icount.overrun);
+			seq_printf(m, " oe:%d", info->icount.overrun);
 	}
 
 	/* Append serial signal status to end */
-	ret += sprintf(buf+ret, " %s\n", stat_buf+1);
+	seq_printf(m, " %s\n", stat_buf+1);
 
-	ret += sprintf(buf+ret, "txactive=%d bh_req=%d bh_run=%d pending_bh=%x\n",
+	seq_printf(m, "txactive=%d bh_req=%d bh_run=%d pending_bh=%x\n",
 		       info->tx_active,info->bh_requested,info->bh_running,
 		       info->pending_bh);
-
-	return ret;
 }
 
 /* Called to print information about devices
  */
-static int mgslpc_read_proc(char *page, char **start, off_t off, int count,
-		 int *eof, void *data)
+static int mgslpc_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0, l;
-	off_t	begin = 0;
 	MGSLPC_INFO *info;
 
-	len += sprintf(page, "synclink driver:%s\n", driver_version);
+	seq_printf(m, "synclink driver:%s\n", driver_version);
 
 	info = mgslpc_device_list;
 	while( info ) {
-		l = line_info(page + len, info);
-		len += l;
-		if (len+begin > off+count)
-			goto done;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
-		}
+		line_info(m, info);
 		info = info->next_device;
 	}
+	return 0;
+}
 
-	*eof = 1;
-done:
-	if (off >= len+begin)
-		return 0;
-	*start = page + (off-begin);
-	return ((count < begin+len-off) ? count : begin+len-off);
+static int mgslpc_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mgslpc_proc_show, NULL);
 }
 
+static const struct file_operations mgslpc_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mgslpc_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int rx_alloc_buffers(MGSLPC_INFO *info)
 {
 	/* each buffer has header and data */
@@ -2861,13 +2856,13 @@ static const struct tty_operations mgslpc_ops = {
 	.send_xchar = mgslpc_send_xchar,
 	.break_ctl = mgslpc_break,
 	.wait_until_sent = mgslpc_wait_until_sent,
-	.read_proc = mgslpc_read_proc,
 	.set_termios = mgslpc_set_termios,
 	.stop = tx_pause,
 	.start = tx_release,
 	.hangup = mgslpc_hangup,
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
+	.proc_fops = &mgslpc_proc_fops,
 };
 
 static void synclink_cs_cleanup(void)
-- 
1.5.6.5

