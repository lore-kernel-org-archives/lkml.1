Return-Path: <linux-kernel-owner+w=401wt.eu-S1762961AbZDAQMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762961AbZDAQMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbZDAQMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:12:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41423 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbZDAQMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:12:39 -0400
Date: Wed, 1 Apr 2009 18:12:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Tejun Heo <htejun@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Joe Perches <joe@perches.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] x86: percpu_to_op() misses memory and flags clobbers
Message-ID: <20090401161218.GB3859@elte.hu>
References: <49D32212.80607@cosmosbay.com> <49D32DC2.9010003@goop.org> <49D33E80.70802@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49D33E80.70802@cosmosbay.com>
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


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Jeremy Fitzhardinge a écrit :
> > Eric Dumazet wrote:
> >> While playing with new percpu_{read|write|add|sub} stuff in network tree,
> >> I found x86 asm was a litle bit optimistic.
> >>
> >> We need to tell gcc that percpu_{write|add|sub|or|xor} are modyfing
> >> memory and possibly eflags. We could add another parameter to
> >> percpu_to_op()
> >> to separate the plain "mov" case (not changing eflags),
> >> but let keep it simple for the moment.
> >>   
> > 
> > Did you observe an actual failure that this patch fixed?
> > 
> 
> Not in current tree, as we dont use yet percpu_xxxx() very much.
> 
> If deployed for SNMP mibs with hundred of call sites,
> can you guarantee it will work as is ?

Do we "guarantee" it for you? No.

Is it expected to work just fine? Yes.

Are there any known bugs in this area? No.

Will we fix it if it's demonstrated to be broken? Of course! :-)

[ Btw., it's definitely cool that you will make heavy use for it for 
  SNMP mib statistics - please share with us your experiences with 
  the facilities - good or bad experiences alike! ]

> >> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> >>
> >> diff --git a/arch/x86/include/asm/percpu.h
> >> b/arch/x86/include/asm/percpu.h
> >> index aee103b..fd4f8ec 100644
> >> --- a/arch/x86/include/asm/percpu.h
> >> +++ b/arch/x86/include/asm/percpu.h
> >> @@ -82,22 +82,26 @@ do {                            \
> >>      case 1:                        \
> >>          asm(op "b %1,"__percpu_arg(0)        \
> >>              : "+m" (var)            \
> >> -            : "ri" ((T__)val));            \
> >> +            : "ri" ((T__)val)            \
> >> +            : "memory", "cc");            \
> >>   
> > 
> > This shouldn't be necessary.   The "+m" already tells gcc that var is a
> > memory input and output, and there are no other memory side-effects
> > which it needs to be aware of; clobbering "memory" will force gcc to
> > reload all register-cached memory, which is a pretty hard hit.  I think
> > all asms implicitly clobber "cc", so that shouldn't have any effect, but
> > it does no harm.
> 
> 
> So, we can probably cleanup many asms in tree :)
> 
> static inline void __down_read(struct rw_semaphore *sem)
> {
>         asm volatile("# beginning down_read\n\t"
>                      LOCK_PREFIX "  incl      (%%eax)\n\t"
>                      /* adds 0x00000001, returns the old value */
>                      "  jns        1f\n"
>                      "  call call_rwsem_down_read_failed\n"
>                      "1:\n\t"
>                      "# ending down_read\n\t"
>                      : "+m" (sem->count)
>                      : "a" (sem)
>                      : "memory", "cc");
> }

Hm, what's your point with pasting this inline function?

> > Now, its true that the asm isn't actually modifying var itself, but
> > %gs:var, which is a different location.  But from gcc's perspective that
> > shouldn't matter because var makes a perfectly good proxy for that
> > location, and will make sure it correctly order all accesses to var.
> > 
> > I'd be surprised if this were broken, because we'd be seeing all sorts
> > of strange crashes all over the place.  We've seen it before when the
> > old x86-64 pda code didn't have proper constraints on its asm statements.
> 
> I was not saying it is broken, but a "litle bit optimistic" :)
> 
> Better be safe than sorry, because those errors are very hard to 
> track, since it depends a lot on gcc being aggressive or not. I 
> dont have time to test all gcc versions all over there.

Well, Jeremy has already made the valid point that your patch 
pessimises the constraints and hence likely causes worse code.

We can only apply assembly constraint patches that:

    either fix a demonstrated bug,

 or improve (speed up) the code emitted,

 or very rarely, we will apply patches that dont actually make the
    code worse (they are an invariant) but are perceived to be safer

This patch matches neither of these tests and in fact it will 
probably make the generated code worse.

	Ingo
