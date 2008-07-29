Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbYG2B70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbYG2B70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYG2B7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:59:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:16900 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYG2B7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qW2KP1CvWo6/DI/Iw5syeItocHpD4Nla9GeuIyXpE/RtOcaJ5BxcvhlGtuiEilqM/j
         OkYGFdlLMOrkK2WSO4VrHFuRVsUJsXAlLIE5jK7mVn144GLrhHSTk+qcKNNXTMaiIW/+
         wIuzEFiu35A1KmPWb7F81a7H1dSPnDuPPxkY4=
Date: Tue, 29 Jul 2008 05:59:23 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/13] proc tty: switch synklink to ->proc_fops
Message-ID: <20080729015923.GE3135@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/synclink.c |  101 +++++++++++++++++++-----------------------------
 1 file changed, 41 insertions(+), 60 deletions(-)

--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -3486,22 +3486,18 @@ cleanup:
 	
 }	/* end of mgsl_open() */
 
-/*
- * /proc fs routines....
- */
-
-static inline int line_info(char *buf, struct mgsl_struct *info)
+#ifdef CONFIG_PROC_FS
+static inline int line_info(struct seq_file *m, struct mgsl_struct *info)
 {
 	char	stat_buf[30];
-	int	ret;
 	unsigned long flags;
 
 	if (info->bus_type == MGSL_BUS_TYPE_PCI) {
-		ret = sprintf(buf, "%s:PCI io:%04X irq:%d mem:%08X lcr:%08X",
+		seq_printf(m, "%s:PCI io:%04X irq:%d mem:%08X lcr:%08X",
 			info->device_name, info->io_base, info->irq_level,
 			info->phys_memory_base, info->phys_lcr_base);
 	} else {
-		ret = sprintf(buf, "%s:(E)ISA io:%04X irq:%d dma:%d",
+		seq_printf(m, "%s:(E)ISA io:%04X irq:%d dma:%d",
 			info->device_name, info->io_base, 
 			info->irq_level, info->dma_level);
 	}
@@ -3528,37 +3524,37 @@ static inline int line_info(char *buf, struct mgsl_struct *info)
 
 	if (info->params.mode == MGSL_MODE_HDLC ||
 	    info->params.mode == MGSL_MODE_RAW ) {
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
 	 
@@ -3575,60 +3571,43 @@ static inline int line_info(char *buf, struct mgsl_struct *info)
 	u16 Tmr = usc_InReg( info, TMR );
 	u16 Tccr = usc_InReg( info, TCCR );
 	u16 Ccar = inw( info->io_base + CCAR );
-	ret += sprintf(buf+ret, "tcsr=%04X tdmr=%04X ticr=%04X rcsr=%04X rdmr=%04X\n"
+	seq_printf(m, "tcsr=%04X tdmr=%04X ticr=%04X rcsr=%04X rdmr=%04X\n"
                         "ricr=%04X icr =%04X dccr=%04X tmr=%04X tccr=%04X ccar=%04X\n",
 	 		Tcsr,Tdmr,Ticr,Rscr,Rdmr,Ricr,Icr,Dccr,Tmr,Tccr,Ccar );
 	}
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
 	
-	return ret;
+	return 0;
 	
 }	/* end of line_info() */
 
-/* mgsl_read_proc()
- * 
- * Called to print information about devices
- * 
- * Arguments:
- * 	page	page of memory to hold returned info
- * 	start	
- * 	off
- * 	count
- * 	eof
- * 	data
- * 	
- * Return Value:
- */
-static int mgsl_read_proc(char *page, char **start, off_t off, int count,
-		 int *eof, void *data)
+static int mgsl_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0, l;
-	off_t	begin = 0;
 	struct mgsl_struct *info;
 	
-	len += sprintf(page, "synclink driver:%s\n", driver_version);
+	seq_printf(m, "synclink driver:%s\n", driver_version);
 	
 	info = mgsl_device_list;
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
-	
-}	/* end of mgsl_read_proc() */
+static int mgsl_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mgsl_proc_show, NULL);
+}
+
+static const struct file_operations mgsl_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mgsl_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
 
 /* mgsl_allocate_dma_buffers()
  * 
@@ -4360,7 +4339,9 @@ static const struct tty_operations mgsl_ops = {
 	.send_xchar = mgsl_send_xchar,
 	.break_ctl = mgsl_break,
 	.wait_until_sent = mgsl_wait_until_sent,
- 	.read_proc = mgsl_read_proc,
+#ifdef CONFIG_PROC_FS
+	.proc_fops = &mgsl_proc_fops,
+#endif
 	.set_termios = mgsl_set_termios,
 	.stop = mgsl_stop,
 	.start = mgsl_start,
-- 
1.5.4.5


