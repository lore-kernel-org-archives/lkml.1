Return-Path: <linux-kernel-owner+w=401wt.eu-S1761127AbYHUSch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbYHUSch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYHUSc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:32:27 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:34130 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754080AbYHUSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:32:26 -0400
Subject: x86: Fix VMI for early params...for mainline
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>
Cc: Zachary Amsden <zach@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 21 Aug 2008 11:32:26 -0700
Message-Id: <1219343546.18349.45.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While fixing a recent breakage in VMI on the recent x86 tree, I noticed
that vmi specific kernel commandline parameters were broken. Below is
the fix.

Please note this needs to go into the mainline tree. 

--
x86: Fix VMI for early params

From: Alok N Kataria <akataria@vmware.com>

In a recent commit 31343d8a5079cda57ffd539fcf4f00cea344fe98,
while fixing a different bug, I moved the call to vmi_init before
early params could be parsed.
This broke the vmi specific commandline parameters.
Fix that, by moving vmi initialization after kernel has got a chance to
parse early parameters.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: Zachary Amsden <zach@vmware.com>

---

 arch/x86/kernel/setup.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d2019ef..7c34c2b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -607,14 +607,6 @@ void __init setup_arch(char **cmdline_p)
 	early_cpu_init();
 	early_ioremap_init();
 
-#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
-	/*
-	 * Must be before kernel pagetables are setup
-	 * or fixmap area is touched.
-	 */
-	vmi_init();
-#endif
-
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
 	edid_info = boot_params.edid_info;
@@ -694,6 +686,14 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
+	/*
+	 * Must be before kernel pagetables are setup
+	 * or fixmap area is touched.
+	 */
+	vmi_init();
+#endif
+
 	/* after early param, so could get panic from serial */
 	reserve_early_setup_data();
 


