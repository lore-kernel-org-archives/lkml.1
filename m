Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYDLVEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYDLVEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 17:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYDLVDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 17:03:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:60949 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYDLVDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 17:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=loEosuTsqUl358TTk3i93oT3ezz8X1BcLharDkOHYsbKImYZHuAJkZgRtrUUeB85hNSUo3KBONTlVvajpAdCj36DaEc03u2x3/txtc9Veh0G7PfA+iAWJCFOHh7OYOGn85wHVar8+EsaNgrhWui56pz+e4mB+MVaZpaoO5xxBPc=
Date: Sun, 13 Apr 2008 00:59:23 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH] proc: convert /proc/tty/ldiscs to seq_file interface
Message-ID: <20080412205923.GA9151@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: THIS_MODULE and header addition aren't technically needed because
      this code is not modular, but let's keep it anyway because people
      can copy this code into modular code.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/proc_tty.c |   74 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 30 deletions(-)

--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -5,7 +5,7 @@
  */
 
 #include <asm/uaccess.h>
-
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/time.h>
@@ -136,39 +136,54 @@ static const struct file_operations proc_tty_drivers_operations = {
 	.release	= seq_release,
 };
 
-/*
- * This is the handler for /proc/tty/ldiscs
- */
-static int tty_ldiscs_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data)
+static void * tty_ldiscs_seq_start(struct seq_file *m, loff_t *pos)
 {
-	int	i;
-	int	len = 0;
-	off_t	begin = 0;
+	return (*pos < NR_LDISCS) ? pos : NULL;
+}
+
+static void * tty_ldiscs_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return (*pos < NR_LDISCS) ? pos : NULL;
+}
+
+static void tty_ldiscs_seq_stop(struct seq_file *m, void *v)
+{
+}
+
+static int tty_ldiscs_seq_show(struct seq_file *m, void *v)
+{
+	int i = *(loff_t *)v;
 	struct tty_ldisc *ld;
 	
-	for (i=0; i < NR_LDISCS; i++) {
-		ld = tty_ldisc_get(i);
-		if (ld == NULL)
-			continue;
-		len += sprintf(page+len, "%-10s %2d\n",
-			       ld->name ? ld->name : "???", i);
-		tty_ldisc_put(i);
-		if (len+begin > off+count)
-			break;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
-		}
-	}
-	if (i >= NR_LDISCS)
-		*eof = 1;
-	if (off >= len+begin)
+	ld = tty_ldisc_get(i);
+	if (ld == NULL)
 		return 0;
-	*start = page + (off-begin);
-	return ((count < begin+len-off) ? count : begin+len-off);
+	seq_printf(m, "%-10s %2d\n", ld->name ? ld->name : "???", i);
+	tty_ldisc_put(i);
+	return 0;
+}
+
+static const struct seq_operations tty_ldiscs_seq_ops = {
+	.start	= tty_ldiscs_seq_start,
+	.next	= tty_ldiscs_seq_next,
+	.stop	= tty_ldiscs_seq_stop,
+	.show	= tty_ldiscs_seq_show,
+};
+
+static int proc_tty_ldiscs_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &tty_ldiscs_seq_ops);
 }
 
+static const struct file_operations tty_ldiscs_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_tty_ldiscs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 /*
  * This function is called by tty_register_driver() to handle
  * registering the driver's /proc handler into /proc/tty/driver/<foo>
@@ -224,7 +239,6 @@ void __init proc_tty_init(void)
 	 * entry.
 	 */
 	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR | S_IXUSR, NULL);
-
-	create_proc_read_entry("tty/ldiscs", 0, NULL, tty_ldiscs_read_proc, NULL);
+	proc_create("tty/ldiscs", 0, NULL, &tty_ldiscs_proc_fops);
 	proc_create("tty/drivers", 0, NULL, &proc_tty_drivers_operations);
 }
-- 
1.5.3.7


