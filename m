Return-Path: <linux-kernel-owner+w=401wt.eu-S1761906AbZEOMxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906AbZEOMxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760131AbZEOMx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:53:29 -0400
Received: from mail-sin.bigfish.com ([207.46.51.100]:60312 "EHLO
	mail25-sin-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758681AbZEOMx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:53:27 -0400
X-BigFish: VPS0(zz936eN14e1Jzz1202hzzz32i68o)
X-Spam-TCS-SCL: 7:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0KJOQDY-02-5LO-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
Cc: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 19/22] amd64_edac: add error decoding logic
Date: Fri, 15 May 2009 14:22:30 +0200
Message-Id: <1242390153-24493-20-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 15 May 2009 12:22:50.0821 (UTC) FILETIME=[DD494F50:01C9D557]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Borislav:

- fold amd64_error_info_valid() into its only user
- fix/cleanup comments
- fix function return value patterns
- cleanup debug calls

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  425 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 425 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 68b5892..2807c97 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2030,3 +2030,428 @@ static int get_channel_from_ecc_syndrome(unsigned short syndrome)
 	debugf0("syndrome(%x) not found\n", syndrome);
 	return -1;
 }
+
+/*
+ * Check for valid error in the NB Status High register. If so, proceed to read
+ * NB Status Low, NB Address Low and NB Address High registers and store data
+ * into error structure.
+ *
+ * Returns:
+ *	- 1: if hardware regs contains valid error info
+ *	- 0: if no valid error is indicated
+ */
+static int amd64_get_error_info_regs(struct mem_ctl_info *mci,
+				     struct amd64_error_info_regs *regs)
+{
+	struct amd64_pvt *pvt;
+	struct pci_dev *misc_f3_ctl;
+	int err = 0;
+
+	pvt = mci->pvt_info;
+	misc_f3_ctl = pvt->misc_f3_ctl;
+
+	err = pci_read_config_dword(misc_f3_ctl, K8_NBSH, &regs->nbsh);
+	if (err)
+		goto err_reg;
+
+	if (!(regs->nbsh & K8_NBSH_VALID_BIT))
+		return 0;
+
+	/* valid error, read remaining error information registers */
+	err = pci_read_config_dword(misc_f3_ctl, K8_NBSL, &regs->nbsl);
+	if (err)
+		goto err_reg;
+
+	err = pci_read_config_dword(misc_f3_ctl, K8_NBEAL, &regs->nbeal);
+	if (err)
+		goto err_reg;
+
+	err = pci_read_config_dword(misc_f3_ctl, K8_NBEAH, &regs->nbeah);
+	if (err)
+		goto err_reg;
+
+	err = pci_read_config_dword(misc_f3_ctl, K8_NBCFG, &regs->nbcfg);
+	if (err)
+		goto err_reg;
+
+	return 1;
+
+err_reg:
+	debugf0("Reading error info register failed\n");
+	return 0;
+}
+
+/*
+ * This function is called to retrieve the error data from hardware and store it
+ * in the info structure.
+ *
+ * Returns:
+ *	- 1: if a valid error is found
+ *	- 0: if no error is found
+ */
+static int amd64_get_error_info(struct mem_ctl_info *mci,
+				struct amd64_error_info_regs *info)
+{
+	struct amd64_pvt *pvt;
+	struct amd64_error_info_regs regs;
+
+	pvt = mci->pvt_info;
+
+	if (!amd64_get_error_info_regs(mci, info))
+		return 0;
+
+	/*
+	 * Here's the problem with the K8's EDAC reporting: There are four
+	 * registers which report pieces of error information. They are shared
+	 * between CEs and UEs. Furthermore, contrary to what is stated in the
+	 * BKDG, the overflow bit is never used! Every error always updates the
+	 * reporting registers.
+	 *
+	 * Can you see the race condition? All four error reporting registers
+	 * must be read before a new error updates them! There is no way to read
+	 * all four registers atomically. The best than can be done is to detect
+	 * that a race has occured and then report the error without any kind of
+	 * precision.
+	 *
+	 * What is still positive is that errors are still reported and thus
+	 * problems can still be detected - just not localized because the
+	 * syndrome and address are spread out across registers.
+	 *
+	 * Grrrrr!!!!!  Here's hoping that AMD fixes this in some future K8 rev.
+	 * UEs and CEs should have separate register sets with proper overflow
+	 * bits that are used! At very least the problem can be fixed by
+	 * honoring the ErrValid bit in 'nbsh' and not updating registers - just
+	 * set the overflow bit - unless the current error is CE and the new
+	 * error is UE which would be the only situation for overwriting the
+	 * current values.
+	 */
+
+	regs = *info;
+
+	/* Use info from the second read - most current */
+	if (unlikely(!amd64_get_error_info_regs(mci, info)))
+		return 0;
+
+	/* clear the error bits in hardware */
+	pci_write_bits32(pvt->misc_f3_ctl, K8_NBSH, 0, K8_NBSH_VALID_BIT);
+
+	/* Check for the possible race condition */
+	if ((regs.nbsh != info->nbsh) ||
+	     (regs.nbsl != info->nbsl) ||
+	     (regs.nbeah != info->nbeah) ||
+	     (regs.nbeal != info->nbeal)) {
+		amd64_mc_printk(mci, KERN_WARNING,
+				"hardware STATUS read access race condition "
+				"detected!\n");
+		return 0;
+	}
+	return 1;
+}
+
+static inline void amd64_decode_gart_tlb_error(struct mem_ctl_info *mci,
+					 struct amd64_error_info_regs *info)
+{
+	u32 err_code;
+	u32 ec_tt;		/* error code transaction type (2b) */
+	u32 ec_ll;		/* error code cache level (2b) */
+
+	err_code = EXTRACT_ERROR_CODE(info->nbsl);
+	ec_ll = EXTRACT_LL_CODE(err_code);
+	ec_tt = EXTRACT_TT_CODE(err_code);
+
+	amd64_mc_printk(mci, KERN_ERR,
+		     "GART TLB event: transaction type(%s), "
+		     "cache level(%s)\n", tt_msgs[ec_tt], ll_msgs[ec_ll]);
+}
+
+static inline void amd64_decode_mem_cache_error(struct mem_ctl_info *mci,
+				      struct amd64_error_info_regs *info)
+{
+	u32 err_code;
+	u32 ec_rrrr;		/* error code memory transaction (4b) */
+	u32 ec_tt;		/* error code transaction type (2b) */
+	u32 ec_ll;		/* error code cache level (2b) */
+
+	err_code = EXTRACT_ERROR_CODE(info->nbsl);
+	ec_ll = EXTRACT_LL_CODE(err_code);
+	ec_tt = EXTRACT_TT_CODE(err_code);
+	ec_rrrr = EXTRACT_RRRR_CODE(err_code);
+
+	amd64_mc_printk(mci, KERN_ERR,
+		     "cache hierarchy error: memory transaction type(%s), "
+		     "transaction type(%s), cache level(%s)\n",
+		     rrrr_msgs[ec_rrrr], tt_msgs[ec_tt], ll_msgs[ec_ll]);
+}
+
+
+/*
+ * Handle any Correctable Errors (CEs) that have occurred. Check for valid ERROR
+ * ADDRESS and process.
+ */
+static void amd64_handle_ce(struct mem_ctl_info *mci,
+			    struct amd64_error_info_regs *info)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	u64 SystemAddress;
+
+	/* Ensure that the Error Address is VALID */
+	if ((info->nbsh & K8_NBSH_VALID_ERROR_ADDR) == 0) {
+		amd64_mc_printk(mci, KERN_ERR,
+			"HW has no ERROR_ADDRESS available\n");
+		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		return;
+	}
+
+	SystemAddress = extract_error_address(mci, info);
+
+	amd64_mc_printk(mci, KERN_ERR,
+		"CE ERROR_ADDRESS= 0x%llx\n", SystemAddress);
+
+	pvt->ops->map_sysaddr_to_csrow(mci, info, SystemAddress);
+}
+
+/* Handle any Un-correctable Errors (UEs) */
+static void amd64_handle_ue(struct mem_ctl_info *mci,
+			    struct amd64_error_info_regs *info)
+{
+	int csrow;
+	u64 SystemAddress;
+	u32 page, offset;
+	struct mem_ctl_info *log_mci, *src_mci = NULL;
+
+	log_mci = mci;
+
+	if ((info->nbsh & K8_NBSH_VALID_ERROR_ADDR) == 0) {
+		amd64_mc_printk(mci, KERN_CRIT,
+			"HW has no ERROR_ADDRESS available\n");
+		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		return;
+	}
+
+	SystemAddress = extract_error_address(mci, info);
+
+	/*
+	 * Find out which node the error address belongs to. This may be
+	 * different from the node that detected the error.
+	 */
+	src_mci = find_mc_by_sys_addr(mci, SystemAddress);
+	if (!src_mci) {
+		amd64_mc_printk(mci, KERN_CRIT,
+			"ERROR ADDRESS (0x%lx) value NOT mapped to a MC\n",
+			(unsigned long)SystemAddress);
+		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+		return;
+	}
+
+	log_mci = src_mci;
+
+	csrow = sys_addr_to_csrow(log_mci, SystemAddress);
+	if (csrow < 0) {
+		amd64_mc_printk(mci, KERN_CRIT,
+			"ERROR_ADDRESS (0x%lx) value NOT mapped to 'csrow'\n",
+			(unsigned long)SystemAddress);
+		edac_mc_handle_ue_no_info(log_mci, EDAC_MOD_STR);
+	} else {
+		error_address_to_page_and_offset(SystemAddress, &page, &offset);
+		edac_mc_handle_ue(log_mci, page, offset, csrow, EDAC_MOD_STR);
+	}
+}
+
+static void amd64_decode_bus_error(struct mem_ctl_info *mci,
+				   struct amd64_error_info_regs *info)
+{
+	u32 err_code, ext_ec;
+	u32 ec_pp;		/* error code participating processor (2p) */
+	u32 ec_to;		/* error code timed out (1b) */
+	u32 ec_rrrr;		/* error code memory transaction (4b) */
+	u32 ec_ii;		/* error code memory or I/O (2b) */
+	u32 ec_ll;		/* error code cache level (2b) */
+
+	ext_ec = EXTRACT_EXT_ERROR_CODE(info->nbsl);
+	err_code = EXTRACT_ERROR_CODE(info->nbsl);
+
+	ec_ll = EXTRACT_LL_CODE(err_code);
+	ec_ii = EXTRACT_II_CODE(err_code);
+	ec_rrrr = EXTRACT_RRRR_CODE(err_code);
+	ec_to = EXTRACT_TO_CODE(err_code);
+	ec_pp = EXTRACT_PP_CODE(err_code);
+
+	amd64_mc_printk(mci, KERN_ERR,
+		"BUS ERROR:\n"
+		"  time-out(%s) mem or i/o(%s)\n"
+		"  participating processor(%s)\n"
+		"  memory transaction type(%s)\n"
+		"  cache level(%s) Error Found by: %s\n",
+		to_msgs[ec_to],
+		ii_msgs[ec_ii],
+		pp_msgs[ec_pp],
+		rrrr_msgs[ec_rrrr],
+		ll_msgs[ec_ll],
+		(info->nbsh & K8_NBSH_ERR_SCRUBER) ?
+			"Scrubber" : "Normal Operation");
+
+	/* If this was an 'observed' error, early out */
+	if (ec_pp == K8_NBSL_PP_OBS)
+		return;		/* We aren't the node involved */
+
+	/* Parse out the extended error code for ECC events */
+	switch (ext_ec) {
+	/* F10 changed to one Extended ECC error code */
+	case F10_NBSL_EXT_ERR_RES:		/* Reserved field */
+	case F10_NBSL_EXT_ERR_ECC:		/* F10 ECC ext err code */
+		break;
+
+	default:
+		amd64_mc_printk(mci, KERN_ERR, "NOT ECC: no special error "
+					       "handling for this error\n");
+		return;
+	}
+
+	if (info->nbsh & K8_NBSH_CECC)
+		amd64_handle_ce(mci, info);
+	else if (info->nbsh & K8_NBSH_UECC)
+		amd64_handle_ue(mci, info);
+
+	/*
+	 * If main error is CE then overflow must be CE.  If main error is UE
+	 * then overflow is unknown.  We'll call the overflow a CE - if
+	 * panic_on_ue is set then we're already panic'ed and won't arrive
+	 * here. Else, then apparently someone doesn't think that UE's are
+	 * catastrophic.
+	 */
+	if (info->nbsh & K8_NBSH_OVERFLOW)
+		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR
+					  "Error Overflow set");
+}
+
+int amd64_process_error_info(struct mem_ctl_info *mci,
+			     struct amd64_error_info_regs *info,
+			     int handle_errors)
+{
+	struct amd64_pvt *pvt;
+	struct amd64_error_info_regs *regs;
+	u32 err_code, ext_ec;
+	int gart_tlb_error = 0;
+
+	pvt = mci->pvt_info;
+
+	/* If caller doesn't want us to process the error, return */
+	if (!handle_errors)
+		return 1;
+
+	regs = info;
+
+	debugf1("NorthBridge ERROR: mci(0x%p)\n", mci);
+	debugf1("  MC node(%d) Error-Address(0x%.8x-%.8x)\n",
+		pvt->mc_node_id, regs->nbeah, regs->nbeal);
+	debugf1("  nbsh(0x%.8x) nbsl(0x%.8x)\n",
+		regs->nbsh, regs->nbsl);
+	debugf1("  Valid Error=%s Overflow=%s\n",
+		(regs->nbsh & K8_NBSH_VALID_BIT) ? "True" : "False",
+		(regs->nbsh & K8_NBSH_OVERFLOW) ? "True" : "False");
+	debugf1("  Err Uncorrected=%s MCA Error Reporting=%s\n",
+		(regs->nbsh & K8_NBSH_UNCORRECTED_ERR) ?
+			"True" : "False",
+		(regs->nbsh & K8_NBSH_ERR_ENABLE) ?
+			"True" : "False");
+	debugf1("  MiscErr Valid=%s ErrAddr Valid=%s PCC=%s\n",
+		(regs->nbsh & K8_NBSH_MISC_ERR_VALID) ?
+			"True" : "False",
+		(regs->nbsh & K8_NBSH_VALID_ERROR_ADDR) ?
+			"True" : "False",
+		(regs->nbsh & K8_NBSH_PCC) ?
+			"True" : "False");
+	debugf1("  CECC=%s UECC=%s Found by Scruber=%s\n",
+		(regs->nbsh & K8_NBSH_CECC) ?
+			"True" : "False",
+		(regs->nbsh & K8_NBSH_UECC) ?
+			"True" : "False",
+		(regs->nbsh & K8_NBSH_ERR_SCRUBER) ?
+			"True" : "False");
+	debugf1("  CORE0=%s CORE1=%s CORE2=%s CORE3=%s\n",
+		(regs->nbsh & K8_NBSH_CORE0) ? "True" : "False",
+		(regs->nbsh & K8_NBSH_CORE1) ? "True" : "False",
+		(regs->nbsh & K8_NBSH_CORE2) ? "True" : "False",
+		(regs->nbsh & K8_NBSH_CORE3) ? "True" : "False");
+
+
+	err_code = EXTRACT_ERROR_CODE(regs->nbsl);
+
+	/* Determine which error type:
+	 *	1) GART errors - non-fatal, developmental events
+	 *	2) MEMORY errors
+	 *	3) BUS errors
+	 *	4) Unknown error
+	 */
+	if (TEST_TLB_ERROR(err_code)) {
+		/*
+		 * GART errors are intended to help graphics driver developers
+		 * to detect bad GART PTEs. It is recommended by AMD to disable
+		 * GART table walk error reporting by default[1] (currently
+		 * being disabled in mce_cpu_quirks()) and according to the
+		 * comment in mce_cpu_quirks(), such GART errors can be
+		 * incorrectly triggered. We may see these errors anyway and
+		 * unless requested by the user, they won't be reported.
+		 *
+		 * [1] section 13.10.1 on BIOS and Kernel Developers Guide for
+		 *     AMD NPT family 0Fh processors
+		 */
+		if (report_gart_errors == 0)
+			return 1;
+
+		/*
+		 * Only if GART error reporting is requested should we generate
+		 * any logs.
+		 */
+		gart_tlb_error = 1;
+
+		debugf1("GART TLB error\n");
+		amd64_decode_gart_tlb_error(mci, info);
+	} else if (TEST_MEM_ERROR(err_code)) {
+		debugf1("Memory/Cache error\n");
+		amd64_decode_mem_cache_error(mci, info);
+	} else if (TEST_BUS_ERROR(err_code)) {
+		debugf1("Bus (Link/DRAM) error\n");
+		amd64_decode_bus_error(mci, info);
+	} else {
+		/* shouldn't reach here! */
+		amd64_mc_printk(mci, KERN_WARNING,
+			     "%s(): unknown MCE error 0x%x\n", __func__,
+			     err_code);
+	}
+
+	ext_ec = EXTRACT_EXT_ERROR_CODE(regs->nbsl);
+	amd64_mc_printk(mci, KERN_ERR,
+		"ExtErr=(0x%x) %s\n", ext_ec, ext_msgs[ext_ec]);
+
+	if (((ext_ec >= F10_NBSL_EXT_ERR_CRC &&
+			ext_ec <= F10_NBSL_EXT_ERR_TGT) ||
+			(ext_ec == F10_NBSL_EXT_ERR_RMW)) &&
+			EXTRACT_LDT_LINK(info->nbsh)) {
+
+		amd64_mc_printk(mci, KERN_ERR,
+			"Error on hypertransport link: %s\n",
+			htlink_msgs[
+			EXTRACT_LDT_LINK(info->nbsh)]);
+	}
+
+	/*
+	 * Check the UE bit of the NB status high register, if set generate some
+	 * logs. If NOT a GART error, then process the event as a NO-INFO event.
+	 * If it was a GART error, skip that process.
+	 */
+	if (regs->nbsh & K8_NBSH_UNCORRECTED_ERR) {
+		amd64_mc_printk(mci, KERN_CRIT, "uncorrected error\n");
+		if (!gart_tlb_error)
+			edac_mc_handle_ue_no_info(mci, "UE bit is set\n");
+	}
+
+	if (regs->nbsh & K8_NBSH_PCC)
+		amd64_mc_printk(mci, KERN_CRIT,
+			"PCC (processor context corrupt) set\n");
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(amd64_process_error_info);
+
+
-- 
1.6.2.4


