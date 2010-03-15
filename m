Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab0COI1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 04:27:14 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:53333 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0COI1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 04:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=AVpYoi/QVNjtNPBkdkBA3tQNzMeFCmcBa+vQeVFsgz91U9GEB/zLBuJpxnZH7i/Exv
         bL9ntFTRJrxPB1BoXrKeAW3uZnmyO4kir++B+On1dwPj4MXSD1c/WxhDyY3QVCL8T9Wt
         lBilTrbXJbJctKQGiIdJcoyXAKGB2esg4xy1Q=
Date: Mon, 15 Mar 2010 11:26:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] dpt_i20: several use after free issues
Message-ID: <20100315082656.GJ18181@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yang Hongyang <yanghy@cn.fujitsu.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adpt_i2o_delete_hba() calls kfree() so we have to save "pHba->next"
before calling it.  Also inside adpt_i2o_delete_hba() itself, there
was another use after free bug which I fixed by moving the kfree() 
down a line.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 4967643..0435d04 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -188,7 +188,8 @@ MODULE_DEVICE_TABLE(pci,dptids);
 static int adpt_detect(struct scsi_host_template* sht)
 {
 	struct pci_dev *pDev = NULL;
-	adpt_hba* pHba;
+	adpt_hba *pHba;
+	adpt_hba *next;
 
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
@@ -206,7 +207,8 @@ static int adpt_detect(struct scsi_host_template* sht)
 	}
 
 	/* In INIT state, Activate IOPs */
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		// Activate does get status , init outbound, and get hrt
 		if (adpt_i2o_activate_hba(pHba) < 0) {
 			adpt_i2o_delete_hba(pHba);
@@ -243,7 +245,8 @@ rebuild_sys_tab:
 	PDEBUG("HBA's in OPERATIONAL state\n");
 
 	printk("dpti: If you have a lot of devices this could take a few minutes.\n");
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		printk(KERN_INFO"%s: Reading the hardware resource table.\n", pHba->name);
 		if (adpt_i2o_lct_get(pHba) < 0){
 			adpt_i2o_delete_hba(pHba);
@@ -263,7 +266,8 @@ rebuild_sys_tab:
 		adpt_sysfs_class = NULL;
 	}
 
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		if (adpt_scsi_host_alloc(pHba, sht) < 0){
 			adpt_i2o_delete_hba(pHba);
 			continue;
@@ -1229,11 +1233,10 @@ static void adpt_i2o_delete_hba(adpt_hba* pHba)
 		}
 	}
 	pci_dev_put(pHba->pDev);
-	kfree(pHba);
-
 	if (adpt_sysfs_class)
 		device_destroy(adpt_sysfs_class,
 				MKDEV(DPTI_I2O_MAJOR, pHba->unit));
+	kfree(pHba);
 
 	if(hba_count <= 0){
 		unregister_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER);   
