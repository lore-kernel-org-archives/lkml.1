Return-Path: <linux-kernel-owner+w=401wt.eu-S1764856AbYAYIJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764856AbYAYIJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763858AbYAYIAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:59399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761532AbYAYH7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 172/196] Kobject: convert drivers/* from kobject_unregister() to kobject_put()
Date: Thu, 24 Jan 2008 23:33:21 -0800
Message-Id: <1201246425-5058-93-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for kobject_unregister() anymore, thanks to Kay's
kobject cleanup changes, so replace all instances of it with
kobject_put().


Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c                     |    4 ++--
 drivers/base/sys.c                     |    2 +-
 drivers/block/pktcdvd.c                |    2 +-
 drivers/cpufreq/cpufreq.c              |    4 +---
 drivers/cpuidle/sysfs.c                |    4 ++--
 drivers/edac/edac_device_sysfs.c       |   10 +++++-----
 drivers/edac/edac_mc_sysfs.c           |   12 ++++++------
 drivers/edac/edac_pci_sysfs.c          |    6 +++---
 drivers/firmware/edd.c                 |    2 +-
 drivers/firmware/efivars.c             |    6 +++---
 drivers/infiniband/core/sysfs.c        |    6 +++---
 drivers/md/md.c                        |    2 +-
 drivers/net/ibmveth.c                  |    2 +-
 drivers/parisc/pdc_stable.c            |    6 +++---
 drivers/pci/hotplug/pci_hotplug_core.c |    2 +-
 drivers/pci/hotplug/rpadlpar_sysfs.c   |    4 ++--
 drivers/uio/uio.c                      |    8 ++++----
 17 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index aea5793..a377b65 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -681,7 +681,7 @@ int bus_add_driver(struct device_driver *drv)
 	kobject_uevent(&priv->kobj, KOBJ_ADD);
 	return error;
 out_unregister:
-	kobject_unregister(&priv->kobj);
+	kobject_put(&priv->kobj);
 out_put_bus:
 	bus_put(bus);
 	return error;
@@ -708,7 +708,7 @@ void bus_remove_driver(struct device_driver * drv)
 	pr_debug("bus: '%s': remove driver %s\n", drv->bus->name, drv->name);
 	driver_detach(drv);
 	module_remove_driver(drv);
-	kobject_unregister(&drv->p->kobj);
+	kobject_put(&drv->p->kobj);
 	bus_put(drv->bus);
 }
 
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 47fc6eb..e666441 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -264,7 +264,7 @@ void sysdev_unregister(struct sys_device * sysdev)
 	}
 	mutex_unlock(&sysdev_drivers_lock);
 
-	kobject_unregister(&sysdev->kobj);
+	kobject_put(&sysdev->kobj);
 }
 
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index d1ee383..e9de171 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -130,7 +130,7 @@ static struct pktcdvd_kobj* pkt_kobj_create(struct pktcdvd_device *pd,
 static void pkt_kobj_remove(struct pktcdvd_kobj *p)
 {
 	if (p)
-		kobject_unregister(&p->kobj);
+		kobject_put(&p->kobj);
 }
 /*
  * default release function for pktcdvd kernel objects.
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9e102af..5efd555 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -913,7 +913,7 @@ err_out_unregister:
 		cpufreq_cpu_data[j] = NULL;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	kobject_unregister(&policy->kobj);
+	kobject_put(&policy->kobj);
 	wait_for_completion(&policy->kobj_unregister);
 
 err_out_driver_exit:
@@ -1030,8 +1030,6 @@ static int __cpufreq_remove_dev (struct sys_device * sys_dev)
 
 	unlock_policy_rwsem_write(cpu);
 
-	kobject_unregister(&data->kobj);
-
 	kobject_put(&data->kobj);
 
 	/* we need to make sure that the underlying kobj is actually
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 059db9c..088ea74 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -277,7 +277,7 @@ static struct kobj_type ktype_state_cpuidle = {
 
 static void inline cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
 {
-	kobject_unregister(&device->kobjs[i]->kobj);
+	kobject_put(&device->kobjs[i]->kobj);
 	wait_for_completion(&device->kobjs[i]->kobj_unregister);
 	kfree(device->kobjs[i]);
 	device->kobjs[i] = NULL;
@@ -358,5 +358,5 @@ void cpuidle_remove_sysfs(struct sys_device *sysdev)
 	struct cpuidle_device *dev;
 
 	dev = per_cpu(cpuidle_devices, cpu);
-	kobject_unregister(&dev->kobj);
+	kobject_put(&dev->kobj);
 }
diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index 10e5b19..5376457 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -303,7 +303,7 @@ void edac_device_unregister_sysfs_main_kobj(
 	 *   a) module_put() this module
 	 *   b) 'kfree' the memory
 	 */
-	kobject_unregister(&edac_dev->kobj);
+	kobject_put(&edac_dev->kobj);
 }
 
 /* edac_dev -> instance information */
@@ -574,7 +574,7 @@ static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 
 	/* Error unwind stack */
 err_on_attrib:
-	kobject_unregister(&block->kobj);
+	kobject_put(&block->kobj);
 
 err_out:
 	return err;
@@ -605,7 +605,7 @@ static void edac_device_delete_block(struct edac_device_ctl_info *edac_dev,
 	/* unregister this block's kobject, SEE:
 	 *	edac_device_ctrl_block_release() callback operation
 	 */
-	kobject_unregister(&block->kobj);
+	kobject_put(&block->kobj);
 }
 
 /* instance ctor/dtor code */
@@ -672,7 +672,7 @@ static int edac_device_create_instance(struct edac_device_ctl_info *edac_dev,
 
 	/* error unwind stack */
 err_release_instance_kobj:
-	kobject_unregister(&instance->kobj);
+	kobject_put(&instance->kobj);
 
 err_out:
 	return err;
@@ -697,7 +697,7 @@ static void edac_device_delete_instance(struct edac_device_ctl_info *edac_dev,
 	/* unregister this instance's kobject, SEE:
 	 *	edac_device_ctrl_instance_release() for callback operation
 	 */
-	kobject_unregister(&instance->kobj);
+	kobject_put(&instance->kobj);
 }
 
 /*
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 45b1d36..9aac880 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -395,7 +395,7 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 		goto err_release_top_kobj;
 
 	/* At this point, to release a csrow kobj, one must
-	 * call the kobject_unregister and allow that tear down
+	 * call the kobject_put and allow that tear down
 	 * to work the releasing
 	 */
 
@@ -406,7 +406,7 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 		err = edac_create_channel_files(&csrow->kobj, chan);
 		if (err) {
 			/* special case the unregister here */
-			kobject_unregister(&csrow->kobj);
+			kobject_put(&csrow->kobj);
 			goto err_out;
 		}
 	}
@@ -808,7 +808,7 @@ fail_out:
 void edac_mc_unregister_sysfs_main_kobj(struct mem_ctl_info *mci)
 {
 	/* delete the kobj from the mc_kset */
-	kobject_unregister(&mci->edac_mci_kobj);
+	kobject_put(&mci->edac_mci_kobj);
 }
 
 #define EDAC_DEVICE_SYMLINK	"device"
@@ -923,7 +923,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 fail1:
 	for (i--; i >= 0; i--) {
 		if (csrow->nr_pages > 0) {
-			kobject_unregister(&mci->csrows[i].kobj);
+			kobject_put(&mci->csrows[i].kobj);
 		}
 	}
 
@@ -950,7 +950,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 	for (i = 0; i < mci->nr_csrows; i++) {
 		if (mci->csrows[i].nr_pages > 0) {
 			debugf0("%s()  unreg csrow-%d\n", __func__, i);
-			kobject_unregister(&mci->csrows[i].kobj);
+			kobject_put(&mci->csrows[i].kobj);
 		}
 	}
 
@@ -967,7 +967,7 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 	debugf0("%s()  unregister this mci kobj\n", __func__);
 
 	/* unregister this instance's kobject */
-	kobject_unregister(&mci->edac_mci_kobj);
+	kobject_put(&mci->edac_mci_kobj);
 }
 
 
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 834eaa9..5b075da 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -205,7 +205,7 @@ void edac_pci_unregister_sysfs_instance_kobj(struct edac_pci_ctl_info *pci)
 	 * function release the main reference count and then
 	 * kfree the memory
 	 */
-	kobject_unregister(&pci->kobj);
+	kobject_put(&pci->kobj);
 }
 
 /***************************** EDAC PCI sysfs root **********************/
@@ -411,9 +411,9 @@ static void edac_pci_main_kobj_teardown(void)
 	 * main kobj
 	 */
 	if (atomic_dec_return(&edac_pci_sysfs_refcount) == 0) {
-		debugf0("%s() called kobject_unregister on main kobj\n",
+		debugf0("%s() called kobject_put on main kobj\n",
 			__func__);
-		kobject_unregister(&edac_pci_top_main_kobj);
+		kobject_put(&edac_pci_top_main_kobj);
 	}
 }
 
diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index dc0b87b..d168223 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -693,7 +693,7 @@ edd_create_symlink_to_pcidev(struct edd_device *edev)
 static inline void
 edd_device_unregister(struct edd_device *edev)
 {
-	kobject_unregister(&edev->kobj);
+	kobject_put(&edev->kobj);
 }
 
 static void edd_populate_dir(struct edd_device * edev)
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index b61a72f..f4f709d 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -397,7 +397,7 @@ static struct kobj_type efivar_ktype = {
 static inline void
 efivar_unregister(struct efivar_entry *var)
 {
-	kobject_unregister(&var->kobj);
+	kobject_put(&var->kobj);
 }
 
 
@@ -732,7 +732,7 @@ efivars_init(void)
 	kset_unregister(vars_kset);
 
 out_firmware_unregister:
-	kobject_unregister(efi_kobj);
+	kobject_put(efi_kobj);
 
 out_free:
 	kfree(variable_name);
@@ -753,7 +753,7 @@ efivars_exit(void)
 	}
 
 	kset_unregister(vars_kset);
-	kobject_unregister(efi_kobj);
+	kobject_put(efi_kobj);
 }
 
 module_init(efivars_init);
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index aa81129..c864ef7 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -714,7 +714,7 @@ err_put:
 			sysfs_remove_group(p, &pma_group);
 			sysfs_remove_group(p, &port->pkey_group);
 			sysfs_remove_group(p, &port->gid_group);
-			kobject_unregister(p);
+			kobject_put(p);
 		}
 	}
 
@@ -738,10 +738,10 @@ void ib_device_unregister_sysfs(struct ib_device *device)
 		sysfs_remove_group(p, &pma_group);
 		sysfs_remove_group(p, &port->pkey_group);
 		sysfs_remove_group(p, &port->gid_group);
-		kobject_unregister(p);
+		kobject_put(p);
 	}
 
-	kobject_unregister(device->ports_parent);
+	kobject_put(device->ports_parent);
 	class_device_unregister(&device->class_dev);
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ae800ba..c28a120 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -231,7 +231,7 @@ static void mddev_put(mddev_t *mddev)
 		list_del(&mddev->all_mddevs);
 		spin_unlock(&all_mddevs_lock);
 		blk_cleanup_queue(mddev->queue);
-		kobject_unregister(&mddev->kobj);
+		kobject_put(&mddev->kobj);
 	} else
 		spin_unlock(&all_mddevs_lock);
 }
diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index bee3037..57772be 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -1236,7 +1236,7 @@ static int __devexit ibmveth_remove(struct vio_dev *dev)
 	int i;
 
 	for(i = 0; i<IbmVethNumBufferPools; i++)
-		kobject_unregister(&adapter->rx_buff_pool[i].kobj);
+		kobject_put(&adapter->rx_buff_pool[i].kobj);
 
 	unregister_netdev(netdev);
 
diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index 87bc6b7..de34aa9 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -1026,7 +1026,7 @@ pdcs_unregister_pathentries(void)
 	for (i = 0; (entry = pdcspath_entries[i]); i++) {
 		read_lock(&entry->rw_lock);
 		if (entry->ready >= 2)
-			kobject_unregister(&entry->kobj);
+			kobject_put(&entry->kobj);
 		read_unlock(&entry->rw_lock);
 	}
 }
@@ -1086,7 +1086,7 @@ fail_pdcsreg:
 	kset_unregister(paths_kset);
 	
 fail_ksetreg:
-	kobject_unregister(stable_kobj);
+	kobject_put(stable_kobj);
 	
 fail_firmreg:
 	printk(KERN_INFO PDCS_PREFIX " bailing out\n");
@@ -1098,7 +1098,7 @@ pdc_stable_exit(void)
 {
 	pdcs_unregister_pathentries();
 	kset_unregister(paths_kset);
-	kobject_unregister(stable_kobj);
+	kobject_put(stable_kobj);
 }
 
 
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 3606d5b..47bb0e1 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -671,7 +671,7 @@ int pci_hp_deregister (struct hotplug_slot *slot)
 
 	fs_remove_slot (slot);
 	dbg ("Removed slot %s from the list\n", slot->name);
-	kobject_unregister(&slot->kobj);
+	kobject_put(&slot->kobj);
 	return 0;
 }
 
diff --git a/drivers/pci/hotplug/rpadlpar_sysfs.c b/drivers/pci/hotplug/rpadlpar_sysfs.c
index 9cde367..e32148a 100644
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c
+++ b/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -114,12 +114,12 @@ int dlpar_sysfs_init(void)
 
 	error = sysfs_create_group(dlpar_kobj, &dlpar_attr_group);
 	if (error)
-		kobject_unregister(dlpar_kobj);
+		kobject_put(dlpar_kobj);
 	return error;
 }
 
 void dlpar_sysfs_exit(void)
 {
 	sysfs_remove_group(dlpar_kobj, &dlpar_attr_group);
-	kobject_unregister(dlpar_kobj);
+	kobject_put(dlpar_kobj);
 }
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index f352731..03b66fb 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -186,9 +186,9 @@ err:
 	for (mi--; mi>=0; mi--) {
 		mem = &idev->info->mem[mi];
 		map = mem->map;
-		kobject_unregister(&map->kobj);
+		kobject_put(&map->kobj);
 	}
-	kobject_unregister(idev->map_dir);
+	kobject_put(idev->map_dir);
 	sysfs_remove_group(&idev->dev->kobj, &uio_attr_grp);
 err_group:
 	dev_err(idev->dev, "error creating sysfs files (%d)\n", ret);
@@ -203,9 +203,9 @@ static void uio_dev_del_attributes(struct uio_device *idev)
 		mem = &idev->info->mem[mi];
 		if (mem->size == 0)
 			break;
-		kobject_unregister(&mem->map->kobj);
+		kobject_put(&mem->map->kobj);
 	}
-	kobject_unregister(idev->map_dir);
+	kobject_put(idev->map_dir);
 	sysfs_remove_group(&idev->dev->kobj, &uio_attr_grp);
 }
 
-- 
1.5.3.8

