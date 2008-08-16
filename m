Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYHPU05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYHPU05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbYHPU0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:26:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33255 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYHPU0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:26:45 -0400
Date: Sat, 16 Aug 2008 21:26:40 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: michael_e_brown@dell.com
Subject: [PATCH 1/2] Export SMI call functionality from dcdbas driver
Message-ID: <20080816202640.GB3331@srcf.ucam.org>
References: <20080816202452.GA3331@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080816202452.GA3331@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the dcdbas SMI request call to avoid namespacing issues, and then 
export it so other kernel modules can make use of the functionality.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

commit be8f9ba0f636c9eec356976acc178623ec58651e
Author: Matthew Garrett <mjg59@m6300.(none)>
Date:   Sat Aug 16 21:12:09 2008 +0100

    Add support for using the dcdbas framework from inside the kernel

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 50a071f..762131b 100644
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
@@ -279,6 +279,8 @@ out:
 	return ret;
 }
 
+EXPORT_SYMBOL(dcdbas_smi_request);
+
 /**
  * smi_request_store:
  *
@@ -309,14 +311,14 @@ static ssize_t smi_request_store(struct device *dev,
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
