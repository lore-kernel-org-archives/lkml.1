Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbZA2Rtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbZA2Rtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbZA2RtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:49:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:24748 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759237AbZA2RtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:49:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H1VegHoe8UuqJ0eE5lWjDWBCk4EQECYWFSMKejoD0mIkvftMESQrB685iYyhVhfXTv
         GZ6mrDpfcCGXSWXPfxpuD0ZZ2+32ZDTvehC/nQQx0Qbm9x2CoNNlV/2k6S9uAdd7wWLa
         gRMcOrwXTZ1hs7vTG2W+h3YLedpP6MzCpaWa4=
Date: Thu, 29 Jan 2009 20:54:51 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/17] proc tty: switch amiserial to ->proc_fops
Message-ID: <20090129175451.GN21643@x200.localdomain>
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
 drivers/char/amiserial.c |   62 ++++++++++++++++++++-------------------------
 1 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index a58869e..fd3ebd1 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -79,6 +79,7 @@ static char *serial_version = "4.30";
 #include <linux/ptrace.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
@@ -1825,14 +1826,13 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
  * /proc fs routines....
  */
 
-static inline int line_info(char *buf, struct serial_state *state)
+static inline void line_info(struct seq_file *m, struct serial_state *state)
 {
 	struct async_struct *info = state->info, scr_info;
 	char	stat_buf[30], control, status;
-	int	ret;
 	unsigned long flags;
 
-	ret = sprintf(buf, "%d: uart:amiga_builtin",state->line);
+	seq_printf(m, "%d: uart:amiga_builtin",state->line);
 
 	/*
 	 * Figure out the current RS-232 lines
@@ -1864,55 +1864,49 @@ static inline int line_info(char *buf, struct serial_state *state)
 		strcat(stat_buf, "|CD");
 
 	if (info->quot) {
-		ret += sprintf(buf+ret, " baud:%d",
-			       state->baud_base / info->quot);
+		seq_printf(m, " baud:%d", state->baud_base / info->quot);
 	}
 
-	ret += sprintf(buf+ret, " tx:%d rx:%d",
-		      state->icount.tx, state->icount.rx);
+	seq_printf(m, " tx:%d rx:%d", state->icount.tx, state->icount.rx);
 
 	if (state->icount.frame)
-		ret += sprintf(buf+ret, " fe:%d", state->icount.frame);
+		seq_printf(m, " fe:%d", state->icount.frame);
 
 	if (state->icount.parity)
-		ret += sprintf(buf+ret, " pe:%d", state->icount.parity);
+		seq_printf(m, " pe:%d", state->icount.parity);
 
 	if (state->icount.brk)
-		ret += sprintf(buf+ret, " brk:%d", state->icount.brk);
+		seq_printf(m, " brk:%d", state->icount.brk);
 
 	if (state->icount.overrun)
-		ret += sprintf(buf+ret, " oe:%d", state->icount.overrun);
+		seq_printf(m, " oe:%d", state->icount.overrun);
 
 	/*
 	 * Last thing is the RS-232 status lines
 	 */
-	ret += sprintf(buf+ret, " %s\n", stat_buf+1);
-	return ret;
+	seq_printf(m, " %s\n", stat_buf+1);
 }
 
-static int rs_read_proc(char *page, char **start, off_t off, int count,
-			int *eof, void *data)
+static int rs_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0, l;
-	off_t	begin = 0;
-
-	len += sprintf(page, "serinfo:1.0 driver:%s\n", serial_version);
-	l = line_info(page + len, &rs_table[0]);
-	len += l;
-	if (len+begin > off+count)
-	  goto done;
-	if (len+begin < off) {
-	  begin += len;
-	  len = 0;
-	}
-	*eof = 1;
-done:
-	if (off >= len+begin)
-		return 0;
-	*start = page + (off-begin);
-	return ((count < begin+len-off) ? count : begin+len-off);
+	seq_printf(m, "serinfo:1.0 driver:%s\n", serial_version);
+	line_info(m, &rs_table[0]);
+	return 0;
 }
 
+static int rs_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rs_proc_show, NULL);
+}
+
+static const struct file_operations rs_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rs_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * ---------------------------------------------------------------------
  * rs_init() and friends
@@ -1951,9 +1945,9 @@ static const struct tty_operations serial_ops = {
 	.break_ctl = rs_break,
 	.send_xchar = rs_send_xchar,
 	.wait_until_sent = rs_wait_until_sent,
-	.read_proc = rs_read_proc,
 	.tiocmget = rs_tiocmget,
 	.tiocmset = rs_tiocmset,
+	.proc_fops = &rs_proc_fops,
 };
 
 /*
-- 
1.5.6.5

