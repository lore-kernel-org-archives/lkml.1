Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZK0Gte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZK0Gte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZK0Gte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:49:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53244 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZK0Gtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fq+THGk4vPitrYY4q7ggk+dzBsNeq1VXzMsN4UNtp+jsAsZKkHDoBNvwEs2RLQoZC8
         uVsQu8m41PH+rX2XK7rZXvkHRrz2BobypE9x5usPLZYkQmSXzke5V74UYV+X9yE+gGLe
         x7TwEqEJO8h55WgNIMYVvXAQtjTRe/Y5ft6T0=
Date: Fri, 27 Nov 2009 09:49:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] clps711xfb: convert to proc_fops
Message-ID: <20091127064936.GB26327@x200.malnet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/video/clps711xfb.c |   50 ++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

--- a/drivers/video/clps711xfb.c
+++ b/drivers/video/clps711xfb.c
@@ -19,8 +19,10 @@
  *
  *  Framebuffer driver for the CLPS7111 and EP7212 processors.
  */
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/init.h>
@@ -38,14 +40,6 @@ struct fb_info	*cfb;
 
 #define CMAP_MAX_SIZE	16
 
-/* The /proc entry for the backlight. */
-static struct proc_dir_entry *clps7111fb_backlight_proc_entry = NULL;
-
-static int clps7111fb_proc_backlight_read(char *page, char **start, off_t off,
-		int count, int *eof, void *data);
-static int clps7111fb_proc_backlight_write(struct file *file, 
-		const char *buffer, unsigned long count, void *data);
-
 /*
  * LCD AC Prescale.  This comes from the LCD panel manufacturers specifications.
  * This determines how many clocks + 1 of CL1 before the M signal toggles.
@@ -221,26 +215,23 @@ static struct fb_ops clps7111fb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static int 
-clps7111fb_proc_backlight_read(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
+static int backlight_proc_show(struct seq_file *m, void *v)
 {
-	/* We need at least two characters, one for the digit, and one for
-	 * the terminating NULL. */
-	if (count < 2) 
-		return -EINVAL;
-
 	if (machine_is_edb7211()) {
-		return sprintf(page, "%d\n", 
+		seq_printf(m, "%d\n",
 				(clps_readb(PDDR) & EDB_PD3_LCDBL) ? 1 : 0);
 	}
 
 	return 0;
 }
 
-static int 
-clps7111fb_proc_backlight_write(struct file *file, const char *buffer, 
-		unsigned long count, void *data)
+static int backlight_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, backlight_proc_show, NULL);
+}
+
+static ssize_t backlight_proc_write(struct file *file, const char *buffer,
+				    size_t count, loff_t *pos)
 {
 	unsigned char char_value;
 	int value;
@@ -271,6 +262,15 @@ clps7111fb_proc_backlight_write(struct file *file, const char *buffer,
 	return count;
 }
 
+static const struct file_operations backlight_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= backlight_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= backlight_proc_write,
+};
+
 static void __init clps711x_guess_lcd_params(struct fb_info *info)
 {
 	unsigned int lcdcon, syscon, size;
@@ -379,19 +379,11 @@ int __init clps711xfb_init(void)
 
 	fb_alloc_cmap(&cfb->cmap, CMAP_MAX_SIZE, 0);
 
-	/* Register the /proc entries. */
-	clps7111fb_backlight_proc_entry = create_proc_entry("backlight", 0444,
-		NULL);
-	if (clps7111fb_backlight_proc_entry == NULL) {
+	if (!proc_create("backlight", 0444, NULL, &backlight_proc_fops)) {
 		printk("Couldn't create the /proc entry for the backlight.\n");
 		return -EINVAL;
 	}
 
-	clps7111fb_backlight_proc_entry->read_proc = 
-		&clps7111fb_proc_backlight_read;
-	clps7111fb_backlight_proc_entry->write_proc = 
-		&clps7111fb_proc_backlight_write;
-
 	/*
 	 * Power up the LCD
 	 */
