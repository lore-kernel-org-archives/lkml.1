Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788Ab0AaIbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0AaIbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 03:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808Ab0AaIbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 03:31:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:55350 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab0AaIbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 03:31:32 -0500
Date: Sun, 31 Jan 2010 08:30:33 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, johannes.hirte@fem.tu-ilmenau.de,
       fujita.tomonori@lab.ntt.co.jp, kjwinchester@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, mitov@issp.bas.bg
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       johannes.hirte@fem.tu-ilmenau.de, kjwinchester@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, mitov@issp.bas.bg
In-Reply-To: <20100125141006O.fujita.tomonori@lab.ntt.co.jp>
References: <20100125141006O.fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/agp: Fix agp_amd64_init regression
Message-ID: <tip-61684ceaad4f65d1a9832c722f7bd5e7fc714de9@git.kernel.org>
Git-Commit-ID: 61684ceaad4f65d1a9832c722f7bd5e7fc714de9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 31 Jan 2010 08:30:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61684ceaad4f65d1a9832c722f7bd5e7fc714de9
Gitweb:     http://git.kernel.org/tip/61684ceaad4f65d1a9832c722f7bd5e7fc714de9
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Mon, 25 Jan 2010 14:10:47 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 31 Jan 2010 07:52:26 +0100

x86/agp: Fix agp_amd64_init regression

This fixes the regression introduced by commit
42590a75019a50012f25a962246498dead428433 ("x86/agp: Fix
agp_amd64_init and agp_amd64_cleanup").

The above commit changes agp_amd64_init() not to do anything if
gart_iommu_aperture is not zero.

If GART iommu calls agp_amd64_init(), we need to skip
agp_amd64_init() when it's called later via module_init.

The problem is that gart_iommu_init() calls agp_amd64_init()
with not zero gart_iommu_aperture so agp_amd64_init() is never
initialized.

When gart_iommu_init() calls agp_amd64_init(), agp should be
always initialized.

Reported-by: Marin Mitov <mitov@issp.bas.bg>
Reported-by: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Marin Mitov <mitov@issp.bas.bg>
Tested-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: davej@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20100125141006O.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
