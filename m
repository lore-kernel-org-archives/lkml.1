Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZJ1QjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZJ1QjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbZJ1QjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:39:15 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:4263 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755098AbZJ1QjO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:39:14 -0400
X-SpamScore: 10
X-BigFish: VPS10(zza4b1ozz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KS8GWB-01-O6V-02
X-M-MSG: 
Date: Wed, 28 Oct 2009 17:38:37 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
CC: Doug Thompson <norsk5@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] amd64_edac: syndromes housekeeping
Message-ID: <20091028163837.GC625@aftab>
References: <20091028163534.GA625@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091028163534.GA625@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Oct 2009 16:38:34.0971 (UTC) FILETIME=[17AF4AB0:01CA57ED]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 49c4f77bc5281cf39fd5afda9d2b29fb6dd0db91 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 28 Oct 2009 15:13:29 +0100
Subject: [PATCH 2/2] amd64_edac: syndromes housekeeping

Check which syndromes table to load based on the node ECC symbol size
used and alloc memory for the respective table.

Not-Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   64 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/edac/amd64_edac.h |    2 +
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 6222a2c..5dc43ba 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -19,6 +19,9 @@ struct amd64_pvt;
 static struct mem_ctl_info *mci_lookup[EDAC_MAX_NUMNODES];
 static struct amd64_pvt *pvt_lookup[EDAC_MAX_NUMNODES];
 
+/* fake platform device for request_firmware */
+static struct platform_device *syndrome_pdev;
+
 /*
  * Address to DRAM bank mapping: see F2x80 for K8 and F2x[1,0]80 for Fam10 and
  * later.
@@ -2014,6 +2017,56 @@ static int amd64_load_syndrome_binary(char *fw_name, struct syndrome_table *s,
 	return 0;
 }
 
+static int amd64_load_syndromes(struct amd64_pvt *pvt)
+{
+	struct syndrome_table *s;
+	char *fw_name;
+	int err;
+	u32 value = 0;
+
+	s = kzalloc(sizeof(struct syndrome_table), GFP_KERNEL);
+	if (!s) {
+		amd64_printk(KERN_ERR, "%s: allocation faliure\n", __func__);
+		return -EINVAL;
+	}
+
+	if (!(pvt->nbcfg & K8_NBCFG_CHIPKILL)) {
+		amd64_printk(KERN_WARNING, "ECC syndromes not supported.\n");
+		return -EINVAL;
+	}
+
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, 0x180, &value);
+
+	/* x4 and x8 symbols supported on F10h, revD */
+	if (boot_cpu_data.x86 == 0x10 &&
+	    boot_cpu_data.x86_model > 7 &&
+	    value & BIT(25)) {
+		fw_name = "amd64_edac/x8.bin";
+		s->type = SYNDROME_X8;
+		s->rows = 256;
+		s->cols = 19;
+	} else {
+		fw_name = "amd64_edac/x4.bin";
+		s->type = SYNDROME_X4;
+		s->rows = 36;
+		s->cols = 15;
+	}
+
+	s->data = kzalloc(sizeof(u16) * s->rows * s->cols, GFP_KERNEL);
+	if (!s->data) {
+		kfree(s);
+		amd64_printk(KERN_ERR, "%s: table alloc faliure\n", __func__);
+		return -EINVAL;
+	}
+
+	err = amd64_load_syndrome_binary(fw_name, s, &syndrome_pdev->dev);
+	if (!err)
+		pvt->syn_tbl = s;
+
+	return err;
+}
+
+
 /*
  * Given the syndrome argument, scan each of the channel tables for a syndrome
  * match. Depending on which table it is found, return the channel number.
@@ -2940,6 +2993,10 @@ static int amd64_init_2nd_stage(struct amd64_pvt *pvt)
 	if (report_gart_errors)
 		amd_report_gart_errors(true);
 
+	if (amd64_load_syndromes(pvt))
+		amd64_printk(KERN_WARNING, "Could not load syndromes table, you"
+			     " won't be able to map CECCs to a DIMM.");
+
 	amd_register_ecc_decoder(amd64_decode_bus_error);
 
 	return 0;
@@ -3003,7 +3060,10 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 
 	amd64_free_mc_sibling_devices(pvt);
 
+	kfree(pvt->syn_tbl->data);
+	kfree(pvt->syn_tbl);
 	kfree(pvt);
+
 	mci->pvt_info = NULL;
 
 	mci_lookup[pvt->mc_node_id] = NULL;
@@ -3101,6 +3161,8 @@ static int __init amd64_edac_init(void)
 	if (err)
 		return err;
 
+	syndrome_pdev = platform_device_register_simple("syndrome", -1,
+							NULL, 0);
 	/*
 	 * At this point, the array 'pvt_lookup[]' contains pointers to alloc'd
 	 * amd64_pvt structs. These will be used in the 2nd stage init function
@@ -3133,6 +3195,8 @@ static void __exit amd64_edac_exit(void)
 	if (amd64_ctl_pci)
 		edac_pci_release_generic_ctl(amd64_ctl_pci);
 
+	platform_device_unregister(syndrome_pdev);
+
 	pci_unregister_driver(&amd64_pci_driver);
 }
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 94f58d7..83b9ff2 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -499,6 +499,8 @@ struct amd64_pvt {
 	/* MC Type Index value: socket F vs Family 10h */
 	u32 mc_type_index;
 
+	struct syndrome_table *syn_tbl;
+
 	/* misc settings */
 	struct flags {
 		unsigned long cf8_extcfg:1;
-- 
1.6.4.3

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

