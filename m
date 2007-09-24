Return-Path: <linux-kernel-owner+w=401wt.eu-S1763362AbXIXRPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763362AbXIXRPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbXIXRPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:15:03 -0400
Received: from mail0.scram.de ([78.47.204.202]:47522 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760527AbXIXRPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:15:00 -0400
X-Spam-Score: -3.885
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <46F7F091.7000406@scram.de>
Date: Mon, 24 Sep 2007 19:14:57 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linuxppc-embedded@ozlabs.org
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH#2 2/4] [PPC] Fix cpm_dpram_addr returning phys mem instead
 of virt mem
Content-Type: multipart/mixed;
 boundary="------------080108060506090808090900"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080108060506090808090900
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

cpm_dpram_addr returns physical memory of the DP RAM instead of
iomapped virtual memory. As there usually is a 1:1 MMU map of
the IMMR area, this is often not noticed. However, cpm_dpram_phys
assumes this iomapped virtual memory and returns garbage on the
1:1 mapped memory causing CPM1 uart console to fail.

This patch fixes the problem (copied from the powerpc tree).

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/ppc/8xx_io/commproc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--------------080108060506090808090900
Content-Type: text/x-patch;
 name="e99a679ff14fb0073efd9220f5aa933e47516202.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="e99a679ff14fb0073efd9220f5aa933e47516202.diff"

diff --git a/arch/ppc/8xx_io/commproc.c b/arch/ppc/8xx_io/commproc.c
index 7088428..9da880b 100644
--- a/arch/ppc/8xx_io/commproc.c
+++ b/arch/ppc/8xx_io/commproc.c
@@ -459,7 +459,7 @@ EXPORT_SYMBOL(cpm_dpdump);
 
 void *cpm_dpram_addr(unsigned long offset)
 {
-	return ((immap_t *)IMAP_ADDR)->im_cpm.cp_dpmem + offset;
+	return (void *)(dpram_vbase + offset);
 }
 EXPORT_SYMBOL(cpm_dpram_addr);
 


--------------080108060506090808090900--
