Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYK0QeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYK0QeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYK0QeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:34:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46861 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYK0QeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:34:03 -0500
Date: Thu, 27 Nov 2008 16:33:57 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: Matt_Domsch@dell.com, greg@kroah.com
Subject: [PATCH 1/2] dcdbas: Export functionality for use in other drivers
Message-ID: <20081127163357.GA22846@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcdbas: Export functionality for use in other drivers
    
The dcdbas code allows calls to be made into the firmware on Dell 
systems. Exporting this to other drivers allows them to implement 
Dell-specific functionality in a safe way.
    
Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 50a071f..45f109d 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -238,11 +238,11 @@ static ssize_t host_control_on_shutdown_store(struct device *dev,
 }
 
 /**
- * smi_request: generate SMI request
+ * dcdbas_smi_request: generate SMI request
  *
  * Called with smi_data_lock.
  */
-static int smi_request(struct smi_cmd *smi_cmd)
+int dcdbas_smi_request(struct smi_cmd *smi_cmd)
 {
 	cpumask_t old_mask;
 	int ret = 0;
@@ -278,6 +278,7 @@ out:
 	set_cpus_allowed_ptr(current, &old_mask);
 	return ret;
 }
+EXPORT_SYMBOL(dcdbas_smi_request);
 
 /**
  * smi_request_store:
@@ -309,14 +310,14 @@ static ssize_t smi_request_store(struct device *dev,
 	switch (val) {
 	case 2:
 		/* Raw SMI */
-		ret = smi_request(smi_cmd);
+		ret = dcdbas_smi_request(smi_cmd);
 		if (!ret)
 			ret = count;
 		break;
 	case 1:
 		/* Calling Interface SMI */
 		smi_cmd->ebx = (u32) virt_to_phys(smi_cmd->command_buffer);
-		ret = smi_request(smi_cmd);
+		ret = dcdbas_smi_request(smi_cmd);
 		if (!ret)
 			ret = count;
 		break;
diff --git a/drivers/firmware/dcdbas.h b/drivers/firmware/dcdbas.h
index 87bc341..ca3cb0a 100644
--- a/drivers/firmware/dcdbas.h
+++ b/drivers/firmware/dcdbas.h
@@ -101,5 +101,7 @@ struct apm_cmd {
 	} __attribute__ ((packed)) parameters;
 } __attribute__ ((packed));
 
+int dcdbas_smi_request(struct smi_cmd *smi_cmd);
+
 #endif /* _DCDBAS_H_ */
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
