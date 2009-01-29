Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZA2Kth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZA2Kth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZA2Kt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:49:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60564 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZA2KtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:49:24 -0500
Date: Thu, 29 Jan 2009 11:49:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>, x86@kernel.org,
       Dave Airlie <airlied@redhat.com>
Subject: Re: Oops / Warning report for the week of January 28th, 2009: The
	200.000th trace.
Message-ID: <20090129104910.GA10987@elte.hu>
References: <4980A0D8.80209@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4980A0D8.80209@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> Rank 3: mtrr_trim_uncached_memory (warning)
> 	Reported 709 times (14696 total reports)
> 	BIOS bug (often in VMWare) where the MTRR's are set up incorrectly or not at all
> 	This warning was last seen in version 2.6.29-rc2-git1, and first seen in 2.6.24.
> 	More info: http://www.kerneloops.org/searchweek.php?search=mtrr_trim_uncached_memory

This bug is not finding any real issues for us anymore and this rate of 
false positives is a distraction - so i've queued up the patch below in 
tip/x86/urgent.

	Ingo

--------------------->
>From bf3647c44bc76c43c4b2ebb4c37a559e899ac70e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 29 Jan 2009 11:45:35 +0100
Subject: [PATCH] x86: tone down mtrr_trim_uncached_memory() warning

kerneloops.org is reporting a lot of these warnings that come due to
vmware not setting up any MTRRs for emulated CPUs:

| Reported 709 times (14696 total reports)
| BIOS bug (often in VMWare) where the MTRR's are set up incorrectly
| or not at all
|
| This warning was last seen in version 2.6.29-rc2-git1, and first
| seen in 2.6.24.
|
| More info:
|   http://www.kerneloops.org/searchweek.php?search=mtrr_trim_uncached_memory

Keep a one-liner KERN_INFO about it - so that we have so notice if empty
MTRRs are caused by native hardware/BIOS weirdness.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index d259e5d..236a401 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1594,8 +1594,7 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
 	if (!highest_pfn) {
-		WARN(!kvm_para_available(), KERN_WARNING
-				"WARNING: strange, CPU MTRRs all blank?\n");
+		printk(KERN_INFO "CPU MTRRs all blank - virtualized system.\n");
 		return 0;
 	}
 
