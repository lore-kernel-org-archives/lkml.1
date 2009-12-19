Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbZLSKsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbZLSKsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 05:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZLSKsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 05:48:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36217 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZLSKsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 05:48:52 -0500
Date: Sat, 19 Dec 2009 11:48:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: [PATCH] HWPOISON: Add PROC_FS dependency to hwpoison injector v2
Message-ID: <20091219104842.GA9809@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This fixes a obscure build problem with the hwpoison injector 
code, found by Ingo's tip compilation testing. The injector requires
PROC_FS and doesn't build when it is disabled. Add suitable
dependencies and ifdefs. Please apply.
Thanks,
-Andi

---

HWPOISON: Add PROC_FS dependency to hwpoison injector v2

The injector filter requires stable_page_flags() which is supplied
by procfs. So make it dependent on that.

Also add ifdefs around the filter code in memory-failure.c so that
when the filter is disabled due to missing dependencies the whole
code still builds. 

Reported-by: Ingo Molnar 
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/Kconfig          |    2 +-
 mm/memory-failure.c |    9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

Index: linux/mm/Kconfig
===================================================================
--- linux.orig/mm/Kconfig
+++ linux/mm/Kconfig
@@ -252,7 +252,7 @@ config MEMORY_FAILURE
 
 config HWPOISON_INJECT
 	tristate "HWPoison pages injector"
-	depends on MEMORY_FAILURE && DEBUG_KERNEL
+	depends on MEMORY_FAILURE && DEBUG_KERNEL && PROC_FS
 	select PROC_PAGE_MONITOR
 
 config NOMMU_INITIAL_TRIM_EXCESS
Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c
+++ linux/mm/memory-failure.c
@@ -52,6 +52,8 @@ int sysctl_memory_failure_recovery __rea
 
 atomic_long_t mce_bad_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
+#if defined(CONFIG_HWPOISON_INJECT) || defined(CONFIG_HWPOISON_INJECT_MODULE)
+
 u32 hwpoison_filter_enable = 0;
 u32 hwpoison_filter_dev_major = ~0U;
 u32 hwpoison_filter_dev_minor = ~0U;
@@ -164,6 +166,13 @@ int hwpoison_filter(struct page *p)
 
 	return 0;
 }
+#else
+int hwpoison_filter(struct page *p)
+{
+	return 0;
+}
+#endif
+
 EXPORT_SYMBOL_GPL(hwpoison_filter);
 
 /*
