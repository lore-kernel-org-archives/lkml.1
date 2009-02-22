Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZBVVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZBVVe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZBVVet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:34:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:38197 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZBVVes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:34:48 -0500
Message-ID: <49A1C4AF.9000009@kernel.org>
Date: Sun, 22 Feb 2009 13:33:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Kevin O'Connor" <kevin@koconnor.net>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: Re: MPTable can not be high-memory on Linux
References: <499DB40C.1060205@coresystems.de> <499DCE79.8020809@coresystems.de> <20090222152530.GA30576@morn.localdomain> <200902221806.55429.rjw@sisk.pl>
In-Reply-To: <200902221806.55429.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday 22 February 2009, Kevin O'Connor wrote:
>> Hi Stefan,
>>
>> I'm CC'ing lkml and coreboot mailing lists.
> 
> (added more CCs)
> 
>> On Thu, Feb 19, 2009 at 10:26:17PM +0100, Stefan Reinauer wrote:
>>> OK, I played some more, and I finally found out it's earlyprintk and not
>>> early_printk. Plus there is bootmem_debug:
>>>
>>> Initializing cgroup subsys cpuset
>>> Initializing cgroup subsys cpu
>>> Linux version 2.6.27.7-9-default (geeko@buildhost) (gcc version 4.3.2
>>> [gcc-4_3-branch re0
>>> PAT WC disabled due to known CPU erratum.
>>> BIOS-provided physical RAM map:
>>>  BIOS-e820: 0000000000000000 - 0000000000001000 (reserved)
>>>  BIOS-e820: 0000000000001000 - 0000000000090000 (usable)
>>>  BIOS-e820: 0000000000090000 - 0000000000100000 (reserved)
>>>  BIOS-e820: 0000000000100000 - 000000003f7f0000 (usable)
>>>  BIOS-e820: 000000003f7f0000 - 0000000040000000 (reserved)
>>>  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
>> [...]
>>> ACPI: no DMI BIOS year, acpi=force is required to enable ACPI
>>> ACPI: Disabling ACPI support
>> [...]
>>> found SMP MP-table at [c00f9fc0] 000f9fc0
>>> bootmem::mark_bootmem_node nid=0 start=f9 end=fb reserve=1 flags=0
>>> bootmem::__reserve nid=0 start=f9 end=fb flags=0
>>> bootmem::__reserve silent double reserve of PFN f9
>>> bootmem::__reserve silent double reserve of PFN fa
>>> BUG: Int 6: CR2 00000000
>>>      EDI c00f9fd0  ESI 3f7f5410  EBP 0003f7f5  ESP c0535f20
>>>      EBX c056c00c  EDX 00000006  ECX 00000001  EAX c056c03c
>>>      err 00000000  EIP c054f8f0   CS 00000060  flg 00010046
>>> Stack: 00000000 00000000 00000001 00038000 0003f7f5 f880abf0 3f7f5410
>>> c00f9fd0
>>>        00000001 c054f91d 00000000 c054571a c0413e7e c00f9fc0 000f9fc0
>>> 00000001
>>>        3f7bf64d 00000000 3e2c5000 c054578a 00000000 c053f3b6 3f7bf64d
>>> 00000000
>>>
>>> So it dies because of the way it tries to reserve the MP-table.
>>>
>>> Here's the stack trace.
>>>
>>>  [<c054f8f0>] mark_bootmem+0x9b/0xab
>>>  [<c054f91d>] reserve_bootmem+0x1d/0x1f
>>>  [<c054571a>] smp_scan_config+0xd9/0xfa
>>>  [<c054578a>] __find_smp_config+0x4f/0x6e
>>>  [<c053f3b6>] setup_arch+0x576/0x639
>>>  [<c054ebc4>] cgroup_init_subsys+0x29/0xc9
>>>  [<c053a6ac>] start_kernel+0x6b/0x31f
>>>  =======================
>> It looks like the problem is that the MPTable is located in the last
>> 64K of memory (instead of the first few megabytes).  There is a
>> comment about this in arch/x86/kernel/mpparse.c:
>>
>>    /*
>>     * We cannot access to MPC table to compute
>>     * table size yet, as only few megabytes from
>>     * the bottom is mapped now.
>>     * PC-9800's MPC table places on the very last
>>     * of physical memory; so that simply reserving
>>     * PAGE_SIZE from mpg->mpf_physptr yields BUG()
>>     * in reserve_bootmem.
>>     */
>>
>> However, that comment is in an #ifdef specific to 32bit kernels.
>> (Though, it's not clear to me how that code would help as it sets size
>> to be a negative number.)

that should work for a long time.

0xf9fc0 < 1M is quite < max_low_pfn, so wonder why bootmem could panic.

YH
