Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYLBEDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYLBEDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 23:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbYLBEDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 23:03:23 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44268 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYLBEDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 23:03:22 -0500
Date: Tue, 2 Dec 2008 04:03:19 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Matt_Domsch@dell.com
Subject: Re: [PATCH 1/2] dcdbas: Export functionality for use in other drivers
Message-ID: <20081202040319.GB17015@srcf.ucam.org>
References: <20081127163357.GA22846@srcf.ucam.org> <20081202035237.GC15966@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202035237.GC15966@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcdbas: Export functionality for use in other drivers
    
The dcdbas code allows calls to be made into the firmware on Dell systems.
Exporting this to other drivers allows them to implement Dell-specific
functionality in a safe way.
    
Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Only change is the s/EXPORT_SYMBOL/EXPORT_SYMBOL_GPL/. The firmware 
subdir doesn't seem to have a separate maintainer, so I guess 
driver-core is fine?

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
+EXPORT_SYMBOL_GPL(dcdbas_smi_request);
 
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
