Return-Path: <linux-kernel-owner+w=401wt.eu-S965143AbZLGWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965143AbZLGWCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965111AbZLGWCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:02:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:54875 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965108AbZLGWCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:02:48 -0500
Message-ID: <4B1D7B47.4000306@kernel.org>
Date: Mon, 07 Dec 2009 14:01:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Volker Lanz <vl@fidra.de>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [BISECTED, REGRESSION] Successful resume from suspend but freezes
 after I/O
References: <200912071856.48125.vl@fidra.de> <200912072013.46332.vl@fidra.de> <4B1D561C.9030802@kernel.org> <200912072136.40202.vl@fidra.de>
In-Reply-To: <200912072136.40202.vl@fidra.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Volker Lanz wrote:
> On Monday 07 December 2009 20:23:08 Yinghai Lu wrote:
>> Volker Lanz wrote:
>>> On Monday 07 December 2009 19:24:02 Yinghai Lu wrote:
>>>> Volker Lanz wrote:
>>>>> Hi,
>>>>>
>>>>> updating to my distro's new 2.6.31 kernel on an x86_64 quad core
>>>>> machine with 6 GB of RAM I noticed resuming from suspend still worked
>>>>> as before, but the machine will now reproducably freeze (have to hard
>>>>> reset) afterwards as soon as I do something disk I/O heavy, though the
>>>>> problem is probably not related to disk activity at all.
>>>>>
>>>>> A current mainline 2.6.32 checkout shows the same behaviour.
>>>>>
>>>>> I git-bisected the problem to this commit:
>>>>>
>>>>>
>>>>> -----------------------------------------------------------------------
>>>>> -- ---- commit 78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
>>>>> Author: Yinghai Lu <yinghai@kernel.org>
>>>>> Date:   Thu Mar 12 22:36:01 2009 -0700
>>>>>
>>>>>     x86: make e820_update_range() handle small range update
>>>>>
>>>>>     Impact: enhance e820 code to handle more cases
>>>>>
>>>>>     Try to handle new range which could be covered by one entry.
>>>>>
>>>>>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>>     Cc: jbeulich@novell.com
>>>>>     LKML-Reference: <49B9F0C1.10402@kernel.org>
>>>>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>> -----------------------------------------------------------------------
>>>>> -- ----
>>>>>
>>>>>
>>>>> A kernel built from this revision does not boot, so the first booting
>>>>> kernel to show the problem actually seems to be:
>>>>>
>>>>>
>>>>> -----------------------------------------------------------------------
>>>>> -- ---- commit 6d7942dc2a70a7e74c352107b150265602671588
>>>>> Author: Yinghai Lu <yinghai@kernel.org>
>>>>> Date:   Sat Mar 14 14:32:41 2009 -0700
>>>>>
>>>>>     x86: fix 64k corruption-check
>>>>>
>>>>>     Impact: fix boot crash
>>>>>
>>>>>     Need to exit early if the addr is far above 64k.
>>>>>
>>>>>     The crash got exposed by:
>>>>>
>>>>>       78a8b35: x86: make e820_update_range() handle small range update
>>>>>
>>>>>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>>     Cc: <stable@kernel.org>
>>>>>     LKML-Reference: <49BC2279.2030101@kernel.org>
>>>>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>> -----------------------------------------------------------------------
>>>>> -- ----
>>>>>
>>>>>
>>>>> The last kernel to work without problems thus seems to be this one:
>>>>>
>>>>>
>>>>> -----------------------------------------------------------------------
>>>>> -- ---- commit 773e673de27297d07d852e7e9bfd1a695cae1da2
>>>>> Author: Yinghai Lu <yinghai@kernel.org>
>>>>> Date:   Thu Mar 12 21:35:18 2009 -0700
>>>>>
>>>>>     x86: fix e820_update_range()
>>>>>
>>>>>     Impact: fix left range size on head
>>>>>
>>>>>     | commit 5c0e6f035df983210e4d22213aed624ced502d3d
>>>>>     |    x86: fix code paths used by update_mptable
>>>>>     |    Impact: fix crashes under Xen due to unrobust e820 code
>>>>>
>>>>>     fixes one e820 bug, but introduces another bug.
>>>>>
>>>>>     Need to update size for left range at first in case it is header.
>>>>>
>>>>>     also add __e820_add_region take more parameter.
>>>>>
>>>>>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>>     Cc: jbeulich@novell.com
>>>>>     LKML-Reference: <49B9E286.502@kernel.org>
>>>>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>> -----------------------------------------------------------------------
>>>>> -- ----
>>>>>
>>>>>
>>>>> The problem is 100% reproducable on this machine: Resuming and then
>>>>> copying /usr/ to $HOME will freeze after a few hundred MB have been
>>>>> copied. Earlier kernels worked fine for the last couple of months.
>>>>>
>>>>> What additional information is required to help diagnose and hopefully
>>>>> fix the problem?
>>>> whole boot log with CONFIG_PCI_DEBUG and debug on command line.
>>> Here it is. It's huge, I hope you were expecting that...
>> and the one with current tip?
>>
>> http://people.redhat.com/mingo/tip.git/readme.txt
> 
> With this kernel, the problem persists. Here's the log:
> 
> 
> -----------------------------------------------------------------------------
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.32-tip-02731-gd17424f (vl@trevor) (gcc 
> version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #22 SMP Mon Dec 7 21:09:21 CET 2009
> [    0.000000] Command line: root=UUID=160351ee-c9b0-4a72-9fd5-9962c8137a7e ro 
> nosplash debug
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
> [    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.4 present.
> [    0.000000] last_pfn = 0x1b0000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CBFFF write-protect
> [    0.000000]   CC000-EFFFF uncachable
> [    0.000000]   F0000-FFFFF write-through
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F00000000 write-back
> [    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
> [    0.000000]   2 base 0D0000000 mask FF0000000 uncachable
> [    0.000000]   3 base 100000000 mask F00000000 write-back
> [    0.000000]   4 base 1C0000000 mask FC0000000 uncachable
> [    0.000000]   5 base 1B0000000 mask FF0000000 uncachable
> [    0.000000]   6 base 0CFF00000 mask FFFF00000 uncachable
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
> 0x7010600070106
> [    0.000000] e820 update range: 00000000cff00000 - 0000000100000000 (usable) 
> ==> (reserved)
> [    0.000000] last_pfn = 0xcfee0 max_arch_pfn = 0x400000000
> [    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) 
> ==> (reserved)
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
> [    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
> [    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
> [    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  modified: 0000000000100000 - 00000000cfee0000 (usable)
> [    0.000000]  modified: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
> [    0.000000]  modified: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
> [    0.000000]  modified: 00000000cfef0000 - 00000000cff00000 (reserved)
> [    0.000000]  modified: 00000000e0000000 - 00000000e4000000 (reserved)
> [    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000]  modified: 0000000100000000 - 00000001b0000000 (usable)

can you try to disable

CONFIG_X86_CHECK_BIOS_CORRUPTION
and
CONFIG_X86_RESERVE_LOW_64K

YH
