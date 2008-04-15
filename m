Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbYDOGco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbYDOGco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYDOGch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:32:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbYDOGcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:32:36 -0400
Date: Mon, 14 Apr 2008 23:31:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fb: convert /proc/fb to seq_file interface
Message-Id: <20080414233154.aef6006e.akpm@linux-foundation.org>
In-Reply-To: <20080412210317.GC9151@martell.zuzino.mipt.ru>
References: <20080412210317.GC9151@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 01:03:17 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Note: looks like accesses to "registered_fb" are done without any exclusion
> so there're none in new proc code, too. This should be fixed in separate
> patch.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Tony has been offline for a while and we need all the help we can get.  So
let's cc linux-fbdev-devel.



 drivers/video/fbmem.c |   61 ++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 18 deletions(-)

diff -puN drivers/video/fbmem.c~fb-convert-proc-fb-to-seq_file-interface drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-convert-proc-fb-to-seq_file-interface
+++ a/drivers/video/fbmem.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/linux_logo.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/console.h>
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
@@ -632,27 +633,51 @@ int fb_prepare_logo(struct fb_info *info
 int fb_show_logo(struct fb_info *info, int rotate) { return 0; }
 #endif /* CONFIG_LOGO */
 
-static int fbmem_read_proc(char *buf, char **start, off_t offset,
-			   int len, int *eof, void *private)
+static void * fb_seq_start(struct seq_file *m, loff_t *pos)
 {
-	struct fb_info **fi;
-	int clen;
+	return (*pos < FB_MAX) ? pos : NULL;
+}
 
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
+static void * fb_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return (*pos < FB_MAX) ? pos : NULL;
+}
+
+static void fb_seq_stop(struct seq_file *m, void *v)
+{
+}
+
+static int fb_seq_show(struct seq_file *m, void *v)
+{
+	int i = *(loff_t *)v;
+	struct fb_info *fi = registered_fb[i];
+
+	if (fi)
+		seq_printf(m, "%d %s\n", fi->node, fi->fix.id);
+	return 0;
 }
 
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
@@ -1533,7 +1558,7 @@ void fb_set_suspend(struct fb_info *info
 static int __init
 fbmem_init(void)
 {
-	create_proc_read_entry("fb", 0, NULL, fbmem_read_proc, NULL);
+	proc_create("fb", 0, NULL, &fb_proc_fops);
 
 	if (register_chrdev(FB_MAJOR,"fb",&fb_fops))
 		printk("unable to get major %d for fb devs\n", FB_MAJOR);
_

