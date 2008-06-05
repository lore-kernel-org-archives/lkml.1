Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbYFEX73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbYFEX73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 19:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYFEX7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 19:59:19 -0400
Received: from ozlabs.org ([203.10.76.45]:44433 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbYFEX7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:59:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu operations
Date: Fri, 6 Jun 2008 09:59:12 +1000
User-Agent: KMail/1.9.9
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>
References: <20080530035620.587204923@sgi.com> <200806021200.41652.rusty@rustcorp.com.au> <4846DC6B.6030802@sgi.com>
In-Reply-To: <4846DC6B.6030802@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806060959.13362.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 04:18:19 Mike Travis wrote:
> > cpu_local_inc() does all this: it takes the name of a local_t var, and is
> > expected to increment this cpu's version of that.  You ripped this out
> > and called it CPU_INC().
>
> Hi,
>
> I'm attempting to test both approaches to compare the object generated in
> order to understand the issues involved here.  Here's my code:
>
>         void test_cpu_inc(int *s)
>         {
>                 __CPU_INC(s);
>         }
>
>         void test_local_inc(local_t *t)
>         {
>                 __local_inc(THIS_CPU(t));
>         }
>
>         void test_cpu_local_inc(local_t *t)
>         {
>                 __cpu_local_inc(t);
>         }
>
> But I don't know how I can use cpu_local_inc because the pointer to the
> object is not &__get_cpu_var(l):

Yes.  Because the only true per-cpu vars are the static ones, cpu_local_inc() 
only works on identifiers, not arbitrary pointers.  Once this is fixed, we 
should be enhancing the infrastructure to allow that (AFAICT it's not too 
hard, but we should add an __percpu marker for sparse).

> At the minimum, we would need a new local_t op to get the correct
> CPU_ALLOC'd pointer value for the increment.  These new local_t ops for
> CPU_ALLOC'd variables could use CPU_XXX primitives to implement them, or
> just a base val_to_ptr primitive to replace __get_cpu_var().

I think the latter: __get_cpu_ptr() perhaps?

> I did notice this in local.h:
>
> 	 * X86_64: This could be done better if we moved the per cpu data directly
> 	 * after GS.
>
> ... which it now is, so true per_cpu variables could be optimized better as
> well.

Indeed.

>
> Also, the above cpu_local_wrap(...) adds:
>
> 	#define cpu_local_wrap(l)               \
> 	({                                      \
> 	        preempt_disable();              \
> 	        (l);                            \
> 	        preempt_enable();               \
> 	})                                      \
>
> ... and there isn't a non-preemption version that I can find.

Yes, this should be fixed.  I thought i386 had optimized versions pre-merge, 
but I was wrong (%gs for per-cpu came later, and noone cleaned up these naive 
versions).  Did you want me to write them?

I actually think that using local_t == atomic_t is better than 
preempt_disable/enable for most archs which can't do atomic deref-and-inc.

> One other distinction is CPU_INC increments an arbitrary sized variable
> while local_inc requires a local_t variable.  This may not make it usable
> in all cases.

You might be right, but note that local_t is 64 bit on 64-bit platforms.  And 
speculation of possible use cases isn't a good reason to rip out working 
infrastructure :)

Cheers,
Rusty.


>
> Thanks,
> Mike


