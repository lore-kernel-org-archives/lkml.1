Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab0APCkd (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108Ab0APCkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:40:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37655 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab0APCkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:40:32 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=HS9PLnRRFYC0jbwLO5cA:9 a=DpVLxJ6-zdtU40X7P6QA:7 a=-cyHkl-sr-Z53zXEbU9kaSVlhr4A:4 a=jeBq3FmKZ4MA:10 a=mmO7LMK7hfL2rugE:21 a=7fJ67uzyM53MlkBs:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v6)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicholas Miell <nmiell@comcast.net>, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com
In-Reply-To: <20100115211325.GB23798@Krystal>
References: <20100115182914.GA10596@Krystal>
	 <1263585489.28171.3990.camel@gandalf.stny.rr.com>
	 <20100115211325.GB23798@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 15 Jan 2010 21:40:28 -0500
Message-ID: <1263609628.28171.3995.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 16:13 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > For the check of MEMBARRIER_QUERY and thread_group_empty(), sure that
> > could be 99.9% true. But for num_online_cpus() == 1, I can see that
> > always being true. How may boxes do you have that are uniprocessor that
> > run without CONFIG_SMP=y?  Every distro I know enables this, only
> > embedded boards seem not to. So you just made the 100% true condition
> > unlikely on those boards. Grant it, this may not be such a big deal, but
> > I like to shed light on the overuse of unlikely. I don't think this
> > unlikely is worth it.
> 
> Good point. So I'll remove the (num_online_cpus() == 1) from unlikely
> then, it will become:
> 
>         if (unlikely(flags & MEMBARRIER_QUERY
>                      || thread_group_empty(current))
>                      || num_online_cpus() == 1)
> 
> (removed extra () around (num_online_cpus() == 1) too)

I wonder if that unlikely even matters. It's not really that critical of
a path. If anything it just documents what would be unlikely.

Honestly, I'd recommend getting rid of that unlikely altogether. But I'm
fine with this version with or without it.

> > >  int rcu_expedited_torture_stats(char *page)
> > > Index: linux-2.6-lttng/arch/x86/include/asm/mmu_context.h
> > > ===================================================================
> > > --- linux-2.6-lttng.orig/arch/x86/include/asm/mmu_context.h	2010-01-12 10:59:31.000000000 -0500
> > > +++ linux-2.6-lttng/arch/x86/include/asm/mmu_context.h	2010-01-12 11:59:49.000000000 -0500
> > > @@ -36,6 +36,11 @@ static inline void switch_mm(struct mm_s
> > >  	unsigned cpu = smp_processor_id();
> > >  
> > >  	if (likely(prev != next)) {
> > > +		/*
> > > +		 * smp_mb() between user-space thread execution and
> > > +		 * mm_cpumask clear is required by sys_membarrier().
> > 
> > Of course on x86, this just turns into a barrier();, perhaps the comment
> > could state, that the use of smp_mb__before_clear_bit() is more of an
> > example for other archs since x86 only requires a barrier().
> 
> Does something like this work ?
> 
>                /*
>                  * smp_mb() between user-space thread execution and
>                  * mm_cpumask clear is required by sys_membarrier().
>                  * smp_mb__before_clear_bit() turns into a barrier() on x86. It
>                  * is left here to document that this barrier is needed, as an
>                  * example for other architectures.
>                  */
>                 smp_mb__before_clear_bit();
> 

That's fine with me.

-- Steve



