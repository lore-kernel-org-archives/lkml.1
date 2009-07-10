Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZGJRBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZGJRBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZGJQ7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:59:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:7780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbZGJQ7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:59:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,379,1243839600"; 
   d="scan'208";a="531777328"
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 06/10] x86, PAT: Generalize the use of page flag PG_uncached
Date: Fri, 10 Jul 2009 09:57:37 -0700
Message-Id: <d165be9f92bc753ebe685b66b512a8fd36205d42.1247162373.git.venkatesh.pallipadi@intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <3a66cb82f9810b9ecc942694b1bb23db7fff8ab2.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
 <fd2fd722222d0abf3d8731b1e564098cb2e1f248.1247162373.git.venkatesh.pallipadi@intel.com>
 <cf6926fb54db50cb0758c4213fe39354c3850157.1247162373.git.venkatesh.pallipadi@intel.com>
 <cdf060718f1e13a3ae2f102d363eb0e25d25c74c.1247162373.git.venkatesh.pallipadi@intel.com>
 <5f0d51bf79a36ebb7c65ab0b80e5018438fe8a77.1247162373.git.venkatesh.pallipadi@intel.com>
 <3a66cb82f9810b9ecc942694b1bb23db7fff8ab2.1247162373.git.venkatesh.pallipadi@intel.com>
In-Reply-To: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
References: <cover.1247162373.git.venkatesh.pallipadi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only IA64 was using PG_uncached as of now. We now intend to use this bit
in x86 as well, to keep track of memory type of those addresses that
have page struct for them. So, generalize the use of that bit across
ia64 and x86.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/ia64/Kconfig          |    4 ++++
 arch/x86/Kconfig           |    4 ++++
 include/linux/page-flags.h |    4 ++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 170042b..e624611 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -112,6 +112,10 @@ config IA64_UNCACHED_ALLOCATOR
 	bool
 	select GENERIC_ALLOCATOR
 
+config ARCH_USES_PG_UNCACHED
+	def_bool y
+	depends on IA64_UNCACHED_ALLOCATOR
+
 config AUDIT_ARCH
 	bool
 	default y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9e90fc5..031db02 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1420,6 +1420,10 @@ config X86_PAT
 
 	  If unsure, say Y.
 
+config ARCH_USES_PG_UNCACHED
+	def_bool y
+	depends on X86_PAT
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e2e5ce5..2b87acf 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -99,7 +99,7 @@ enum pageflags {
 #ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 	PG_mlocked,		/* Page is vma mlocked */
 #endif
-#ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
+#ifdef CONFIG_ARCH_USES_PG_UNCACHED
 	PG_uncached,		/* Page has been mapped as uncached */
 #endif
 	__NR_PAGEFLAGS,
@@ -257,7 +257,7 @@ PAGEFLAG_FALSE(Mlocked)
 	SETPAGEFLAG_NOOP(Mlocked) TESTCLEARFLAG_FALSE(Mlocked)
 #endif
 
-#ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
+#ifdef CONFIG_ARCH_USES_PG_UNCACHED
 PAGEFLAG(Uncached, uncached)
 #else
 PAGEFLAG_FALSE(Uncached)
-- 
1.6.0.6

