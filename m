Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab0CATBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:01:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:54234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0CATBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:01:11 -0500
Date: Mon, 1 Mar 2010 19:00:39 GMT
From: tip-bot for Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sachinp@in.ibm.com, tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       fengguang.wu@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sachinp@in.ibm.com, tglx@linutronix.de, fengguang.wu@intel.com,
       kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20100301135551.GA9998@localhost>
References: <20100301135551.GA9998@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] resource: Fix generic page_is_ram() for partial RAM pages
Message-ID: <tip-37b99dd5372cff42f83210c280f314f10f99138e@git.kernel.org>
Git-Commit-ID: 37b99dd5372cff42f83210c280f314f10f99138e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 19:00:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37b99dd5372cff42f83210c280f314f10f99138e
Gitweb:     http://git.kernel.org/tip/37b99dd5372cff42f83210c280f314f10f99138e
Author:     Wu Fengguang <fengguang.wu@intel.com>
AuthorDate: Mon, 1 Mar 2010 21:55:51 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 10:18:32 -0800

resource: Fix generic page_is_ram() for partial RAM pages

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
LKML-Reference: <20100301135551.GA9998@localhost>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 kernel/resource.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 03c897f..8f0e3d0 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -274,7 +274,7 @@ int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
 	struct resource res;
-	unsigned long pfn, len;
+	unsigned long pfn, end_pfn;
 	u64 orig_end;
 	int ret = -1;
 
@@ -284,9 +284,10 @@ int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
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
