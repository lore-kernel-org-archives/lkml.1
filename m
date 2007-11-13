Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXKMSp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXKMSp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbXKMSpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:45:19 -0500
Received: from flatline.sindominio.net ([82.144.4.26]:44649 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbXKMSpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:45:17 -0500
Date: Tue, 13 Nov 2007 19:45:03 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: rolandd@cisco.com, mshefty@ichips.intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] QLogic InfiniPath: convert ipath_eep_sem to mutex
Message-ID: <20071113184503.GE30483@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	rolandd@cisco.com, mshefty@ichips.intel.com,
	hal.rosenstock@gmail.com, general@lists.openfabrics.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

QLogic InfiniPath: convert the semaphore ipath_eep_sem to the mutex
API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/infiniband/hw/ipath/ipath_eeprom.c b/drivers/infiniband/hw/ipath/ipath_eeprom.c
index e7c25db..a5b6299 100644
--- a/drivers/infiniband/hw/ipath/ipath_eeprom.c
+++ b/drivers/infiniband/hw/ipath/ipath_eeprom.c
@@ -510,10 +510,10 @@ int ipath_eeprom_read(struct ipath_devdata *dd, u8 eeprom_offset,
 {
 	int ret;
 
-	ret = down_interruptible(&dd->ipath_eep_sem);
+	ret = mutex_lock_interruptible(&dd->ipath_eep_lock);
 	if (!ret) {
 		ret = ipath_eeprom_internal_read(dd, eeprom_offset, buff, len);
-		up(&dd->ipath_eep_sem);
+		mutex_unlock(&dd->ipath_eep_lock);
 	}
 
 	return ret;
@@ -524,10 +524,10 @@ int ipath_eeprom_write(struct ipath_devdata *dd, u8 eeprom_offset,
 {
 	int ret;
 
-	ret = down_interruptible(&dd->ipath_eep_sem);
+	ret = mutex_lock_interruptible(&dd->ipath_eep_lock);
 	if (!ret) {
 		ret = ipath_eeprom_internal_write(dd, eeprom_offset, buff, len);
-		up(&dd->ipath_eep_sem);
+		mutex_unlock(&dd->ipath_eep_lock);
 	}
 
 	return ret;
@@ -616,9 +616,9 @@ void ipath_get_eeprom_info(struct ipath_devdata *dd)
 		goto bail;
 	}
 
-	down(&dd->ipath_eep_sem);
+	mutex_lock(&dd->ipath_eep_lock);
 	eep_stat = ipath_eeprom_internal_read(dd, 0, buf, len);
-	up(&dd->ipath_eep_sem);
+	mutex_unlock(&dd->ipath_eep_lock);
 
 	if (eep_stat) {
 		ipath_dev_err(dd, "Failed reading GUID from eeprom\n");
@@ -764,14 +764,14 @@ int ipath_update_eeprom_log(struct ipath_devdata *dd)
 	/* Grab semaphore and read current EEPROM. If we get an
 	 * error, let go, but if not, keep it until we finish write.
 	 */
-	ret = down_interruptible(&dd->ipath_eep_sem);
+	ret = mutex_lock_interruptible(&dd->ipath_eep_lock);
 	if (ret) {
 		ipath_dev_err(dd, "Unable to acquire EEPROM for logging\n");
 		goto free_bail;
 	}
 	ret = ipath_eeprom_internal_read(dd, 0, buf, len);
 	if (ret) {
-		up(&dd->ipath_eep_sem);
+		mutex_unlock(&dd->ipath_eep_lock);
 		ipath_dev_err(dd, "Unable read EEPROM for logging\n");
 		goto free_bail;
 	}
@@ -779,7 +779,7 @@ int ipath_update_eeprom_log(struct ipath_devdata *dd)
 
 	csum = flash_csum(ifp, 0);
 	if (csum != ifp->if_csum) {
-		up(&dd->ipath_eep_sem);
+		mutex_unlock(&dd->ipath_eep_lock);
 		ipath_dev_err(dd, "EEPROM cks err (0x%02X, S/B 0x%02X)\n",
 				csum, ifp->if_csum);
 		ret = 1;
@@ -849,7 +849,7 @@ int ipath_update_eeprom_log(struct ipath_devdata *dd)
 		csum = flash_csum(ifp, 1);
 		ret = ipath_eeprom_internal_write(dd, 0, buf, hi_water + 1);
 	}
-	up(&dd->ipath_eep_sem);
+	mutex_unlock(&dd->ipath_eep_lock);
 	if (ret)
 		ipath_dev_err(dd, "Failed updating EEPROM\n");
 
diff --git a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers/infiniband/hw/ipath/ipath_init_chip.c
index 9dd0bac..9e9d6fa 100644
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c
+++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c
@@ -348,7 +348,7 @@ static int init_chip_first(struct ipath_devdata *dd,
 
 	spin_lock_init(&dd->ipath_gpio_lock);
 	spin_lock_init(&dd->ipath_eep_st_lock);
-	sema_init(&dd->ipath_eep_sem, 1);
+	mutex_init(&dd->ipath_eep_lock);
 
 done:
 	*pdp = pd;
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 8786dd7..a6e7a60 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -41,6 +41,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
+#include <linux/mutex.h>
 #include <asm/io.h>
 #include <rdma/ib_verbs.h>
 
@@ -616,7 +617,7 @@ struct ipath_devdata {
 	/* control access to actual counters, timer */
 	spinlock_t ipath_eep_st_lock;
 	/* control high-level access to EEPROM */
-	struct semaphore ipath_eep_sem;
+	struct mutex ipath_eep_lock;
 	/* Below inc'd by ipath_snap_cntrs(), locked by ipath_eep_st_lock */
 	uint64_t ipath_traffic_wds;
 	/* active time is kept in seconds, but logged in hours */

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
