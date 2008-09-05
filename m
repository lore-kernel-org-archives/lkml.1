Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYIERWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYIERWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYIERWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:22:12 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41140 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbYIERWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:22:10 -0400
Date: Fri, 5 Sep 2008 10:21:32 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] [RESEND] x86_64: add memory hotremove config option
Message-ID: <20080905172132.GA11692@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sieve: CMU Sieve 2.3
X-Spam-TestScore: ALL_TRUSTED=-1.44,DNS_FROM_RFC_ABUSE=0.479
X-Spam-TokenSummary: Bayes not run.
X-Xagent-From: garyhade@us.ibm.com
X-Xagent-To: garyhade@linux.vnet.ibm.com
X-Xagent-Gateway: bldvmb.vnet.ibm.com (XAGENTU2 at BLDVMB)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with linux-kernel@vger.kernel.org and x86@kernel.org copied
this time.  No changes other than this and modified Subject line.  The
only response so far on linux-mm has been an Acked-by: from 
Yasunori Goto <y-goto@jp.fujitsu.com>


Add memory hotremove config option to x86_64

Memory hotremove functionality can currently be configured into
the ia64, powerpc, and s390 kernels.  This patch makes it possible
to configure the memory hotremove functionality into the x86_64
kernel as well. 

Signed-off-by: Gary Hade <garyhade@us.ibm.com>

---
 arch/x86/Kconfig      |    3 +++
 arch/x86/mm/init_64.c |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

Index: linux-2.6.27-rc5/arch/x86/Kconfig
===================================================================
--- linux-2.6.27-rc5.orig/arch/x86/Kconfig	2008-09-03 13:33:59.000000000 -0700
+++ linux-2.6.27-rc5/arch/x86/Kconfig	2008-09-03 13:34:55.000000000 -0700
@@ -1384,6 +1384,9 @@
 	def_bool y
 	depends on X86_64 || (X86_32 && HIGHMEM)

+config ARCH_ENABLE_MEMORY_HOTREMOVE
+	def_bool y
+
 config HAVE_ARCH_EARLY_PFN_TO_NID
 	def_bool X86_64
 	depends on NUMA
Index: linux-2.6.27-rc5/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.27-rc5.orig/arch/x86/mm/init_64.c	2008-09-03 13:34:08.000000000 -0700
+++ linux-2.6.27-rc5/arch/x86/mm/init_64.c	2008-09-03 13:34:55.000000000 -0700
@@ -740,6 +740,24 @@
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif

+#ifdef CONFIG_MEMORY_HOTREMOVE
+int remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn, end_pfn;
+	unsigned long timeout = 120 * HZ;
+	int ret;
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = start_pfn + (size >> PAGE_SHIFT);
+	ret = offline_pages(start_pfn, end_pfn, timeout);
+	if (ret)
+		goto out;
+	/* Arch-specific calls go here */
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(remove_memory);
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
 #endif /* CONFIG_MEMORY_HOTPLUG */

 /*
