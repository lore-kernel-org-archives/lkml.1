Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZADKFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZADKFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZADKFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:05:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbZADKFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:05:39 -0500
Date: Sun, 4 Jan 2009 11:05:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org,
       weidong.han@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [GIT PULL] various IOMMU updates for 2.6.29
Message-ID: <20090104100511.GC12938@elte.hu>
References: <20090103173130.GB6103@amd.com> <20090103220611.GA4389@elte.hu> <20090103221135.GA14298@8bytes.org> <20090103225627.GA21841@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103225627.GA21841@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> @@ -491,7 +491,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
>  	int map_size;
>  	u32 ver;
>  	static int iommu_allocated = 0;
> -	int agaw;
> +	int agaw = 0;
>  
>  	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
>  	if (!iommu)
> @@ -507,6 +507,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
>  	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
>  	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
>  
> +#ifdef CONFIG_DMAR
>  	agaw = iommu_calculate_agaw(iommu);
>  	if (agaw < 0) {
>  		printk(KERN_ERR

yeah, setting it to zero should be safe in this case - agaw == 0 is a 
potentially bogus value as far as the hw is concerned, but the only user 
of it is intel-iommu.c which is only built if CONFIG_DMAR is set - and 
this is the non-DMA-remap case so it should not matter. David, do you 
agree?

but, that #ifdef in your patch is inacceptably ugly. The right approach is 
for iommu_calculate_agaw() to be an inline function in the !CONFIG_DMAR 
case, which returns 0. That makes the above code sequence work out of box, 
without any ugly #ifdefs.

See the patch below - i have queued it up in tip/core/urgent.

	Ingo

----------------------------->
>From c66b9906f863696159e05890bb7123269bb9a9de Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 4 Jan 2009 10:55:02 +0100
Subject: [PATCH] intel-iommu: fix build error with INTR_REMAP=y and DMAR=n

dmar.o can be built in the CONFIG_INTR_REMAP=y case but
iommu_calculate_agaw() is only available if VT-d is built as well.

So create an inline version of iommu_calculate_agaw() for the
!CONFIG_DMAR case. The iommu->agaw value wont be used in this
case, but the code is cleaner (has less #ifdefs) if we have it around
unconditionally.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/dma_remapping.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 136f170..af1dab4 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -17,7 +17,15 @@ struct dmar_domain;
 struct root_entry;
 
 extern void free_dmar_iommu(struct intel_iommu *iommu);
+
+#ifdef CONFIG_DMAR
 extern int iommu_calculate_agaw(struct intel_iommu *iommu);
+#else
+static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
+{
+	return 0;
+}
+#endif
 
 extern int dmar_disabled;
 
