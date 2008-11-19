Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYKSI37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYKSI37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYKSI3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:29:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58217 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbYKSI3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:29:50 -0500
Date: Wed, 19 Nov 2008 09:29:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David.Woodhouse@intel.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
       Youquan Song <youquan.song@intel.com>
Subject: Re: [PATCH] intel-iommu: fix compile warnings
Message-ID: <20081119082928.GC1078@elte.hu>
References: <20081119135351M.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119135351M.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> I got the following warnings on IA64:
> 
> linux-2.6/drivers/pci/intel-iommu.c: In function 'init_dmars':
> linux-2.6/drivers/pci/intel-iommu.c:1658: warning: format '%Lx' expects type 'long long unsigned int', but argument 2 has type 'u64'
> linux-2.6/drivers/pci/intel-iommu.c:1663: warning: format '%Lx' expects type 'long long unsigned int', but argument 2 has type 'u64'

applied to tip/core/urgent, thanks!

Note, i extended the changelog, see the commit attached below.

I think in 2.6.29 we want to convert struct dmar_drhd_unit's 
->reg_base_addr to the phys_addr_t type, and use the %pR extension to 
print it out.

There's other files affected as well by this type problem: 
drivers/pci/intr_remapping.c for example - it's just not built on ia64 
right now because it depends on CONFIG_INTR_REMAP which is only 64-bit 
x86.

Some goes for other fields as well:

	u64	base_address;		/* reserved base address*/
	u64	end_address;		/* reserved end address */

(and some other variables in dmar.c as well)

Would you be interested in sending a patch for this wider cleanup?

It will be a pure cleanup with no functional complications as DMAR is 
only available on 64-bit platforms so phys_addr_t is always 64 bits 
wide - but it will help avoid such problems that u64 types 
historically have.

	Ingo

------------->
>From b4e0f9eb8aeceb22c48fee005378bd19e25216fc Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 19 Nov 2008 13:53:42 +0900
Subject: [PATCH] intel-iommu: fix compile warnings

Impact: cleanup

I got the following warnings on IA64:

  linux-2.6/drivers/pci/intel-iommu.c: In function 'init_dmars':
  linux-2.6/drivers/pci/intel-iommu.c:1658: warning: format '%Lx' expects type 'long long unsigned int', but argument 2 has type 'u64'
  linux-2.6/drivers/pci/intel-iommu.c:1663: warning: format '%Lx' expects type 'long long unsigned int', but argument 2 has type 'u64'

Another victim of int-ll64.h versus int-l64.h confusion between platforms.

->reg_base_addr has a type of u64 - which can only be printed out
consistently if we cast its type up to LL.

[ Eventually reg_base_addr should be converted to phys_addr_t, for which
  we have the %pR printk helper - but that is out of the scope of late
  -rc's. ]

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/pci/intel-iommu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a269272..5c8baa4 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1655,12 +1655,14 @@ int __init init_dmars(void)
 			iommu->flush.flush_context = __iommu_flush_context;
 			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
 			printk(KERN_INFO "IOMMU 0x%Lx: using Register based "
-			       "invalidation\n", drhd->reg_base_addr);
+			       "invalidation\n",
+			       (unsigned long long)drhd->reg_base_addr);
 		} else {
 			iommu->flush.flush_context = qi_flush_context;
 			iommu->flush.flush_iotlb = qi_flush_iotlb;
 			printk(KERN_INFO "IOMMU 0x%Lx: using Queued "
-			       "invalidation\n", drhd->reg_base_addr);
+			       "invalidation\n",
+			       (unsigned long long)drhd->reg_base_addr);
 		}
 	}
 

