Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbZH1Sxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbZH1Sxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZH1Sxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:53:36 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56459 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZH1Sxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=meuZU+6vQl6D0UJ99B4o6TipGGPOcN9ty931uWTiqY10IKjDIIuEvXkuNlxFrWGB3Z
         YrlhO0GAJVL/DYrKYYH9/nETr/WJC9o+aKt3WkafclLOoe2WFikkO8hwqsssJMRNKEpN
         1y/sSU0ofG1nK2szlqCGcZ06+k4u5dPr3kawU=
Date: Fri, 28 Aug 2009 22:53:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux@dominikbrodowski.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: switch /proc/bus/pccard/drivers to seq_file
Message-ID: <20090828185322.GB14499@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/pcmcia/pcmcia_ioctl.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/drivers/pcmcia/pcmcia_ioctl.c
+++ b/drivers/pcmcia/pcmcia_ioctl.c
@@ -27,6 +27,7 @@
 #include <linux/proc_fs.h>
 #include <linux/poll.h>
 #include <linux/pci.h>
+#include <linux/seq_file.h>
 #include <linux/smp_lock.h>
 #include <linux/workqueue.h>
 
@@ -105,37 +106,40 @@ static struct pcmcia_driver *get_pcmcia_driver(dev_info_t *dev_info)
 #ifdef CONFIG_PROC_FS
 static struct proc_dir_entry *proc_pccard = NULL;
 
-static int proc_read_drivers_callback(struct device_driver *driver, void *d)
+static int proc_read_drivers_callback(struct device_driver *driver, void *_m)
 {
-	char **p = d;
+	struct seq_file *m = _m;
 	struct pcmcia_driver *p_drv = container_of(driver,
 						   struct pcmcia_driver, drv);
 
-	*p += sprintf(*p, "%-24.24s 1 %d\n", p_drv->drv.name,
+	seq_printf(m, "%-24.24s 1 %d\n", p_drv->drv.name,
 #ifdef CONFIG_MODULE_UNLOAD
 		      (p_drv->owner) ? module_refcount(p_drv->owner) : 1
 #else
 		      1
 #endif
 	);
-	d = (void *) p;
-
 	return 0;
 }
 
-static int proc_read_drivers(char *buf, char **start, off_t pos,
-			     int count, int *eof, void *data)
+static int pccard_drivers_proc_show(struct seq_file *m, void *v)
 {
-	char *p = buf;
-	int rc;
-
-	rc = bus_for_each_drv(&pcmcia_bus_type, NULL,
-			      (void *) &p, proc_read_drivers_callback);
-	if (rc < 0)
-		return rc;
+	return bus_for_each_drv(&pcmcia_bus_type, NULL,
+				m, proc_read_drivers_callback);
+}
 
-	return (p - buf);
+static int pccard_drivers_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pccard_drivers_proc_show, NULL);
 }
+
+static const struct file_operations pccard_drivers_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pccard_drivers_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 
@@ -1011,7 +1015,7 @@ void __init pcmcia_setup_ioctl(void) {
 #ifdef CONFIG_PROC_FS
 	proc_pccard = proc_mkdir("bus/pccard", NULL);
 	if (proc_pccard)
-		create_proc_read_entry("drivers",0,proc_pccard,proc_read_drivers,NULL);
+		proc_create("drivers", 0, proc_pccard, &pccard_drivers_proc_fops);
 #endif
 }
 
