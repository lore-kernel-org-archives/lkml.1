Return-Path: <linux-kernel-owner+w=401wt.eu-S1751151AbZL1JRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbZL1JRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbZL1JRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:17:54 -0500
Received: from sh.osrg.net ([192.16.179.4]:56237 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZL1JRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:17:54 -0500
Date: Mon, 28 Dec 2009 18:11:56 +0900
To: mingo@elte.hu
Cc: mitov@issp.bas.bg, davej@redhat.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: [BUG] agpgart-amd64 not initialized in 2.6.33-rc2
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091228081021.GD28652@elte.hu>
References: <20091228153704Z.fujita.tomonori@lab.ntt.co.jp>
	<200912280918.36067.mitov@issp.bas.bg>
	<20091228081021.GD28652@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091228181118C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 28 Dec 2009 18:11:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 09:10:21 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > On Monday 28 December 2009 08:37:33 am FUJITA Tomonori wrote:
> > > On Sun, 27 Dec 2009 17:19:39 +0200
> > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > Recently (2.6.33-rc2 kernel, x86_64, 4GB RAM) I found (in dmesg):
> > > > 
> > > > [drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19
> > > > 
> > > > and there is no /dev/agpgart device on the machine while all is OK 
> > > > if booting 2.6.32.2. 
> > > > 
> > > > In both kernels I have:
> > > > 
> > > > CONFIG_AGP=y
> > > > CONFIG_AGP_AMD64=y
> > > > 
> > > > CONFIG_GART_IOMMU=y
> > > > 
> > > > but nevertheless dmesg shows:
> > > > 
> > > > PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> > > > 
> > > > due to quirks in via K8T800Pro host bridge.
> > > > 
> > > > Looking for the reason I found that agp_amd64_init() appears in:
> > > > 
> > > > #ifndef CONFIG_GART_IOMMU
> > > > module_init(agp_amd64_init);
> > > > module_exit(agp_amd64_cleanup);
> > > > #endif
> > > > 
> > > >  /*  so it is not invoked here due to CONFIG_GART_IOMMU=y   */
> > > > 
> > > > and also appears in:
> > > >  
> > > > arch/x86/kernel/pci-gart_64.c, function: gart_iommu_init()
> > > > 
> > > > The last one is part of the struct x86_init_ops(struct x86_init_iommu, as a function pointer) 
> > > > only if gart-iommu is successfully detected, which is not the case here due to the quirk, 
> > > > so agp_amd64_init() is not invoked here neither. 
> > > > 
> > > > Sure, configuring the kernel without CONFIG_GART_IOMMU=y (which is not user selectable)
> > > > 
> > > > should solve the problem, but usually users do not know about quirks, so it should
> > > > work even as set here (and it works up to 2.6.32.2). I believe the bug is introduced
> > > > with the changes in the order iommu detect/init works for 2.6.33.
> > > > 
> > > > I am here for additional info/tests.
> > > 
> > > Sorry about the regression. Does this works?
> > 
> > Yes, it works for me, thank you.
> 
> Great! Fujita-san, mind sending a fully changelogged version of the patch with 
> Tested-by and your Signed-off-by?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86/agp: fix agp_amd64_init() initialization with CONFIG_GART_IOMMU enabled

drivers/char/agp/amd64-agp.c has:

#ifndef CONFIG_GART_IOMMU
module_init(agp_amd64_init);
module_exit(agp_amd64_cleanup);
#endif

agp_amd64_init() was called via gart_iommu_init with CONFIG_GART_IOMMU=y
agp_amd64_init() was called via module_init with CONFIG_GART_IOMMU=n

The commit 75f1cdf1dda92cae037ec848ae63690d91913eac changes the x86
dma initialization routine: gart_iommu_init() is called only when GART
IOMMU is detected. So when GART IOMMU isn't detected, agp_amd64_init
isn't called.

Marin Mitov reported this issue:

http://marc.info/?l=linux-kernel&m=126192729110083&w=2

With this patch, agp_amd64_init() is always called via module_init
(the above ifndef is removed). If agp_amd64_init() is called via
gart_iommu_init() earlier, agp_amd64_init() finishes without doing
anything (when it is called via module_init).

Reported-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Marin Mitov <mitov@issp.bas.bg>
---
 drivers/char/agp/amd64-agp.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 2fb2e6c..5aa7a58 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -725,9 +725,14 @@ static struct pci_driver agp_amd64_pci_driver = {
 int __init agp_amd64_init(void)
 {
 	int err = 0;
+	static int done = 0;
 
 	if (agp_off)
 		return -EINVAL;
+
+	if (done++)
+		return agp_bridges_found ? 0 : -ENODEV;
+
 	err = pci_register_driver(&agp_amd64_pci_driver);
 	if (err < 0)
 		return err;
@@ -771,12 +776,8 @@ static void __exit agp_amd64_cleanup(void)
 	pci_unregister_driver(&agp_amd64_pci_driver);
 }
 
-/* On AMD64 the PCI driver needs to initialize this driver early
-   for the IOMMU, so it has to be called via a backdoor. */
-#ifndef CONFIG_GART_IOMMU
 module_init(agp_amd64_init);
 module_exit(agp_amd64_cleanup);
-#endif
 
 MODULE_AUTHOR("Dave Jones <davej@redhat.com>, Andi Kleen");
 module_param(agp_try_unsupported, bool, 0);
-- 
1.5.6.5

