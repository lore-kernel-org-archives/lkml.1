Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbYGILMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbYGILMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbYGILMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:12:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60892 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbYGILMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:12:39 -0400
Date: Wed, 9 Jul 2008 13:12:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 00 of 55] xen64: implement 64-bit Xen support
Message-ID: <20080709111219.GA24874@elte.hu>
References: <patchbomb.1215554782@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1215554782@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> Here's the set of patches to implement 64-bit Xen support.
> 
> The first part of the series is some more (fairly minor) x86 arch 
> updates which here missed in the previous series.

thanks Jeremy, applied.

Since they depend on the generic-ipi infrastructure changes, i've 
created a separate, new tip/xen-64bit branch. The tip/x86/xen-64bit got 
merged into tip/x86/core and thus is headed for upstream. I have added 
your patches to the new topic branch - see the shortlog further below.

> Following that are the Xen-specific changes to implement 64-bit 
> support.  It works fairly well, but I know of a couple of bugs:
> 
>  - 32-bit emulation doesn't work properly yet.  Something goes wrong
>    with %gs, and a userspace %gs: reference segfaults.
> 
>  - It crashes when bringing up secondary CPUs under some combinations
>    of config.  I think it isn't quite setting up all the CPU sibling
>    topology stuff for the various scheduler policies.  It's trying to
>    set up the most simple of arrangements (every CPU is a singleton
>    with no shared cache or anything else).  It was quite tricky to
>    arrange this...
> 
> I hope to have followup patches to address both of these in the next 
> couple of days.  I expect both fixes will be small.

that's OK, it should only affect 64-bit Xen, correct?

Right now we need to get the generic impact of these patches tested, 
fixes to xen64 functionality can be done later on in an add-on manner.

Testing: i've done a trial merge of tip/xen-64bit to tip/master - not 
pushed out yet. If it holds up in testing i'll put the integration rule 
into tip/master.

tip/xen-64bit (which i've just pushed out) can be cleanly git-merged 
into tip/master, so if you send updates then please send it against such 
a merged tree - even if tip/master does not have tip/xen-64bit yet. 
These patches will need at least half a day of testing before i can push 
them out.

	Ingo

-------------------------->
Eduardo Habkost (6):
      x86/paravirt: call paravirt_pagetable_setup_{start, done}
      pvops-64: call paravirt_post_allocator_init() on setup_arch()
      xen64: xen_write_idt_entry() and cvt_gate_to_trap()
      Xen64: HYPERVISOR_set_segment_base() implementation
      xen64: implement xen_load_gs_index()
      xen64: Clear %fs on xen_load_tls()

Isaku Yamahata (2):
      xen-netfront: fix xennet_release_tx_bufs()
      xen: add xen_arch_resume()/xen_timer_resume hook for ia64 support

Jeremy Fitzhardinge (47):
      x86_64: there's no need to preallocate level1_fixmap_pgt
      x86: clean up formatting of __switch_to
      x86: use __page_aligned_data/bss
      x86_64: adjust exception frame in ia32entry
      x86_64: unstatic get_local_pda
      xen: print backtrace on multicall failure
      xen: define set_pte from the outset
      xen64: define asm/xen/interface for 64-bit
      xen: make ELF notes work for 32 and 64 bit
      xen: fix 64-bit hypercall variants
      xen64: fix calls into hypercall page
      xen64: add extra pv_mmu_ops
      xen64: random ifdefs to mask out 32-bit only code
      xen64: get active_mm from the pda
      xen: move smp setup into smp.c
      x86_64: add workaround for no %gs-based percpu
      xen64: smp.c compile hacking
      xen64: add xen-head code to head_64.S
      xen64: add asm-offsets
      xen64: add 64-bit assembler
      xen64: use set_fixmap for shared_info structure
      xen: cpu_detect is 32-bit only
      xen64: add hypervisor callbacks for events, etc
      xen64: early mapping setup
      xen64: 64-bit starts using set_pte from very early
      xen64: map an initial chunk of physical memory
      xen32: create initial mappings like 64-bit
      xen: fix truncation of machine address
      xen64: use arbitrary_virt_to_machine for xen_set_pmd
      xen: set num_processors
      xen64: defer setting pagetable alloc/release ops
      xen: use set_pte_vaddr
      xen64: deal with extra words Xen pushes onto exception frames
      xen64: add pvop for swapgs
      xen64: register callbacks in arch-independent way
      xen64: add identity irq->vector map
      xen: rework pgd_walk to deal with 32/64 bit
      xen: make sure the kernel command line is right
      suspend, xen: enable PM_SLEEP for CONFIG_XEN
      xen64: implement failsafe callback
      xen64: implement 64-bit update_descriptor
      xen64: save lots of registers
      xen64: allocate and manage user pagetables
      xen64: set up syscall and sysenter entrypoints for 64-bit
      xen64: set up userspace syscall patch
      xen: implement Xen write_msr operation
      xen: update Kconfig to allow 64-bit Xen

