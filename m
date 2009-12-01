Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbZLAPQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbZLAPQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZLAPQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:16:52 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:29102
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750815AbZLAPQv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:16:51 -0500
X-SpamScore: -21
X-BigFish: VPS-21(z21eWz179dN1102Kzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTZBRP-01-M43-02
X-M-MSG: 
Date: Tue, 1 Dec 2009 16:16:39 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Borislav Petkov <petkovbb@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: 2.6.32-rc8: amd64_edac slub error
Message-ID: <20091201151639.GA670@aftab>
References: <4B1400B3.60300@oracle.com>
 <20091130203547.GA2838@liondog.tnic>
 <20091130141629.44401d86.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091130141629.44401d86.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 01 Dec 2009 15:16:38.0497 (UTC) FILETIME=[47486510:01CA7299]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2367:     DRAM MEM-CTL PCI Bus ID:	0000:00:18.2
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2369:     Misc device PCI Bus ID:	0000:00:18.3
> calling  alsa_pcm_init+0x0/0x71 [snd_pcm] @ 1402
> initcall alsa_pcm_init+0x0/0x71 [snd_pcm] returned 0 after 17 usecs
> EDAC amd64: ECC is enabled by BIOS.
> get_cpus_on_this_dct_cpumask: nid: 0, cpu: 0
> get_cpus_on_this_dct_cpumask: nid: 0, cpu: 2
> amd64_nb_mce_bank_enabled_on_node: weight: 2
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2776: core: 0, MCG_CTL: 0x1f, NB MSR is enabled
> EDAC DEBUG: in drivers/edac/amd64_edac.c, line at 2776: core: 2, MCG_CTL: 0x0, NB MSR is disabled
> =============================================================================
> BUG kmalloc-16: Redzone overwritten
> -----------------------------------------------------------------------------

Hmm, I think I know what happens. This machine has non-contigious
core enumeration on a node (e.g. 0,2 on node 0 instead of 0,1) but
rdmsr_on_cpus assumes the former. Therefore we write outside of the
allocated msrs struct and thus the redzone overwrite. Here's a simple
fix that should take care of it. Please apply on top of the debugging
patch and catch the output again so that we could verify it.

I'll fix this properly when I get back and then maybe even backport it
depending on the intrusiveness of the changes.

Thanks.

---
 drivers/edac/amd64_edac.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 139bc14..c013261 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2750,7 +2750,8 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 {
 	cpumask_t mask;
 	struct msr *msrs;
-	int cpu, nbe, idx = 0;
+	int cpu, nbe, i, idx = 0;
+	int first_cpu, last_cpu = 0;
 	bool ret = false;
 
 	cpumask_clear(&mask);
@@ -2759,7 +2760,17 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 
 	pr_err("%s: weight: %d\n", __func__, cpumask_weight(&mask));
 
-	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(&mask), GFP_KERNEL);
+	/*
+	 * calc. cores interval when non-contigious core enumeration
+	 */
+	first_cpu = cpumask_first(&mask);
+
+	for (i = first_cpu; i < nr_cpu_ids; i++)
+		if (cpumask_test_cpu(i, &mask))
+			last_cpu = i;
+
+	msrs = kzalloc(sizeof(struct msr) * (last_cpu - first_cpu + 1),
+		       GFP_KERNEL);
 	if (!msrs) {
 		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
 			      __func__);
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

