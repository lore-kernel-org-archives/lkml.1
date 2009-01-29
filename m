Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZA2Rni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZA2Rni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZA2Rn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:43:28 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:42050 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZA2Rn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:43:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nKfJ94GQVYvxDPiiNX3OHrXdVLoFPS5tHf6/KrTmJ57o7PFNx9uvKt3uuUXT/OlK/w
         fvXe1UDeFnnZ6c4jSrollSxwb8CLq7LnrD2Xd9xL3DodU7NfLyU4UoUUiF/me9hIiadz
         uv/qTumnMUsXgS4U5BAYcCV+PZwEwQZmcX8+A=
Date: Thu, 29 Jan 2009 20:49:04 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/17] proc tty: switch cyclades to ->proc_fops
Message-ID: <20090129174904.GB21643@x200.localdomain>
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
 drivers/char/cyclades.c |   54 +++++++++++++++++-----------------------------
 1 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 6a59f72..272db0e 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -657,6 +657,7 @@
 
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 static void cy_throttle(struct tty_struct *tty);
 static void cy_send_xchar(struct tty_struct *tty, char ch);
@@ -868,8 +869,6 @@ static int cyz_issue_cmd(struct cyclades_card *, __u32, __u8, __u32);
 static unsigned detect_isa_irq(void __iomem *);
 #endif				/* CONFIG_ISA */
 
-static int cyclades_get_proc_info(char *, char **, off_t, int, int *, void *);
-
 #ifndef CONFIG_CYZ_INTR
 static void cyz_poll(unsigned long);
 
@@ -5216,31 +5215,22 @@ static struct pci_driver cy_pci_driver = {
 };
 #endif
 
-static int
-cyclades_get_proc_info(char *buf, char **start, off_t offset, int length,
-		int *eof, void *data)
+static int cyclades_proc_show(struct seq_file *m, void *v)
 {
 	struct cyclades_port *info;
 	unsigned int i, j;
-	int len = 0;
-	off_t begin = 0;
-	off_t pos = 0;
-	int size;
 	__u32 cur_jifs = jiffies;
 
-	size = sprintf(buf, "Dev TimeOpen   BytesOut  IdleOut    BytesIn   "
+	seq_puts(m, "Dev TimeOpen   BytesOut  IdleOut    BytesIn   "
 			"IdleIn  Overruns  Ldisc\n");
 
-	pos += size;
-	len += size;
-
 	/* Output one line for each known port */
 	for (i = 0; i < NR_CARDS; i++)
 		for (j = 0; j < cy_card[i].nports; j++) {
 			info = &cy_card[i].ports[j];
 
 			if (info->port.count)
-				size = sprintf(buf + len, "%3d %8lu %10lu %8lu "
+				seq_printf(m, "%3d %8lu %10lu %8lu "
 					"%10lu %8lu %9lu %6ld\n", info->line,
 					(cur_jifs - info->idle_stats.in_use) /
 					HZ, info->idle_stats.xmit_bytes,
@@ -5251,30 +5241,26 @@ cyclades_get_proc_info(char *buf, char **start, off_t offset, int length,
 					/* FIXME: double check locking */
 					(long)info->port.tty->ldisc.ops->num);
 			else
-				size = sprintf(buf + len, "%3d %8lu %10lu %8lu "
+				seq_printf(m, "%3d %8lu %10lu %8lu "
 					"%10lu %8lu %9lu %6ld\n",
 					info->line, 0L, 0L, 0L, 0L, 0L, 0L, 0L);
-			len += size;
-			pos = begin + len;
-
-			if (pos < offset) {
-				len = 0;
-				begin = pos;
-			}
-			if (pos > offset + length)
-				goto done;
 		}
-	*eof = 1;
-done:
-	*start = buf + (offset - begin);	/* Start of wanted data */
-	len -= (offset - begin);	/* Start slop */
-	if (len > length)
-		len = length;	/* Ending slop */
-	if (len < 0)
-		len = 0;
-	return len;
+	return 0;
+}
+
+static int cyclades_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cyclades_proc_show, NULL);
 }
 
+static const struct file_operations cyclades_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cyclades_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /* The serial driver boot-time initialization code!
     Hardware I/O ports are mapped to character special devices on a
     first found, first allocated manner.  That is, this code searches
@@ -5311,9 +5297,9 @@ static const struct tty_operations cy_ops = {
 	.hangup = cy_hangup,
 	.break_ctl = cy_break,
 	.wait_until_sent = cy_wait_until_sent,
-	.read_proc = cyclades_get_proc_info,
 	.tiocmget = cy_tiocmget,
 	.tiocmset = cy_tiocmset,
+	.proc_fops = &cyclades_proc_fops,
 };
 
 static int __init cy_init(void)
-- 
1.5.6.5

