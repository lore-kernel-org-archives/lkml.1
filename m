Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYG2CBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYG2CBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYG2CBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:01:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:16725 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYG2CB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=q+aDh4A53e/X5+FBerHcvdf3FQEKLf/ypzJEGGQk4CgXf89WqEA0LxTF7j98QaygSx
         EqVhfgwxztVxy7o5Fn/2jMGtE1s1Kv74D9OcYiRWagCxs8yHw7xVJT5YHb9kUhAJGWv+
         KLScoRl/bymDpTRmVG8nasmlyFap6L+8qCPEo=
Date: Tue, 29 Jul 2008 06:01:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/13] proc tty: switch synclink_gt to ->proc_fops
Message-ID: <20080729020135.GG3135@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/synclink_gt.c |   80 +++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 42 deletions(-)

--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -161,7 +161,6 @@ static void tx_hold(struct tty_struct *tty);
 static void tx_release(struct tty_struct *tty);
 
 static int  ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
-static int  read_proc(char *page, char **start, off_t off, int count,int *eof, void *data);
 static int  chars_in_buffer(struct tty_struct *tty);
 static void throttle(struct tty_struct * tty);
 static void unthrottle(struct tty_struct * tty);
@@ -1281,16 +1280,13 @@ static long slgt_compat_ioctl(struct tty_struct *tty, struct file *file,
 #define slgt_compat_ioctl NULL
 #endif /* ifdef CONFIG_COMPAT */
 
-/*
- * proc fs support
- */
-static inline int line_info(char *buf, struct slgt_info *info)
+#ifdef CONFIG_PROC_FS
+static inline int line_info(struct seq_file *m, struct slgt_info *info)
 {
 	char stat_buf[30];
-	int ret;
 	unsigned long flags;
 
-	ret = sprintf(buf, "%s: IO=%08X IRQ=%d MaxFrameSize=%u\n",
+	seq_printf(m, "%s: IO=%08X IRQ=%d MaxFrameSize=%u\n",
 		      info->device_name, info->phys_reg_addr,
 		      info->irq_level, info->max_frame_size);
 
@@ -1315,75 +1311,73 @@ static inline int line_info(char *buf, struct slgt_info *info)
 		strcat(stat_buf, "|RI");
 
 	if (info->params.mode != MGSL_MODE_ASYNC) {
-		ret += sprintf(buf+ret, "\tHDLC txok:%d rxok:%d",
+		seq_printf(m, "\tHDLC txok:%d rxok:%d",
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
-		ret += sprintf(buf+ret, "\tASYNC tx:%d rx:%d",
+		seq_printf(m, "\tASYNC tx:%d rx:%d",
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
 
-	ret += sprintf(buf+ret, "\ttxactive=%d bh_req=%d bh_run=%d pending_bh=%x\n",
+	seq_printf(m, "\ttxactive=%d bh_req=%d bh_run=%d pending_bh=%x\n",
 		       info->tx_active,info->bh_requested,info->bh_running,
 		       info->pending_bh);
 
-	return ret;
+	return 0;
 }
 
 /* Called to print information about devices
  */
-static int read_proc(char *page, char **start, off_t off, int count,
-		     int *eof, void *data)
+static int slgt_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0, l;
-	off_t	begin = 0;
 	struct slgt_info *info;
 
-	len += sprintf(page, "synclink_gt driver:%s\n", driver_version);
+	seq_printf(m, "synclink_gt driver:%s\n", driver_version);
 
 	info = slgt_device_list;
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
+static int slgt_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, slgt_proc_show, NULL);
 }
 
+static const struct file_operations slgt_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= slgt_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
 /*
  * return count of bytes in transmit buffer
  */
@@ -3591,7 +3585,9 @@ static const struct tty_operations ops = {
 	.send_xchar = send_xchar,
 	.break_ctl = set_break,
 	.wait_until_sent = wait_until_sent,
- 	.read_proc = read_proc,
+#ifdef CONFIG_PROC_FS
+	.proc_fops = &slgt_proc_fops,
+#endif
 	.set_termios = set_termios,
 	.stop = tx_hold,
 	.start = tx_release,
-- 
1.5.4.5


