Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbZH1TuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbZH1TuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZH1TuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:50:09 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47279 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZH1TuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=h9v+Qq29y/d6aXSfm/H2dDdj8raT2JVXyFrbyxS4HnAIMvVaYOmYWEk9+YHAuk3yxB
         v4ESFOYO8A5/rTgjw3cAtr8pEQ6mZFuzcOjknWkjFcys3eWjfiNphMnwhJfcPpVqCT6k
         Z0RemkLQy9rW7AmZaaa360zpfA4ulP7Zl3dg8=
Date: Fri, 28 Aug 2009 23:50:05 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cpqarray: switch to seq_file
Message-ID: <20090828195005.GA15123@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/block/cpqarray.c |   63 ++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 33 deletions(-)

--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -32,6 +32,7 @@
 #include <linux/blkpg.h>
 #include <linux/timer.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/hdreg.h>
 #include <linux/spinlock.h>
@@ -177,7 +178,6 @@ static int cpqarray_register_ctlr(int ctlr, struct pci_dev *pdev);
 
 #ifdef CONFIG_PROC_FS
 static void ida_procinit(int i);
-static int ida_proc_get_info(char *buffer, char **start, off_t offset, int length, int *eof, void *data);
 #else
 static void ida_procinit(int i) {}
 #endif
@@ -206,6 +206,7 @@ static struct block_device_operations ida_fops  = {
 #ifdef CONFIG_PROC_FS
 
 static struct proc_dir_entry *proc_array;
+static const struct file_operations ida_proc_fops;
 
 /*
  * Get us a file in /proc/array that says something about each controller.
@@ -218,19 +219,16 @@ static void __init ida_procinit(int i)
 		if (!proc_array) return;
 	}
 
-	create_proc_read_entry(hba[i]->devname, 0, proc_array,
-			       ida_proc_get_info, hba[i]);
+	proc_create_data(hba[i]->devname, 0, proc_array, &ida_proc_fops, hba[i]);
 }
 
 /*
  * Report information about this controller.
  */
-static int ida_proc_get_info(char *buffer, char **start, off_t offset, int length, int *eof, void *data)
+static int ida_proc_show(struct seq_file *m, void *v)
 {
-	off_t pos = 0;
-	off_t len = 0;
-	int size, i, ctlr;
-	ctlr_info_t *h = (ctlr_info_t*)data;
+	int i, ctlr;
+	ctlr_info_t *h = (ctlr_info_t*)m->private;
 	drv_info_t *drv;
 #ifdef CPQ_PROC_PRINT_QUEUES
 	cmdlist_t *c;
@@ -238,7 +236,7 @@ static int ida_proc_get_info(char *buffer, char **start, off_t offset, int lengt
 #endif
 
 	ctlr = h->ctlr;
-	size = sprintf(buffer, "%s:  Compaq %s Controller\n"
+	seq_printf(m, "%s:  Compaq %s Controller\n"
 		"       Board ID: 0x%08lx\n"
 		"       Firmware Revision: %c%c%c%c\n"
 		"       Controller Sig: 0x%08lx\n"
@@ -258,55 +256,54 @@ static int ida_proc_get_info(char *buffer, char **start, off_t offset, int lengt
 		h->log_drives, h->phys_drives,
 		h->Qdepth, h->maxQsinceinit);
 
-	pos += size; len += size;
-	
-	size = sprintf(buffer+len, "Logical Drive Info:\n");
-	pos += size; len += size;
+	seq_puts(m, "Logical Drive Info:\n");
 
 	for(i=0; i<h->log_drives; i++) {
 		drv = &h->drv[i];
-		size = sprintf(buffer+len, "ida/c%dd%d: blksz=%d nr_blks=%d\n",
+		seq_printf(m, "ida/c%dd%d: blksz=%d nr_blks=%d\n",
 				ctlr, i, drv->blk_size, drv->nr_blks);
-		pos += size; len += size;
 	}
 
 #ifdef CPQ_PROC_PRINT_QUEUES
 	spin_lock_irqsave(IDA_LOCK(h->ctlr), flags); 
-	size = sprintf(buffer+len, "\nCurrent Queues:\n");
-	pos += size; len += size;
+	seq_puts(m, "\nCurrent Queues:\n");
 
 	c = h->reqQ;
-	size = sprintf(buffer+len, "reqQ = %p", c); pos += size; len += size;
+	seq_printf(m, "reqQ = %p", c);
 	if (c) c=c->next;
 	while(c && c != h->reqQ) {
-		size = sprintf(buffer+len, "->%p", c);
-		pos += size; len += size;
+		seq_printf(m, "->%p", c);
 		c=c->next;
 	}
 
 	c = h->cmpQ;
-	size = sprintf(buffer+len, "\ncmpQ = %p", c); pos += size; len += size;
+	seq_printf(m, "\ncmpQ = %p", c);
 	if (c) c=c->next;
 	while(c && c != h->cmpQ) {
-		size = sprintf(buffer+len, "->%p", c);
-		pos += size; len += size;
+		seq_printf(m, "->%p", c);
 		c=c->next;
 	}
 
-	size = sprintf(buffer+len, "\n"); pos += size; len += size;
+	seq_putc(m, '\n');
 	spin_unlock_irqrestore(IDA_LOCK(h->ctlr), flags); 
 #endif
-	size = sprintf(buffer+len, "nr_allocs = %d\nnr_frees = %d\n",
+	seq_printf(m, "nr_allocs = %d\nnr_frees = %d\n",
 			h->nr_allocs, h->nr_frees);
-	pos += size; len += size;
-
-	*eof = 1;
-	*start = buffer+offset;
-	len -= offset;
-	if (len>length)
-		len = length;
-	return len;
+	return 0;
+}
+
+static int ida_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ida_proc_show, PDE(inode)->data);
 }
+
+static const struct file_operations ida_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ida_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_PROC_FS */
 
 module_param_array(eisa, int, NULL, 0);
