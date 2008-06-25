Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYFYInf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYFYInf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 04:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYFYInZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 04:43:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44751 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYFYInY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:43:24 -0400
Date: Wed, 25 Jun 2008 10:42:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen
	support
Message-ID: <20080625084253.GA11524@elte.hu>
References: <patchbomb.1214367536@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1214367536@localhost>
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
> This series lays the groundwork for 64-bit Xen support.  It follows 
> the usual pattern: a series of general cleanups and improvements, 
> followed by additions and modifications needed to slide Xen in.

cool stuff :-)

> Most of the 64-bit paravirt-ops work has already been done and 
> integrated for some time, so the changes are relatively minor.
> 
> Interesting and potentially hazardous changes in this series are:
> 
> "paravirt/x86_64: move __PAGE_OFFSET to leave a space for hypervisor"
> 
> This moves __PAGE_OFFSET up by 16 GDT slots, from 0xffff810000000000 
> to 0xffff880000000000.  I have no general justification for this: the 
> specific reason is that Xen claims the first 16 kernel GDT slots for 
> itself, and we must move up the mapping to make room.  In the process 
> I parameterised the compile-time construction of the initial 
> pagetables in head_64.S to cope with it.

This reduces native kernel max memory support from around 127 TB to 
around 120 TB. We also limit the Xen hypervisor to ~7 TB of physical 
memory - is that wise in the long run? Sure, current CPUs support 40 
physical bits [1 TB] for now so it's all theoretical at this moment.

my guess is that CPU makers will first extend the physical lines all the 
way up to 46-47 bits before they are willing to touch the logical model 
and extend the virtual space beyond 48 bits (47 bits of that available 
to kernel-space in practice - i.e. 128 TB).

So eventually, in a few years, we'll feel some sort of crunch when the # 
of physical lines approaches the # of logical bits - just like when 
32-bit felt a crunch when physical lines went to 31 and beyond.

> "x86_64: adjust mapping of physical pagetables to work with Xen"
> "x86_64: create small vmemmap mappings if PSE not available"
> 
> This rearranges the construction of the physical mapping so that it
> works with Xen.  This affects three aspects of the code:
>  1. It can't use pse, so it will only use pse if the processor
>     supports it.
>  2. It never replaces an existing mapping, so it can just extend the
>     early boot-provided mappings (either from head_64.S or the Xen domain
>     builder).
>  3. It makes sure that any page is iounmapped before attaching it to the 
>     pagetable to avoid having writable aliases of pagetable pages.
> 
> The logical structure of the code is more or less unchanged, and still
> works fine in the native case.
> 
> vmemmap mapping is likewise changed.
> 
> "x86_64: PSE no longer a hard requirement."
> 
> Because booting under Xen doesn't set PSE, it's no longer a hard 
> requirement for the kernel.  PSE will be used whereever possible.

That should be fine too - and probably useful for 64-bit kmemcheck 
support as well.

To further increase the symmetry between 64-bit and 32-bit, could you 
please also activate the mem=nopentium switch on 64-bit to allow the 
forcing of a non-PSE native 64-bit bootup? (Obviously not a good idea 
normally, as it wastes 0.1% of RAM and increases PTE related CPU cache 
footprint and TLB overhead, but it is useful for debugging.)

a few other risk areas:

- the vmalloc-sync changes. Are you absolutely sure that it does not
  matter for performance?

- "The 32-bit early_ioremap will work equally well for 64-bit, so just
   use it." Famous last words ;-)

Anyway, that's all theory - i'll try out your patchset in -tip to see 
what breaks in practice ;-)

	Ingo
