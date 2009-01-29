Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZA2Ro2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZA2Ro2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZA2RoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:44:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:14412 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZA2RoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:44:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y7tobgldUZ8eUoKV2+57oPWhwqauzSU3SiFv4VyjfOna/1o3uC+9R6atIeZ2JuzDbL
         CnNbW1ca4Z1clto06qlpimP+izY34THFi7FOlS8wfePZOmjFVX28Ehez19WUBFqjMFv5
         8eeTMVqtVpm4N+1DD58kcW8wZwi9jThxMy7q8=
Date: Thu, 29 Jan 2009 20:49:54 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/17] proc tty: switch istallion to ->proc_fops
Message-ID: <20090129174954.GD21643@x200.localdomain>
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
 drivers/char/istallion.c |  121 ++++++++++++++++++++--------------------------
 1 files changed, 52 insertions(+), 69 deletions(-)

diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 5c3dc6b..fff19f7 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -24,6 +24,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
+#include <linux/seq_file.h>
 #include <linux/cdk.h>
 #include <linux/comstats.h>
 #include <linux/istallion.h>
@@ -613,7 +614,6 @@ static int	stli_breakctl(struct tty_struct *tty, int state);
 static void	stli_waituntilsent(struct tty_struct *tty, int timeout);
 static void	stli_sendxchar(struct tty_struct *tty, char ch);
 static void	stli_hangup(struct tty_struct *tty);
-static int	stli_portinfo(struct stlibrd *brdp, struct stliport *portp, int portnr, char *pos);
 
 static int	stli_brdinit(struct stlibrd *brdp);
 static int	stli_startbrd(struct stlibrd *brdp);
@@ -1893,20 +1893,10 @@ static void stli_sendxchar(struct tty_struct *tty, char ch)
 	stli_cmdwait(brdp, portp, A_PORTCTRL, &actrl, sizeof(asyctrl_t), 0);
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
-static int stli_portinfo(struct stlibrd *brdp, struct stliport *portp, int portnr, char *pos)
+static void stli_portinfo(struct seq_file *m, struct stlibrd *brdp, struct stliport *portp, int portnr)
 {
-	char *sp, *uart;
-	int rc, cnt;
+	char *uart;
+	int rc;
 
 	rc = stli_portcmdstats(NULL, portp);
 
@@ -1918,44 +1908,50 @@ static int stli_portinfo(struct stlibrd *brdp, struct stliport *portp, int portn
 		default:uart = "CD1400"; break;
 		}
 	}
-
-	sp = pos;
-	sp += sprintf(sp, "%d: uart:%s ", portnr, uart);
+	seq_printf(m, "%d: uart:%s ", portnr, uart);
 
 	if ((brdp->state & BST_STARTED) && (rc >= 0)) {
-		sp += sprintf(sp, "tx:%d rx:%d", (int) stli_comstats.txtotal,
+		char sep;
+
+		seq_printf(m, "tx:%d rx:%d", (int) stli_comstats.txtotal,
 			(int) stli_comstats.rxtotal);
 
 		if (stli_comstats.rxframing)
-			sp += sprintf(sp, " fe:%d",
+			seq_printf(m, " fe:%d",
 				(int) stli_comstats.rxframing);
 		if (stli_comstats.rxparity)
-			sp += sprintf(sp, " pe:%d",
+			seq_printf(m, " pe:%d",
 				(int) stli_comstats.rxparity);
 		if (stli_comstats.rxbreaks)
-			sp += sprintf(sp, " brk:%d",
+			seq_printf(m, " brk:%d",
 				(int) stli_comstats.rxbreaks);
 		if (stli_comstats.rxoverrun)
-			sp += sprintf(sp, " oe:%d",
+			seq_printf(m, " oe:%d",
 				(int) stli_comstats.rxoverrun);
 
-		cnt = sprintf(sp, "%s%s%s%s%s ",
-			(stli_comstats.signals & TIOCM_RTS) ? "|RTS" : "",
-			(stli_comstats.signals & TIOCM_CTS) ? "|CTS" : "",
-			(stli_comstats.signals & TIOCM_DTR) ? "|DTR" : "",
-			(stli_comstats.signals & TIOCM_CD) ? "|DCD" : "",
-			(stli_comstats.signals & TIOCM_DSR) ? "|DSR" : "");
-		*sp = ' ';
-		sp += cnt;
+		sep = ' ';
+		if (stli_comstats.signals & TIOCM_RTS) {
+			seq_printf(m, "%c%s", sep, "RTS");
+			sep = '|';
+		}
+		if (stli_comstats.signals & TIOCM_CTS) {
+			seq_printf(m, "%c%s", sep, "CTS");
+			sep = '|';
+		}
+		if (stli_comstats.signals & TIOCM_DTR) {
+			seq_printf(m, "%c%s", sep, "DTR");
+			sep = '|';
+		}
+		if (stli_comstats.signals & TIOCM_CD) {
+			seq_printf(m, "%c%s", sep, "DCD");
+			sep = '|';
+		}
+		if (stli_comstats.signals & TIOCM_DSR) {
+			seq_printf(m, "%c%s", sep, "DSR");
+			sep = '|';
+		}
 	}
-
-	for (cnt = (sp - pos); (cnt < (MAXLINE - 1)); cnt++)
-		*sp++ = ' ';
-	if (cnt >= MAXLINE)
-		pos[(MAXLINE - 2)] = '+';
-	pos[(MAXLINE - 1)] = '\n';
-
-	return(MAXLINE);
+	seq_putc(m, '\n');
 }
 
 /*****************************************************************************/
@@ -1964,26 +1960,15 @@ static int stli_portinfo(struct stlibrd *brdp, struct stliport *portp, int portn
  *	Port info, read from the /proc file system.
  */
 
-static int stli_readproc(char *page, char **start, off_t off, int count, int *eof, void *data)
+static int stli_proc_show(struct seq_file *m, void *v)
 {
 	struct stlibrd *brdp;
 	struct stliport *portp;
 	unsigned int brdnr, portnr, totalport;
-	int curoff, maxoff;
-	char *pos;
 
-	pos = page;
 	totalport = 0;
-	curoff = 0;
-
-	if (off == 0) {
-		pos += sprintf(pos, "%s: version %s", stli_drvtitle,
-			stli_drvversion);
-		while (pos < (page + MAXLINE - 1))
-			*pos++ = ' ';
-		*pos++ = '\n';
-	}
-	curoff =  MAXLINE;
+
+	seq_printf(m, "%s: version %s\n", stli_drvtitle, stli_drvversion);
 
 /*
  *	We scan through for each board, panel and port. The offset is
@@ -1996,33 +1981,31 @@ static int stli_readproc(char *page, char **start, off_t off, int count, int *eo
 		if (brdp->state == 0)
 			continue;
 
-		maxoff = curoff + (brdp->nrports * MAXLINE);
-		if (off >= maxoff) {
-			curoff = maxoff;
-			continue;
-		}
-
 		totalport = brdnr * STL_MAXPORTS;
 		for (portnr = 0; (portnr < brdp->nrports); portnr++,
 		    totalport++) {
 			portp = brdp->ports[portnr];
 			if (portp == NULL)
 				continue;
-			if (off >= (curoff += MAXLINE))
-				continue;
-			if ((pos - page + MAXLINE) > count)
-				goto stli_readdone;
-			pos += stli_portinfo(brdp, portp, totalport, pos);
+			stli_portinfo(m, brdp, portp, totalport);
 		}
 	}
+	return 0;
+}
 
-	*eof = 1;
-
-stli_readdone:
-	*start = page;
-	return(pos - page);
+static int stli_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, stli_proc_show, NULL);
 }
 
+static const struct file_operations stli_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= stli_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*****************************************************************************/
 
 /*
@@ -4427,9 +4410,9 @@ static const struct tty_operations stli_ops = {
 	.break_ctl = stli_breakctl,
 	.wait_until_sent = stli_waituntilsent,
 	.send_xchar = stli_sendxchar,
-	.read_proc = stli_readproc,
 	.tiocmget = stli_tiocmget,
 	.tiocmset = stli_tiocmset,
+	.proc_fops = &stli_proc_fops,
 };
 
 static const struct tty_port_operations stli_port_ops = {
-- 
1.5.6.5

