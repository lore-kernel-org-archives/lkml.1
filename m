Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYGOPWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYGOPWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYGOPW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:22:27 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:55445 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbYGOPW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:22:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAGxafEhMRKxB/2dsb2JhbACBWq0f
Date: Tue, 15 Jul 2008 11:22:24 -0400
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
Message-ID: <20080715152224.GE20037@Krystal>
References: <20080709145929.352201601@polymtl.ca> <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins> <20080715132543.GB20037@Krystal> <1216130356.12595.184.camel@twins> <20080715142710.GC20037@Krystal> <1216132928.12595.201.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216132928.12595.201.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:48:31 up 40 days, 19:29,  5 users,  load average: 0.61, 0.82,
	0.94
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-07-15 at 10:27 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Tue, 2008-07-15 at 09:25 -0400, Mathieu Desnoyers wrote:
> > > > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > > > On Wed, 2008-07-09 at 10:59 -0400, Mathieu Desnoyers wrote:
> > > 
> > > > > > +#define __DO_TRACE(tp, proto, args)					\
> > > > > > +	do {								\
> > > > > > +		int i;							\
> > > > > > +		void **funcs;						\
> > > > > > +		preempt_disable();					\
> > > > > > +		funcs = (tp)->funcs;					\
> > > > > > +		smp_read_barrier_depends();				\
> > > > > > +		if (funcs) {						\
> > > > > > +			for (i = 0; funcs[i]; i++) {			\
> > > > > 
> > > > > can't you get rid of 'i' and write:
> > > > > 
> > > > >   void **func;
> > > > > 
> > > > >   preempt_disable();
> > > > >   func = (tp)->funcs;
> > > > >   smp_read_barrier_depends();
> > > > >   for (; func; func++)
> > > > >     ((void (*)(proto))func)(args);
> > > > >   preempt_enable();
> > > > > 
> > > > 
> > > > Yes, I though there would be an optimization to do here, I'll use your
> > > > proposal. This code snippet is especially important since it will
> > > > generate instructions near every tracepoint side. Saving a few bytes
> > > > becomes important.
> > > > 
> > > > Given that (tp)->funcs references an array of function pointers and that
> > > > it can be NULL, the if (funcs) test must still be there and we must use
> > > > 
> > > > #define __DO_TRACE(tp, proto, args)					\
> > > > 	do {								\
> > > > 		void *func;						\
> > > > 									\
> > > > 		preempt_disable();					\
> > > > 		if ((tp)->funcs) {					\
> > > > 			func = rcu_dereference((tp)->funcs);		\
> > > > 			for (; func; func++) {				\
> > > > 				((void(*)(proto))(func))(args);		\
> > > > 			}						\
> > > > 		}							\
> > > > 		preempt_enable();					\
> > > > 	} while (0)
> > > > 
> > > > 
> > > > The resulting assembly is a bit more dense than my previous
> > > > implementation, which is good :
> > > 
> > > My version also has that if ((tp)->funcs), but its hidden in the 
> > > for (; func; func++) loop. The only thing your version does is an extra
> > > test of tp->funcs but without read depends barrier - not sure if that is
> > > ok.
> > > 
> > 
> > Hrm, you are right, the implementation I just proposed is bogus. (but so
> > was yours) ;)
> > 
> > func is an iterator on the funcs array. My typing of func is thus wrong,
> > it should be void **. Otherwise I'm just incrementing the function
> > address which is plain wrong.
> > 
> > The read barrier is included in rcu_dereference() now. But given that we
> > have to take a pointer to the array as an iterator, we would have to
> > rcu_dereference() our iterator multiple times and then have many read
> > barrier depends, which we don't need. This is why I would go back to a
> > smp_read_barrier_depends().
> > 
> > Also, I use a NULL entry at the end of the funcs array as an end of
> > array identifier. However, I cannot use this in the for loop both as a
> > check for NULL array and check for NULL array element. This is why a if
> > () test is needed in addition to the for loop test. (this is actually
> > what is wrong in the implementation you proposed : you treat func both
> > as a pointer to the function pointer array and as a function pointer)
> 
> Ah, D'0h! Indeed.
> 
> > Something like this seems better :
> > 
> > #define __DO_TRACE(tp, proto, args)                                     \
> >         do {                                                            \
> >                 void **it_func;                                         \
> >                                                                         \
> >                 preempt_disable();                                      \
> >                 it_func = (tp)->funcs;                                  \
> >                 if (it_func) {                                          \
> >                         smp_read_barrier_depends();                     \
> >                         for (; *it_func; it_func++)                     \
> >                                 ((void(*)(proto))(*it_func))(args);     \
> >                 }                                                       \
> >                 preempt_enable();                                       \
> >         } while (0)
> > 
> > What do you think ?
> 
> I'm confused by the barrier games here.
> 
> Why not:
> 
>   void **it_func;
> 
>   preempt_disable();
>   it_func = rcu_dereference((tp)->funcs);
>   if (it_func) {
>     for (; *it_func; it_func++)
>       ((void(*)(proto))(*it_func))(args);
>   }
>   preempt_enable();
> 
> That is, why can we skip the barrier when !it_func? is that because at
> that time we don't actually dereference it_func and therefore cannot
> observe stale data?
> 

Exactly. I used the implementation of rcu_assign_pointer as a hint that
we did not need barriers when setting the pointer to NULL, and thus we
should not need the read barrier when reading the NULL pointer, because
it references no data.

#define rcu_assign_pointer(p, v) \
        ({ \
                if (!__builtin_constant_p(v) || \
                    ((v) != NULL)) \
                        smp_wmb(); \
                (p) = (v); \
        })

#define rcu_dereference(p)     ({ \
                                typeof(p) _________p1 = ACCESS_ONCE(p); \
                                smp_read_barrier_depends(); \
                                (_________p1); \
                                })

But I think you are right, since we are already in unlikely code, using
rcu_dereference as you do is better than my use of read barrier depends.
It should not change anything in the assembly result except on alpha,
where the read_barrier_depends() is not a nop.

I wonder if there would be a way to add this kind of NULL pointer case
check without overhead in rcu_dereference() on alpha. I guess not, since
the pointer is almost never known at compile-time. And I guess Paul must
already have thought about it. The only case where we could add this
test is when we know that we have a if (ptr != NULL) test following the
rcu_dereference(); we could then assume the compiler will merge the two
branches since they depend on the same condition.

> If so, does this really matter since we're already in an unlikely
> section? Again, if so, this deserves a comment ;-)
> 
> [ still think those preempt_* calls should be called
>   rcu_read_sched_lock() or such. ]
> 
> Anyway, does this still generate better code?
> 

On x86_64 :

 820:   bf 01 00 00 00          mov    $0x1,%edi
 825:   e8 00 00 00 00          callq  82a <thread_return+0x136>
 82a:   48 8b 1d 00 00 00 00    mov    0x0(%rip),%rbx        # 831 <thread_return+0x13d>
 831:   48 85 db                test   %rbx,%rbx
 834:   75 21                   jne    857 <thread_return+0x163>
 836:   eb 27                   jmp    85f <thread_return+0x16b>
 838:   0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
 83f:   00 
 840:   48 8b 95 68 ff ff ff    mov    -0x98(%rbp),%rdx
 847:   48 8b b5 60 ff ff ff    mov    -0xa0(%rbp),%rsi
 84e:   4c 89 e7                mov    %r12,%rdi
 851:   48 83 c3 08             add    $0x8,%rbx
 855:   ff d0                   callq  *%rax
 857:   48 8b 03                mov    (%rbx),%rax
 85a:   48 85 c0                test   %rax,%rax
 85d:   75 e1                   jne    840 <thread_return+0x14c>
 85f:   bf 01 00 00 00          mov    $0x1,%edi
 864:

for 68 bytes.

My original implementation was 77 bytes, so yes, we have a win.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
