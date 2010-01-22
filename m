Return-Path: <linux-kernel-owner+w=401wt.eu-S1752179Ab0AVIQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab0AVIQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 03:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027Ab0AVIQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 03:16:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:52587 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab0AVIQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 03:16:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,322,1262592000"; 
   d="scan'208";a="533568544"
Date: Fri, 22 Jan 2010 16:16:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yinghai Lu <yinghai@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>
Subject: [PATCH 1/3 v4] resources: introduce generic page_is_ram()
Message-ID: <20100122081619.GA6431@localhost>
References: <20100122032102.137106635@intel.com> <20100122033004.193166010@intel.com> <4B595904.4000202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B595904.4000202@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 12:51:32AM -0700, H. Peter Anvin wrote:
> On 01/21/2010 07:21 PM, Wu Fengguang wrote:
> > --- linux-mm.orig/kernel/resource.c	2010-01-22 11:20:34.000000000 +0800
> > +++ linux-mm/kernel/resource.c	2010-01-22 11:20:35.000000000 +0800
> > @@ -327,6 +327,17 @@ int walk_system_ram_range(unsigned long 
> >  
> >  #endif
> >  
> > +#define PAGE_IS_RAM	24
> > +static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
> > +{
> > +	return PAGE_IS_RAM;
> > +}
> > +int __attribute__((weak)) page_is_ram(unsigned long pfn)
> > +{
> > +	return PAGE_IS_RAM == walk_system_ram_range(pfn, 1, NULL, __is_ram);
> > +}
> > +#undef PAGE_IS_RAM
> > +
> 
> Stylistic nitpick:
> 
> The use of the magic number "24" here is pretty ugly; it seems to imply
> that there is something peculiar with this number and that it is trying
> to avoid an overlap, whereas in fact any number but 0 and -1 would do.

Yes, exactly.

> I would rather see just returning 1 and do:
> 
> 	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
> 
> (walk_system_ram_range() returning -1 on error, and 0 means continue.)

Good suggestion.

> Note also that we don't write "constant == expression"; although some
> schools teach it as a way to avoid the "=" versus "==" beginner C
> mistake, it makes the code less intuitive to read.

Yeah.

> Other than that, the patchset looks good; if Ingo doesn't beat me to it
> I'll put it in tomorrow (need sleep right now.)

OK, thanks! Here is the updated patch.

---
resources: introduce generic page_is_ram()

It's based on walk_system_ram_range(), for archs that don't have
their own page_is_ram().

The static verions in MIPS and SCORE are also made global.

v4: prefer plain 1 instead of PAGE_IS_RAM (H. Peter Anvin)
v3: add comment (KAMEZAWA Hiroyuki)
    "AFAIK, this "System RAM" information has been used for kdump to
    grab valid memory area and seems good for the kernel itself."
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
 kernel/resource.c      |   13 +++++++++++++
 4 files changed, 17 insertions(+), 2 deletions(-)

--- linux-mm.orig/kernel/resource.c	2010-01-22 11:20:34.000000000 +0800
+++ linux-mm/kernel/resource.c	2010-01-22 16:12:55.000000000 +0800
@@ -327,6 +327,19 @@ int walk_system_ram_range(unsigned long 
 
 #endif
 
+static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
+{
+	return 1;
+}
+/*
+ * This generic page_is_ram() returns true if specified address is
+ * registered as "System RAM" in iomem_resource list.
+ */
+int __attribute__((weak)) page_is_ram(unsigned long pfn)
+{
+	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
+}
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
 
