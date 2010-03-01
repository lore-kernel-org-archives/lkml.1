Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0CAT6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:58:46 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19955 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0CAT6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:58:43 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh2a8h43h64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KYMCTJ-01-HAU-02
X-M-MSG: 
Date: Mon, 1 Mar 2010 20:58:41 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Doug Thompson <norsk5@yahoo.com>
CC: edac-devel <bluesmoke-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] amd64_edac: Simplify ECC override handling
Message-ID: <20100301195841.GA5096@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Mar 2010 19:58:32.0104 (UTC) FILETIME=[91C18280:01CAB979]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got only this fix for the current merge window. Will push to Linus
later if no objections.

--
No need for clearing ecc_enable_override and checking it in two places.
Instead, simply check it during probing and act accordingly. Also,
rename the flag bitfields according to the functionality they actually
represent. What is more, make sure original BIOS ECC settings are
restored when the module is unloaded.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   37 +++++++++++++++++++------------------
 drivers/edac/amd64_edac.h |    3 ++-
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 3391e67..dc9caab 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2553,14 +2553,14 @@ static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 
 		if (on) {
 			if (reg->l & K8_MSR_MCGCTL_NBE)
-				pvt->flags.ecc_report = 1;
+				pvt->flags.nb_mce_enable = 1;
 
 			reg->l |= K8_MSR_MCGCTL_NBE;
 		} else {
 			/*
-			 * Turn off ECC reporting only when it was off before
+			 * Turn off NB MCE reporting only when it was off before
 			 */
-			if (!pvt->flags.ecc_report)
+			if (!pvt->flags.nb_mce_enable)
 				reg->l &= ~K8_MSR_MCGCTL_NBE;
 		}
 	}
@@ -2571,22 +2571,11 @@ static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 	return 0;
 }
 
-/*
- * Only if 'ecc_enable_override' is set AND BIOS had ECC disabled, do "we"
- * enable it.
- */
 static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
-	if (!ecc_enable_override)
-		return;
-
-	amd64_printk(KERN_WARNING,
-		"'ecc_enable_override' parameter is active, "
-		"Enabling AMD ECC hardware now: CAUTION\n");
-
 	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCTL, &value);
 
 	/* turn on UECCn and CECCEn bits */
@@ -2611,6 +2600,8 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 			"This node reports that DRAM ECC is "
 			"currently Disabled; ENABLING now\n");
 
+		pvt->flags.nb_ecc_prev = 0;
+
 		/* Attempt to turn on DRAM ECC Enable */
 		value |= K8_NBCFG_ECC_ENABLE;
 		pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCFG, value);
@@ -2625,7 +2616,10 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 			amd64_printk(KERN_DEBUG,
 				"Hardware accepted DRAM ECC Enable\n");
 		}
+	} else {
+		pvt->flags.nb_ecc_prev = 1;
 	}
+
 	debugf0("NBCFG(2)= 0x%x  CHIPKILL= %s ECC_ENABLE= %s\n", value,
 		(value & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
 		(value & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled");
@@ -2644,12 +2638,18 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 	value &= ~mask;
 	value |= pvt->old_nbctl;
 
-	/* restore the NB Enable MCGCTL bit */
 	pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCTL, value);
 
+	/* restore previous BIOS DRAM ECC "off" setting which we force-enabled */
+	if (!pvt->flags.nb_ecc_prev) {
+		amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCFG, &value);
+		value &= ~K8_NBCFG_ECC_ENABLE;
+		pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCFG, value);
+	}
+
+	/* restore the NB Enable MCGCTL bit */
 	if (amd64_toggle_ecc_err_reporting(pvt, OFF))
-		amd64_printk(KERN_WARNING, "Error restoring ECC reporting over "
-					   "MCGCTL!\n");
+		amd64_printk(KERN_WARNING, "Error restoring NB MCGCTL settings!\n");
 }
 
 /*
@@ -2690,8 +2690,9 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 		if (!ecc_enable_override) {
 			amd64_printk(KERN_NOTICE, "%s", ecc_msg);
 			return -ENODEV;
+		} else {
+			amd64_printk(KERN_WARNING, "Forcing ECC checking on!\n");
 		}
-		ecc_enable_override = 0;
 	}
 
 	return 0;
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 41bc561..0d4bf56 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -487,7 +487,8 @@ struct amd64_pvt {
 	/* misc settings */
 	struct flags {
 		unsigned long cf8_extcfg:1;
-		unsigned long ecc_report:1;
+		unsigned long nb_mce_enable:1;
+		unsigned long nb_ecc_prev:1;
 	} flags;
 };
 
-- 
1.6.6.1


-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center

