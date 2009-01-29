Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbZA2Rtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbZA2Rtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760323AbZA2Rta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:49:30 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34702 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760303AbZA2Rt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:49:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K5Vmx9QJtP35UluFsZUbkeQ8q+LpMkql+P2QFZ+r5Bad+cC6qEl19kC0kG28bCajeM
         bRF0QIkk7X6qRxwVWojqGyGNGrvIFljv4tArw0NesQs+bXER/ZAeSMYZpVZBfk2X9cTG
         SFCQEoch3/KeNyIuvMHx6RNRtNjulJA4kSzsI=
Date: Thu, 29 Jan 2009 20:55:10 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/17] proc tty: switch ia64 simserial to ->proc_fops
Message-ID: <20090129175510.GO21643@x200.localdomain>
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
 arch/ia64/hp/sim/simserial.c |   49 ++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 24b1ad5..2bef526 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -24,6 +24,7 @@
 #include <linux/major.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/capability.h>
 #include <linux/console.h>
@@ -848,38 +849,36 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
  * /proc fs routines....
  */
 
-static inline int line_info(char *buf, struct serial_state *state)
+static inline void line_info(struct seq_file *m, struct serial_state *state)
 {
-	return sprintf(buf, "%d: uart:%s port:%lX irq:%d\n",
+	seq_printf(m, "%d: uart:%s port:%lX irq:%d\n",
 		       state->line, uart_config[state->type].name,
 		       state->port, state->irq);
 }
 
-static int rs_read_proc(char *page, char **start, off_t off, int count,
-		 int *eof, void *data)
+static int rs_proc_show(struct seq_file *m, void *v)
 {
-	int i, len = 0, l;
-	off_t	begin = 0;
-
-	len += sprintf(page, "simserinfo:1.0 driver:%s\n", serial_version);
-	for (i = 0; i < NR_PORTS && len < 4000; i++) {
-		l = line_info(page + len, &rs_table[i]);
-		len += l;
-		if (len+begin > off+count)
-			goto done;
-		if (len+begin < off) {
-			begin += len;
-			len = 0;
-		}
-	}
-	*eof = 1;
-done:
-	if (off >= len+begin)
-		return 0;
-	*start = page + (begin-off);
-	return ((count < begin+len-off) ? count : begin+len-off);
+	int i;
+
+	seq_printf(m, "simserinfo:1.0 driver:%s\n", serial_version);
+	for (i = 0; i < NR_PORTS; i++)
+		line_info(m, &rs_table[i]);
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
@@ -917,7 +916,7 @@ static const struct tty_operations hp_ops = {
 	.start = rs_start,
 	.hangup = rs_hangup,
 	.wait_until_sent = rs_wait_until_sent,
-	.read_proc = rs_read_proc,
+	.proc_fops = &rs_proc_fops,
 };
 
 /*
-- 
1.5.6.5

