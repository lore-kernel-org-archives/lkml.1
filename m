Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYGOQve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYGOQve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYGOQv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:51:26 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:62565 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972AbYGOQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:51:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAFlufEhMRKxB/2dsb2JhbACBWq1d
Date: Tue, 15 Jul 2008 12:51:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 01/15] Kernel Tracepoints
Message-ID: <20080715165122.GB30082@Krystal>
References: <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins> <20080715132543.GB20037@Krystal> <1216130356.12595.184.camel@twins> <20080715142710.GC20037@Krystal> <1216132928.12595.201.camel@twins> <20080715152224.GE20037@Krystal> <1216135902.12595.214.camel@twins> <20080715160813.GB27626@Krystal> <1216139149.12595.224.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216139149.12595.224.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:31:50 up 40 days, 21:12,  5 users,  load average: 1.12, 1.78,
	1.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-07-15 at 12:08 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Tue, 2008-07-15 at 11:22 -0400, Mathieu Desnoyers wrote:
> > > > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > > > 
> > > > > I'm confused by the barrier games here.
> > > > > 
> > > > > Why not:
> > > > > 
> > > > >   void **it_func;
> > > > > 
> > > > >   preempt_disable();
> > > > >   it_func = rcu_dereference((tp)->funcs);
> > > > >   if (it_func) {
> > > > >     for (; *it_func; it_func++)
> > > > >       ((void(*)(proto))(*it_func))(args);
> > > > >   }
> > > > >   preempt_enable();
> > > > > 
> > > > > That is, why can we skip the barrier when !it_func? is that because at
> > > > > that time we don't actually dereference it_func and therefore cannot
> > > > > observe stale data?
> > > > > 
> > > > 
> > > > Exactly. I used the implementation of rcu_assign_pointer as a hint that
> > > > we did not need barriers when setting the pointer to NULL, and thus we
> > > > should not need the read barrier when reading the NULL pointer, because
> > > > it references no data.
> > > > 
> > > > #define rcu_assign_pointer(p, v) \
> > > >         ({ \
> > > >                 if (!__builtin_constant_p(v) || \
> > > >                     ((v) != NULL)) \
> > > >                         smp_wmb(); \
> > > >                 (p) = (v); \
> > > >         })
> > > 
> > > Yeah, I saw that,.. made me wonder. It basically assumes that when we
> > > write:
> > > 
> > >   rcu_assign_pointer(foo, NULL);
> > > 
> > > foo will not be used as an index or offset.
> > > 
> > > I guess Paul has thought it through and verified all in-kernel use
> > > cases, but it still makes me feel unconfortable.
> > > 
> > > > #define rcu_dereference(p)     ({ \
> > > >                                 typeof(p) _________p1 = ACCESS_ONCE(p); \
> > > >                                 smp_read_barrier_depends(); \
> > > >                                 (_________p1); \
> > > >                                 })
> > > > 
> > > > But I think you are right, since we are already in unlikely code, using
> > > > rcu_dereference as you do is better than my use of read barrier depends.
> > > > It should not change anything in the assembly result except on alpha,
> > > > where the read_barrier_depends() is not a nop.
> > > > 
> > > > I wonder if there would be a way to add this kind of NULL pointer case
> > > > check without overhead in rcu_dereference() on alpha. I guess not, since
> > > > the pointer is almost never known at compile-time. And I guess Paul must
> > > > already have thought about it. The only case where we could add this
> > > > test is when we know that we have a if (ptr != NULL) test following the
> > > > rcu_dereference(); we could then assume the compiler will merge the two
> > > > branches since they depend on the same condition.
> > > 
> > > I remember seeing a thread about all this special casing NULL, but have
> > > never been able to find it again - my google skillz always fail me.
> > > 
> > > Basically it doesn't work if you use the variable as an index/offset,
> > > because in that case 0 is a valid offset and you still generate a data
> > > dependency.
> > > 
> > > IIRC the conclusion was that the gains were too small to spend more time
> > > on it, although I would like to hear about the special case in
> > > rcu_assign_pointer.
> > > 
> > > /me goes use git blame....
> > > 
> > 
> > Actually, we could probably do the following, which also adds an extra
> > coherency check about non-NULL pointer assumptions :
> > 
> > #ifdef CONFIG_RCU_DEBUG /* this would be new */
> > #define DEBUG_RCU_BUG_ON(x) BUG_ON(x)
> > #else
> > #define DEBUG_RCU_BUG_ON(x)
> > #endif
> > 
> > #define rcu_dereference(p)     ({ \
> >                                 typeof(p) _________p1 = ACCESS_ONCE(p); \
> >                                 if (p != NULL) \
> >                                   smp_read_barrier_depends(); \
> >                                 (_________p1); \
> >                                 })
> > 
> > #define rcu_dereference_non_null(p)     ({ \
> >                                 typeof(p) _________p1 = ACCESS_ONCE(p); \
> >                                 DEBUG_RCU_BUG_ON(p == NULL); \
> >                                 smp_read_barrier_depends(); \
> >                                 (_________p1); \
> >                                 })
> > 
> > The use-case where rcu_dereference() would be used is when it is
> > followed by a null pointer check (grepping through the sources shows me
> > this is a very very common case). In rare cases, it is assumed that the
> > pointer is never NULL and it is used just after the rcu_dereference. It
> > those cases, the extra test could be saved on alpha by using
> > rcu_dereference_non_null(p), which would check the the pointer is indeed
> > never NULL under some debug kernel configuration.
> > 
> > Does it make sense ?
> 
> This would break the case where the dereferenced variable is used as an
> index/offset where 0 is a valid value and still generates data
> dependencies.
> 
> So if with your new version we do:
> 
>   i = rcu_dereference(foo);
>   j = table[i];
> 
> which translates into:
> 
>   i = ACCESS_ONCE(foo);
>   if (i)
>     smp_read_barrier_depends();
>   j = table[i];
> 
> which when i == 0, would fail to do the barrier and can thus cause j to
> be a wrong value.
> 
> Sadly I'll have to defer to Paul to explain exactly how that can happen
> - I always get my head in a horrible twist with this case.
> 

I completely agree with you. However, given the current
rcu_assign_pointer() implementation, we already have this problem. My
proposal assumes the current rcu_assign_pointer() behavior is correct
and that those are never ever used for index/offsets.

We could enforce this as a compile-time check with something along the
lines of :

#define BUILD_BUG_ON_NOT_OFFSETABLE(x) (void)(x)[0]

And use it both in rcu_assign_pointer() and rcu_dereference().  It would
check for any type passed to rcu_assign_pointer and rcu_dereference
which is not either a pointer or an array.

Then if someone really want to shoot himself in the foot by casting a
pointer to a long after the rcu_deref, that's his problem.

Hrm, looking at rcu_assign_pointer tells me that the ((v) != NULL) test
should probably already complain if v is not a pointer. So my build test
is probably unneeded.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
