Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350Ab0ADHRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0ADHRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 02:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323Ab0ADHRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 02:17:21 -0500
Received: from sh.osrg.net ([192.16.179.4]:51730 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab0ADHRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 02:17:20 -0500
Date: Mon, 4 Jan 2010 16:16:23 +0900
To: mingo@elte.hu
Cc: mitov@issp.bas.bg, davej@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] x86/agp: fix agp_amd64_init and agp_amd64_cleanup
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100104161603L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 04 Jan 2010 16:16:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, the previous fix added another bug.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -tip] x86/agp: fix agp_amd64_init and agp_amd64_cleanup

This fixes the regression introduced by the commit
f405d2c02395a74d3883bd03ded36457aa3697ad.

The above commit fixes the following issue:

http://marc.info/?l=linux-kernel&m=126192729110083&w=2

However, it doesn't work properly when you remove and insert the
agp_amd64 module again.

agp_amd64_init() and agp_amd64_cleanup should be called only when
gart_iommu is not called earlier (that is, the GART IOMMU is not
enabled). We need to use 'gart_iommu_aperture' to see if GART IOMMU is
enabled or not.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/aperture_64.c |    1 +
 drivers/char/agp/amd64-agp.c  |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 3704997..f147a95 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -31,6 +31,7 @@
 #include <asm/x86_init.h>
 
 int gart_iommu_aperture;
+EXPORT_SYMBOL_GPL(gart_iommu_aperture);
 int gart_iommu_aperture_disabled __initdata;
 int gart_iommu_aperture_allowed __initdata;
 
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 5aa7a58..1afb896 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -725,12 +725,11 @@ static struct pci_driver agp_amd64_pci_driver = {
 int __init agp_amd64_init(void)
 {
 	int err = 0;
-	static int done = 0;
 
 	if (agp_off)
 		return -EINVAL;
 
-	if (done++)
+	if (gart_iommu_aperture)
 		return agp_bridges_found ? 0 : -ENODEV;
 
 	err = pci_register_driver(&agp_amd64_pci_driver);
@@ -771,6 +770,8 @@ int __init agp_amd64_init(void)
 
 static void __exit agp_amd64_cleanup(void)
 {
+	if (gart_iommu_aperture)
+		return;
 	if (aperture_resource)
 		release_resource(aperture_resource);
 	pci_unregister_driver(&agp_amd64_pci_driver);
-- 
1.5.6.5

