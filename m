Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZLBK6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZLBK6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZLBK6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:58:48 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:34175 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZLBK6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:58:47 -0500
X-SpamScore: -26
X-BigFish: VPS-26(z21eWz98dN148cMab9bh1102Kzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KU0UHN-02-3JH-02
X-M-MSG: 
Date: Wed, 2 Dec 2009 11:58:38 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Borislav Petkov <petkovbb@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: 2.6.32-rc8: amd64_edac slub error
Message-ID: <20091202105838.GA10306@aftab>
References: <4B1400B3.60300@oracle.com>
 <20091130203547.GA2838@liondog.tnic>
 <20091130141629.44401d86.randy.dunlap@oracle.com>
 <20091201151639.GA670@aftab>
 <4B155023.1000801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4B155023.1000801@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Dec 2009 10:58:36.0346 (UTC) FILETIME=[659D61A0:01CA733E]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 09:19:31AM -0800, Randy Dunlap wrote:
> Here's the new log file (attached).

Thanks for testing. Meanwhile, I noticed that the other places where
rdmsr_on_cpus() gets called with non-contigious cpumasks need fixing
too. Here's a version that takes care of that, I'd be nice if you could
give it a run too (patch against today's upstream). You could also
enforce the module loading by setting 'ecc_enable_override=1' to verify
the other rdmsr_on_cpus calls.

Thanks.

---
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index a38831c..da2428b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2618,6 +2618,9 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 	return empty;
 }
 
+static struct msr *alloc_msrs(const cpumask_t *mask);
+static void free_msrs(struct msr *msrs);
+
 /*
  * Only if 'ecc_enable_override' is set AND BIOS had ECC disabled, do "we"
  * enable it.
@@ -2627,14 +2630,16 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 	struct amd64_pvt *pvt = mci->pvt_info;
 	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
 	int cpu, idx = 0, err = 0;
-	struct msr msrs[cpumask_weight(cpumask)];
+	struct msr *msrs;
 	u32 value;
 	u32 mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
 	if (!ecc_enable_override)
 		return;
 
-	memset(msrs, 0, sizeof(msrs));
+	msrs = alloc_msrs(cpumask);
+	if (!msrs)
+		return;
 
 	amd64_printk(KERN_WARNING,
 		"'ecc_enable_override' parameter is active, "
@@ -2697,20 +2702,24 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 		(value & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled");
 
 	pvt->ctl_error_info.nbcfg = value;
+
+	free_msrs(msrs);
 }
 
 static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 {
 	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
 	int cpu, idx = 0, err = 0;
-	struct msr msrs[cpumask_weight(cpumask)];
+	struct msr *msrs;
 	u32 value;
 	u32 mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
 	if (!pvt->nbctl_mcgctl_saved)
 		return;
 
-	memset(msrs, 0, sizeof(msrs));
+	msrs = alloc_msrs(cpumask);
+	if (!msrs)
+		return;
 
 	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCTL, &value);
 	if (err)
@@ -2731,6 +2740,8 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 	}
 
 	wrmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
+
+	free_msrs(msrs);
 }
 
 /* get all cores on this DCT */
@@ -2743,6 +2754,40 @@ static void get_cpus_on_this_dct_cpumask(cpumask_t *mask, int nid)
 			cpumask_set_cpu(cpu, mask);
 }
 
+/*
+ * Allocate enough msr structs for the supplied cpumask. Also, take care of
+ * non-contigious bitmasks.
+ */
+static struct msr *alloc_msrs(const cpumask_t *mask)
+{
+	struct msr *msrs;
+	int i, first_cpu, last_cpu = 0;
+
+	if (cpumask_empty(mask)) {
+		amd64_printk(KERN_WARNING, "%s: Empty cpumask!\n", __func__);
+		return NULL;
+	}
+
+	first_cpu = cpumask_first(mask);
+	for (i = first_cpu; i < nr_cpu_ids; i++)
+		if (cpumask_test_cpu(i, mask))
+			last_cpu = i;
+
+	msrs = kzalloc(sizeof(*msrs) * (last_cpu - first_cpu + 1), GFP_KERNEL);
+	if (!msrs) {
+		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
+			      __func__);
+		 return NULL;
+	}
+
+	return msrs;
+}
+
+static void free_msrs(struct msr *msrs)
+{
+	 kfree(msrs);
+}
+
 /* check MCG_CTL on all the cpus on this node */
 static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 {
@@ -2755,12 +2800,9 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 
 	get_cpus_on_this_dct_cpumask(&mask, nid);
 
-	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(&mask), GFP_KERNEL);
-	if (!msrs) {
-		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
-			      __func__);
-		 return false;
-	}
+	msrs = alloc_msrs(&mask);
+	if (!msrs)
+		goto out_err;
 
 	rdmsr_on_cpus(&mask, MSR_IA32_MCG_CTL, msrs);
 
@@ -2779,7 +2821,9 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 	ret = true;
 
 out:
-	kfree(msrs);
+	free_msrs(msrs);
+
+out_err:
 	return ret;
 }
 

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

