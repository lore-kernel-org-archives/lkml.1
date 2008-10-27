Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbYJ0XHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbYJ0XHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYJ0XHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:07:34 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:57182 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYJ0XHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:07:31 -0400
Message-ID: <490649AE.6050905@ct.jp.nec.com>
Date: Mon, 27 Oct 2008 16:07:26 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip/cpus4096-v2] cpumask: fix cpumask of	call_function_data
References: <49015358.9050308@ct.jp.nec.com> <200810242215.19440.rusty@rustcorp.com.au> <20081027125512.GD12461@elte.hu> <20081027125904.GA24347@elte.hu> <20081027133248.GA1007@elte.hu>
In-Reply-To: <20081027133248.GA1007@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> in any case, i've started testing tip/cpus4096-v2 again on x86 - the 
>> problem with d4de5a above was the only outstanding known issue, right?
> 
> the sched_init() slab corruption bug is still there, i just triggered it 
> on two separate test-systems:
> 
> [    0.510620] CPU1 attaching sched-domain:
> [    0.512007]  domain 0: span 0-1 level CPU
> [    0.517730]   groups: 1 0
> [    0.520528] =============================================================================
> [    0.524002] BUG kmalloc-8: Wrong object count. Counter is 11 but counted were 50
> [    0.524002] -----------------------------------------------------------------------------
> [    0.524002] 

Hm,

I think kmalloc-8 is too small.
In this case, struct cpumask is defined;

struct cpumask {
        DECLARE_BITMAP(bits, NR_CPUS);
};

So, storing cpumask such as cpu_core_map, cpu_sibling_map and sd->span etc.
requires NR_CPUS bits. In Ingo's config, it needs 4096 bits.

At alloc_cpumask_var uses cpumask_size() for kmalloc(),

bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
{
        if (likely(slab_is_available()))
                *mask = kmalloc(cpumask_size(), flags);

cpumask_size() looks nr_cpumask_bits and it defined as follows;

#define nr_cpumask_bits nr_cpu_ids

it's CONFIG_NR_CPUS > BITS_PER_LONG case.
And now nr_cpu_ids is 2 on this boot log.

...
> [    0.000000] PERCPU: Allocating 1900544 bytes of per cpu data
> [    0.000000] NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1

So, kmalloc(8, flags) for cpumask_var_t at alloc_cpumask_var().
But the content is treated as cpumask_t, it causes slab corruption
with overwritten when the mask data is copied.

For example, cpu_to_core_group()

static int
cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
                  cpumask_t *mask)
{
        int group;

        *mask = per_cpu(cpu_sibling_map, cpu);

this copies 0x200 bytes (= 4096 bits), compiled my environment as follows;
ffffffff80251c56 <cpu_to_core_group>:
cpu_to_core_group():
ffffffff80251c56:       55                      push   %rbp
ffffffff80251c57:       48 63 ff                movslq %edi,%rdi
ffffffff80251c5a:       48 89 e5                mov    %rsp,%rbp
ffffffff80251c5d:       41 55                   push   %r13
ffffffff80251c5f:       49 89 d5                mov    %rdx,%r13
ffffffff80251c62:       ba 00 02 00 00          mov    $0x200,%edx
ffffffff80251c67:       41 54                   push   %r12
ffffffff80251c69:       49 89 f4                mov    %rsi,%r12
ffffffff80251c6c:       48 c7 c6 00 c1 c8 81    mov    $0xffffffff81c8c100,%rsi
ffffffff80251c73:       53                      push   %rbx
ffffffff80251c74:       48 89 cb                mov    %rcx,%rbx
ffffffff80251c77:       48 83 ec 08             sub    $0x8,%rsp
ffffffff80251c7b:       48 8b 05 3e d0 98 01    mov    0x198d03e(%rip),%rax        # ffffffff81bdecc0 <_cpu_pda>
ffffffff80251c82:       48 8b 04 f8             mov    (%rax,%rdi,8),%rax
ffffffff80251c86:       48 89 cf                mov    %rcx,%rdi
ffffffff80251c89:       48 03 70 08             add    0x8(%rax),%rsi
ffffffff80251c8d:       e8 de 29 25 00          callq  ffffffff804a4670 <__memcpy>

the 3rd parameter of __memcpy is rdx = 0x200.

So, I guess, we need
kmalloc(BITS_TO_LONGS(NR_CPUS), flags)
at alloc_cpumask_var().

Or change cpumask handling in sched.c etc?
I've no idea for this more, now.

thanks,
Hiroshi Shimamoto
