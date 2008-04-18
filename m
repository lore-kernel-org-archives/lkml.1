Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYDRAGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYDRAGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 20:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbYDRAFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 20:05:55 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:63422 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755566AbYDRAFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 20:05:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANuCB0hMROPA/2dsb2JhbACBYKs0
Date: Thu, 17 Apr 2008 20:05:51 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v3)
Message-ID: <20080418000551.GA5062@Krystal>
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416151054.GA32456@elte.hu> <20080416162810.GA20450@Krystal> <48063E19.9090701@goop.org> <20080417162932.GA23351@Krystal> <48077EB2.9030009@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48077EB2.9030009@firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:16:21 up 48 days, 19:27,  5 users,  load average: 0.07, 0.08,
	0.08
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers wrote:
> > * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> >> Mathieu Desnoyers wrote:
> >>> "This way lies madness. Don't go there."
> >>>   
> >> It is a large amount of... stuff.  This immediate values thing makes a big 
> >> improvement then?
> >>
> > 
> > As ingo said : the nmi-safe traps and exception is not only usefu lto
> > immediate values, but also to oprofile. 
> 
> How is it useful to oprofile?
> 

oprofile hooks this in the nmi callbacks :

arch/x86/oprofile/nmi_timer_int.c: profile_timer_exceptions_notify()
calls
drivers/oprofile/oprofile_add_sample()
which calls oprofile_add_ext_sample()
where
       if (log_sample(cpu_buf, pc, is_kernel, event))
                oprofile_ops.backtrace(regs, backtrace_depth);

First, log_sample writes into the vmalloc'd cpu buffer. That's for one
possible page fault.

Then, is a kernel backtrace happen, then I am not sure if printk_address
won't try to read any of the module data, which is vmalloc'd.


> > On top of that, the LTTng kernel
> > tracer has to write into vmalloc'd memory, so it's required there too.
> 
> All this effort changing really critical (and also fragile) code paths
> used all the time is to handle setting markers into NMI functions. Or
> actually the special case of setting markers in there that access
> vmalloc() without calling vmalloc_sync().
> 

Isn't vmalloc_sync() an expensive operation ? That would imply doing a
vmalloc_sync() after loading modules and after each buffer allocation I
suppose. And it's also to be able to put a breakpoint there, for the
immediate values.

> NMI are maybe 5-6 functions all over the kernel.
> 
> I just don't think it makes any sense to put markers in there.
> It is a really small part of the kernel the kernel that is unlikely
> to be really useful for anybody. You should rather first solve the
> problem of tracing the other 99.999999% of the kernel properly.
> 

The fact is that NMIs are very useful and powerful when it comes to try
to understand where code disabling interrupts is stucked, to get
performance counter reads periodically without suffering from IRQ
latency. Also, when trying to figure out what is actually happening in
the kernel timekeeping, having a stable periodic time source can be
pretty useful. Hooking this kind of feature in a tracer seems rather
logical.


> And then you could actually set the markers in there if you're
> crazy enough, just call vmalloc_sync().
> 

That would be one way to do it, except that it would not deal with int3.
Also, it would have to be taken into account at module load time. To me,
that looks like an error-prone design. If the problem is at the lower
end of the architecture, in the interrupt return path, why don't we
simply fix it there for good ?

> Mathieu argued earlier that markers should be set everywhere but
> that is also bogus because there is enough other code where
> you cannot set them either (one example would be early boot code[1])
> 

hmmm ? :) There is no "init" function in marker.c. It depends on the rcu
mechanism though, so I guess we can instrument start_kernel only after
rcu_init(). And yes, boot code is one of the first thing embedded system
developers want to instrument.

> And to do anything in NMI context you cannot use any locks so you would
> have to write all data structures used by the markers lock less. I did
> that for the the new mce code, but it's a really painful and bug prone
> experience that I cannot really recommend to anybody.
> 

LTTng is a lockless tracer which uses the RCU mechanism for control data
structure updates and a lockless cmpxchg_local scheme to manage the
per-cpu buffer space reservation. It has been out there for about 3
years now and is used in the industry.

> And then NMIs (and machine checks) are a really obscure case, very
> rarely used.
> 

I wonder if they are used so rarely because the underlying kernel is
buggy with respect with NMIs or because they are useless.

> I think the right way is just to say that you cannot set markers
> into NMI and machine check. Even with this patch it is highly unlikely
> the resulting code will be correct anyways. Actually you could probably
> set them without the patch with some effort (like calling vmalloc_sync),
> but for the basic reasons mentioned above (lock less code is really
> hard, nmi type functions are less than hundred lines in the millions
> of kernel LOCs) it is just a very very bad idea.
> 

You should have a look at LTTng then. ;) And by the way, the kernel
marker infrastructure also uses RCU-style updates and is designed to be
NMI-safe from the start.

Mathieu


> -Andi
> 
> 
> [1] Now that I mentioned it I still have enough faith to assume nobody
> will be crazy enough to come up with some horrible hack to set markers
> in early boot code too. But after seeing this patchkit ending up in a
> git tree I'm not sure.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
