Return-Path: <linux-kernel-owner+w=401wt.eu-S1751915Ab0AVEUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab0AVEUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466Ab0AVEUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:20:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:34237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab0AVEUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:20:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,321,1262592000"; 
   d="scan'208";a="766352045"
Date: Fri, 22 Jan 2010 12:20:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       Yinghai Lu <yinghai@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>
Subject: [PATCH 1/3 v3] resources: introduce generic page_is_ram()
Message-ID: <20100122042046.GA24258@localhost>
References: <20100122032102.137106635@intel.com> <20100122033004.193166010@intel.com> <20100122131017.544dd91b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100122131017.544dd91b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 06:10:17AM +0200, KAMEZAWA Hiroyuki wrote:
> On Fri, 22 Jan 2010 11:21:03 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > It's based on walk_system_ram_range(), for archs that don't have
> > their own page_is_ram().
> > 
> > The static verions in MIPS and SCORE are also made global.
> > 
> > CC: Chen Liqin <liqin.chen@sunplusct.com>
> > CC: Lennox Wu <lennox.wu@gmail.com>
> > CC: Ralf Baechle <ralf@linux-mips.org>
> > CC: Am辿rico Wang <xiyou.wangcong@gmail.com>
> > CC: linux-mips@linux-mips.org
> > CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> 
> > CC: Yinghai Lu <yinghai@kernel.org>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Maybe adding comment like this is good for reviewers..
> 
> "This page_is_ram() returns true if specified address is registered
>  as System RAM in io_resource list."
> 
> AFAIK, this "System RAM" information has been used for kdump to grab valid
> memory area and seems good for the kernel itself.

Thanks! Patch updated as follows.

---
resources: introduce generic page_is_ram()

It's based on walk_system_ram_range(), for archs that don't have
their own page_is_ram().

The static verions in MIPS and SCORE are also made global.

v3: add comment (KAMEZAWA Hiroyuki)
v2: add PAGE_IS_RAM macro (Américo Wang)

CC: Chen Liqin <liqin.chen@sunplusct.com>
CC: Lennox Wu <lennox.wu@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Américo Wang <xiyou.wangcong@gmail.com>
CC: linux-mips@linux-mips.org
CC: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 arch/mips/mm/init.c    |    2 +-
 arch/score/mm/init.c   |    2 +-
 include/linux/ioport.h |    2 ++
 kernel/resource.c      |   15 +++++++++++++++
 4 files changed, 19 insertions(+), 2 deletions(-)

--- linux-mm.orig/kernel/resource.c	2010-01-22 11:20:34.000000000 +0800
+++ linux-mm/kernel/resource.c	2010-01-22 12:17:50.000000000 +0800
@@ -327,6 +327,21 @@ int walk_system_ram_range(unsigned long 
 
 #endif
 
+#define PAGE_IS_RAM	24
+static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
+{
+	return PAGE_IS_RAM;
+}
+/*
+ * This generic page_is_ram() returns true if specified address is
+ * registered as "System RAM" in iomem_resource list.
+ */
+int __attribute__((weak)) page_is_ram(unsigned long pfn)
+{
+	return PAGE_IS_RAM == walk_system_ram_range(pfn, 1, NULL, __is_ram);
+}
+#undef PAGE_IS_RAM
+
 /*
  * Find empty slot in the resource tree given range and alignment.
  */
--- linux-mm.orig/include/linux/ioport.h	2010-01-22 11:20:34.000000000 +0800
+++ linux-mm/include/linux/ioport.h	2010-01-22 11:20:35.000000000 +0800
@@ -191,5 +191,7 @@ extern int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
 
+extern int page_is_ram(unsigned long pfn);
+
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
--- linux-mm.orig/arch/score/mm/init.c	2010-01-22 11:20:34.000000000 +0800
+++ linux-mm/arch/score/mm/init.c	2010-01-22 11:20:35.000000000 +0800
@@ -59,7 +59,7 @@ static unsigned long setup_zero_page(voi
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-static int __init page_is_ram(unsigned long pagenr)
+int page_is_ram(unsigned long pagenr)
 {
 	if (pagenr >= min_low_pfn && pagenr < max_low_pfn)
 		return 1;
--- linux-mm.orig/arch/mips/mm/init.c	2010-01-22 11:20:34.000000000 +0800
+++ linux-mm/arch/mips/mm/init.c	2010-01-22 11:20:35.000000000 +0800
@@ -298,7 +298,7 @@ void __init fixrange_init(unsigned long 
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-static int __init page_is_ram(unsigned long pagenr)
+int page_is_ram(unsigned long pagenr)
 {
 	int i;
 

