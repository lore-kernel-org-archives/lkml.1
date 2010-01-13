Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818Ab0AMKjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0AMKjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807Ab0AMKi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:38:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:38590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab0AMKix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:38:53 -0500
Date: Wed, 13 Jan 2010 10:38:22 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100104161603L.fujita.tomonori@lab.ntt.co.jp>
References: <20100104161603L.fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/agp: Fix agp_amd64_init and agp_amd64_cleanup
Message-ID: <tip-42590a75019a50012f25a962246498dead428433@git.kernel.org>
Git-Commit-ID: 42590a75019a50012f25a962246498dead428433
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:38:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42590a75019a50012f25a962246498dead428433
Gitweb:     http://git.kernel.org/tip/42590a75019a50012f25a962246498dead428433
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Mon, 4 Jan 2010 16:16:23 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 11:15:37 +0100

x86/agp: Fix agp_amd64_init and agp_amd64_cleanup

This fixes the regression introduced by the commit
f405d2c02395a74d3883bd03ded36457aa3697ad.

The above commit fixes the following issue:

  http://marc.info/?l=linux-kernel&m=126192729110083&w=2

However, it doesn't work properly when you remove and insert the
agp_amd64 module again.

agp_amd64_init() and agp_amd64_cleanup should be called only
when gart_iommu is not called earlier (that is, the GART IOMMU
is not enabled). We need to use 'gart_iommu_aperture' to see if
GART IOMMU is enabled or not.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mitov@issp.bas.bg
Cc: davej@redhat.com
LKML-Reference: <20100104161603L.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
