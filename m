Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYGOOl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYGOOl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYGOOlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:41:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43163 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYGOOlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:41:50 -0400
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
In-Reply-To: <20080715142710.GC20037@Krystal>
References: <20080709145929.352201601@polymtl.ca>
	 <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins>
	 <20080715132543.GB20037@Krystal> <1216130356.12595.184.camel@twins>
	 <20080715142710.GC20037@Krystal>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 16:42:08 +0200
Message-Id: <1216132928.12595.201.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 10:27 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Tue, 2008-07-15 at 09:25 -0400, Mathieu Desnoyers wrote:
> > > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > > On Wed, 2008-07-09 at 10:59 -0400, Mathieu Desnoyers wrote:
> > 
> > > > > +#define __DO_TRACE(tp, proto, args)					\
> > > > > +	do {								\
> > > > > +		int i;							\
> > > > > +		void **funcs;						\
> > > > > +		preempt_disable();					\
> > > > > +		funcs = (tp)->funcs;					\
> > > > > +		smp_read_barrier_depends();				\
> > > > > +		if (funcs) {						\
> > > > > +			for (i = 0; funcs[i]; i++) {			\
> > > > 
> > > > can't you get rid of 'i' and write:
> > > > 
> > > >   void **func;
> > > > 
> > > >   preempt_disable();
> > > >   func = (tp)->funcs;
> > > >   smp_read_barrier_depends();
> > > >   for (; func; func++)
> > > >     ((void (*)(proto))func)(args);
> > > >   preempt_enable();
> > > > 
> > > 
> > > Yes, I though there would be an optimization to do here, I'll use your
> > > proposal. This code snippet is especially important since it will
> > > generate instructions near every tracepoint side. Saving a few bytes
> > > becomes important.
> > > 
> > > Given that (tp)->funcs references an array of function pointers and that
> > > it can be NULL, the if (funcs) test must still be there and we must use
> > > 
> > > #define __DO_TRACE(tp, proto, args)					\
> > > 	do {								\
> > > 		void *func;						\
> > > 									\
> > > 		preempt_disable();					\
> > > 		if ((tp)->funcs) {					\
> > > 			func = rcu_dereference((tp)->funcs);		\
> > > 			for (; func; func++) {				\
> > > 				((void(*)(proto))(func))(args);		\
> > > 			}						\
> > > 		}							\
> > > 		preempt_enable();					\
> > > 	} while (0)
> > > 
> > > 
> > > The resulting assembly is a bit more dense than my previous
> > > implementation, which is good :
> > 
> > My version also has that if ((tp)->funcs), but its hidden in the 
> > for (; func; func++) loop. The only thing your version does is an extra
> > test of tp->funcs but without read depends barrier - not sure if that is
> > ok.
> > 
> 
> Hrm, you are right, the implementation I just proposed is bogus. (but so
> was yours) ;)
> 
> func is an iterator on the funcs array. My typing of func is thus wrong,
> it should be void **. Otherwise I'm just incrementing the function
> address which is plain wrong.
> 
> The read barrier is included in rcu_dereference() now. But given that we
> have to take a pointer to the array as an iterator, we would have to
> rcu_dereference() our iterator multiple times and then have many read
> barrier depends, which we don't need. This is why I would go back to a
> smp_read_barrier_depends().
> 
> Also, I use a NULL entry at the end of the funcs array as an end of
> array identifier. However, I cannot use this in the for loop both as a
> check for NULL array and check for NULL array element. This is why a if
> () test is needed in addition to the for loop test. (this is actually
> what is wrong in the implementation you proposed : you treat func both
> as a pointer to the function pointer array and as a function pointer)

Ah, D'0h! Indeed.

> Something like this seems better :
> 
> #define __DO_TRACE(tp, proto, args)                                     \
>         do {                                                            \
>                 void **it_func;                                         \
>                                                                         \
>                 preempt_disable();                                      \
>                 it_func = (tp)->funcs;                                  \
>                 if (it_func) {                                          \
>                         smp_read_barrier_depends();                     \
>                         for (; *it_func; it_func++)                     \
>                                 ((void(*)(proto))(*it_func))(args);     \
>                 }                                                       \
>                 preempt_enable();                                       \
>         } while (0)
> 
> What do you think ?

I'm confused by the barrier games here.

Why not:

  void **it_func;

  preempt_disable();
  it_func = rcu_dereference((tp)->funcs);
  if (it_func) {
    for (; *it_func; it_func++)
      ((void(*)(proto))(*it_func))(args);
  }
  preempt_enable();

That is, why can we skip the barrier when !it_func? is that because at
that time we don't actually dereference it_func and therefore cannot
observe stale data?

If so, does this really matter since we're already in an unlikely
section? Again, if so, this deserves a comment ;-)

[ still think those preempt_* calls should be called
  rcu_read_sched_lock() or such. ]

Anyway, does this still generate better code?

