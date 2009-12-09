Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbZLICAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbZLICAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 21:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZLICAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 21:00:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:35687 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbZLICAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 21:00:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="220412681"
Date: Wed, 9 Dec 2009 10:00:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andi Kleen <andi@firstfloor.org>, "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [19/31] mm: export stable page flags
Message-ID: <20091209020042.GA7751@localhost>
References: <200912081016.198135742@firstfloor.org> <20091208211635.7965AB151F@basil.firstfloor.org> <1260311251.31323.129.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260311251.31323.129.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 06:27:31AM +0800, Matt Mackall wrote:
> On Tue, 2009-12-08 at 22:16 +0100, Andi Kleen wrote:
> > From: Wu Fengguang <fengguang.wu@intel.com>
> > 
> > Rename get_uflags() to stable_page_flags() and make it a global function
> > for use in the hwpoison page flags filter, which need to compare user
> > page flags with the value provided by user space.
> > 
> > Also move KPF_* to kernel-page-flags.h for use by user space tools.
> > 
> > CC: Matt Mackall <mpm@selenic.com>
> > CC: Nick Piggin <npiggin@suse.de>
> > CC: Christoph Lameter <cl@linux-foundation.org>
> > CC: Andi Kleen <andi@firstfloor.org>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

Andi and Matt,

Sorry the stable_page_flags() will be undefined on
!CONFIG_PROC_PAGE_MONITOR (it is almost always on,
except for some embedded systems).

Currently the easy solution is to add a Kconfig dependency to
CONFIG_PROC_PAGE_MONITOR.  When there comes more users (ie. some
ftrace event), we can then always compile in stable_page_flags().

Thanks,
Fengguang
---
 mm/Kconfig          |    1 +
 mm/memory-failure.c |    4 ++++
 2 files changed, 5 insertions(+)

--- linux-mm.orig/mm/Kconfig	2009-12-09 09:47:51.000000000 +0800
+++ linux-mm/mm/Kconfig	2009-12-09 09:58:54.000000000 +0800
@@ -259,6 +259,7 @@ config MEMORY_FAILURE
 config HWPOISON_INJECT
 	tristate "HWPoison pages injector"
 	depends on MEMORY_FAILURE && DEBUG_KERNEL
+	depends on PROC_PAGE_MONITOR
 
 config NOMMU_INITIAL_TRIM_EXCESS
 	int "Turn on mmap() excess space trimming before booting"
--- linux-mm.orig/mm/memory-failure.c	2009-12-09 09:49:13.000000000 +0800
+++ linux-mm/mm/memory-failure.c	2009-12-09 09:55:42.000000000 +0800
@@ -51,6 +51,7 @@ int sysctl_memory_failure_recovery __rea
 
 atomic_long_t mce_bad_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
+#ifdef CONFIG_HWPOISON_INJECT
 u32 hwpoison_filter_enable = 1;
 u32 hwpoison_filter_dev_major = ~0U;
 u32 hwpoison_filter_dev_minor = ~0U;
@@ -160,6 +161,9 @@ int hwpoison_filter(struct page *p)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(hwpoison_filter);
+#else
+int hwpoison_filter(struct page *p) { return 0; }
+#endif
 
 /*
  * Send all the processes who have the page mapped an ``action optional''
