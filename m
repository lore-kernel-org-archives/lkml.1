Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbYFDPLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbYFDPLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbYFDPLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:11:22 -0400
Received: from neuf-infra-smtp-out-sp604003av.neufgp.fr ([84.96.92.124]:33550
	"EHLO neuf-infra-smtp-out-sp604003av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818AbYFDPLV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:11:21 -0400
Message-ID: <4846B084.6000607@cosmosbay.com>
Date: Wed, 04 Jun 2008 17:11:00 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 02/41] cpu alloc: The allocator
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com> <483F8AF7.9000309@cosmosbay.com> <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com> <4846AD84.2090800@sgi.com>
In-Reply-To: <4846AD84.2090800@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis a écrit :
> Christoph Lameter wrote:
>> On Fri, 30 May 2008, Eric Dumazet wrote:
>>
>>>> +static DEFINE_PER_CPU(UNIT_TYPE, area[UNITS]);
>>>>   
>>> area[] is not guaranteed to be aligned on anything but 4 bytes.
>>>
>>> If someone then needs to call cpu_alloc(8, GFP_KERNEL, 8), it might get an non
>>> aligned result.
>>>
>>> Either you should add an __attribute__((__aligned__(PAGE_SIZE))),
>>> or take into account the real address of area[] in cpu_alloc() to avoid waste
>>> of up to PAGE_SIZE bytes
>>> per cpu.
>> I think cacheline aligning should be sufficient. People should not 
>> allocate large page aligned objects here.
> 
> I'm a bit confused.  Why is DEFINE_PER_CPU_SHARED_ALIGNED() conditioned on
> ifdef MODULE?
> 
>         #ifdef MODULE
>         #define SHARED_ALIGNED_SECTION ".data.percpu"
>         #else
>         #define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
>         #endif
> 
>         #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)                       \
>                 __attribute__((__section__(SHARED_ALIGNED_SECTION)))            \
>                 PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name             \
>                 ____cacheline_aligned_in_smp
> 
> Thanks,
> Mike
> 
> 

Because we had crashes when loading oprofile module, when a previous version of oprofile
used to use DEFINE_PER_CPU_SHARED_ALIGNED variable

module loader only takes into account the special section ".data.percpu" and ignores ".data.percpu.shared_aligned"

I therefore submitted two patches :

1) commit 8b8b498836942c0c855333d357d121c0adeefbd9
oprofile: don't request cache line alignment for cpu_buffer

Alignment was previously requested because cpu_buffer was an [NR_CPUS]
array, to avoid cache line sharing between CPUS.

After commit 608dfddd845da5ab6accef70154c8910529699f7 (oprofile: change
cpu_buffer from array to per_cpu variable ), we dont need to force an
alignement anymore since cpu_buffer sits in per_cpu zone.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


2) and commit 	44c81433e8b05dbc85985d939046f10f95901184
per_cpu: fix DEFINE_PER_CPU_SHARED_ALIGNED for modules

Current module loader lookups ".data.percpu" ELF section to perform
per_cpu relocation.  But DEFINE_PER_CPU_SHARED_ALIGNED() uses another
section (".data.percpu.shared_aligned"), currently only handled in
vmlinux.lds, not by module loader.

To correct this problem, instead of adding logic into module loader, or
using at build time a module.lds file for all arches to group
".data.percpu.shared_aligned" into ".data.percpu", just use ".data.percpu"
for modules.

Alignment requirements are correctly handled by ld and module loader.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>



