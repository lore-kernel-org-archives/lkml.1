Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYDLVHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYDLVHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 17:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYDLVHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 17:07:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:1503 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYDLVHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 17:07:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=JC3muIKuellYEBrUM2pZQGUMgeKxi4fpVSpJNgjA86EMJ+0D7L8ixZtMLq8VLVNlVUb4uF/NYdViuSRdYD3SpfdMgEOaqIaNfP1id9mVUQGGpFq9g+FFgDByT06/6IGwFsi8k7vC5vRO74a5vtrm3UaqxH0KfpsIcW62ATLp+Hs=
Date: Sun, 13 Apr 2008 01:03:17 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] fb: convert /proc/fb to seq_file interface
Message-ID: <20080412210317.GC9151@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: looks like accesses to "registered_fb" are done without any exclusion
so there're none in new proc code, too. This should be fixed in separate
patch.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/video/fbmem.c |   63 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 19 deletions(-)

--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/linux_logo.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/console.h>
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
@@ -632,27 +633,51 @@ int fb_prepare_logo(struct fb_info *info, int rotate) { return 0; }
 int fb_show_logo(struct fb_info *info, int rotate) { return 0; }
 #endif /* CONFIG_LOGO */
 
-static int fbmem_read_proc(char *buf, char **start, off_t offset,
-			   int len, int *eof, void *private)
+static void * fb_seq_start(struct seq_file *m, loff_t *pos)
+{
+	return (*pos < FB_MAX) ? pos : NULL;
+}
+
+static void * fb_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return (*pos < FB_MAX) ? pos : NULL;
+}
+
+static void fb_seq_stop(struct seq_file *m, void *v)
 {
-	struct fb_info **fi;
-	int clen;
-
-	clen = 0;
-	for (fi = registered_fb; fi < &registered_fb[FB_MAX] && clen < 4000;
-	     fi++)
-		if (*fi)
-			clen += sprintf(buf + clen, "%d %s\n",
-				        (*fi)->node,
-				        (*fi)->fix.id);
-	*start = buf + offset;
-	if (clen > offset)
-		clen -= offset;
-	else
-		clen = 0;
-	return clen < len ? clen : len;
 }
 
+static int fb_seq_show(struct seq_file *m, void *v)
+{
+	int i = *(loff_t *)v;
+	struct fb_info *fi = registered_fb[i];
+
+	if (fi)
+		seq_printf(m, "%d %s\n", fi->node, fi->fix.id);
+	return 0;
+}
+
+static const struct seq_operations proc_fb_seq_ops = {
+	.start	= fb_seq_start,
+	.next	= fb_seq_next,
+	.stop	= fb_seq_stop,
+	.show	= fb_seq_show,
+};
+
+static int proc_fb_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &proc_fb_seq_ops);
+}
+
+static const struct file_operations fb_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_fb_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static ssize_t
 fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
@@ -1533,7 +1558,7 @@ void fb_set_suspend(struct fb_info *info, int state)
 static int __init
 fbmem_init(void)
 {
-	create_proc_read_entry("fb", 0, NULL, fbmem_read_proc, NULL);
+	proc_create("fb", 0, NULL, &fb_proc_fops);
 
 	if (register_chrdev(FB_MAJOR,"fb",&fb_fops))
 		printk("unable to get major %d for fb devs\n", FB_MAJOR);
-- 
1.5.3.7


