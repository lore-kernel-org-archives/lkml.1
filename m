Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYGPNBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYGPNBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbYGPNBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:01:32 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49483 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754611AbYGPNBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:01:31 -0400
Message-ID: <487DF12A.1090604@sgi.com>
Date: Wed, 16 Jul 2008 06:01:30 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH 7/8] cpumask: Provide a generic set of CPUMASK_ALLOC macros
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>	 <20080715211430.448714000@polaris-admin.engr.sgi.com> <36ca99e90807152341h28ec137do76fbf85bd50a3abe@mail.gmail.com> <487DE8BB.5070407@sgi.com>
In-Reply-To: <487DE8BB.5070407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Bert Wesarg wrote:
...
>>> + *   CPUMASK_VAR(v, m)                 Declares cpumask_t *v =
>>> + *                                             m + offset(struct m, v)
>>                                                       offsetof
>> and why can't you use a &(m->v)?
> 
> I thought about this but what if kmalloc fails?  It's ok to add the
> offset to a NULL pointer, but dereferencing a null pointer (even though
> it's just to get the address) may introduce a fault, yes?
> 
> I'll look into this further.  

Answering my own question, apparently it is ok.  The pointer is simply used
to provide the base to which the offset is added.  

        struct allmasks *allmasks = ((void *)0);
  400557:       48 c7 45 d8 00 00 00    movq   $0x0,0xffffffffffffffd8(%rbp)
  40055e:       00

        cpumask_t *online_policy_cpus = &(allmasks->online_policy_cpus);
  40055f:       48 8b 45 d8             mov    0xffffffffffffffd8(%rbp),%rax
  400563:       48 89 45 e0             mov    %rax,0xffffffffffffffe0(%rbp)
        cpumask_t *saved_mask = &(allmasks->saved_mask);
  400567:       48 8b 45 d8             mov    0xffffffffffffffd8(%rbp),%rax
  40056b:       48 05 00 02 00 00       add    $0x200,%rax
  400571:       48 89 45 e8             mov    %rax,0xffffffffffffffe8(%rbp)
        cpumask_t *set_mask = &(allmasks->set_mask);
  400575:       48 8b 45 d8             mov    0xffffffffffffffd8(%rbp),%rax
  400579:       48 05 00 04 00 00       add    $0x400,%rax
  40057f:       48 89 45 f0             mov    %rax,0xfffffffffffffff0(%rbp)
        cpumask_t *covered_cpus = &(allmasks->covered_cpus);
  400583:       48 8b 45 d8             mov    0xffffffffffffffd8(%rbp),%rax
  400587:       48 05 00 06 00 00       add    $0x600,%rax
  40058d:       48 89 45 f8             mov    %rax,0xfffffffffffffff8(%rbp)

Sometimes the most obvious is also the most elusive... ;-)

I've updated the code and the patch description to clarify the checking
of a NULL structure base before using the cpumask_t pointers.  I've also
changed CPUMASK_VAR to CPUMASK_PTR to be a bit more clear on it's function.

  * Provide a generic set of CPUMASK_ALLOC macros patterned after the
    SCHED_CPUMASK_ALLOC macros.  This is used where multiple cpumask_t
    variables are declared on the stack to reduce the amount of stack
    space required when the NR_CPUS count is large enough to warrant it.

    Basically, if NR_CPUS <= BITS_PER_LONG then the multiple cpumask_t
    structure (which needs to be pre-defined) is declared as a local
    variable and pointers to each mask is provided.  The compiler
    will optimize out the extra dereference, resulting in code that
    is the same without the pointer reference.

    If NR_CPUS > BITS_PER_LONG, then instead of declaring the combined
    cpumask_t structure on the stack, kmalloc is used to obtain the
    memory space.  In this case, the CPUMASK_FREE is now kfree instead
    of a nop.

    For both cases, CPUMASK_PTR declares and initializes each cpumask_t
    pointer but these should *not* be used before the structure pointer
    is verified not to be NULL.  (This check for NULL will be optimized
    out for the case where the structure is declared as local memory.)

One question that remains, should the threshold to use kmalloc be
BITS_PER_LONG or something larger?  Sched uses NR_CPUS > 128, though
it has about 7 cpumask_t vars it uses.  My (obvious) concern is when
NR_CPUS is 4096 (and soon 16384), but where is the line between a
fairly large system and a really huge system?

Thanks,
Mike
