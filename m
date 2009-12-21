Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbZLUPSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbZLUPSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZLUPSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:18:15 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:33193 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZLUPSO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:18:14 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zzab9bh1432R98dN148cMzz1202hzz5a6ciz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KV0D5X-01-L6V-02
X-M-MSG: 
Date: Mon, 21 Dec 2009 16:18:19 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Darren Jenkins <darrenrjenkins@gmail.com>
CC: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dougthompson@xmission.com, bluesmoke-devel@lists.sourceforge.net
Subject: Re: drivers/edac/ move a kfree() to after last use
Message-ID: <20091221151819.GA16432@aftab>
References: <1261370306.11354.52.camel@ICE-BOX>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1261370306.11354.52.camel@ICE-BOX>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 21 Dec 2009 15:17:58.0406 (UTC) FILETIME=[C72C8A60:01CA8250]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 03:38:26PM +1100, Darren Jenkins wrote:
> 
> Move a kfree() below the last use of the memory
> 
> Coverity CID: 13142
> 
> Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>

Thanks for catching that. Here's a better version that does all the
freeing at the end of the function.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 21 Dec 2009 15:15:59 +0100
Subject: [PATCH] amd64_edac: fix driver instance freeing

Fix use-after-free errors by pushing all memory-freeing calls to the end
of amd64_remove_one_instance().

Reported-by: Darren Jenkins <darrenrjenkins@gmail.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 784cc5a..fb0d36b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2929,16 +2929,15 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 
 	amd64_free_mc_sibling_devices(pvt);
 
-	kfree(pvt);
-	mci->pvt_info = NULL;
-
-	mci_lookup[pvt->mc_node_id] = NULL;
-
 	/* unregister from EDAC MCE */
 	amd_report_gart_errors(false);
 	amd_unregister_ecc_decoder(amd64_decode_bus_error);
 
 	/* Free the EDAC CORE resources */
+	mci->pvt_info = NULL;
+	mci_lookup[pvt->mc_node_id] = NULL;
+
+	kfree(pvt);
 	edac_mc_free(mci);
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

