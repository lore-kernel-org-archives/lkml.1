Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab0BDJwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:52:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:52029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab0BDJwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:52:39 -0500
Date: Thu, 4 Feb 2010 09:51:58 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu,
       mitov@issp.bas.bg
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mitov@issp.bas.bg,
       mingo@elte.hu
In-Reply-To: <20100204090802S.fujita.tomonori@lab.ntt.co.jp>
References: <20100204090802S.fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/agp: Fix amd64-agp module initialization regression
Message-ID: <tip-06df6dafb5d9e3cfa3588c6ce79328b91582b6af@git.kernel.org>
Git-Commit-ID: 06df6dafb5d9e3cfa3588c6ce79328b91582b6af
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:51:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06df6dafb5d9e3cfa3588c6ce79328b91582b6af
Gitweb:     http://git.kernel.org/tip/06df6dafb5d9e3cfa3588c6ce79328b91582b6af
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Thu, 4 Feb 2010 14:43:38 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 07:27:26 +0100

x86/agp: Fix amd64-agp module initialization regression

This fixes the regression introduced by commit
42590a75019a50012f25a962246498dead428433 ("x86/agp: Fix
agp_amd64_init and agp_amd64_cleanup").

The commit 61684ceaad4f65d1a9832c722f7bd5e7fc714de9 fixed the
above regression but it's not enough. When amd64-agp is built as
a module, AGP isn't initialized, iommu is initialized, all the
aperture is owned by the iommu.

Reported-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Marin Mitov <mitov@issp.bas.bg>
LKML-Reference: <20100204090802S.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
