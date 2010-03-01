Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab0CAKnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:43:41 -0500
Received: from www.tglx.de ([62.245.132.106]:40355 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab0CAKnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:43:37 -0500
Date: Mon, 1 Mar 2010 11:42:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiaotian Feng <xtfeng@gmail.com>
cc: Sachin Sant <sachinp@in.ibm.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: 2.6.33-git6 boot failure[x86_64] (WARN: at
 arch/x86/mm/ioremap.c:111)
In-Reply-To: <7b6bb4a51003010038l49c90414lff1ecaa37c96ad61@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003011058470.4245@localhost.localdomain>
References: <4B8B43E9.1010506@in.ibm.com>  <7b6bb4a51002282218u22c8f4c4wb2a345fcb7a82257@mail.gmail.com>  <4B8B7AC7.1070201@in.ibm.com> <7b6bb4a51003010038l49c90414lff1ecaa37c96ad61@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010, Xiaotian Feng wrote:
> On Mon, Mar 1, 2010 at 4:28 PM, Sachin Sant <sachinp@in.ibm.com> wrote:
> > Xiaotian Feng wrote:
> >> On Mon, Mar 1, 2010 at 12:34 PM, Sachin Sant <sachinp@in.ibm.com> wrote:
>
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

We probably need to sanitize the E820 map befor throwing it at the
resource manager.

Thanks,

	tglx
