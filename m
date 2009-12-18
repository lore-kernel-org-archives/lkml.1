Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbZLRLpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbZLRLpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 06:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbZLRLpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 06:45:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51695 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZLRLpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 06:45:06 -0500
Date: Fri, 18 Dec 2009 12:45:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: -tip: origin tree build failure
Message-ID: <20091218114501.GA17561@basil.fritz.box>
References: <20091217094041.GA24708@elte.hu> <20091217122316.GB14088@elte.hu> <87bphxu5ef.fsf@basil.nowhere.org> <20091218112300.GA25726@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218112300.GA25726@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, your patch is not the correct fix. As i said, PROC_PAGE_MONITOR provides 
> the facility and mm/memory-failure.c uses that facility - and your patch does 
> not solve that fundamental dependency issue, it just fudges around the 
> dependencies.

Thanks for the report.

The filter is really part of the injector, even if it happens to be 
in the other file. I first resisted adding an ifdef to it, but it seems
we need it. I think I forgot to set to set CONFIG_EMBEDDED earlier,
that is what made the earlier build test pass even when it shouldn't have.

This updated patch should fix it. I tried to build test all applicable
combinations, if anything is still missing please let me know.

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
