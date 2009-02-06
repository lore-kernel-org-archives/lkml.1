Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbZBFRLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbZBFRLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbZBFRLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:11:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759611AbZBFRLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:11:33 -0500
Date: Fri, 6 Feb 2009 09:10:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
Message-Id: <20090206091039.d0acb680.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0902060822440.10059@gandalf.stny.rr.com>
References: <20090206065352.940088243@goodmis.org>
	<20090206065437.986292747@goodmis.org>
	<20090205231215.412def47.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902060822440.10059@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 08:25:52 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 5 Feb 2009, Andrew Morton wrote:
> > >  
> > > +/*
> > > + * Are we in NMI context?
> > > + */
> > > +#define in_nmi()	(preempt_count() & NMI_OFFSET)
> > > +
> > >  #if defined(CONFIG_PREEMPT)
> > >  # define PREEMPT_INATOMIC_BASE kernel_locked()
> > >  # define PREEMPT_CHECK_OFFSET 1
> > > @@ -167,6 +178,8 @@ extern void irq_exit(void);
> > >  #define nmi_enter()				\
> > >  	do {					\
> > >  		ftrace_nmi_enter();		\
> > > +		BUG_ON(in_nmi());		\
> > > +		add_preempt_count(NMI_OFFSET);	\
> > >  		lockdep_off();			\
> > >  		rcu_nmi_enter();		\
> > >  		__irq_enter();			\
> > > @@ -177,6 +190,8 @@ extern void irq_exit(void);
> > >  		__irq_exit();			\
> > >  		rcu_nmi_exit();			\
> > >  		lockdep_on();			\
> > > +		BUG_ON(!in_nmi());		\
> > > +		sub_preempt_count(NMI_OFFSET);	\
> > >  		ftrace_nmi_exit();		\
> > >  	} while (0)
> > >  
> > 
> > Well that was tidy.
> > 
> > We're sure that no present or future architecture will for some weird
> > reason nest NMIs?
> 
> That would be fun to implement. Not the in_nmi code, but the handling of 
> nested NMIs. How would you be able to save the state when the NMI occurred 
> without being preempted by another NMI?

Like with normal interrupts?

As long as the number of sources is finite, nested NMIs could work OK.

> I think the arch that has nested NMIs will have many more issues to solve 
> in the kernel than this one.

I have a vague memory that x86 can do this.

<googles a bit>

What's all this about?
https://www.x86-64.org/pipermail/discuss/2005-October/007010.html
http://kerneltrap.org/index.php?q=mailarchive/linux-kernel/2008/2/12/830704/thread

I expect that even if it is possible, we can live without it.

And if I'm wrong, it'll be easy to accommodate by adding a new counter
into the task_struct or thread_struct.

Does your above implementation make in_interrupt() return true if
in_nmi()?  I think it doesn't, but should?

