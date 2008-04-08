Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbYDHLZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbYDHLZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbYDHLTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:33 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3039 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbYDHLTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:30 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 29/29] drivers: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:36 +0400
Message-Id: <1207653576-12640-29-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/pktcdvd.c               |    7 +------
 drivers/cdrom/viocd.c                 |   10 +++-------
 drivers/ide/ide-proc.c                |    7 ++-----
 drivers/input/input.c                 |   12 ++++--------
 drivers/md/md.c                       |    6 +-----
 drivers/media/video/zoran_procfs.c    |    7 +++----
 drivers/message/i2o/i2o_proc.c        |    6 ++----
 drivers/misc/hdpuftrs/hdpu_cpustate.c |    5 +----
 drivers/misc/hdpuftrs/hdpu_nexus.c    |   13 ++++---------
 drivers/pci/proc.c                    |   13 ++++++-------
 drivers/pnp/isapnp/proc.c             |    7 +++----
 drivers/rapidio/rio.c                 |    6 +-----
 drivers/rtc/rtc-proc.c                |    8 +++-----
 13 files changed, 34 insertions(+), 73 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 0431e59..fd04729 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2744,7 +2744,6 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	int i;
 	int ret = 0;
 	char b[BDEVNAME_SIZE];
-	struct proc_dir_entry *proc;
 	struct block_device *bdev;
 
 	if (pd->pkt_dev == dev) {
@@ -2788,11 +2787,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 		goto out_mem;
 	}
 
-	proc = create_proc_entry(pd->name, 0, pkt_proc);
-	if (proc) {
-		proc->data = pd;
-		proc->proc_fops = &pkt_proc_fops;
-	}
+	proc_create_data(pd->name, 0, pkt_proc, &pkt_proc_fops, pd);
 	DPRINTK(DRIVER_NAME": writer %s mapped to %s\n", pd->name, bdevname(bdev, b));
 	return 0;
 
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index b74b6c2..5245a4a 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -144,6 +144,7 @@ static int proc_viocd_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations proc_viocd_operations = {
+	.owner		= THIS_MODULE,
 	.open		= proc_viocd_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -679,7 +680,6 @@ static struct vio_driver viocd_driver = {
 
 static int __init viocd_init(void)
 {
-	struct proc_dir_entry *e;
 	int ret = 0;
 
 	if (!firmware_has_feature(FW_FEATURE_ISERIES))
@@ -719,12 +719,8 @@ static int __init viocd_init(void)
 	if (ret)
 		goto out_free_info;
 
-	e = create_proc_entry("iSeries/viocd", S_IFREG|S_IRUGO, NULL);
-	if (e) {
-		e->owner = THIS_MODULE;
-		e->proc_fops = &proc_viocd_operations;
-	}
-
+	proc_create("iSeries/viocd", S_IFREG|S_IRUGO, NULL,
+		    &proc_viocd_operations);
 	return 0;
 
 out_free_info:
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index d9d98ac..5db5da1 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -830,6 +830,7 @@ static int ide_drivers_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ide_drivers_operations = {
+	.owner		= THIS_MODULE,
 	.open		= ide_drivers_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -838,16 +839,12 @@ static const struct file_operations ide_drivers_operations = {
 
 void proc_ide_create(void)
 {
-	struct proc_dir_entry *entry;
-
 	proc_ide_root = proc_mkdir("ide", NULL);
 
 	if (!proc_ide_root)
 		return;
 
-	entry = create_proc_entry("drivers", 0, proc_ide_root);
-	if (entry)
-		entry->proc_fops = &ide_drivers_operations;
+	proc_create("drivers", 0, proc_ide_root, &ide_drivers_operations);
 }
 
 void proc_ide_destroy(void)
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 1142660..27006fc 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -904,20 +904,16 @@ static int __init input_proc_init(void)
 
 	proc_bus_input_dir->owner = THIS_MODULE;
 
-	entry = create_proc_entry("devices", 0, proc_bus_input_dir);
+	entry = proc_create("devices", 0, proc_bus_input_dir,
+			    &input_devices_fileops);
 	if (!entry)
 		goto fail1;
 
-	entry->owner = THIS_MODULE;
-	entry->proc_fops = &input_devices_fileops;
-
-	entry = create_proc_entry("handlers", 0, proc_bus_input_dir);
+	entry = proc_create("handlers", 0, proc_bus_input_dir,
+			    &input_handlers_fileops);
 	if (!entry)
 		goto fail2;
 
-	entry->owner = THIS_MODULE;
-	entry->proc_fops = &input_handlers_fileops;
-
 	return 0;
 
  fail2:	remove_proc_entry("devices", proc_bus_input_dir);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f7ff94..1d4a396 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5947,13 +5947,9 @@ static struct notifier_block md_notifier = {
 
 static void md_geninit(void)
 {
-	struct proc_dir_entry *p;
-
 	dprintk("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
 
-	p = create_proc_entry("mdstat", S_IRUGO, NULL);
-	if (p)
-		p->proc_fops = &md_seq_fops;
+	proc_create("mdstat", S_IRUGO, NULL, &md_seq_fops);
 }
 
 static int __init md_init(void)
diff --git a/drivers/media/video/zoran_procfs.c b/drivers/media/video/zoran_procfs.c
index 328ed6e..870bc5a 100644
--- a/drivers/media/video/zoran_procfs.c
+++ b/drivers/media/video/zoran_procfs.c
@@ -180,6 +180,7 @@ static ssize_t zoran_write(struct file *file, const char __user *buffer,
 }
 
 static const struct file_operations zoran_operations = {
+	.owner		= THIS_MODULE,
 	.open		= zoran_open,
 	.read		= seq_read,
 	.write		= zoran_write,
@@ -195,10 +196,8 @@ zoran_proc_init (struct zoran *zr)
 	char name[8];
 
 	snprintf(name, 7, "zoran%d", zr->id);
-	if ((zr->zoran_proc = create_proc_entry(name, 0, NULL))) {
-		zr->zoran_proc->data = zr;
-		zr->zoran_proc->owner = THIS_MODULE;
-		zr->zoran_proc->proc_fops = &zoran_operations;
+	zr->zoran_proc = proc_create_data(name, 0, NULL, &zoran_operations, zr);
+	if (zr->zoran_proc != NULL) {
 		dprintk(2,
 			KERN_INFO
 			"%s: procfs entry /proc/%s allocated. data=%p\n",
diff --git a/drivers/message/i2o/i2o_proc.c b/drivers/message/i2o/i2o_proc.c
index 6fdd072..54a3016 100644
--- a/drivers/message/i2o/i2o_proc.c
+++ b/drivers/message/i2o/i2o_proc.c
@@ -1893,13 +1893,11 @@ static int i2o_proc_create_entries(struct proc_dir_entry *dir,
 	struct proc_dir_entry *tmp;
 
 	while (i2o_pe->name) {
-		tmp = create_proc_entry(i2o_pe->name, i2o_pe->mode, dir);
+		tmp = proc_create_data(i2o_pe->name, i2o_pe->mode, dir,
+				       i2o_pe->fops, data);
 		if (!tmp)
 			return -1;
 
-		tmp->data = data;
-		tmp->proc_fops = i2o_pe->fops;
-
 		i2o_pe++;
 	}
 
diff --git a/drivers/misc/hdpuftrs/hdpu_cpustate.c b/drivers/misc/hdpuftrs/hdpu_cpustate.c
index 4ff3512..8a3b222 100644
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c
+++ b/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -209,13 +209,10 @@ static int hdpu_cpustate_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	proc_de = create_proc_entry("sky_cpustate", 0666, NULL);
+	proc_de = proc_create("sky_cpustate", 0666, NULL, &proc_cpustate);
 	if (!proc_de) {
 		printk(KERN_WARNING "sky_cpustate: "
 		       "Unable to create proc entry\n");
-	} else {
-		proc_de->proc_fops = &proc_cpustate;
-		proc_de->owner = THIS_MODULE;
 	}
 
 	printk(KERN_INFO "Sky CPU State Driver v" SKY_CPUSTATE_VERSION "\n");
diff --git a/drivers/misc/hdpuftrs/hdpu_nexus.c b/drivers/misc/hdpuftrs/hdpu_nexus.c
index 4137022..40f1b20 100644
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c
+++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -101,22 +101,17 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 		printk(KERN_ERR "sky_nexus: Could not map slot id\n");
 	}
 
-	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, NULL);
-	if (!hdpu_slot_id)
+	hdpu_slot_id = proc_create("sky_slot_id", 0666, NULL, &proc_slot_id);
+	if (!hdpu_slot_id) {
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_slot_id\n");
-	} else {
-		hdpu_slot_id->proc_fops = &proc_slot_id;
-		hdpu_slot_id->owner = THIS_MODULE;
 	}
 
-	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, NULL);
+	hdpu_chassis_id = proc_create("sky_chassis_id", 0666, NULL,
+				      &proc_chassis_id);
 	if (!hdpu_chassis_id)
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_chassis_id\n");
-	} else {
-		hdpu_chassis_id->proc_fops = &proc_chassis_id;
-		hdpu_chassis_id->owner = THIS_MODULE;
 	}
 
 	return 0;
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 7b5e45b..963a976 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -293,6 +293,7 @@ static int proc_bus_pci_release(struct inode *inode, struct file *file)
 #endif /* HAVE_PCI_MMAP */
 
 static const struct file_operations proc_bus_pci_operations = {
+	.owner		= THIS_MODULE,
 	.llseek		= proc_bus_pci_lseek,
 	.read		= proc_bus_pci_read,
 	.write		= proc_bus_pci_write,
@@ -406,11 +407,10 @@ int pci_proc_attach_device(struct pci_dev *dev)
 	}
 
 	sprintf(name, "%02x.%x", PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
-	e = create_proc_entry(name, S_IFREG | S_IRUGO | S_IWUSR, bus->procdir);
+	e = proc_create_data(name, S_IFREG | S_IRUGO | S_IWUSR, bus->procdir,
+			     &proc_bus_pci_operations, dev);
 	if (!e)
 		return -ENOMEM;
-	e->proc_fops = &proc_bus_pci_operations;
-	e->data = dev;
 	e->size = dev->cfg_size;
 	dev->procent = e;
 
@@ -462,6 +462,7 @@ static int proc_bus_pci_dev_open(struct inode *inode, struct file *file)
 	return seq_open(file, &proc_bus_pci_devices_op);
 }
 static const struct file_operations proc_bus_pci_dev_operations = {
+	.owner		= THIS_MODULE,
 	.open		= proc_bus_pci_dev_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -470,12 +471,10 @@ static const struct file_operations proc_bus_pci_dev_operations = {
 
 static int __init pci_proc_init(void)
 {
-	struct proc_dir_entry *entry;
 	struct pci_dev *dev = NULL;
 	proc_bus_pci_dir = proc_mkdir("bus/pci", NULL);
-	entry = create_proc_entry("devices", 0, proc_bus_pci_dir);
-	if (entry)
-		entry->proc_fops = &proc_bus_pci_dev_operations;
+	proc_create("devices", 0, proc_bus_pci_dir,
+		    &proc_bus_pci_dev_operations);
 	proc_initialized = 1;
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		pci_proc_attach_device(dev);
diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
index e1d1f2a..3f94eda 100644
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -85,6 +85,7 @@ static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
 }
 
 static const struct file_operations isapnp_proc_bus_file_operations = {
+	.owner	= THIS_MODULE,
 	.llseek = isapnp_proc_bus_lseek,
 	.read = isapnp_proc_bus_read,
 };
@@ -102,12 +103,10 @@ static int isapnp_proc_attach_device(struct pnp_dev *dev)
 			return -ENOMEM;
 	}
 	sprintf(name, "%02x", dev->number);
-	e = dev->procent = create_proc_entry(name, S_IFREG | S_IRUGO, de);
+	e = dev->procent = proc_create_data(name, S_IFREG | S_IRUGO, de,
+			&isapnp_proc_bus_file_operations, dev);
 	if (!e)
 		return -ENOMEM;
-	e->proc_fops = &isapnp_proc_bus_file_operations;
-	e->owner = THIS_MODULE;
-	e->data = dev;
 	e->size = 256;
 	return 0;
 }
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 9bae341..e048ef6 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -984,11 +984,7 @@ static const struct file_operations proc_riores_operations = {
 
 static int __init rioresources_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("riores", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_riores_operations;
+	proc_create("riores", 0, NULL, &proc_riores_operations);
 	return 0;
 }
 __initcall(rioresources_init);
diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index 8d300e6..0c6257a 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -108,12 +108,10 @@ void rtc_proc_add_device(struct rtc_device *rtc)
 	if (rtc->id == 0) {
 		struct proc_dir_entry *ent;
 
-		ent = create_proc_entry("driver/rtc", 0, NULL);
-		if (ent) {
-			ent->proc_fops = &rtc_proc_fops;
+		ent = proc_create_data("driver/rtc", 0, NULL,
+				       &rtc_proc_fops, rtc);
+		if (ent)
 			ent->owner = rtc->owner;
-			ent->data = rtc;
-		}
 	}
 }
 
-- 
1.5.3.rc5

