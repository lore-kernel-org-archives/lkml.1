Return-Path: <linux-kernel-owner+w=401wt.eu-S933297AbZJFUmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbZJFUmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933288AbZJFUmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:42:07 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:34190 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933280AbZJFUmE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:42:04 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>
CC: "Austria, Winston" <Winston.Austria@lsi.com>
Date: Tue, 6 Oct 2009 14:40:58 -0600
Subject: [PATCH 7/12] scsi: megaraid_sas - allocate the application cmds to
 sas2 controller 
Thread-Topic: [PATCH 7/12] scsi: megaraid_sas - allocate the application
 cmds to sas2 controller 
Thread-Index: Aco284muq21jjlUCRvWfDnAhnowdBQAABfzAAAAxetAAAF05EAAATiEQAAAy5GAA20T3MAMX4Uig
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C6861D5@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C51199A@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C512403@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C512403@cosmail02.lsi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: AfDC KBmq KjjA TOVM YXGb YiS+ b6XQ ehiM glhh oUAM ri6A
 uPWt 2jzz 3JK5 7uC/
 9zGi;5;YQBrAHAAbQBAAG8AcwBkAGwALgBvAHIAZwA7AGoAYQBtAGUAcwAuAGIAbwB0AHQAbwBtAGwAZQB5AEAAaABhAG4AcwBlAG4AcABhAHIAdABuAGUAcgBzAGgAaQBwAC4AYwBvAG0AOwBqAGEAbQBlAHMALgBiAG8AdAB0AG8AbQBsAGUAeQBAAHMAdQBzAGUALgBkAGUAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AcwBjAHMAaQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{FC1E1059-E18D-4CA5-89DD-81A39855E04A};YgBvAC4AeQBhAG4AZwBAAGwAcwBpAC4AYwBvAG0A;Tue,
 06 Oct 2009 20:40:58
 GMT;WwBQAEEAVABDAEgAIAA3AC8AMQAyAF0AIABzAGMAcwBpADoAIABtAGUAZwBhAHIAYQBpAGQAXwBzAGEAcwAgAC0AIABhAGwAbABvAGMAYQB0AGUAIAB0AGgAZQAgAGEAcABwAGwAaQBjAGEAdABpAG8AbgAgAGMAbQBkAHMAIAB0AG8AIABzAGEAcwAyACAAYwBvAG4AdAByAG8AbABsAGUAcgA=
x-cr-puzzleid: {FC1E1059-E18D-4CA5-89DD-81A39855E04A}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RESUBMIT:

MegaRAID SAS2 controller ioctl can't use 32 cmd for applications.  Driver need to divide different number of cmds to IO and application.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   24 +++++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas.h |    1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c	2009-09-14 05:59:48.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c	2009-09-14 06:07:09.000000000 -0400
@@ -1239,7 +1239,14 @@ static void megasas_complete_cmd_dpc(uns
 
 		spin_lock_irqsave(instance->host->host_lock, flags);
 		instance->flag &= ~MEGASAS_FW_BUSY;
-		instance->host->can_queue =
+		if ((instance->pdev->device ==
+			PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+			(instance->pdev->device ==
+			PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+			instance->host->can_queue =
+				instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
+		} else
+			instance->host->can_queue =
 				instance->max_fw_cmds - MEGASAS_INT_CMDS;
 
 		spin_unlock_irqrestore(instance->host->host_lock, flags);
@@ -2774,7 +2781,13 @@ static int megasas_io_attach(struct mega
 	 */
 	host->irq = instance->pdev->irq;
 	host->unique_id = instance->unique_id;
-	host->can_queue = instance->max_fw_cmds - MEGASAS_INT_CMDS;
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+		host->can_queue =
+			instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
+	} else
+		host->can_queue =
+			instance->max_fw_cmds - MEGASAS_INT_CMDS;
 	host->this_id = instance->init_id;
 	host->sg_tablesize = instance->max_num_sge;
 	host->max_sectors = instance->max_sectors_per_req;
@@ -2909,7 +2922,6 @@ megasas_probe_one(struct pci_dev *pdev, 
 	spin_lock_init(&poll_aen_lock);
 
 	mutex_init(&instance->aen_mutex);
-	sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
 
 	/*
 	 * Initialize PCI related and misc parameters
@@ -2919,6 +2931,12 @@ megasas_probe_one(struct pci_dev *pdev, 
 	instance->unique_id = pdev->bus->number << 8 | pdev->devfn;
 	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
 
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+		sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
+	} else
+		sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
+
 	megasas_dbg_lvl = 0;
 	instance->flag = 0;
 	instance->unload = 0;
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h	2009-09-14 05:59:48.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h	2009-09-14 06:09:56.000000000 -0400
@@ -655,6 +655,7 @@ struct megasas_ctrl_info {
  * is shown below
  */
 #define MEGASAS_INT_CMDS			32
+#define MEGASAS_SKINNY_INT_CMDS			5
 
 /*
  * FW can accept both 32 and 64 bit SGLs. We want to allocate 32/64 bit
