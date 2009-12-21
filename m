Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbZLUOFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbZLUOFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZLUOFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:05:23 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:5798 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZLUOFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:05:22 -0500
X-SpamScore: -20
X-BigFish: VPS-20(z21eWzab9bh98dNzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KV09SN-02-0F5-02
X-M-MSG: 
Date: Mon, 21 Dec 2009 15:05:33 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Borislav Petkov <petkovbb@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc1
Message-ID: <20091221140533.GA14468@aftab>
References: <alpine.LFD.2.00.0912171745160.15740@localhost.localdomain>
 <64bb37e0912191154n4a7ea5benbb3da57f1aabdbe6@mail.gmail.com>
 <64bb37e0912200953j2046a935n2f9ecd2cdfed780f@mail.gmail.com>
 <20091220191436.GA3982@liondog.tnic>
 <64bb37e0912201136m5bd46867s73ddc43c85f80b38@mail.gmail.com>
 <64bb37e0912201140i772c8484h4662c2fea15a921a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <64bb37e0912201140i772c8484h4662c2fea15a921a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 21 Dec 2009 14:05:12.0608 (UTC) FILETIME=[9CF4A200:01CA8246]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 08:40:53PM +0100, Torsten Kaiser wrote:
> [    4.697308] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 838: F2x090 (DRAM Cfg Low): 0x00080810
> [    4.697311] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 842:   DIMM type: buffered; all DIMMs support ECC: yes
> [    4.697313] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 845:   PAR/ERR parity: disabled
> [    4.697315] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 848:   DCT 128bit mode width: 128b
> [    4.697317] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 854:   x4 logical DIMMs present: L0: no L1: no L2: no L3: no
> [    4.697319] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 873: F3xB0 (Online Spare): 0x0f000000
> [    4.697322] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 880: F1xF0 (DRAM Hole Address): 0x00000000, base: 0x00000000, offset: 0x00000000
> [    4.697324] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 883:   DramHoleValid: no
> [    4.697327] EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 1716: F2x080 (DRAM Bank Address Mapping): 0x00000002
> [    4.697328] EDAC MC: DCT0 chip selects:
> [    4.697330] EDAC MC:  0:   512MB 1:   512MB
> [    4.697331] EDAC MC:  2:     0MB 3:     0MB
> [    4.697333] EDAC MC:  4:     0MB 5:     0MB
> [    4.697334] EDAC MC:  6:     0MB 7:     0MB

Yes, you're correct. The DRAM controller is running in 128bit mode
and we should account for that. Turns out that there's more clumsy
stuff going on in the code wrt to channel accounting and I'll fix this
properly when I get the chance. Here's a temporary fix for now which
should solve your issue.

---
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 21 Dec 2009 14:52:53 +0100
Subject: [PATCH] amd64_edac: fix K8 chip select reporting

Fix the case when amd64_debug_display_dimm_sizes() reports only half the
amount of DRAM on it because it doesn't account for when the single DCT
operates in 128-bit mode and merges chip selects from different DIMMs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index df5b684..784cc5a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1700,11 +1700,14 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
  */
 static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 {
-	int dimm, size0, size1;
+	int dimm, size0, size1, factor = 0;
 	u32 dbam;
 	u32 *dcsb;
 
 	if (boot_cpu_data.x86 == 0xf) {
+		if (pvt->dclr0 & F10_WIDTH_128)
+			factor = 1;
+
 		/* K8 families < revF not supported yet */
 	       if (pvt->ext_model < K8_REV_F)
 			return;
@@ -1732,7 +1735,8 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 			size1 = pvt->ops->dbam_to_cs(pvt, DBAM_DIMM(dimm, dbam));
 
 		edac_printk(KERN_DEBUG, EDAC_MC, " %d: %5dMB %d: %5dMB\n",
-			    dimm * 2, size0, dimm * 2 + 1, size1);
+			    dimm * 2,     size0 << factor,
+			    dimm * 2 + 1, size1 << factor);
 	}
 }
 
-- 
1.6.5.4


-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

