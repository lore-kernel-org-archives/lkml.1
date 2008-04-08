Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYDHL0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYDHL0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYDHLTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45963 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbYDHLTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:30 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 24/29] net: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:31 +0400
Message-Id: <1207653576-12640-24-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Jeff Garzik <jgarzik@pobox.com>
---
 drivers/net/bonding/bond_main.c |    9 +---
 drivers/net/ibmveth.c           |    9 +---
 drivers/net/irda/vlsi_ir.c      |    5 +-
 drivers/net/pppoe.c             |    4 +-
 drivers/net/pppol2tp.c          |    4 +-
 drivers/net/wireless/airo.c     |   84 +++++++++++++++------------------------
 6 files changed, 43 insertions(+), 72 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ecfaf14..fb47448 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3284,17 +3284,14 @@ static int bond_create_proc_entry(struct bonding *bond)
 	struct net_device *bond_dev = bond->dev;
 
 	if (bond_proc_dir) {
-		bond->proc_entry = create_proc_entry(bond_dev->name,
-						     S_IRUGO,
-						     bond_proc_dir);
+		bond->proc_entry = proc_create_data(bond_dev->name,
+						    S_IRUGO, bond_proc_dir,
+						    &bond_info_fops, bond);
 		if (bond->proc_entry == NULL) {
 			printk(KERN_WARNING DRV_NAME
 			       ": Warning: Cannot create /proc/net/%s/%s\n",
 			       DRV_NAME, bond_dev->name);
 		} else {
-			bond->proc_entry->data = bond;
-			bond->proc_entry->proc_fops = &bond_info_fops;
-			bond->proc_entry->owner = THIS_MODULE;
 			memcpy(bond->proc_file_name, bond_dev->name, IFNAMSIZ);
 		}
 	}
diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index bb31e09..a99a3ae 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -1303,13 +1303,10 @@ static void ibmveth_proc_register_adapter(struct ibmveth_adapter *adapter)
 	if (ibmveth_proc_dir) {
 		char u_addr[10];
 		sprintf(u_addr, "%x", adapter->vdev->unit_address);
-		entry = create_proc_entry(u_addr, S_IFREG, ibmveth_proc_dir);
-		if (!entry) {
+		entry = proc_create_data(u_addr, S_IFREG, ibmveth_proc_dir,
+					 &ibmveth_proc_fops, adapter);
+		if (!entry)
 			ibmveth_error_printk("Cannot create adapter proc entry");
-		} else {
-			entry->data = (void *) adapter;
-			entry->proc_fops = &ibmveth_proc_fops;
-		}
 	}
 	return;
 }
diff --git a/drivers/net/irda/vlsi_ir.c b/drivers/net/irda/vlsi_ir.c
index acd082a..d15e00b 100644
--- a/drivers/net/irda/vlsi_ir.c
+++ b/drivers/net/irda/vlsi_ir.c
@@ -1674,13 +1674,12 @@ vlsi_irda_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (vlsi_proc_root != NULL) {
 		struct proc_dir_entry *ent;
 
-		ent = create_proc_entry(ndev->name, S_IFREG|S_IRUGO, vlsi_proc_root);
+		ent = proc_create_data(ndev->name, S_IFREG|S_IRUGO,
+				       vlsi_proc_root, VLSI_PROC_FOPS, ndev);
 		if (!ent) {
 			IRDA_WARNING("%s: failed to create proc entry\n",
 				     __FUNCTION__);
 		} else {
-			ent->data = ndev;
-			ent->proc_fops = VLSI_PROC_FOPS;
 			ent->size = 0;
 		}
 		idev->proc_entry = ent;
diff --git a/drivers/net/pppoe.c b/drivers/net/pppoe.c
index 4fad4dd..58a26a4 100644
--- a/drivers/net/pppoe.c
+++ b/drivers/net/pppoe.c
@@ -1052,11 +1052,9 @@ static int __init pppoe_proc_init(void)
 {
 	struct proc_dir_entry *p;
 
-	p = create_proc_entry("pppoe", S_IRUGO, init_net.proc_net);
+	p = proc_net_fops_create(&init_net, "pppoe", S_IRUGO, &pppoe_seq_fops);
 	if (!p)
 		return -ENOMEM;
-
-	p->proc_fops = &pppoe_seq_fops;
 	return 0;
 }
 #else /* CONFIG_PROC_FS */
diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
index 3d10ca0..244d783 100644
--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -2469,12 +2469,12 @@ static int __init pppol2tp_init(void)
 		goto out_unregister_pppol2tp_proto;
 
 #ifdef CONFIG_PROC_FS
-	pppol2tp_proc = create_proc_entry("pppol2tp", 0, init_net.proc_net);
+	pppol2tp_proc = proc_net_fops_create(&init_net, "pppol2tp", 0,
+					     &pppol2tp_proc_fops);
 	if (!pppol2tp_proc) {
 		err = -ENOMEM;
 		goto out_unregister_pppox_proto;
 	}
-	pppol2tp_proc->proc_fops = &pppol2tp_proc_fops;
 #endif /* CONFIG_PROC_FS */
 	printk(KERN_INFO "PPPoL2TP kernel driver, %s\n",
 	       PPPOL2TP_DRV_VERSION);
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 6c395fc..d263eee 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4347,24 +4347,28 @@ static int proc_config_open( struct inode *inode, struct file *file );
 static int proc_wepkey_open( struct inode *inode, struct file *file );
 
 static const struct file_operations proc_statsdelta_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.open		= proc_statsdelta_open,
 	.release	= proc_close
 };
 
 static const struct file_operations proc_stats_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.open		= proc_stats_open,
 	.release	= proc_close
 };
 
 static const struct file_operations proc_status_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.open		= proc_status_open,
 	.release	= proc_close
 };
 
 static const struct file_operations proc_SSID_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_SSID_open,
@@ -4372,6 +4376,7 @@ static const struct file_operations proc_SSID_ops = {
 };
 
 static const struct file_operations proc_BSSList_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_BSSList_open,
@@ -4379,6 +4384,7 @@ static const struct file_operations proc_BSSList_ops = {
 };
 
 static const struct file_operations proc_APList_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_APList_open,
@@ -4386,6 +4392,7 @@ static const struct file_operations proc_APList_ops = {
 };
 
 static const struct file_operations proc_config_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_config_open,
@@ -4393,6 +4400,7 @@ static const struct file_operations proc_config_ops = {
 };
 
 static const struct file_operations proc_wepkey_ops = {
+	.owner		= THIS_MODULE,
 	.read		= proc_read,
 	.write		= proc_write,
 	.open		= proc_wepkey_open,
@@ -4411,10 +4419,6 @@ struct proc_data {
 	void (*on_close) (struct inode *, struct file *);
 };
 
-#ifndef SETPROC_OPS
-#define SETPROC_OPS(entry, ops) (entry)->proc_fops = &(ops)
-#endif
-
 static int setup_proc_entry( struct net_device *dev,
 			     struct airo_info *apriv ) {
 	struct proc_dir_entry *entry;
@@ -4430,100 +4434,76 @@ static int setup_proc_entry( struct net_device *dev,
 	apriv->proc_entry->owner = THIS_MODULE;
 
 	/* Setup the StatsDelta */
-	entry = create_proc_entry("StatsDelta",
-				  S_IFREG | (S_IRUGO&proc_perm),
-				  apriv->proc_entry);
+	entry = proc_create_data("StatsDelta",
+				 S_IFREG | (S_IRUGO&proc_perm),
+				 apriv->proc_entry, &proc_statsdelta_ops, dev);
 	if (!entry)
 		goto fail_stats_delta;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_statsdelta_ops);
 
 	/* Setup the Stats */
-	entry = create_proc_entry("Stats",
-				  S_IFREG | (S_IRUGO&proc_perm),
-				  apriv->proc_entry);
+	entry = proc_create_data("Stats",
+				 S_IFREG | (S_IRUGO&proc_perm),
+				 apriv->proc_entry, &proc_stats_ops, dev);
 	if (!entry)
 		goto fail_stats;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_stats_ops);
 
 	/* Setup the Status */
-	entry = create_proc_entry("Status",
-				  S_IFREG | (S_IRUGO&proc_perm),
-				  apriv->proc_entry);
+	entry = proc_create_data("Status",
+				 S_IFREG | (S_IRUGO&proc_perm),
+				 apriv->proc_entry, &proc_status_ops, dev);
 	if (!entry)
 		goto fail_status;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_status_ops);
 
 	/* Setup the Config */
-	entry = create_proc_entry("Config",
-				  S_IFREG | proc_perm,
-				  apriv->proc_entry);
+	entry = proc_create_data("Config",
+				 S_IFREG | proc_perm,
+				 apriv->proc_entry, &proc_config_ops, dev);
 	if (!entry)
 		goto fail_config;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_config_ops);
 
 	/* Setup the SSID */
-	entry = create_proc_entry("SSID",
-				  S_IFREG | proc_perm,
-				  apriv->proc_entry);
+	entry = proc_create_data("SSID",
+				 S_IFREG | proc_perm,
+				 apriv->proc_entry, &proc_SSID_ops, dev);
 	if (!entry)
 		goto fail_ssid;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_SSID_ops);
 
 	/* Setup the APList */
-	entry = create_proc_entry("APList",
-				  S_IFREG | proc_perm,
-				  apriv->proc_entry);
+	entry = proc_create_data("APList",
+				 S_IFREG | proc_perm,
+				 apriv->proc_entry, &proc_APList_ops, dev);
 	if (!entry)
 		goto fail_aplist;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_APList_ops);
 
 	/* Setup the BSSList */
-	entry = create_proc_entry("BSSList",
-				  S_IFREG | proc_perm,
-				  apriv->proc_entry);
+	entry = proc_create_data("BSSList",
+				 S_IFREG | proc_perm,
+				 apriv->proc_entry, &proc_BSSList_ops, dev);
 	if (!entry)
 		goto fail_bsslist;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_BSSList_ops);
 
 	/* Setup the WepKey */
-	entry = create_proc_entry("WepKey",
-				  S_IFREG | proc_perm,
-				  apriv->proc_entry);
+	entry = proc_create_data("WepKey",
+				 S_IFREG | proc_perm,
+				 apriv->proc_entry, &proc_wepkey_ops, dev);
 	if (!entry)
 		goto fail_wepkey;
 	entry->uid = proc_uid;
 	entry->gid = proc_gid;
-	entry->data = dev;
-	entry->owner = THIS_MODULE;
-	SETPROC_OPS(entry, proc_wepkey_ops);
 
 	return 0;
 
-- 
1.5.3.rc5

