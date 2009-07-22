Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbZGVOYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbZGVOYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbZGVOYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:24:05 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:39537 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbZGVOYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:24:04 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz1432R98dN936eMzz1202hzzz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KN6TBL-01-BXT-01
Date: Wed, 22 Jul 2009 16:21:09 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: dougthompson@xmission.com
CC: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] edac: fix amd64_edac ecc probe
Message-ID: <20090722142101.GA1366@aftab>
References: <4a66a2fa.nomWoVo6gwi9Ls7j%dougthompson@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4a66a2fa.nomWoVo6gwi9Ls7j%dougthompson@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Jul 2009 14:21:12.0138 (UTC) FILETIME=[AA174AA0:01CA0AD7]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 21, 2009 at 11:26:18PM -0600, dougthompson@xmission.com wrote:
> From: Doug Thompson <dougthompson@xmission.com>
> 
> 1) Current code indicates an error and the amd64_edac module
> fails to complete initialization, but remains loaded in memory:
> 
> On the good path of BIOS enabled ECC and no override, the 'ret' value is 1 by
> omission and returns a non-zero failure code to the probe() function.
> 
> This in turns fails the initialization code path. Added an explicit setting
> of ret = 0 on a success, thus allowing the module to properly initialize.

Instead of clearing 'ret' at several places in the if-else branching
of amd64_check_ecc_enabled(), I went and radically cleaned up that
function, see below. Now it is much more readable, IMHO, and half the
size. Please do test and let me know if it works for you.

> (interesting result of the pci_probe is even though an error is returned
> by EDAC to the PCI probing code, the module remains IN memory and loaded.
> Manual rmmod is necessary. Upon reading the pci probe code, it indicates
> allowing "other" drivers to attempt to attach to it. This seems to be
> a bug to me on the part of the PCI probing code, leaving the module 
> LOADED when it indicates failure)

Off the top of my head, we're missing a pci_disable_device() in
amd64_init_one_instance() for error values of ret but I don't think
that'll influence module unloading on error status. We should look into
it more carefully though when possible.

> 2) Added explicit returns above a above a couple of error exits,
> so that successful exiting would not leave debug output, indicating a
> false error condition

That's a real bug, please respin your patch after we've agreed on the
previous one so that I could send the fixes in the next couple of days.

Thanks.

> 3) Align TOP_MEM output
> 
> 
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> ---
>  amd64_edac.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.31-rc3/drivers/edac/amd64_edac.c
> ===================================================================
> --- linux-2.6.31-rc3.orig/drivers/edac/amd64_edac.c	2009-07-20 20:55:57.000000000 -0600
> +++ linux-2.6.31-rc3/drivers/edac/amd64_edac.c	2009-07-20 21:21:33.000000000 -0600
> @@ -868,8 +868,10 @@ static void amd64_read_dbam_reg(struct a
>  			goto err_reg;
>  	}
>  
> +	return;
> +
>  err_reg:
> -	debugf0("Error reading F2x%03x.\n", reg);
> +	debugf0("Error (%d) reading F2x%03x.\n", err, reg);

No need for the printing the error here since it can be only -EINVAL.

>  }
>  

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 22 Jul 2009 15:39:00 +0200
Subject: [PATCH] amd64_edac: cleanup amd64_check_ecc_enabled

Simplify code flow and make sure return value is always valid since
further driver init depends on it. Carve out long warning string and
make code more readable.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   70 +++++++++++++++-----------------------------
 1 files changed, 24 insertions(+), 46 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 858fe60..0d3a1e7 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2904,7 +2904,7 @@ static void check_mcg_ctl(void *ret)
 }
 
 /* check MCG_CTL on all the cpus on this node */
-static int amd64_mcg_ctl_enabled_on_cpus(const cpumask_t *mask)
+static int mcg_ctl_enabled_on_node(const cpumask_t *mask)
 {
 	int ret = 1;
 	preempt_disable();
@@ -2920,66 +2920,44 @@ static int amd64_mcg_ctl_enabled_on_cpus(const cpumask_t *mask)
  * the memory system completely. A command line option allows to force-enable
  * hardware ECC later in amd64_enable_ecc_error_reporting().
  */
+static const char *ecc_warning =
+	"WARNING: ECC is disabled by BIOS. Module will NOT be loaded.\n"
+	" Either Enable ECC in the BIOS, or set 'ecc_enable_override'.\n"
+	" Also, use of the override can cause unknown side effects.\n";
+
 static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 {
 	u32 value;
-	int err = 0, ret = 0;
-	u8 ecc_enabled = 0;
+	int err = 0, ret;
+	u8 ecc_enabled = 0, mcg_ctl_en = 0;
 
 	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
 	if (err)
 		debugf0("Reading K8_NBCTL failed\n");
 
 	ecc_enabled = !!(value & K8_NBCFG_ECC_ENABLE);
+	if (!ecc_enabled)
+		amd64_printk(KERN_WARNING, "This node reports that Memory ECC "
+			     "is currently disabled, set F3x%x[22] (%s).\n",
+			     K8_NBCFG, pci_name(pvt->misc_f3_ctl));
+	else
+		amd64_printk(KERN_INFO, "ECC is enabled by BIOS.\n");
 
-	ret = amd64_mcg_ctl_enabled_on_cpus(cpumask_of_node(pvt->mc_node_id));
-
-	debugf0("K8_NBCFG=0x%x,  DRAM ECC is %s\n", value,
-			(value & K8_NBCFG_ECC_ENABLE ? "enabled" : "disabled"));
-
-	if (!ecc_enabled || !ret) {
-		if (!ecc_enabled) {
-			amd64_printk(KERN_WARNING, "This node reports that "
-						   "Memory ECC is currently "
-						   "disabled.\n");
+	mcg_ctl_en = mcg_ctl_enabled_on_node(cpumask_of_node(pvt->mc_node_id));
+	if (!mcg_ctl_en)
+		amd64_printk(KERN_WARNING, "NB MCE bank disabled, set MSR "
+			     "0x%08x[4] on node %d to enable.\n",
+			     MSR_IA32_MCG_CTL, pvt->mc_node_id);
 
-			amd64_printk(KERN_WARNING, "bit 0x%lx in register "
-				"F3x%x of the MISC_CONTROL device (%s) "
-				"should be enabled\n", K8_NBCFG_ECC_ENABLE,
-				K8_NBCFG, pci_name(pvt->misc_f3_ctl));
-		}
-		if (!ret) {
-			amd64_printk(KERN_WARNING, "bit 0x%016lx in MSR 0x%08x "
-					"of node %d should be enabled\n",
-					K8_MSR_MCGCTL_NBE, MSR_IA32_MCG_CTL,
-					pvt->mc_node_id);
-		}
+	ret = 0;
+	if (!ecc_enabled || !mcg_ctl_en) {
 		if (!ecc_enable_override) {
-			amd64_printk(KERN_WARNING, "WARNING: ECC is NOT "
-				"currently enabled by the BIOS. Module "
-				"will NOT be loaded.\n"
-				"    Either Enable ECC in the BIOS, "
-				"or use the 'ecc_enable_override' "
-				"parameter.\n"
-				"    Might be a BIOS bug, if BIOS says "
-				"ECC is enabled\n"
-				"    Use of the override can cause "
-				"unknown side effects.\n");
+			amd64_printk(KERN_WARNING, "%s", ecc_warning);
 			ret = -ENODEV;
-		} else
-			/*
-			 * enable further driver loading if ECC enable is
-			 * overridden.
-			 */
-			ret = 0;
-	} else {
-		amd64_printk(KERN_INFO,
-			"ECC is enabled by BIOS, Proceeding "
-			"with EDAC module initialization\n");
-
+		}
+	} else
 		/* CLEAR the override, since BIOS controlled it */
 		ecc_enable_override = 0;
-	}
 
 	return ret;
 }
-- 
1.6.3.3

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

