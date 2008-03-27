Return-Path: <linux-kernel-owner+w=401wt.eu-S1760974AbYC0UzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbYC0UzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbYC0UzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:55:10 -0400
Received: from gw.goop.org ([64.81.55.164]:45391 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259AbYC0UzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:55:09 -0400
Message-ID: <47EC099C.9030609@goop.org>
Date: Thu, 27 Mar 2008 13:54:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: Trying to make use of hotplug memory for xen balloon driver
References: <47EAD83A.2000000@goop.org>	<20080327095059.5d2759a3.kamezawa.hiroyu@jp.fujitsu.com>	<47EB3765.8020702@goop.org> <20080327151115.be9f325d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080327151115.be9f325d.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 26 Mar 2008 22:57:57 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Ah, I see what it is.  I wasn't trying to add enough memory.  It adds in 
>> units of SECTION_SIZE_BITS, which is 2^30 on 32-bit PAE.  When I 
>> increase the initial balloon extension to PAGES_PER_SECTION pages, I 
>> make some more progress:
>>
>> xen_balloon: Initialising balloon driver.
>> trying to reserve 262144 pages (1073741824 bytes) for balloon
>> bootmem alloc of 147456 bytes failed!
>> Kernel panic - not syncing: Out of memory
>> Pid: 1, comm: swapper Not tainted 2.6.25-rc7-x86-latest.git-dirty #361
>>  [<c01299dc>] panic+0x49/0x102
>>  [<c0647c3c>] __alloc_bootmem+0x24/0x29
>>  [<c0647c6d>] __alloc_bootmem_node+0x2c/0x34
>>  [<c044bd97>] zone_wait_table_init+0x45/0x95
>>  [<c0467258>] init_currently_empty_zone+0x1d/0xaa
>>  [<c01738ea>] __add_pages+0x88/0xdb
>>  [<c011c1a5>] arch_add_memory+0x25/0x2b
>>  [<c01737a9>] add_memory_resource+0x2f/0x36
>>  [<c064e487>] balloon_init+0x1b8/0x2b9
>>  [<c0635495>] kernel_init+0x137/0x292
>>  [<c063535e>] ? kernel_init+0x0/0x292
>>  [<c063535e>] ? kernel_init+0x0/0x292
>>  [<c0108b67>] kernel_thread_helper+0x7/0x10
>>  =======================
>>
>>
>> What's the rationale for setting SECTION_SIZE_BITS to 30?  Seems like a 
>> fairly large chunk.
>>
>>     
> At first, I believe usual DIMM size is bigger than SECTION_SIZE_BITS. This is
> designed for hardware-based hotplug.
>
> If you want to use memory-hotplug for virtualized enviroment, it's good to make
> this to be smaller chunk. Powerpc/IBM lpar uses 16MB chunk.
>
> It's a trade-off between section mainainance cost v.s. size of plugged memory.
> please find the best.

Hm, I tried reducing it to 2^28 (=256M), but I get a compilation failure:

  CC      arch/x86/kernel/asm-offsets.s
In file included from /home/jeremy/hg/xen/paravirt/linux/include/linux/suspend.h:11,
                 from /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/asm-offsets_32.c:11,
                 from /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/asm-offsets.c:2:
/home/jeremy/hg/xen/paravirt/linux/include/linux/mm.h:458:2: error: #error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
make[3]: *** [arch/x86/kernel/asm-offsets.s] Error 1


2^29 works.

    J

