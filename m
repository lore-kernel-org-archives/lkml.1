Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZBFN0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZBFN0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:26:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZBFNZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:25:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbZBFNZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:25:55 -0500
Date: Fri, 6 Feb 2009 08:25:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
In-Reply-To: <20090205231215.412def47.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0902060822440.10059@gandalf.stny.rr.com>
References: <20090206065352.940088243@goodmis.org> <20090206065437.986292747@goodmis.org> <20090205231215.412def47.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 5 Feb 2009, Andrew Morton wrote:
> >  
> > +/*
> > + * Are we in NMI context?
> > + */
> > +#define in_nmi()	(preempt_count() & NMI_OFFSET)
> > +
> >  #if defined(CONFIG_PREEMPT)
> >  # define PREEMPT_INATOMIC_BASE kernel_locked()
> >  # define PREEMPT_CHECK_OFFSET 1
> > @@ -167,6 +178,8 @@ extern void irq_exit(void);
> >  #define nmi_enter()				\
> >  	do {					\
> >  		ftrace_nmi_enter();		\
> > +		BUG_ON(in_nmi());		\
> > +		add_preempt_count(NMI_OFFSET);	\
> >  		lockdep_off();			\
> >  		rcu_nmi_enter();		\
> >  		__irq_enter();			\
> > @@ -177,6 +190,8 @@ extern void irq_exit(void);
> >  		__irq_exit();			\
> >  		rcu_nmi_exit();			\
> >  		lockdep_on();			\
> > +		BUG_ON(!in_nmi());		\
> > +		sub_preempt_count(NMI_OFFSET);	\
> >  		ftrace_nmi_exit();		\
> >  	} while (0)
> >  
> 
> Well that was tidy.
> 
> We're sure that no present or future architecture will for some weird
> reason nest NMIs?

That would be fun to implement. Not the in_nmi code, but the handling of 
nested NMIs. How would you be able to save the state when the NMI occurred 
without being preempted by another NMI?

I think the arch that has nested NMIs will have many more issues to solve 
in the kernel than this one.

-- Steve

