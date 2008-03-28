Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbYC1AR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbYC1AR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYC1ART
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:17:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40855 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYC1ARS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:17:18 -0400
Date: Fri, 28 Mar 2008 09:20:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: Trying to make use of hotplug memory for xen balloon driver
Message-Id: <20080328092057.82864a58.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47EC099C.9030609@goop.org>
References: <47EAD83A.2000000@goop.org>
	<20080327095059.5d2759a3.kamezawa.hiroyu@jp.fujitsu.com>
	<47EB3765.8020702@goop.org>
	<20080327151115.be9f325d.kamezawa.hiroyu@jp.fujitsu.com>
	<47EC099C.9030609@goop.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 13:54:52 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Wed, 26 Mar 2008 22:57:57 -0700
> > Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >   
> >> Ah, I see what it is.  I wasn't trying to add enough memory.  It adds in 
> >> units of SECTION_SIZE_BITS, which is 2^30 on 32-bit PAE.  When I 
> >> increase the initial balloon extension to PAGES_PER_SECTION pages, I 
> >> make some more progress:
> >>
> >> xen_balloon: Initialising balloon driver.
> >> trying to reserve 262144 pages (1073741824 bytes) for balloon
> >> bootmem alloc of 147456 bytes failed!
> >> Kernel panic - not syncing: Out of memory
> >> Pid: 1, comm: swapper Not tainted 2.6.25-rc7-x86-latest.git-dirty #361
> >>  [<c01299dc>] panic+0x49/0x102
> >>  [<c0647c3c>] __alloc_bootmem+0x24/0x29
> >>  [<c0647c6d>] __alloc_bootmem_node+0x2c/0x34
> >>  [<c044bd97>] zone_wait_table_init+0x45/0x95
> >>  [<c0467258>] init_currently_empty_zone+0x1d/0xaa
> >>  [<c01738ea>] __add_pages+0x88/0xdb
> >>  [<c011c1a5>] arch_add_memory+0x25/0x2b
> >>  [<c01737a9>] add_memory_resource+0x2f/0x36
> >>  [<c064e487>] balloon_init+0x1b8/0x2b9
> >>  [<c0635495>] kernel_init+0x137/0x292
> >>  [<c063535e>] ? kernel_init+0x0/0x292
> >>  [<c063535e>] ? kernel_init+0x0/0x292
> >>  [<c0108b67>] kernel_thread_helper+0x7/0x10
> >>  =======================
> >>
> >>
> >> What's the rationale for setting SECTION_SIZE_BITS to 30?  Seems like a 
> >> fairly large chunk.
> >>
> >>     
> > At first, I believe usual DIMM size is bigger than SECTION_SIZE_BITS. This is
> > designed for hardware-based hotplug.
> >
> > If you want to use memory-hotplug for virtualized enviroment, it's good to make
> > this to be smaller chunk. Powerpc/IBM lpar uses 16MB chunk.
> >
> > It's a trade-off between section mainainance cost v.s. size of plugged memory.
> > please find the best.
> 
> Hm, I tried reducing it to 2^28 (=256M), but I get a compilation failure:
> 
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from /home/jeremy/hg/xen/paravirt/linux/include/linux/suspend.h:11,
>                  from /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/asm-offsets_32.c:11,
>                  from /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/asm-offsets.c:2:
> /home/jeremy/hg/xen/paravirt/linux/include/linux/mm.h:458:2: error: #error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
> make[3]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> 
Ah, Now, section number of the page is encoded in page->flags.
(Sorry, I'm usually working on 64bit memory-hotplug...)
see mm.h
==
 371  * There are three possibilities for how page->flags get
 372  * laid out.  The first is for the normal case, without
 373  * sparsemem.  The second is for sparsemem when there is
 374  * plenty of space for node and section.  The last is when
 375  * we have run out of space and have to fall back to an
 376  * alternate (slower) way of determining the node.
 377  *
 378  *        No sparsemem: |       NODE     | ZONE | ... | FLAGS |
 379  * with space for node: | SECTION | NODE | ZONE | ... | FLAGS |
 380  *   no space for node: | SECTION |     ZONE    | ... | FLAGS |
==

Hmm, in other archs, sparsemem-vmemmap allows us to remove bits for section
(recent Christoph's work.) But for x86-32, kernel's NORMAL area seems to be
not enough to maintain vmemmap.

I have no good idea against this, now.

Thanks,
-Kame




