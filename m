Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbXH0O4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbXH0O4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 10:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXH0O4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 10:56:31 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:39149 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082AbXH0O4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 10:56:30 -0400
Date: Mon, 27 Aug 2007 10:56:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB: use have_arch_cmpxchg()
Message-ID: <20070827145627.GB18504@Krystal>
References: <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com> <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com> <20070822000323.GG29691@Krystal> <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com> <20070822002616.GA1400@Krystal> <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com> <20070822150248.GB8504@Krystal> <84144f020708220924y6d707d50md1c95eeb58d5ce7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <84144f020708220924y6d707d50md1c95eeb58d5ce7@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:48:37 up 28 days, 15:07,  5 users,  load average: 1.47, 1.36, 0.95
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> Hi Mathieu,
> 
> On 8/22/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > Cons:
> > - Does not help code readability, i.e.:
> >
> > if (have_arch_cmpxchg())
> >         preempt_disable();
> > else
> >         local_irq_save(flags);
> 
> Heh, that's an understatement, as now slub is starting to look a bit
> like slab... ;-)  We need to hide that if-else maze into helper
> functions for sure.
> 

Hrm, actually, I don't think such have_arch_cmpxchg() macro will be
required at all because of the small performance hit disabling
preemption will have on the slow and fast paths. Let's compare, for each
of the slow path and fast path, what locking looks like on architecture
with and without local cmpxchg:

What we actually do here is:

fast path:
with local_cmpxchg:
  preempt_disable()
  preempt_enable()
without local_cmpxchg:
  preempt_disable()
  local_irq_save
  local_irq_restore
  preempt_enable()
    (we therefore disable preemption _and_ disable interrupts for
    nothing)

slow path:
both with and without local_cmpxchg():
  preempt_disable()
  preempt_enable()
  local_irq_save()
  local_irq_restore()


Therefore, we would add preempt disable/enable to the fast path of
architectures where local_cmpxchg is emulated with irqs off. But since
preempt disable/enable is just a check counter increment/decrement with
barrier() and thread flag check, I doubt it would hurt performances
enough to justify the added complexity of disabling interrupts for the
whole fast path in this case.

Mathieu


> On 8/22/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > --- slab.orig/mm/slub.c 2007-08-22 10:28:22.000000000 -0400
> > +++ slab/mm/slub.c      2007-08-22 10:51:53.000000000 -0400
> > @@ -1450,7 +1450,8 @@ static void *__slab_alloc(struct kmem_ca
> >         void **freelist = NULL;
> >         unsigned long flags;
> >
> > -       local_irq_save(flags);
> > +       if (have_arch_cmpxchg())
> > +               local_irq_save(flags);
> 
> I haven't been following on the cmpxchg_local() discussion too much so
> the obvious question is: why do we do local_irq_save() for the _has_
> cmpxchg() case here...
> 
> On 8/22/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > @@ -1553,8 +1556,12 @@ static void __always_inline *slab_alloc(
> >  {
> >         void **object;
> >         struct kmem_cache_cpu *c;
> > +       unsigned long flags;
> >
> > -       preempt_disable();
> > +       if (have_arch_cmpxchg())
> > +               preempt_disable();
> > +       else
> > +               local_irq_save(flags);
> 
> ...and preempt_disable() here?
> 
> On 8/22/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > +       if (have_arch_cmpxchg()) {
> > +               if (unlikely(cmpxchg_local(&c->freelist, object,
> > +                               object[c->offset]) != object))
> > +                       goto redo;
> > +               preempt_enable();
> > +       } else {
> > +               c->freelist = object[c->offset];
> > +               local_irq_restore(flags);
> > +       }
> 
> If you move the preempt_enable/local_irq_restore pair outside of the
> if-else block, you can make a static inline function slob_get_object()
> that does:
> 
>     static inline bool slob_get_object(struct kmem_cache *c, void **object)
>     {
>         if (have_arch_cmpxchg()) {
>             if (unlikely(cmpxchg_local(&c->freelist, object,
>                     object[c->offset]) != object))
>                 return false;
>         } else {
>             c->freelist = object[c->offset];
>         }
>         return true;
>     }
> 
> And let the compiler optimize out the branch for the non-cmpxchg case.
> Same for the reverse case too (i.e. slob_put_object).
> 
>                                 Pekka

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
