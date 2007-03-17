Return-Path: <linux-kernel-owner+w=401wt.eu-S1750913AbXCQQ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913AbXCQQ2b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 12:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXCQQ2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 12:28:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:25708 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbXCQQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 12:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=TUcy5lMQPO5BNQYobpqn8jbg99fT5R5otaoDTdixIAYVbmmtYIH3NEAqfrYW/7ciEgTzJU0QEOY26qjIDWxIM38y6h3Tw8fV+uPB3Fo7uxvJFrKozW97qFShQzx1qINShpLl6Sf1Suzol44dE6mTEkIkNcq08GzUA1QFegfIzrA=
Date: Sat, 17 Mar 2007 19:28:27 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx, kyle@parisc-linux.org,
       grundler@parisc-linux.org
Subject: [PATCH] parisc: convert /proc/gsc/pcxl_dma to seq_file
Message-ID: <20070317162827.GA5327@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As side effect, remove one more ->get_info user and a novel approach of content
generation:

	sprintf(buf, "%sfoo", buf, ...);
	sprintf(buf, "%sbar", buf, ...);
		...

Compile-tested.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/parisc/kernel/pci-dma.c |   94 ++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 41 deletions(-)

--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -21,6 +21,7 @@ #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -34,7 +35,6 @@ #include <asm/uaccess.h>
 #include <asm/tlbflush.h>	/* for purge_tlb_*() macros */
 
 static struct proc_dir_entry * proc_gsc_root __read_mostly = NULL;
-static int pcxl_proc_info(char *buffer, char **start, off_t offset, int length);
 static unsigned long pcxl_used_bytes __read_mostly = 0;
 static unsigned long pcxl_used_pages __read_mostly = 0;
 
@@ -330,6 +330,54 @@ pcxl_free_range(unsigned long vaddr, siz
 	dump_resmap();
 }
 
+static int proc_pcxl_dma_show(struct seq_file *m, void *v)
+{
+#if 0
+	u_long i = 0;
+	unsigned long *res_ptr = (u_long *)pcxl_res_map;
+#endif
+	unsigned long total_pages = pcxl_res_size << 3;   /* 8 bits per byte */
+
+	seq_printf(m, "\nDMA Mapping Area size    : %d bytes (%ld pages)\n",
+		PCXL_DMA_MAP_SIZE, total_pages);
+
+	seq_printf(m, "Resource bitmap : %d bytes\n", pcxl_res_size);
+
+	seq_puts(m,  "     	  total:    free:    used:   % used:\n");
+	seq_printf(m, "blocks  %8d %8ld %8ld %8ld%%\n", pcxl_res_size,
+		pcxl_res_size - pcxl_used_bytes, pcxl_used_bytes,
+		(pcxl_used_bytes * 100) / pcxl_res_size);
+
+	seq_printf(m, "pages   %8ld %8ld %8ld %8ld%%\n", total_pages,
+		total_pages - pcxl_used_pages, pcxl_used_pages,
+		(pcxl_used_pages * 100 / total_pages));
+
+#if 0
+	seq_puts(m, "\nResource bitmap:");
+
+	for(; i < (pcxl_res_size / sizeof(u_long)); ++i, ++res_ptr) {
+		if ((i & 7) == 0)
+		    seq_puts(m,"\n   ");
+		seq_printf(m, "%s %08lx", buf, *res_ptr);
+	}
+#endif
+	seq_putc(m, '\n');
+	return 0;
+}
+
+static int proc_pcxl_dma_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_pcxl_dma_show, NULL);
+}
+
+static const struct file_operations proc_pcxl_dma_ops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_pcxl_dma_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int __init
 pcxl_dma_init(void)
 {
@@ -348,9 +396,10 @@ pcxl_dma_init(void)
 			"pcxl_dma_init: Unable to create gsc /proc dir entry\n");
 	else {
 		struct proc_dir_entry* ent;
-		ent = create_proc_info_entry("pcxl_dma", 0,
-				proc_gsc_root, pcxl_proc_info);
-		if (!ent)
+		ent = create_proc_entry("pcxl_dma", 0, proc_gsc_root);
+		if (ent)
+			ent->proc_fops = &proc_pcxl_dma_ops;
+		else
 			printk(KERN_WARNING
 				"pci-dma.c: Unable to create pcxl_dma /proc entry.\n");
 	}
@@ -551,40 +600,3 @@ struct hppa_dma_ops pcx_dma_ops = {
 	.dma_sync_sg_for_cpu =		pa11_dma_sync_sg_for_cpu,
 	.dma_sync_sg_for_device =	pa11_dma_sync_sg_for_device,
 };
-
-
-static int pcxl_proc_info(char *buf, char **start, off_t offset, int len)
-{
-#if 0
-	u_long i = 0;
-	unsigned long *res_ptr = (u_long *)pcxl_res_map;
-#endif
-	unsigned long total_pages = pcxl_res_size << 3;   /* 8 bits per byte */
-
-	sprintf(buf, "\nDMA Mapping Area size    : %d bytes (%ld pages)\n",
-		PCXL_DMA_MAP_SIZE, total_pages);
-	
-	sprintf(buf, "%sResource bitmap : %d bytes\n", buf, pcxl_res_size);
-
-	strcat(buf,  "     	  total:    free:    used:   % used:\n");
-	sprintf(buf, "%sblocks  %8d %8ld %8ld %8ld%%\n", buf, pcxl_res_size,
-		pcxl_res_size - pcxl_used_bytes, pcxl_used_bytes,
-		(pcxl_used_bytes * 100) / pcxl_res_size);
-
-	sprintf(buf, "%spages   %8ld %8ld %8ld %8ld%%\n", buf, total_pages,
-		total_pages - pcxl_used_pages, pcxl_used_pages,
-		(pcxl_used_pages * 100 / total_pages));
-
-#if 0
-	strcat(buf, "\nResource bitmap:");
-
-	for(; i < (pcxl_res_size / sizeof(u_long)); ++i, ++res_ptr) {
-		if ((i & 7) == 0)
-		    strcat(buf,"\n   ");
-		sprintf(buf, "%s %08lx", buf, *res_ptr);
-	}
-#endif
-	strcat(buf, "\n");
-	return strlen(buf);
-}
-

