Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbZENPSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbZENPSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZENPRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:17:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:45697 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZENPRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:17:54 -0400
Subject: Re: [PATCH] Fix Intel IOMMU Compilation Warnings on IA64
From: David Woodhouse <dwmw2@infradead.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: "'Tony Luck'" <tony.luck@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'iommu'" <iommu@lists.linux-foundation.org>,
       "'ia64'" <linux-ia64@vger.kernel.org>
In-Reply-To: <20090513231351.GA22386@linux-os.sc.intel.com>
References: <20090327212241.234500000@intel.com>
	 <20090327212321.070229000@intel.com>
	 <20090416001957.GA1527@linux-os.sc.intel.com>
	 <1240135508.3589.75.camel@macbook.infradead.org>
	 <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
	 <20090513231351.GA22386@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 16:17:51 +0100
Message-Id: <1242314271.3393.11.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 16:13 -0700, Fenghua Yu wrote:
> Compiling kernel on IA64 reports two warnings in intel-iommu.c:
> 
> drivers/pci/intel-iommu.c:3150: warning: format ?%llx? expects
> type ?long long unsigned int?, but argument 4 has type ?u64?
> drivers/pci/intel-iommu.c: In function ?intel_iommu_map_range?:
> drivers/pci/intel-iommu.c:3201: warning: format ?%llx? expects
> type ?long long unsigned int?, but argument 4 has type ?u64?

Charset corruption there? I'm sure GCC didn't actually use question
marks...

> The warnings are fixed by adding type cast unsigned long long.
> 
> Signed-off-by: Fenghua Yu <fegnhua.yu@intel.com>
> 
> ---
> 
>  intel-iommu.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index a563fbe..6f8cc21 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -3147,7 +3147,8 @@ static int intel_iommu_attach_device(struct
> iommu_domain *domain,
>         if (end < dmar_domain->max_addr) {
>                 printk(KERN_ERR "%s: iommu agaw (%d) is not "
>                        "sufficient for the mapped address (%llx)\n",
> -                      __func__, iommu->agaw, dmar_domain->max_addr);
> +                      __func__, iommu->agaw,
> +                      (unsigned long long)dmar_domain->max_addr);
>                 return -EFAULT;
>         }

Perhaps this would be better, modelled after commit fe333321:

diff --git a/arch/ia64/include/asm/types.h b/arch/ia64/include/asm/types.h
index e36b371..b0ecc20 100644
--- a/arch/ia64/include/asm/types.h
+++ b/arch/ia64/include/asm/types.h
@@ -13,7 +13,11 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
  */
 
+#ifdef __KERNEL__
+#include <asm-generic/int-ll64.h>
+#else
 #include <asm-generic/int-l64.h>
+#endif
 
 #ifdef __ASSEMBLY__
 # define __IA64_UL(x)		(x)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

