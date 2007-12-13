Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXLMHLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXLMHLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762383AbXLMG5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:57:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55456 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762527AbXLMG51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:27 -0500
Date: Wed, 12 Dec 2007 22:52:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, James.Bottomley@SteelEye.com, matthew@wil.cx,
       fujita.tomonori@lab.ntt.co.jp, anders.henke@1und1.de,
       mark_salyzyn@adaptec.com
Subject: [patch 34/60] revert "dpt_i2o: convert to SCSI hotplug model"
Message-ID: <20071213065244.GJ6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="revert-dpt_i2o-convert-to-scsi-hotplug-model.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andrew Morton <akpm@linux-foundation.org>

patch 24601bbcacb3356657747f2e64317923feb7a1a2 in mainline.

revert

    commit 55d9fcf57ba5ec427544fca7abc335cf3da78160
    Author: Matthew Wilcox <matthew@wil.cx>
    Date:   Mon Jul 30 15:19:18 2007 -0600

        [SCSI] dpt_i2o: convert to SCSI hotplug model

         - Delete refereces to HOSTS_C
         - Switch to module_init/module_exit instead of detect/release
         - Don't pass around the host template and rename it to adpt_template
         - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
           scsi_add_host, scsi_scan_host and scsi_host_put.

Because it caused (for unknown reasons) Andres' all-data-reads-as-zeroes
problem, reported at
http://groups.google.com/group/fa.linux.kernel/msg/083a9acff0330234

Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Anders Henke <anders.henke@1und1.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/dpt_i2o.c |  132 ++++++++++++++++++++++---------------------------
 drivers/scsi/dpti.h    |    9 ++-
 2 files changed, 68 insertions(+), 73 deletions(-)

--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -173,20 +173,20 @@ static struct pci_device_id dptids[] = {
 };
 MODULE_DEVICE_TABLE(pci,dptids);
 
-static void adpt_exit(void);
-
-static int adpt_detect(void)
+static int adpt_detect(struct scsi_host_template* sht)
 {
 	struct pci_dev *pDev = NULL;
 	adpt_hba* pHba;
 
+	adpt_init();
+
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
         /* search for all Adatpec I2O RAID cards */
 	while ((pDev = pci_get_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
 		if(pDev->device == PCI_DPT_DEVICE_ID ||
 		   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
-			if(adpt_install_hba(pDev) ){
+			if(adpt_install_hba(sht, pDev) ){
 				PERROR("Could not Init an I2O RAID device\n");
 				PERROR("Will not try to detect others.\n");
 				return hba_count-1;
@@ -248,33 +248,34 @@ rebuild_sys_tab:
 	}
 
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
-		if (adpt_scsi_register(pHba) < 0) {
+		if( adpt_scsi_register(pHba,sht) < 0){
 			adpt_i2o_delete_hba(pHba);
 			continue;
 		}
 		pHba->initialized = TRUE;
 		pHba->state &= ~DPTI_STATE_RESET;
-		scsi_scan_host(pHba->host);
 	}
 
 	// Register our control device node
 	// nodes will need to be created in /dev to access this
 	// the nodes can not be created from within the driver
 	if (hba_count && register_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER, &adpt_fops)) {
-		adpt_exit();
+		adpt_i2o_sys_shutdown();
 		return 0;
 	}
 	return hba_count;
 }
 
 
-static int adpt_release(adpt_hba *pHba)
+/*
+ * scsi_unregister will be called AFTER we return.
+ */
+static int adpt_release(struct Scsi_Host *host)
 {
-	struct Scsi_Host *shost = pHba->host;
-	scsi_remove_host(shost);
+	adpt_hba* pHba = (adpt_hba*) host->hostdata[0];
 //	adpt_i2o_quiesce_hba(pHba);
 	adpt_i2o_delete_hba(pHba);
-	scsi_host_put(shost);
+	scsi_unregister(host);
 	return 0;
 }
 
@@ -881,7 +882,7 @@ static int adpt_reboot_event(struct noti
 #endif
 
 
-static int adpt_install_hba(struct pci_dev* pDev)
+static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev)
 {
 
 	adpt_hba* pHba = NULL;
@@ -1030,6 +1031,8 @@ static void adpt_i2o_delete_hba(adpt_hba
 
 
 	mutex_lock(&adpt_configuration_lock);
+	// scsi_unregister calls our adpt_release which
+	// does a quiese
 	if(pHba->host){
 		free_irq(pHba->host->irq, pHba);
 	}
@@ -1081,6 +1084,17 @@ static void adpt_i2o_delete_hba(adpt_hba
 }
 
 
+static int adpt_init(void)
+{
+	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
+#ifdef REBOOT_NOTIFIER
+	register_reboot_notifier(&adpt_reboot_notifier);
+#endif
+
+	return 0;
+}
+
+
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun)
 {
 	struct adpt_device* d;
@@ -2166,6 +2180,37 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pH
 }
 
 
+static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht)
+{
+	struct Scsi_Host *host = NULL;
+
+	host = scsi_register(sht, sizeof(adpt_hba*));
+	if (host == NULL) {
+		printk ("%s: scsi_register returned NULL\n",pHba->name);
+		return -1;
+	}
+	host->hostdata[0] = (unsigned long)pHba;
+	pHba->host = host;
+
+	host->irq = pHba->pDev->irq;
+	/* no IO ports, so don't have to set host->io_port and
+	 * host->n_io_port
+	 */
+	host->io_port = 0;
+	host->n_io_port = 0;
+				/* see comments in scsi_host.h */
+	host->max_id = 16;
+	host->max_lun = 256;
+	host->max_channel = pHba->top_scsi_channel + 1;
+	host->cmd_per_lun = 1;
+	host->unique_id = (uint) pHba;
+	host->sg_tablesize = pHba->sg_tablesize;
+	host->can_queue = pHba->post_fifo_size;
+
+	return 0;
+}
+
+
 static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 {
 	adpt_hba* pHba;
@@ -3284,10 +3329,12 @@ static static void adpt_delay(int millis
 
 #endif
 
-static struct scsi_host_template adpt_template = {
+static struct scsi_host_template driver_template = {
 	.name			= "dpt_i2o",
 	.proc_name		= "dpt_i2o",
 	.proc_info		= adpt_proc_info,
+	.detect			= adpt_detect,
+	.release		= adpt_release,
 	.info			= adpt_info,
 	.queuecommand		= adpt_queue,
 	.eh_abort_handler	= adpt_abort,
@@ -3301,62 +3348,5 @@ static struct scsi_host_template adpt_te
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
-
-static s32 adpt_scsi_register(adpt_hba* pHba)
-{
-	struct Scsi_Host *host;
-
-	host = scsi_host_alloc(&adpt_template, sizeof(adpt_hba*));
-	if (host == NULL) {
-		printk ("%s: scsi_host_alloc returned NULL\n",pHba->name);
-		return -1;
-	}
-	host->hostdata[0] = (unsigned long)pHba;
-	pHba->host = host;
-
-	host->irq = pHba->pDev->irq;
-	/* no IO ports, so don't have to set host->io_port and
-	 * host->n_io_port
-	 */
-	host->io_port = 0;
-	host->n_io_port = 0;
-				/* see comments in scsi_host.h */
-	host->max_id = 16;
-	host->max_lun = 256;
-	host->max_channel = pHba->top_scsi_channel + 1;
-	host->cmd_per_lun = 1;
-	host->unique_id = (uint) pHba;
-	host->sg_tablesize = pHba->sg_tablesize;
-	host->can_queue = pHba->post_fifo_size;
-
-	if (scsi_add_host(host, &pHba->pDev->dev)) {
-		scsi_host_put(host);
-		return -1;
-	}
-
-	return 0;
-}
-
-static int __init adpt_init(void)
-{
-	int count;
-
-	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
-#ifdef REBOOT_NOTIFIER
-	register_reboot_notifier(&adpt_reboot_notifier);
-#endif
-
-	count = adpt_detect();
-
-	return count > 0 ? 0 : -ENODEV;
-}
-
-static void __exit adpt_exit(void)
-{
-	while (hba_chain)
-		adpt_release(hba_chain);
-}
-
-module_init(adpt_init);
-module_exit(adpt_exit);
+#include "scsi_module.c"
 MODULE_LICENSE("GPL");
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -28,9 +28,11 @@
  * SCSI interface function Prototypes
  */
 
+static int adpt_detect(struct scsi_host_template * sht);
 static int adpt_queue(struct scsi_cmnd * cmd, void (*cmdcomplete) (struct scsi_cmnd *));
 static int adpt_abort(struct scsi_cmnd * cmd);
 static int adpt_reset(struct scsi_cmnd* cmd);
+static int adpt_release(struct Scsi_Host *host);
 static int adpt_slave_configure(struct scsi_device *);
 
 static const char *adpt_info(struct Scsi_Host *pSHost);
@@ -47,6 +49,8 @@ static int adpt_device_reset(struct scsi
 
 #define DPT_DRIVER_NAME	"Adaptec I2O RAID"
 
+#ifndef HOSTS_C
+
 #include "dpt/sys_info.h"
 #include <linux/wait.h>
 #include "dpt/dpti_i2o.h"
@@ -285,7 +289,7 @@ static s32 adpt_i2o_init_outbound_q(adpt
 static s32 adpt_i2o_hrt_get(adpt_hba* pHba);
 static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_device* dptdevice);
 static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd);
-static s32 adpt_scsi_register(adpt_hba* pHba);
+static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht);
 static s32 adpt_hba_reset(adpt_hba* pHba);
 static s32 adpt_i2o_reset_hba(adpt_hba* pHba);
 static s32 adpt_rescan(adpt_hba* pHba);
@@ -295,7 +299,7 @@ static void adpt_i2o_delete_hba(adpt_hba
 static void adpt_inquiry(adpt_hba* pHba);
 static void adpt_fail_posted_scbs(adpt_hba* pHba);
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun);
-static int adpt_install_hba(struct pci_dev* pDev) ;
+static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev) ;
 static int adpt_i2o_online_hba(adpt_hba* pHba);
 static void adpt_i2o_post_wait_complete(u32, int);
 static int adpt_i2o_systab_send(adpt_hba* pHba);
@@ -339,4 +343,5 @@ static void adpt_i386_info(sysInfo_S* si
 #define FW_DEBUG_BLED_OFFSET       8
 
 #define FW_DEBUG_FLAGS_NO_HEADERS_B    0x01
+#endif				/* !HOSTS_C */
 #endif				/* _DPT_H */

-- 
