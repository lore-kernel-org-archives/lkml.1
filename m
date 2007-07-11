Return-Path: <linux-kernel-owner+w=401wt.eu-S932654AbXGKSkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbXGKSkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759171AbXGKSjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:39:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:18906 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbXGKSju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=a0KL2rs02Y/JGgrOl4HT1vwwvz5Oe/o26GcpHyrqCtwH6mReck73ybbdrigL+bLYj0doBn2hL4K8xojZVatcWPI2IRebagBjgHYPE9QyUn+YLIImfYnH9mV/tb+Y0tytUEJDmLnbIZWzLoa/4dkZn68UHltNG6xE0YMibRao2Rg=
Date: Wed, 11 Jul 2007 22:39:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] Sky Cpu and Nexus: use seq_file/single_open on proc
	interface
Message-ID: <20070711183941.GB7157@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes proc interface to be used with
single_file/seq_open calls.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |   67 +++++++++++++++++----------------
 drivers/misc/hdpuftrs/hdpu_nexus.c    |   52 +++++++++++++++++++------
 2 files changed, 74 insertions(+), 45 deletions(-)

diff --git a/drivers/misc/hdpuftrs/hdpu_cpustate.c b/drivers/misc/hdpuftrs/hdpu_cpustate.c
index 427e357..c0d9577 100644
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c
+++ b/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -19,9 +19,10 @@
 #include <linux/spinlock.h>
 #include <linux/miscdevice.h>
 #include <linux/proc_fs.h>
+#include <linux/hdpu_features.h>
 #include <linux/platform_device.h>
 #include <asm/uaccess.h>
-#include <linux/hdpu_features.h>
+#include <linux/seq_file.h>
 #include <asm/io.h>
 
 #define SKY_CPUSTATE_VERSION		"1.1"
@@ -29,7 +30,30 @@
 static int hdpu_cpustate_probe(struct platform_device *pdev);
 static int hdpu_cpustate_remove(struct platform_device *pdev);
 
-struct cpustate_t cpustate;
+static unsigned char cpustate_get_state(void);
+static int cpustate_proc_open(struct inode *inode, struct file *file);
+static int cpustate_proc_read(struct seq_file *seq, void *offset);
+
+static struct cpustate_t cpustate;
+
+static const struct file_operations proc_cpustate = {
+	.open = cpustate_proc_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static int cpustate_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cpustate_proc_read, NULL);
+}
+
+static int cpustate_proc_read(struct seq_file *seq, void *offset)
+{
+	seq_printf(seq, "CPU State: %04x\n", cpustate_get_state());
+	return 0;
+}
 
 static int cpustate_get_ref(int excl)
 {
@@ -65,12 +89,12 @@ static int cpustate_free_ref(void)
 	return 0;
 }
 
-unsigned char cpustate_get_state(void)
+static unsigned char cpustate_get_state(void)
 {
 	return cpustate.cached_val;
 }
 
-void cpustate_set_state(unsigned char new_state)
+static void cpustate_set_state(unsigned char new_state)
 {
 	unsigned int state = (new_state << 21);
 
@@ -135,30 +159,6 @@ static int cpustate_release(struct inode *inode, struct file *file)
 	return cpustate_free_ref();
 }
 
-/*
- *	Info exported via "/proc/sky_cpustate".
- */
-static int cpustate_read_proc(char *page, char **start, off_t off,
-			      int count, int *eof, void *data)
-{
-	char *p = page;
-	int len = 0;
-
-	p += sprintf(p, "CPU State: %04x\n", cpustate_get_state());
-	len = p - page;
-
-	if (len <= off + count)
-		*eof = 1;
-	*start = page + off;
-	len -= off;
-	if (len > count)
-		len = count;
-	if (len < 0)
-		len = 0;
-
-	return len;
-}
-
 static struct platform_driver hdpu_cpustate_driver = {
 	.probe = hdpu_cpustate_probe,
 	.remove = hdpu_cpustate_remove,
@@ -209,11 +209,14 @@ static int hdpu_cpustate_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	proc_de = create_proc_read_entry("sky_cpustate", 0, 0,
-					 cpustate_read_proc, NULL);
-	if (proc_de == NULL)
+	proc_de = create_proc_entry("sky_cpustate", 0666, &proc_root);
+	if (!proc_de) {
 		printk(KERN_WARNING "sky_cpustate: "
-		       "Unable to create proc dir entry\n");
+		       "Unable to create proc entry\n");
+	} else {
+		proc_de->proc_fops = &proc_cpustate;
+		proc_de->owner = THIS_MODULE;
+	}
 
 	printk(KERN_INFO "Sky CPU State Driver v" SKY_CPUSTATE_VERSION "\n");
 	return 0;
diff --git a/drivers/misc/hdpuftrs/hdpu_nexus.c b/drivers/misc/hdpuftrs/hdpu_nexus.c
index cc81853..2887b21 100644
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c
+++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -18,18 +18,38 @@
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
 #include <linux/hdpu_features.h>
-
 #include <linux/platform_device.h>
+#include <linux/seq_file.h>
 #include <asm/io.h>
 
 static int hdpu_nexus_probe(struct platform_device *pdev);
 static int hdpu_nexus_remove(struct platform_device *pdev);
+static int hdpu_slot_id_open(struct inode *inode, struct file *file);
+static int hdpu_slot_id_read(struct seq_file *seq, void *offset);
+static int hdpu_chassis_id_open(struct inode *inode, struct file *file);
+static int hdpu_chassis_id_read(struct seq_file *seq, void *offset);
 
 static struct proc_dir_entry *hdpu_slot_id;
 static struct proc_dir_entry *hdpu_chassis_id;
 static int slot_id = -1;
 static int chassis_id = -1;
 
+static const struct file_operations proc_slot_id = {
+	.open = hdpu_slot_id_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations proc_chassis_id = {
+	.open = hdpu_chassis_id_open,
+	.read = seq_read,
+	.llseek	= seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static struct platform_driver hdpu_nexus_driver = {
 	.probe = hdpu_nexus_probe,
 	.remove = hdpu_nexus_remove,
@@ -38,22 +58,26 @@ static struct platform_driver hdpu_nexus_driver = {
 	},
 };
 
-int hdpu_slot_id_read(char *buffer, char **buffer_location, off_t offset,
-		      int buffer_length, int *zero, void *ptr)
+static int hdpu_slot_id_open(struct inode *inode, struct file *file)
 {
-	if (offset > 0)
-		return 0;
+	return single_open(file, hdpu_slot_id_read, NULL);
+}
 
-	return sprintf(buffer, "%d\n", slot_id);
+static int hdpu_slot_id_read(struct seq_file *seq, void *offset)
+{
+	seq_printf(seq, "%d\n", slot_id);
+	return 0;
 }
 
-int hdpu_chassis_id_read(char *buffer, char **buffer_location, off_t offset,
-			 int buffer_length, int *zero, void *ptr)
+static int hdpu_chassis_id_open(struct inode *inode, struct file *file)
 {
-	if (offset > 0)
-		return 0;
+	return single_open(file, hdpu_chassis_id_read, NULL);
+}
 
-	return sprintf(buffer, "%d\n", chassis_id);
+static int hdpu_chassis_id_read(struct seq_file *seq, void *offset)
+{
+	seq_printf(seq, "%d\n", chassis_id);
+	return 0;
 }
 
 static int hdpu_nexus_probe(struct platform_device *pdev)
@@ -82,7 +106,8 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_slot_id\n");
 	} else {
-		hdpu_slot_id->read_proc = hdpu_slot_id_read;
+		hdpu_slot_id->proc_fops = &proc_slot_id;
+		hdpu_slot_id->owner = THIS_MODULE;
 	}
 
 	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, &proc_root);
@@ -90,7 +115,8 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_chassis_id\n");
 	} else {
-		hdpu_chassis_id->read_proc = hdpu_chassis_id_read;
+		hdpu_chassis_id->proc_fops = &proc_chassis_id;
+		hdpu_chassis_id->owner = THIS_MODULE;
 	}
 
 	return 0;
