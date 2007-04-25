Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXDYNqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXDYNqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932282AbXDYNqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:46:22 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:46696
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932753AbXDYNqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:46:21 -0400
Date: Wed, 25 Apr 2007 15:49:17 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: norsk5@xmission.com, bluesmoke-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of semaphore in EDAC core
Message-ID: <20070425134917.GL6798@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	norsk5@xmission.com, bluesmoke-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the EDAC core code uses a semaphore as mutex. use the mutex API
instead of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 7b62230..f217750 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -50,7 +50,7 @@ static int panic_on_ue;
 static int poll_msec = 1000;
 
 /* lock to memory controller's control array */
-static DECLARE_MUTEX(mem_ctls_mutex);
+static DEFINE_MUTEX(mem_ctls_mutex);
 static struct list_head mc_devices = LIST_HEAD_INIT(mc_devices);
 
 static struct task_struct *edac_thread;
@@ -1489,7 +1489,7 @@ int edac_mc_add_mc(struct mem_ctl_info *mci, int mc_idx)
 		}
 	}
 #endif
-	down(&mem_ctls_mutex);
+	mutex_lock(&mem_ctls_mutex);
 
 	if (add_mc_to_global_list(mci))
 		goto fail0;
@@ -1507,14 +1507,14 @@ int edac_mc_add_mc(struct mem_ctl_info *mci, int mc_idx)
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to %s %s: DEV %s\n",
 		mci->mod_name, mci->ctl_name, dev_name(mci->dev));
 
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 	return 0;
 
 fail1:
 	del_mc_from_global_list(mci);
 
 fail0:
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(edac_mc_add_mc);
@@ -1531,16 +1531,16 @@ struct mem_ctl_info * edac_mc_del_mc(struct device *dev)
 	struct mem_ctl_info *mci;
 
 	debugf0("MC: %s()\n", __func__);
-	down(&mem_ctls_mutex);
+	mutex_lock(&mem_ctls_mutex);
 
 	if ((mci = find_mci_by_dev(dev)) == NULL) {
-		up(&mem_ctls_mutex);
+		mutex_unlock(&mem_ctls_mutex);
 		return NULL;
 	}
 
 	edac_remove_sysfs_mci_device(mci);
 	del_mc_from_global_list(mci);
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 	edac_printk(KERN_INFO, EDAC_MC,
 		"Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
 		mci->mod_name, mci->ctl_name, dev_name(mci->dev));
@@ -1877,7 +1877,7 @@ static inline void check_mc_devices(void)
 	struct mem_ctl_info *mci;
 
 	debugf3("%s()\n", __func__);
-	down(&mem_ctls_mutex);
+	mutex_lock(&mem_ctls_mutex);
 
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
@@ -1886,7 +1886,7 @@ static inline void check_mc_devices(void)
 			mci->edac_check(mci);
 	}
 
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 }
 
 /*
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

                Don't walk behind me, I may not lead
             Don't walk in front of me, I may not follow
                Just walk beside me and be my friend
                          (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
