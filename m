Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZBQRW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZBQRW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZBQRWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:22:17 -0500
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:53285 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZBQRWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:22:16 -0500
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Austria, Winston" <Winston.Austria@lsi.com>
Date: Tue, 17 Feb 2009 09:21:59 -0800
Subject: [PATCH 7/9] scsi: megaraid_sas - Resign the Application cmds to
 0x73 (new SAS2) controller
Thread-Topic: [PATCH 7/9] scsi: megaraid_sas - Resign the Application cmds
 to 0x73 (new SAS2) controller
Thread-Index: AciIcSnS7H5xFQtCQzyNHR19nlBrTUImYsQgAAFMQJAAAQsscAAAaQSQAAFE92AAAZ3CEAAAdldw
Message-ID: <4B6A08C587958942AA3002690DD4F8C33A07FC48@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C33A07FC2B@cosmail02.lsi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resign the Application cmds to new SAS2 controller

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   23 ++++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas.h |    1 +
 2 files changed, 21 insertions(+), 3 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-02-12 16:27:20.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-02-12 16:32:34.000000000 -0500
@@ -1204,7 +1204,14 @@ static void megasas_complete_cmd_dpc(uns

                spin_lock_irqsave(instance->host->host_lock, flags);
                instance->flag &= ~MEGASAS_FW_BUSY;
-               instance->host->can_queue =
+               if ((instance->pdev->device ==
+                       PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+                       (instance->pdev->device ==
+                       PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+                       instance->host->can_queue =
+                               instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
+               } else
+                       instance->host->can_queue =
                                instance->max_fw_cmds - MEGASAS_INT_CMDS;

                spin_unlock_irqrestore(instance->host->host_lock, flags);
@@ -2933,7 +2940,13 @@ static int megasas_io_attach(struct mega
         */
        host->irq = instance->pdev->irq;
        host->unique_id = instance->unique_id;
-       host->can_queue = instance->max_fw_cmds - MEGASAS_INT_CMDS;
+       if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+               (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+               host->can_queue =
+                       instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
+       } else
+               host->can_queue =
+                       instance->max_fw_cmds - MEGASAS_INT_CMDS;
        host->this_id = instance->init_id;
        host->sg_tablesize = instance->max_num_sge;
        host->max_sectors = instance->max_sectors_per_req;
@@ -3066,7 +3079,11 @@ megasas_probe_one(struct pci_dev *pdev,
        spin_lock_init(&instance->completion_lock);

        mutex_init(&instance->aen_mutex);
-       sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);
+       if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+               (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+               sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
+       } else
+               sema_init(&instance->ioctl_sem, MEGASAS_INT_CMDS);

        /*
         * Initialize PCI related and misc parameters
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-02-12 16:27:21.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-02-12 15:24:58.000000000 -0500
@@ -674,6 +674,7 @@ struct megasas_ctrl_info {
  * is shown below
  */
 #define MEGASAS_INT_CMDS                       32
+#define MEGASAS_SKINNY_INT_CMDS                        5

 /*
  * FW can accept both 32 and 64 bit SGLs. We want to allocate 32/64 bit
