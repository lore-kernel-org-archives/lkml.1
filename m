Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbYGOQZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbYGOQZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbYGOQZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:25:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57212 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbYGOQZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:25:41 -0400
Subject: Re: [patch 01/15] Kernel Tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20080715160813.GB27626@Krystal>
References: <20080709145929.352201601@polymtl.ca>
	 <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins>
	 <20080715132543.GB20037@Krystal> <1216130356.12595.184.camel@twins>
	 <20080715142710.GC20037@Krystal> <1216132928.12595.201.camel@twins>
	 <20080715152224.GE20037@Krystal> <1216135902.12595.214.camel@twins>
	 <20080715160813.GB27626@Krystal>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:25:49 +0200
Message-Id: <1216139149.12595.224.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 12:08 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Tue, 2008-07-15 at 11:22 -0400, Mathieu Desnoyers wrote:
> > > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > > 
> > > > I'm confused by the barrier games here.
> > > > 
> > > > Why not:
> > > > 
> > > >   void **it_func;
> > > > 
> > > >   preempt_disable();
> > > >   it_func = rcu_dereference((tp)->funcs);
> > > >   if (it_func) {
> > > >     for (; *it_func; it_func++)
> > > >       ((void(*)(proto))(*it_func))(args);
> > > >   }
> > > >   preempt_enable();
> > > > 
> > > > That is, why can we skip the barrier when !it_func? is that because at
> > > > that time we don't actually dereference it_func and therefore cannot
> > > > observe stale data?
> > > > 
> > > 
> > > Exactly. I used the implementation of rcu_assign_pointer as a hint that
> > > we did not need barriers when setting the pointer to NULL, and thus we
> > > should not need the read barrier when reading the NULL pointer, because
> > > it references no data.
> > > 
> > > #define rcu_assign_pointer(p, v) \
> > >         ({ \
> > >                 if (!__builtin_constant_p(v) || \
> > >                     ((v) != NULL)) \
> > >                         smp_wmb(); \
> > >                 (p) = (v); \
> > >         })
> > 
> > Yeah, I saw that,.. made me wonder. It basically assumes that when we
> > write:
> > 
> >   rcu_assign_pointer(foo, NULL);
> > 
> > foo will not be used as an index or offset.
> > 
> > I guess Paul has thought it through and verified all in-kernel use
> > cases, but it still makes me feel unconfortable.
> > 
> > > #define rcu_dereference(p)     ({ \
> > >                                 typeof(p) _________p1 = ACCESS_ONCE(p); \
> > >                                 smp_read_barrier_depends(); \
> > >                                 (_________p1); \
> > >                                 })
> > > 
> > > But I think you are right, since we are already in unlikely code, using
> > > rcu_dereference as you do is better than my use of read barrier depends.
> > > It should not change anything in the assembly result except on alpha,
> > > where the read_barrier_depends() is not a nop.
> > > 
> > > I wonder if there would be a way to add this kind of NULL pointer case
> > > check without overhead in rcu_dereference() on alpha. I guess not, since
> > > the pointer is almost never known at compile-time. And I guess Paul must
> > > already have thought about it. The only case where we could add this
> > > test is when we know that we have a if (ptr != NULL) test following the
> > > rcu_dereference(); we could then assume the compiler will merge the two
> > > branches since they depend on the same condition.
> > 
> > I remember seeing a thread about all this special casing NULL, but have
> > never been able to find it again - my google skillz always fail me.
> > 
> > Basically it doesn't work if you use the variable as an index/offset,
> > because in that case 0 is a valid offset and you still generate a data
> > dependency.
> > 
> > IIRC the conclusion was that the gains were too small to spend more time
> > on it, although I would like to hear about the special case in
> > rcu_assign_pointer.
> > 
> > /me goes use git blame....
> > 
> 
> Actually, we could probably do the following, which also adds an extra
> coherency check about non-NULL pointer assumptions :
> 
> #ifdef CONFIG_RCU_DEBUG /* this would be new */
> #define DEBUG_RCU_BUG_ON(x) BUG_ON(x)
> #else
> #define DEBUG_RCU_BUG_ON(x)
> #endif
> 
> #define rcu_dereference(p)     ({ \
>                                 typeof(p) _________p1 = ACCESS_ONCE(p); \
>                                 if (p != NULL) \
>                                   smp_read_barrier_depends(); \
>                                 (_________p1); \
>                                 })
> 
> #define rcu_dereference_non_null(p)     ({ \
>                                 typeof(p) _________p1 = ACCESS_ONCE(p); \
>                                 DEBUG_RCU_BUG_ON(p == NULL); \
>                                 smp_read_barrier_depends(); \
>                                 (_________p1); \
>                                 })
> 
> The use-case where rcu_dereference() would be used is when it is
> followed by a null pointer check (grepping through the sources shows me
> this is a very very common case). In rare cases, it is assumed that the
> pointer is never NULL and it is used just after the rcu_dereference. It
> those cases, the extra test could be saved on alpha by using
> rcu_dereference_non_null(p), which would check the the pointer is indeed
> never NULL under some debug kernel configuration.
> 
> Does it make sense ?

This would break the case where the dereferenced variable is used as an
index/offset where 0 is a valid value and still generates data
dependencies.

So if with your new version we do:

  i = rcu_dereference(foo);
  j = table[i];

which translates into:

  i = ACCESS_ONCE(foo);
  if (i)
    smp_read_barrier_depends();
  j = table[i];

which when i == 0, would fail to do the barrier and can thus cause j to
be a wrong value.

Sadly I'll have to defer to Paul to explain exactly how that can happen
- I always get my head in a horrible twist with this case.



