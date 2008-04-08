Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYDHOws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYDHOws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYDHOwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:52:35 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:44926 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbYDHOwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:52:34 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Subject: [PATCH 02/12] proc: switch /proc/driver/radio-typhoon to seq_file interface
Date: Tue, 8 Apr 2008 18:51:57 +0400
User-Agent: KMail/1.9.9
Cc: devel@openvz.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081851.57512.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/media/radio/radio-typhoon.c |   40 ++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

--- a/drivers/media/radio/radio-typhoon.c
+++ b/drivers/media/radio/radio-typhoon.c
@@ -35,6 +35,7 @@
 #include <linux/init.h>		/* Initdata                       */
 #include <linux/ioport.h>	/* request_region		  */
 #include <linux/proc_fs.h>	/* radio card status report	  */
+#include <linux/seq_file.h>
 #include <asm/io.h>		/* outb, outb_p                   */
 #include <asm/uaccess.h>	/* copy to/from user              */
 #include <linux/videodev2.h>	/* kernel radio structs           */
@@ -93,9 +94,6 @@ static int typhoon_setfreq(struct typhoon_device *dev, unsigned long frequency);
 static void typhoon_mute(struct typhoon_device *dev);
 static void typhoon_unmute(struct typhoon_device *dev);
 static int typhoon_setvol(struct typhoon_device *dev, int vol);
-#ifdef CONFIG_RADIO_TYPHOON_PROC_FS
-static int typhoon_get_info(char *buf, char **start, off_t offset, int len);
-#endif
 
 static void typhoon_setvol_generic(struct typhoon_device *dev, int vol)
 {
@@ -368,30 +366,39 @@ static struct video_device typhoon_radio =
 
 #ifdef CONFIG_RADIO_TYPHOON_PROC_FS
 
-static int typhoon_get_info(char *buf, char **start, off_t offset, int len)
+static int typhoon_proc_show(struct seq_file *m, void *v)
 {
-	char *out = buf;
-
 	#ifdef MODULE
 	    #define MODULEPROCSTRING "Driver loaded as a module"
 	#else
 	    #define MODULEPROCSTRING "Driver compiled into kernel"
 	#endif
 
-	/* output must be kept under PAGE_SIZE */
-	out += sprintf(out, BANNER);
-	out += sprintf(out, "Load type: " MODULEPROCSTRING "\n\n");
-	out += sprintf(out, "frequency = %lu kHz\n",
+	seq_puts(m, BANNER);
+	seq_puts(m, "Load type: " MODULEPROCSTRING "\n\n");
+	seq_printf(m, "frequency = %lu kHz\n",
 		typhoon_unit.curfreq >> 4);
-	out += sprintf(out, "volume = %d\n", typhoon_unit.curvol);
-	out += sprintf(out, "mute = %s\n", typhoon_unit.muted ?
+	seq_printf(m, "volume = %d\n", typhoon_unit.curvol);
+	seq_printf(m, "mute = %s\n", typhoon_unit.muted ?
 		"on" : "off");
-	out += sprintf(out, "iobase = 0x%x\n", typhoon_unit.iobase);
-	out += sprintf(out, "mute frequency = %lu kHz\n",
+	seq_printf(m, "iobase = 0x%x\n", typhoon_unit.iobase);
+	seq_printf(m, "mute frequency = %lu kHz\n",
 		typhoon_unit.mutefreq >> 4);
-	return out - buf;
+	return 0;
 }
 
+static int typhoon_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, typhoon_proc_show, NULL);
+}
+
+static const struct file_operations typhoon_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= typhoon_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_RADIO_TYPHOON_PROC_FS */
 
 MODULE_AUTHOR("Dr. Henrik Seidel");
@@ -452,8 +459,7 @@ static int __init typhoon_init(void)
 	typhoon_mute(&typhoon_unit);
 
 #ifdef CONFIG_RADIO_TYPHOON_PROC_FS
-	if (!create_proc_info_entry("driver/radio-typhoon", 0, NULL,
-				    typhoon_get_info))
+	if (!proc_create("driver/radio-typhoon", 0, NULL, &typhoon_proc_fops))
 		printk(KERN_ERR "radio-typhoon: registering /proc/driver/radio-typhoon failed\n");
 #endif
 
-- 
1.5.4.3

