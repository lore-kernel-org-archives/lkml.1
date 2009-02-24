Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZBXJ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZBXJ5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 04:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZBXJ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 04:57:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52006 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbZBXJ5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 04:57:30 -0500
Date: Tue, 24 Feb 2009 10:57:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk
	allocation
Message-ID: <20090224095708.GA20739@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235445101-7882-1-git-send-email-tj@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello, all.
> 
> This patchset improves the first percpu chunk allocation.  The 
> problem is that the dynamic percpu area allocation maps the 
> whole percpu area into vmalloc area using 4k mappings which 
> adds considerable amount of TLB pressure.
> 
> This patchset modularizes the first percpu chunk allocation 
> and uses different allocation schemes to optimize TLB usage.
> 
> * On !NUMA, the first chunk is allocated directly using
>   alloc_bootmem() thus adding no TLB pressure whatsoever.
> 
> * On NUMA, the first chunk is remapped using large pages and 
>   whatever is left in the large page is given back to the 
>   bootmem allocator. This makes each cpu use an additional 
>   large TLB entry for the first chunk but still is much better 
>   than using many 4k TLB entries.

Hm, i think there still must be some basic misunderstanding 
somewhere here. Let me describe the design i described in the 
previous mail in more detail.

In one of your changelogs you state:

|    On NUMA, embedding allocator can't be used as different 
|    units can't be made to fall in the correct NUMA nodes.

This is a direct consequence of the unit/chunk abstraction, and 
i think that abstraction is wrong.

What i'm suggesting is to have a simple continuous [non-chunked, 
with a hole in the last bits of the first 2MB] virtual memory 
range for each CPU.

This special virtual memory starts with a 2MB page (for the 
static bits - perhaps also with a default starter dynamic area 
appended to that - we can size this reasonably) and continues 
with 4K mappings at the next 2MB boundary and goes on linearly 
from that point on.

The variables within this singular 'percpu area' mirror each 
other amongst CPUs. So if a dynamic (or static) percpu variable 
is at offset 156100 in CPU#5's range - then it will be at offset 
156100 in CPU#11's percpu area too. Each of these areas are 
tightly packed with that CPU's allocations (and only that CPU's 
allocations), there's no chunking, no units.

As with your proposal this tears down the current artificial 
distinction between static and dynamic percpu variables.

But with this approach we'd the following additional advantages:

- No dynamic-alloc single-allocation size limits _at all_ in 
  practice. [up to the total size of the virtual memory window]

  ( With your current proposal the dynamic alloc is limited to
    unit size - which is looks a bit inflexible as unit size
    impacts other characteristics so when we want to increase 
    the dynamic allocation size we'd also affect other areas of 
    the code. )

  percpu_alloc() would become as limitless (on 64-bit) as 
  vmalloc().

- no NUMA complications and no NUMA assymetry at all. When we 
  extend a CPU's percpu area we do NUMA-local allocations to 
  that CPU. The memory allocated is purely for that CPU's 
  purpose.

- We'd have a very 'compressed' pte presence in the pagetables: 
  the dynamic percpu area is as tightly packed as possible. With 
  a chunked design we 'scatter' the ptes a bit more broadly.

The only thing that gets a bit trickier is sizing - but not by 
much. The best way we can size this without practical 
complications on very small or very large systems would by 
setting the maximum _combined_ size for all percpu allocations.

Say we set this 'PERCPU_TOTAL' limit to 4 GB. That means that if 
there are 8 possible CPUs, each CPU can have up to 512 MB of 
RAM. That's plenty in practice.

We can do this splitup dynamically during bootup, because the 
area is still fully linear, relative to the percpu offset.

[ A system with 4k CPUs would want to have a larger PERCPU_TOTAL 
  - but obviously it cannot be really mind-blowingly large 
  because the total max has to be backed up with real RAM. So 
  realistically we wont have more than 1TB in the next 10 years 
  or so. Which is still well below the limitations of the 64-bit 
  address space. ]

In a non-chunked allocator the whole bitmap management becomes 
much simpler and more straightforward as well. It's also much 
easier to think about than an interleaved unit+chunk design.

The only special complication is the setup of the initial 2MB 
area - but that is tricky to bootstrap anyway because we need to 
set it up before the page allocator gets initialized. It's also 
worthwile to put the most common percpu variables, and an 
expected amount of dynamic area into a 2MB TLB.

Hm?

	Ingo
