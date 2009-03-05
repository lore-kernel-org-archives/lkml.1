Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZCENHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZCENHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZCENGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:06:38 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:37719 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZCENGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:06:37 -0500
X-Greylist: delayed 685 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2009 08:06:37 EST
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/17] x86: ifdef 32-bit specific setup in init_memory_mapping()
Date: Thu,  5 Mar 2009 14:54:56 +0200
Message-Id: <1236257708-27269-5-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Enabling NX, PSE, and PGE are only required on 32-bit so ifdef them in both
versions of the function.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |    2 ++
 arch/x86/mm/init_64.c |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index cfc68d6..eb98cb9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -948,6 +948,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
+#ifdef CONFIG_X86_32
 #ifdef CONFIG_X86_PAE
 	set_nx();
 	if (nx_enabled)
@@ -963,6 +964,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		set_in_cr4(X86_CR4_PGE);
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
+#endif
 
 	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 151e5ba..c3c0be5 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -712,6 +712,24 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
+#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_PAE
+	set_nx();
+	if (nx_enabled)
+		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
+#endif
+
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+#endif
+
 	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
 	if (use_pse)
-- 
1.5.4.3

