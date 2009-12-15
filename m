Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbZLOPay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbZLOPay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbZLOPap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:30:45 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:26742 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759244AbZLOPam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:30:42 -0500
X-SpamScore: -25
X-BigFish: VPS-25(z21eWzab9bh98dN936eMzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUP9QF-01-AZJ-02
X-M-MSG: 
Date: Tue, 15 Dec 2009 16:30:26 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
CC: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org,
       osrc-patches <osrc-patches@elbe.amd.com>
Subject: Re: K8 ECC error with linux-2.6.32
Message-ID: <20091215153026.GD20880@aftab>
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
 <200912141426.46361.johannes.hirte@fem.tu-ilmenau.de>
 <20091214222331.GB32614@liondog.tnic>
 <200912150808.04814.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200912150808.04814.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Dec 2009 15:30:15.0940 (UTC) FILETIME=[804CCC40:01CA7D9B]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 08:08:04AM +0100, Johannes Hirte wrote:
>  Northbridge Error, node 0, core: -1
> amd_decode_nb_mce: NBSL: 0x0005001b, NBSL: 0xa4000000
> K8 ECC error.

Yep, this is a benign GART TLB error which is not being reported but
you're using the amd64_edac module and it trips since the error is still
being logged and the module sees it. There are two fixes:

1. If you have a BIOS option with a wording like:

"Gart Table Walk Error MC reporting: Disabled/Enabled."

which should disable it.

2. If no BIOS option, the patch below should fix it. Can you please
test (against v2.6.32).

Thanks.

---
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 713ed7d..026f0cb 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -300,6 +300,12 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 	if (!handle_errors)
 		return;
 
+	/*
+	 * GART TLB error reporting is disabled by default. Bail out early.
+	 */
+	if (TLB_ERROR(ec) && !report_gart_errors)
+		return;
+
 	pr_emerg(" Northbridge Error, node %d", node_id);
 
 	/*
@@ -311,10 +317,9 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 		if (regs->nbsh & K8_NBSH_ERR_CPU_VAL)
 			pr_cont(", core: %u\n", (u8)(regs->nbsh & 0xf));
 	} else {
-		pr_cont(", core: %d\n", ilog2((regs->nbsh & 0xf)));
+		pr_cont(", core: %d\n", fls((regs->nbsh & 0xf) - 1));
 	}
 
-
 	pr_emerg("%s.\n", EXT_ERR_MSG(xec));
 
 	if (BUS_ERROR(ec) && nb_bus_decoder)
@@ -334,21 +339,6 @@ static void amd_decode_fr_mce(u64 mc5_status)
 static inline void amd_decode_err_code(unsigned int ec)
 {
 	if (TLB_ERROR(ec)) {
-		/*
-		 * GART errors are intended to help graphics driver developers
-		 * to detect bad GART PTEs. It is recommended by AMD to disable
-		 * GART table walk error reporting by default[1] (currently
-		 * being disabled in mce_cpu_quirks()) and according to the
-		 * comment in mce_cpu_quirks(), such GART errors can be
-		 * incorrectly triggered. We may see these errors anyway and
-		 * unless requested by the user, they won't be reported.
-		 *
-		 * [1] section 13.10.1 on BIOS and Kernel Developers Guide for
-		 *     AMD NPT family 0Fh processors
-		 */
-		if (!report_gart_errors)
-			return;
-
 		pr_emerg(" Transaction: %s, Cache Level %s\n",
 			 TT_MSG(ec), LL_MSG(ec));
 	} else if (MEM_ERROR(ec)) {

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

