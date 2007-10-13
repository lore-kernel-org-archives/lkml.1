Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbXJMOrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbXJMOrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761873AbXJMOma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:30 -0400
Received: from 1wt.eu ([62.212.114.60]:2973 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761852AbXJMOm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:28 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143454.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:37 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [2.6.20.21 review 15/35] Convert snd-page-alloc proc file to use seq_file
Content-Disposition: inline; filename=0001-Convert-snd-page-alloc-proc-file-to-use-seq_file.patch2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use seq_file for the proc file read/write of snd-page-alloc module.
This automatically fixes bugs in the old proc code.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 sound/core/memalloc.c |   68 ++++++++++++++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 29 deletions(-)

Index: 2.6/sound/core/memalloc.c
===================================================================
--- 2.6.orig/sound/core/memalloc.c
+++ 2.6/sound/core/memalloc.c
@@ -27,6 +27,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <asm/uaccess.h>
 #include <linux/dma-mapping.h>
 #include <linux/moduleparam.h>
@@ -483,10 +484,8 @@ static void free_all_reserved_pages(void
 #define SND_MEM_PROC_FILE	"driver/snd-page-alloc"
 static struct proc_dir_entry *snd_mem_proc;
 
-static int snd_mem_proc_read(char *page, char **start, off_t off,
-			     int count, int *eof, void *data)
+static int snd_mem_proc_read(struct seq_file *seq, void *offset)
 {
-	int len = 0;
 	long pages = snd_allocated_pages >> (PAGE_SHIFT-12);
 	struct list_head *p;
 	struct snd_mem_list *mem;
@@ -494,44 +493,47 @@ static int snd_mem_proc_read(char *page,
 	static char *types[] = { "UNKNOWN", "CONT", "DEV", "DEV-SG", "SBUS" };
 
 	mutex_lock(&list_mutex);
-	len += snprintf(page + len, count - len,
-			"pages  : %li bytes (%li pages per %likB)
",
-			pages * PAGE_SIZE, pages, PAGE_SIZE / 1024);
+	seq_printf(seq, "pages  : %li bytes (%li pages per %likB)
",
+		   pages * PAGE_SIZE, pages, PAGE_SIZE / 1024);
 	devno = 0;
 	list_for_each(p, &mem_list_head) {
 		mem = list_entry(p, struct snd_mem_list, list);
 		devno++;
-		len += snprintf(page + len, count - len,
-				"buffer %d : ID %08x : type %s
",
-				devno, mem->id, types[mem->buffer.dev.type]);
-		len += snprintf(page + len, count - len,
-				"  addr = 0x%lx, size = %d bytes
",
-				(unsigned long)mem->buffer.addr, (int)mem->buffer.bytes);
+		seq_printf(seq, "buffer %d : ID %08x : type %s
",
+			   devno, mem->id, types[mem->buffer.dev.type]);
+		seq_printf(seq, "  addr = 0x%lx, size = %d bytes
",
+			   (unsigned long)mem->buffer.addr,
+			   (int)mem->buffer.bytes);
 	}
 	mutex_unlock(&list_mutex);
-	return len;
+	return 0;
+}
+
+static int snd_mem_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, snd_mem_proc_read, NULL);
 }
 
 /* FIXME: for pci only - other bus? */
 #ifdef CONFIG_PCI
 #define gettoken(bufp) strsep(bufp, " 	
")
 
-static int snd_mem_proc_write(struct file *file, const char __user *buffer,
-			      unsigned long count, void *data)
+static ssize_t snd_mem_proc_write(struct file *file, const char __user * buffer,
+				  size_t count, loff_t * ppos)
 {
 	char buf[128];
 	char *token, *p;
 
-	if (count > ARRAY_SIZE(buf) - 1)
-		count = ARRAY_SIZE(buf) - 1;
+	if (count > sizeof(buf) - 1)
+		return -EINVAL;
 	if (copy_from_user(buf, buffer, count))
 		return -EFAULT;
-	buf[ARRAY_SIZE(buf) - 1] = '';
+	buf[count] = '';
 
 	p = buf;
 	token = gettoken(&p);
 	if (! token || *token == '#')
-		return (int)count;
+		return count;
 	if (strcmp(token, "add") == 0) {
 		char *endp;
 		int vendor, device, size, buffers;
@@ -552,7 +554,7 @@ static int snd_mem_proc_write(struct fil
 		    (buffers = simple_strtol(token, NULL, 0)) <= 0 ||
 		    buffers > 4) {
 			printk(KERN_ERR "snd-page-alloc: invalid proc write format
");
-			return (int)count;
+			return count;
 		}
 		vendor &= 0xffff;
 		device &= 0xffff;
@@ -564,7 +566,7 @@ static int snd_mem_proc_write(struct fil
 				if (pci_set_dma_mask(pci, mask) < 0 ||
 				    pci_set_consistent_dma_mask(pci, mask) < 0) {
 					printk(KERN_ERR "snd-page-alloc: cannot set DMA mask %lx for pci %04x:%04x
", mask, vendor, device);
-					return (int)count;
+					return count;
 				}
 			}
 			for (i = 0; i < buffers; i++) {
@@ -574,7 +576,7 @@ static int snd_mem_proc_write(struct fil
 							size, &dmab) < 0) {
 					printk(KERN_ERR "snd-page-alloc: cannot allocate buffer pages (size = %d)
", size);
 					pci_dev_put(pci);
-					return (int)count;
+					return count;
 				}
 				snd_dma_reserve_buf(&dmab, snd_dma_pci_buf_id(pci));
 			}
@@ -600,9 +602,21 @@ static int snd_mem_proc_write(struct fil
 		free_all_reserved_pages();
 	else
 		printk(KERN_ERR "snd-page-alloc: invalid proc cmd
");
-	return (int)count;
+	return count;
 }
 #endif /* CONFIG_PCI */
+
+static const struct file_operations snd_mem_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= snd_mem_proc_open,
+	.read		= seq_read,
+#ifdef CONFIG_PCI
+	.write		= snd_mem_proc_write,
+#endif
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 #endif /* CONFIG_PROC_FS */
 
 /*
@@ -613,12 +627,8 @@ static int __init snd_mem_init(void)
 {
 #ifdef CONFIG_PROC_FS
 	snd_mem_proc = create_proc_entry(SND_MEM_PROC_FILE, 0644, NULL);
-	if (snd_mem_proc) {
-		snd_mem_proc->read_proc = snd_mem_proc_read;
-#ifdef CONFIG_PCI
-		snd_mem_proc->write_proc = snd_mem_proc_write;
-#endif
-	}
+	if (snd_mem_proc)
+		snd_mem_proc->proc_fops = &snd_mem_proc_fops;
 #endif
 	return 0;
 }

-- 
