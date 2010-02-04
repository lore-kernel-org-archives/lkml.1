Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab0BDANB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:13:01 -0500
Received: from sh.osrg.net ([192.16.179.4]:53389 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779Ab0BDAM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:12:59 -0500
Date: Thu, 4 Feb 2010 09:12:03 +0900
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, mitov@issp.bas.bg, davej@redhat.com
Subject: [PATCH] x86/agp: fix agp_amd64_init module initialization
 regression
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100204090802S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Feb 2010 09:12:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the regression introduced by commit
42590a75019a50012f25a962246498dead428433 ("x86/agp: Fix agp_amd64_init
and agp_amd64_cleanup").

The commit 61684ceaad4f65d1a9832c722f7bd5e7fc714de9 fixed the above
regression but there is still a problem in the module initialization;
when apg_amd64 is built as a module, the GART IOMMU is not still
initialized.

Reported-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Marin Mitov <mitov@issp.bas.bg>
---
 drivers/char/agp/amd64-agp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 34cf04e..fd50ead 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -767,16 +767,19 @@ int __init agp_amd64_init(void)
 
 static int __init agp_amd64_mod_init(void)
 {
+#ifndef MODULE
 	if (gart_iommu_aperture)
 		return agp_bridges_found ? 0 : -ENODEV;
-
+#endif
 	return agp_amd64_init();
 }
 
 static void __exit agp_amd64_cleanup(void)
 {
+#ifndef MODULE
 	if (gart_iommu_aperture)
 		return;
+#endif
 	if (aperture_resource)
 		release_resource(aperture_resource);
 	pci_unregister_driver(&agp_amd64_pci_driver);
-- 
1.5.6.5

