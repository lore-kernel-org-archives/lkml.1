Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYGOPua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYGOPua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYGOPuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:50:22 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:44460 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430AbYGOPuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:50:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAEZgfEhMRKxB/2dsb2JhbACBWq1O
Date: Tue, 15 Jul 2008 11:50:18 -0400
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
Message-ID: <20080715155018.GA27626@Krystal>
References: <20080709145929.352201601@polymtl.ca> <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins> <20080715132543.GB20037@Krystal> <1216130356.12595.184.camel@twins> <20080715142710.GC20037@Krystal> <1216132928.12595.201.camel@twins> <20080715152224.GE20037@Krystal> <1216135902.12595.214.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216135902.12595.214.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:49:37 up 40 days, 20:30,  5 users,  load average: 0.91, 1.19,
	1.35
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-07-15 at 11:22 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > 
> > > I'm confused by the barrier games here.
> > > 
> > > Why not:
> > > 
> > >   void **it_func;
> > > 
> > >   preempt_disable();
> > >   it_func = rcu_dereference((tp)->funcs);
> > >   if (it_func) {
> > >     for (; *it_func; it_func++)
> > >       ((void(*)(proto))(*it_func))(args);
> > >   }
> > >   preempt_enable();
> > > 
> > > That is, why can we skip the barrier when !it_func? is that because at
> > > that time we don't actually dereference it_func and therefore cannot
> > > observe stale data?
> > > 
> > 
> > Exactly. I used the implementation of rcu_assign_pointer as a hint that
> > we did not need barriers when setting the pointer to NULL, and thus we
> > should not need the read barrier when reading the NULL pointer, because
> > it references no data.
> > 
> > #define rcu_assign_pointer(p, v) \
> >         ({ \
> >                 if (!__builtin_constant_p(v) || \
> >                     ((v) != NULL)) \
> >                         smp_wmb(); \
> >                 (p) = (v); \
> >         })
> 
> Yeah, I saw that,.. made me wonder. It basically assumes that when we
> write:
> 
>   rcu_assign_pointer(foo, NULL);
> 
> foo will not be used as an index or offset.
> 
> I guess Paul has thought it through and verified all in-kernel use
> cases, but it still makes me feel unconfortable.
> 
> > #define rcu_dereference(p)     ({ \
> >                                 typeof(p) _________p1 = ACCESS_ONCE(p); \
> >                                 smp_read_barrier_depends(); \
> >                                 (_________p1); \
> >                                 })
> > 
> > But I think you are right, since we are already in unlikely code, using
> > rcu_dereference as you do is better than my use of read barrier depends.
> > It should not change anything in the assembly result except on alpha,
> > where the read_barrier_depends() is not a nop.
> > 
> > I wonder if there would be a way to add this kind of NULL pointer case
> > check without overhead in rcu_dereference() on alpha. I guess not, since
> > the pointer is almost never known at compile-time. And I guess Paul must
> > already have thought about it. The only case where we could add this
> > test is when we know that we have a if (ptr != NULL) test following the
> > rcu_dereference(); we could then assume the compiler will merge the two
> > branches since they depend on the same condition.
> 
> I remember seeing a thread about all this special casing NULL, but have
> never been able to find it again - my google skillz always fail me.
> 
> Basically it doesn't work if you use the variable as an index/offset,
> because in that case 0 is a valid offset and you still generate a data
> dependency.
> 
> IIRC the conclusion was that the gains were too small to spend more time
> on it, although I would like to hear about the special case in
> rcu_assign_pointer.
> 
> /me goes use git blame....
> 

Seems to come from :

commit d99c4f6b13b3149bc83703ab1493beaeaaaf8a2d

which refers to this discussion :

http://www.mail-archive.com/netdev@vger.kernel.org/msg54852.html

Mathieu


> > > If so, does this really matter since we're already in an unlikely
> > > section? Again, if so, this deserves a comment ;-)
> > > 
> > > [ still think those preempt_* calls should be called
> > >   rcu_read_sched_lock() or such. ]
> > > 
> > > Anyway, does this still generate better code?
> > > 
> > 
> > On x86_64 :
> > 
> >  820:   bf 01 00 00 00          mov    $0x1,%edi
> >  825:   e8 00 00 00 00          callq  82a <thread_return+0x136>
> >  82a:   48 8b 1d 00 00 00 00    mov    0x0(%rip),%rbx        # 831 <thread_return+0x13d>
> >  831:   48 85 db                test   %rbx,%rbx
> >  834:   75 21                   jne    857 <thread_return+0x163>
> >  836:   eb 27                   jmp    85f <thread_return+0x16b>
> >  838:   0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
> >  83f:   00 
> >  840:   48 8b 95 68 ff ff ff    mov    -0x98(%rbp),%rdx
> >  847:   48 8b b5 60 ff ff ff    mov    -0xa0(%rbp),%rsi
> >  84e:   4c 89 e7                mov    %r12,%rdi
> >  851:   48 83 c3 08             add    $0x8,%rbx
> >  855:   ff d0                   callq  *%rax
> >  857:   48 8b 03                mov    (%rbx),%rax
> >  85a:   48 85 c0                test   %rax,%rax
> >  85d:   75 e1                   jne    840 <thread_return+0x14c>
> >  85f:   bf 01 00 00 00          mov    $0x1,%edi
> >  864:
> > 
> > for 68 bytes.
> > 
> > My original implementation was 77 bytes, so yes, we have a win.
> 
> Ah, good good ! :-)
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
