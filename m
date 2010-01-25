Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706Ab0AYFLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab0AYFLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 00:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425Ab0AYFLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 00:11:38 -0500
Received: from sh.osrg.net ([192.16.179.4]:40939 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab0AYFLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 00:11:37 -0500
Date: Mon, 25 Jan 2010 14:10:47 +0900
To: mitov@issp.bas.bg
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu,
       davej@redhat.com
Subject: Re: [BUG] agpgart-amd64 not initialized in 2.6.33-rc5 if
 iommu=allowed in kernel command line
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201001232314.55425.mitov@issp.bas.bg>
References: <201001232314.55425.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100125141006O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 25 Jan 2010 14:10:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jan 2010 23:14:55 +0200
Marin Mitov <mitov@issp.bas.bg> wrote:

> Hi,
> 
> If I start the kernel without command line parameters (4GB RAM)
> iommu-swiotlb is used due to quirk in VIA K8T800Pro Host Bridge.
> In that case all is OK.
> 
> If I put in the kernel command line: iommu=allowed (+other parameters)
> I have iommu-gart used but no AGP. dmesg output:
> 
> [drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19
> 
> For debugging I patched the kernel (mostly prink(), shown at the end)
> producing the output in the dmesg:
> 
> no command line
> MDM: agp_amd64_init entered
> MDM: agp_off: false
> MDM: agp_bridges_found: 0
> MDM: gart_iommu_aperture: 0
> MDM: agp_amd64_probe entered
> 
> command line: iommu=allowed:
> MDM: gart_iommu_init
> MDM: before: no_agp = 0
> MDM: 	agp_amd64_init entered
> MDM: 	agp_off: false
> MDM: 	agp_bridges_found: 0
> MDM: after: no_agp = 1
> MDM: agp_amd64_init() < 0: 1
> MDM: agp_copy_info() < 0: -1
> MDM: 	agp_amd64_init entered
> MDM: 	agp_off: false
> MDM: 	agp_bridges_found: 0
> 
> One see in the last case ( iommu=allowed) agp_amd64_init()
> is executed twice, but agp_amd64_probe() is not executed at all
> (agp_bridges_found is incremented only in agp_amd64_probe())
> 
> Is this expected behavior?

Duh, it's my stupid mistake. Sorry about that.

This works for you?

Can you test this patch with set CONFIG_AGP_AMD64 to both y and m
(also loading/unloading the module twice)?

Thanks,

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86/agp: fix agp_amd64_init regression

This fixes the regression introduced by the commit
42590a75019a50012f25a962246498dead428433.

The above commit changes agp_amd64_init() not to do anything if
gart_iommu_aperture is not zero.

If GART iommu calls agp_amd64_init(), we need to skip agp_amd64_init()
when it's called later via module_init.

The problem is that gart_iommu_init() calls agp_amd64_init() with not
zero gart_iommu_aperture so agp_amd64_init() is never initialized.

When gart_iommu_init() calls agp_amd64_init(), agp should be always
initialized.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/char/agp/amd64-agp.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 1afb896..34cf04e 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -729,9 +729,6 @@ int __init agp_amd64_init(void)
 	if (agp_off)
 		return -EINVAL;
 
-	if (gart_iommu_aperture)
-		return agp_bridges_found ? 0 : -ENODEV;
-
 	err = pci_register_driver(&agp_amd64_pci_driver);
 	if (err < 0)
 		return err;
@@ -768,6 +765,14 @@ int __init agp_amd64_init(void)
 	return err;
 }
 
+static int __init agp_amd64_mod_init(void)
+{
+	if (gart_iommu_aperture)
+		return agp_bridges_found ? 0 : -ENODEV;
+
+	return agp_amd64_init();
+}
+
 static void __exit agp_amd64_cleanup(void)
 {
 	if (gart_iommu_aperture)
@@ -777,7 +782,7 @@ static void __exit agp_amd64_cleanup(void)
 	pci_unregister_driver(&agp_amd64_pci_driver);
 }
 
-module_init(agp_amd64_init);
+module_init(agp_amd64_mod_init);
 module_exit(agp_amd64_cleanup);
 
 MODULE_AUTHOR("Dave Jones <davej@redhat.com>, Andi Kleen");
-- 
1.5.6.5

