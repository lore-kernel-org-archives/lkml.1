Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbYGORug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbYGORug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYGORu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:50:28 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:61297 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142AbYGORu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:50:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAFh9fEhMRKxB/2dsb2JhbACBWq13
Date: Tue, 15 Jul 2008 13:50:25 -0400
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
Message-ID: <20080715175025.GA1936@Krystal>
References: <20080709145929.352201601@polymtl.ca> <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins> <20080715132543.GB20037@Krystal> <1216130356.12595.184.camel@twins> <20080715142710.GC20037@Krystal> <1216132928.12595.201.camel@twins> <20080715152224.GE20037@Krystal> <1216135902.12595.214.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216135902.12595.214.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:43:53 up 40 days, 22:24,  4 users,  load average: 0.87, 1.61,
	1.24
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
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

For the same number of instruction bytes, here is yet another improvement. I
removed the it_func[0] NULL test case, which is impossible. We never
have an empty array. If the array is empty, the array pointer is set to
NULL and the array is eventually freed when a quiescent state is reached.

/*
 * it_func[0] is never NULL because there is at least one element in the array
 * when the array itself is non NULL.
 */
#define __DO_TRACE(tp, proto, args)                                     \
        do {                                                            \
                void **it_func;                                         \
                                                                        \
                preempt_disable();                                      \
                it_func = rcu_dereference((tp)->funcs);                 \
                if (it_func) {                                          \
                        do {                                            \
                                ((void(*)(proto))(*it_func))(args);     \
                        } while (*(++it_func));                         \
                }                                                       \
                preempt_enable();                                       \
        } while (0)

P.S.: I'll change the preempt_enable/disable for rcu locks when I port
this patchset to linux.next. I temporarily keep the preempt
disable/enable statements.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
