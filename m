Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbYFDSSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbYFDSSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYFDSSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:18:23 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55000 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752599AbYFDSSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:18:22 -0400
Message-ID: <4846DC6B.6030802@sgi.com>
Date: Wed, 04 Jun 2008 11:18:19 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
References: <20080530035620.587204923@sgi.com> <200805301708.51284.rusty@rustcorp.com.au> <Pine.LNX.4.64.0805301055270.14564@schroedinger.engr.sgi.com> <200806021200.41652.rusty@rustcorp.com.au>
In-Reply-To: <200806021200.41652.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> cpu_local_inc() does all this: it takes the name of a local_t var, and is 
> expected to increment this cpu's version of that.  You ripped this out and 
> called it CPU_INC().

Hi,

I'm attempting to test both approaches to compare the object generated in order
to understand the issues involved here.  Here's my code:

        void test_cpu_inc(int *s)
        {
                __CPU_INC(s);
        }

        void test_local_inc(local_t *t)
        {
                __local_inc(THIS_CPU(t));
        }

        void test_cpu_local_inc(local_t *t)
        {
                __cpu_local_inc(t);
        }

But I don't know how I can use cpu_local_inc because the pointer to the object
is not &__get_cpu_var(l):

	#define __cpu_local_inc(l)      cpu_local_inc((l))
	#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var((l))))

At the minimum, we would need a new local_t op to get the correct CPU_ALLOC'd
pointer value for the increment.  These new local_t ops for CPU_ALLOC'd variables
could use CPU_XXX primitives to implement them, or just a base val_to_ptr primitive
to replace __get_cpu_var().

I did notice this in local.h:

	 * X86_64: This could be done better if we moved the per cpu data directly
	 * after GS.

... which it now is, so true per_cpu variables could be optimized better as well.

Also, the above cpu_local_wrap(...) adds:

	#define cpu_local_wrap(l)               \
	({                                      \
	        preempt_disable();              \
	        (l);                            \
	        preempt_enable();               \
	})                                      \

... and there isn't a non-preemption version that I can find.

Here are the objects.  

0000000000000000 <test_cpu_inc>:
   0:   55                      push   %rbp
   1:   48 89 e5                mov    %rsp,%rbp
   4:   48 83 ec 08             sub    $0x8,%rsp
   8:   48 89 7d f8             mov    %rdi,0xfffffffffffffff8(%rbp)
   c:   65 48 ff 45 f8          incq   %gs:0xfffffffffffffff8(%rbp)
  11:   c9                      leaveq
  12:   c3                      retq

0000000000000013 <test_local_inc>:
  13:   55                      push   %rbp
  14:   65 48 8b 05 00 00 00    mov    %gs:0(%rip),%rax        # 1c <test_local_inc+0x9>
  1b:   00
  1c:   48 89 e5                mov    %rsp,%rbp
  1f:   48 ff 04 07             incq   (%rdi,%rax,1)
  23:   c9                      leaveq
  24:   c3                      retq


With a new local_t op then test_local_inc probably could be optimized to be
the same instructions as test_cpu_inc.

One other distinction is CPU_INC increments an arbitrary sized variable
while local_inc requires a local_t variable.  This may not make it usable
in all cases.

Thanks,
Mike
