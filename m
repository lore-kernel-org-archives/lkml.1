Return-Path: <linux-kernel-owner+w=401wt.eu-S933228AbZJFUfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbZJFUfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933183AbZJFUfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:35:30 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38575 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933055AbZJFUf2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:35:28 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "James.Bottomley@suse.de" <James.Bottomley@suse.de>
CC: "Austria, Winston" <Winston.Austria@lsi.com>,
       "Mukker, Atul" <Atul.Mukker@lsi.com>
Date: Tue, 6 Oct 2009 14:33:06 -0600
Subject: [PATCH 6/12] scsi: megaraid_sas - report system pds to OS (part II)
Thread-Topic: [PATCH 6/12] scsi: megaraid_sas - report system pds to OS
 (part II)
Thread-Index: Aco284muq21jjlUCRvWfDnAhnowdBQAABfzAAAAxetAAAF05EAAATiEQANttm3ADF65SQA==
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C6861C9@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C51198F@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C512401@cosmail02.lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C512401@cosmail02.lsi.com>
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

RESUBMIT:

Add the system pds support part-II.  When OS issue inquiry, it will check driver's internal pd_list.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   91 +++++++++++++++++++++++++----------
 1 file changed, 65 insertions(+), 26 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c	2009-09-14 05:49:20.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c	2009-09-14 05:56:01.000000000 -0400
@@ -1115,24 +1115,76 @@ megasas_queue_command(struct scsi_cmnd *
 	return 0;
 }
 
+static struct megasas_instance *megasas_lookup_instance(u16 host_no)
+{
+	int i;
+
+	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+
+		if ((megasas_mgmt_info.instance[i]) &&
+		    (megasas_mgmt_info.instance[i]->host->host_no == host_no))
+			return megasas_mgmt_info.instance[i];
+	}
+
+	return NULL;
+}
+
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
+	u16             pd_index = 0;
+	struct  megasas_instance *instance ;
+
+	instance = megasas_lookup_instance(sdev->host->host_no);
+
 	/*
-	 * Don't export physical disk devices to the disk driver.
-	 *
-	 * FIXME: Currently we don't export them to the midlayer at all.
-	 * 	  That will be fixed once LSI engineers have audited the
-	 * 	  firmware for possible issues.
-	 */
-	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type == TYPE_DISK)
+	* Don't export physical disk devices to the disk driver.
+	*
+	* FIXME: Currently we don't export them to the midlayer at all.
+	*        That will be fixed once LSI engineers have audited the
+	*        firmware for possible issues.
+	*/
+	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS &&
+				sdev->type == TYPE_DISK) {
+		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
+								sdev->id;
+		if (instance->pd_list[pd_index].driveState ==
+						MR_PD_STATE_SYSTEM) {
+			blk_queue_rq_timeout(sdev->request_queue,
+				MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
+			return 0;
+		}
 		return -ENXIO;
+	}
 
 	/*
-	 * The RAID firmware may require extended timeouts.
-	 */
-	if (sdev->channel >= MEGASAS_MAX_PD_CHANNELS)
-		blk_queue_rq_timeout(sdev->request_queue,
-				     MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
+	* The RAID firmware may require extended timeouts.
+	*/
+	blk_queue_rq_timeout(sdev->request_queue,
+		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
+	return 0;
+}
+
+static int megasas_slave_alloc(struct scsi_device *sdev)
+{
+	u16             pd_index = 0;
+	struct megasas_instance *instance ;
+	instance = megasas_lookup_instance(sdev->host->host_no);
+	if ((sdev->channel < MEGASAS_MAX_PD_CHANNELS) &&
+				(sdev->type == TYPE_DISK)) {
+		/*
+		 * Open the OS scan to the SYSTEM PD
+		 */
+		pd_index =
+			(sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
+			sdev->id;
+		if ((instance->pd_list[pd_index].driveState ==
+					MR_PD_STATE_SYSTEM) &&
+			(instance->pd_list[pd_index].driveType ==
+						TYPE_DISK)) {
+			return 0;
+		}
+		return -ENXIO;
+	}
 	return 0;
 }
 
@@ -1423,6 +1475,7 @@ static struct scsi_host_template megasas
 	.name = "LSI SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
 	.slave_configure = megasas_slave_configure,
+	.slave_alloc = megasas_slave_alloc,
 	.queuecommand = megasas_queue_command,
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
@@ -3455,20 +3508,6 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	return error;
 }
 
-static struct megasas_instance *megasas_lookup_instance(u16 host_no)
-{
-	int i;
-
-	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
-
-		if ((megasas_mgmt_info.instance[i]) &&
-		    (megasas_mgmt_info.instance[i]->host->host_no == host_no))
-			return megasas_mgmt_info.instance[i];
-	}
-
-	return NULL;
-}
-
 static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 {
 	struct megasas_iocpacket __user *user_ioc =
