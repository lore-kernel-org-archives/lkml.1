Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbZL3MWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbZL3MWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZL3MWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:22:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:42448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZL3MWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:22:37 -0500
Date: Wed, 30 Dec 2009 12:21:33 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu,
       mitov@issp.bas.bg
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mitov@issp.bas.bg,
       mingo@elte.hu
In-Reply-To: <20091228181118C.fujita.tomonori@lab.ntt.co.jp>
References: <20091228181118C.fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/agp: Fix agp_amd64_init() initialization with CONFIG_GART_IOMMU enabled
Message-ID: <tip-f405d2c02395a74d3883bd03ded36457aa3697ad@git.kernel.org>
Git-Commit-ID: f405d2c02395a74d3883bd03ded36457aa3697ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f405d2c02395a74d3883bd03ded36457aa3697ad
Gitweb:     http://git.kernel.org/tip/f405d2c02395a74d3883bd03ded36457aa3697ad
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Mon, 28 Dec 2009 18:11:56 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 11:52:04 +0100

x86/agp: Fix agp_amd64_init() initialization with CONFIG_GART_IOMMU enabled

with CONFIG_GART_IOMMU enabled drivers/char/agp/amd64-agp.c has:

 #ifndef CONFIG_GART_IOMMU
 module_init(agp_amd64_init);
 module_exit(agp_amd64_cleanup);
 #endif

agp_amd64_init() was called via gart_iommu_init with
CONFIG_GART_IOMMU=y agp_amd64_init() was called via module_init
with CONFIG_GART_IOMMU=n

The commit 75f1cdf1dda92cae037ec848ae63690d91913eac changes the
x86 dma initialization routine: gart_iommu_init() is called only
when GART IOMMU is detected. So when GART IOMMU isn't detected,
agp_amd64_init isn't called.

Marin Mitov reported this issue:

 http://marc.info/?l=linux-kernel&m=126192729110083&w=2

With this patch, agp_amd64_init() is always called via
module_init (the above ifndef is removed). If agp_amd64_init()
is called via gart_iommu_init() earlier, agp_amd64_init()
finishes without doing anything (when it is called via
module_init).

Reported-by: Marin Mitov <mitov@issp.bas.bg>
Tested-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davej@redhat.com
LKML-Reference: <20091228181118C.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
