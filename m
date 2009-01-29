Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbZA2Rpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbZA2Rpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZA2Roz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:44:55 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:32910 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775AbZA2Roy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:44:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lkN2CKmJ0D/hN2mO8SmMt7S/5pKcqZAK2JWe5Uair+QaUrqoaLGplHF6tWyyTh9rl8
         VimtD0gBcRUWHRxtLIs3IGHfI+CvbQnLL6ZvYhfZ28yjzctdnCspP5ym9i8aFUkxPjwO
         FLxJvFn6s6XeI7+qw5XwQ8t9mMXWRmFUathXs=
Date: Thu, 29 Jan 2009 20:50:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/17] proc tty: switch stallion to ->proc_fops
Message-ID: <20090129175037.GF21643@x200.localdomain>
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
 drivers/char/stallion.c |  126 +++++++++++++++++++----------------------------
 1 files changed, 50 insertions(+), 76 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index e1e0dd8..2ad813a 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -32,6 +32,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
+#include <linux/seq_file.h>
 #include <linux/cd1400.h>
 #include <linux/sc26198.h>
 #include <linux/comstats.h>
@@ -1379,52 +1380,47 @@ static void stl_sendxchar(struct tty_struct *tty, char ch)
 		stl_putchar(tty, ch);
 }
 
-/*****************************************************************************/
-
-#define	MAXLINE		80
-
-/*
- *	Format info for a specified port. The line is deliberately limited
- *	to 80 characters. (If it is too long it will be truncated, if too
- *	short then padded with spaces).
- */
-
-static int stl_portinfo(struct stlport *portp, int portnr, char *pos)
+static void stl_portinfo(struct seq_file *m, struct stlport *portp, int portnr)
 {
-	char	*sp;
-	int	sigs, cnt;
+	int	sigs;
+	char sep;
 
-	sp = pos;
-	sp += sprintf(sp, "%d: uart:%s tx:%d rx:%d",
+	seq_printf(m, "%d: uart:%s tx:%d rx:%d",
 		portnr, (portp->hwid == 1) ? "SC26198" : "CD1400",
 		(int) portp->stats.txtotal, (int) portp->stats.rxtotal);
 
 	if (portp->stats.rxframing)
-		sp += sprintf(sp, " fe:%d", (int) portp->stats.rxframing);
+		seq_printf(m, " fe:%d", (int) portp->stats.rxframing);
 	if (portp->stats.rxparity)
-		sp += sprintf(sp, " pe:%d", (int) portp->stats.rxparity);
+		seq_printf(m, " pe:%d", (int) portp->stats.rxparity);
 	if (portp->stats.rxbreaks)
-		sp += sprintf(sp, " brk:%d", (int) portp->stats.rxbreaks);
+		seq_printf(m, " brk:%d", (int) portp->stats.rxbreaks);
 	if (portp->stats.rxoverrun)
-		sp += sprintf(sp, " oe:%d", (int) portp->stats.rxoverrun);
+		seq_printf(m, " oe:%d", (int) portp->stats.rxoverrun);
 
 	sigs = stl_getsignals(portp);
-	cnt = sprintf(sp, "%s%s%s%s%s ",
-		(sigs & TIOCM_RTS) ? "|RTS" : "",
-		(sigs & TIOCM_CTS) ? "|CTS" : "",
-		(sigs & TIOCM_DTR) ? "|DTR" : "",
-		(sigs & TIOCM_CD) ? "|DCD" : "",
-		(sigs & TIOCM_DSR) ? "|DSR" : "");
-	*sp = ' ';
-	sp += cnt;
-
-	for (cnt = sp - pos; cnt < (MAXLINE - 1); cnt++)
-		*sp++ = ' ';
-	if (cnt >= MAXLINE)
-		pos[(MAXLINE - 2)] = '+';
-	pos[(MAXLINE - 1)] = '\n';
-
-	return MAXLINE;
+	sep = ' ';
+	if (sigs & TIOCM_RTS) {
+		seq_printf(m, "%c%s", sep, "RTS");
+		sep = '|';
+	}
+	if (sigs & TIOCM_CTS) {
+		seq_printf(m, "%c%s", sep, "CTS");
+		sep = '|';
+	}
+	if (sigs & TIOCM_DTR) {
+		seq_printf(m, "%c%s", sep, "DTR");
+		sep = '|';
+	}
+	if (sigs & TIOCM_CD) {
+		seq_printf(m, "%c%s", sep, "DCD");
+		sep = '|';
+	}
+	if (sigs & TIOCM_DSR) {
+		seq_printf(m, "%c%s", sep, "DSR");
+		sep = '|';
+	}
+	seq_putc(m, '\n');
 }
 
 /*****************************************************************************/
@@ -1433,30 +1429,17 @@ static int stl_portinfo(struct stlport *portp, int portnr, char *pos)
  *	Port info, read from the /proc file system.
  */
 
-static int stl_readproc(char *page, char **start, off_t off, int count, int *eof, void *data)
+static int stl_proc_show(struct seq_file *m, void *v)
 {
 	struct stlbrd	*brdp;
 	struct stlpanel	*panelp;
 	struct stlport	*portp;
 	unsigned int	brdnr, panelnr, portnr;
-	int		totalport, curoff, maxoff;
-	char		*pos;
+	int		totalport;
 
-	pr_debug("stl_readproc(page=%p,start=%p,off=%lx,count=%d,eof=%p,"
-		"data=%p\n", page, start, off, count, eof, data);
-
-	pos = page;
 	totalport = 0;
-	curoff = 0;
-
-	if (off == 0) {
-		pos += sprintf(pos, "%s: version %s", stl_drvtitle,
-			stl_drvversion);
-		while (pos < (page + MAXLINE - 1))
-			*pos++ = ' ';
-		*pos++ = '\n';
-	}
-	curoff =  MAXLINE;
+
+	seq_printf(m, "%s: version %s\n", stl_drvtitle, stl_drvversion);
 
 /*
  *	We scan through for each board, panel and port. The offset is
@@ -1469,46 +1452,37 @@ static int stl_readproc(char *page, char **start, off_t off, int count, int *eof
 		if (brdp->state == 0)
 			continue;
 
-		maxoff = curoff + (brdp->nrports * MAXLINE);
-		if (off >= maxoff) {
-			curoff = maxoff;
-			continue;
-		}
-
 		totalport = brdnr * STL_MAXPORTS;
 		for (panelnr = 0; panelnr < brdp->nrpanels; panelnr++) {
 			panelp = brdp->panels[panelnr];
 			if (panelp == NULL)
 				continue;
 
-			maxoff = curoff + (panelp->nrports * MAXLINE);
-			if (off >= maxoff) {
-				curoff = maxoff;
-				totalport += panelp->nrports;
-				continue;
-			}
-
 			for (portnr = 0; portnr < panelp->nrports; portnr++,
 			    totalport++) {
 				portp = panelp->ports[portnr];
 				if (portp == NULL)
 					continue;
-				if (off >= (curoff += MAXLINE))
-					continue;
-				if ((pos - page + MAXLINE) > count)
-					goto stl_readdone;
-				pos += stl_portinfo(portp, totalport, pos);
+				stl_portinfo(m, portp, totalport);
 			}
 		}
 	}
+	return 0;
+}
 
-	*eof = 1;
-
-stl_readdone:
-	*start = page;
-	return pos - page;
+static int stl_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, stl_proc_show, NULL);
 }
 
+static const struct file_operations stl_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= stl_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*****************************************************************************/
 
 /*
@@ -2566,9 +2540,9 @@ static const struct tty_operations stl_ops = {
 	.break_ctl = stl_breakctl,
 	.wait_until_sent = stl_waituntilsent,
 	.send_xchar = stl_sendxchar,
-	.read_proc = stl_readproc,
 	.tiocmget = stl_tiocmget,
 	.tiocmset = stl_tiocmset,
+	.proc_fops = &stl_proc_fops,
 };
 
 static const struct tty_port_operations stl_port_ops = {
-- 
1.5.6.5

