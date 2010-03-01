Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab0CANz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:55:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:5804 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab0CANz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:55:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,560,1262592000"; 
   d="scan'208";a="544894835"
Date: Mon, 1 Mar 2010 21:55:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Sachin Sant <sachinp@in.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: 2.6.33-git6 boot failure[x86_64] (WARN: at
	arch/x86/mm/ioremap.c:111)
Message-ID: <20100301135551.GA9998@localhost>
References: <4B8B43E9.1010506@in.ibm.com> <7b6bb4a51002282218u22c8f4c4wb2a345fcb7a82257@mail.gmail.com> <4B8B7AC7.1070201@in.ibm.com> <7b6bb4a51003010038l49c90414lff1ecaa37c96ad61@mail.gmail.com> <alpine.LFD.2.00.1003011058470.4245@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003011058470.4245@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 06:42:59PM +0800, Thomas Gleixner wrote:
> On Mon, 1 Mar 2010, Xiaotian Feng wrote:
> > On Mon, Mar 1, 2010 at 4:28 PM, Sachin Sant <sachinp@in.ibm.com> wrote:
> > > Xiaotian Feng wrote:
> > >> On Mon, Mar 1, 2010 at 12:34 PM, Sachin Sant <sachinp@in.ibm.com> wrote:
> >
> > >>> WARNING: at arch/x86/mm/ioremap.c:111 __ioremap_caller+0x169/0x2f1()
> > >>> Hardware name: BladeCenter LS21 -[79716AA]-
> > >>> Modules linked in:
> > >>> Pid: 0, comm: swapper Not tainted 2.6.33-git6-autotest #1
> > >>> Call Trace:
> > >>> [<ffffffff81047cff>] ? __ioremap_caller+0x169/0x2f1
> > >>> [<ffffffff81063b7d>] warn_slowpath_common+0x77/0xa4
> > >>> [<ffffffff81063bb9>] warn_slowpath_null+0xf/0x11
> > >>> [<ffffffff81047cff>] __ioremap_caller+0x169/0x2f1
> > >>> [<ffffffff813747a3>] ? acpi_os_map_memory+0x12/0x1b
> > >>> [<ffffffff81047f10>] ioremap_nocache+0x12/0x14
> > >>> [<ffffffff813747a3>] acpi_os_map_memory+0x12/0x1b
> > >>> [<ffffffff81282fa0>] acpi_tb_verify_table+0x29/0x5b
> > >>> [<ffffffff812827f0>] acpi_load_tables+0x39/0x15a
> > >>> [<ffffffff8191c8f8>] acpi_early_init+0x60/0xf5
> > >>> [<ffffffff818f2cad>] start_kernel+0x397/0x3a7
> > >>> [<ffffffff818f2295>] x86_64_start_reservations+0xa5/0xa9
> > >>> [<ffffffff818f237a>] x86_64_start_kernel+0xe1/0xe8
> > >>> ---[ end trace 4eaa2a86a8e2da22 ]---
> > >>> ioremap reserve_memtype failed -22
> 
> The return code is -EINVAL, so it failed in the is_ram check, which is
> not too surprising
> 
> > BIOS-provided physical RAM map:
> >  BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
> >  BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
> >  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> >  BIOS-e820: 0000000000100000 - 00000000cffa3900 (usable)
> >  BIOS-e820: 00000000cffa3900 - 00000000cffa7400 (ACPI data)
> 
> The ACPI data is not starting on a page boundary and neither does the
> usable RAM area end on a page boundary. Very useful !
> 
> > ACPI: DSDT 00000000cffa3900 036CE (v01 IBM    SERLEWIS 00001000 INTL 20060912)
> 
> ACPI is trying to map DSDT at cffa3900, which results in a check
> vs. cffa3000 which is the relevant page boundary. The generic is_ram
> check correctly identifies that as RAM because it's in the usable
> resource area. The old e820 based is_ram check does not take
> overlapping resource areas into account. That's why it works.
> 
> We probably need to sanitize the E820 map befor throwing it at the
> resource manager.

Ah walk_system_ram_range() is actually doing almost the same alignment
check as the removed x86 page_is_ram(), except that it calls func()
with len=0.  This happens when page_is_ram(cffa3000) is called.

walk_system_ram_range():
               pfn = (unsigned long)(res.start >> PAGE_SHIFT);                                                                      
               len = (unsigned long)((res.end + 1 - res.start) >> PAGE_SHIFT);                                                      
               ret = (*func)(pfn, len, arg);                                                                                        

The following patch should fix the problem.

Thanks,
Fengguang
---
resource: fix generic page_is_ram() for partial RAM pages

The System RAM walk shall skip partial RAM pages and avoid calling
func() on them. So that page_is_ram() return 0 for a partial RAM page.

In particular, it shall not call func() with len=0.
This fixes a boot time bug reported by Sachin and root caused by Thomas:

> >>> WARNING: at arch/x86/mm/ioremap.c:111 __ioremap_caller+0x169/0x2f1()
> >>> Hardware name: BladeCenter LS21 -[79716AA]-
> >>> Modules linked in:
> >>> Pid: 0, comm: swapper Not tainted 2.6.33-git6-autotest #1
> >>> Call Trace:
> >>> [<ffffffff81047cff>] ? __ioremap_caller+0x169/0x2f1
> >>> [<ffffffff81063b7d>] warn_slowpath_common+0x77/0xa4
> >>> [<ffffffff81063bb9>] warn_slowpath_null+0xf/0x11
> >>> [<ffffffff81047cff>] __ioremap_caller+0x169/0x2f1
> >>> [<ffffffff813747a3>] ? acpi_os_map_memory+0x12/0x1b
> >>> [<ffffffff81047f10>] ioremap_nocache+0x12/0x14
> >>> [<ffffffff813747a3>] acpi_os_map_memory+0x12/0x1b
> >>> [<ffffffff81282fa0>] acpi_tb_verify_table+0x29/0x5b
> >>> [<ffffffff812827f0>] acpi_load_tables+0x39/0x15a
> >>> [<ffffffff8191c8f8>] acpi_early_init+0x60/0xf5
> >>> [<ffffffff818f2cad>] start_kernel+0x397/0x3a7
> >>> [<ffffffff818f2295>] x86_64_start_reservations+0xa5/0xa9
> >>> [<ffffffff818f237a>] x86_64_start_kernel+0xe1/0xe8
> >>> ---[ end trace 4eaa2a86a8e2da22 ]---
> >>> ioremap reserve_memtype failed -22

The return code is -EINVAL, so it failed in the is_ram check, which is
not too surprising

> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
>  BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000cffa3900 (usable)
>  BIOS-e820: 00000000cffa3900 - 00000000cffa7400 (ACPI data)

The ACPI data is not starting on a page boundary and neither does the
usable RAM area end on a page boundary. Very useful !

> ACPI: DSDT 00000000cffa3900 036CE (v01 IBM    SERLEWIS 00001000 INTL 20060912)

ACPI is trying to map DSDT at cffa3900, which results in a check
vs. cffa3000 which is the relevant page boundary. The generic is_ram
check correctly identifies that as RAM because it's in the usable
resource area. The old e820 based is_ram check does not take
overlapping resource areas into account. That's why it works.


CC: Sachin Sant <sachinp@in.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 kernel/resource.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- linux.orig/kernel/resource.c	2010-03-01 21:16:04.000000000 +0800
+++ linux/kernel/resource.c	2010-03-01 21:33:32.000000000 +0800
@@ -304,7 +304,7 @@ int walk_system_ram_range(unsigned long 
 		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
 	struct resource res;
-	unsigned long pfn, len;
+	unsigned long pfn, end_pfn;
 	u64 orig_end;
 	int ret = -1;
 
@@ -314,9 +314,10 @@ int walk_system_ram_range(unsigned long 
 	orig_end = res.end;
 	while ((res.start < res.end) &&
 		(find_next_system_ram(&res, "System RAM") >= 0)) {
-		pfn = (unsigned long)(res.start >> PAGE_SHIFT);
-		len = (unsigned long)((res.end + 1 - res.start) >> PAGE_SHIFT);
-		ret = (*func)(pfn, len, arg);
+		pfn = (res.start + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		end_pfn = (res.end + 1) >> PAGE_SHIFT;
+		if (end_pfn > pfn)
+		    ret = (*func)(pfn, end_pfn - pfn, arg);
 		if (ret)
 			break;
 		res.start = res.end + 1;
