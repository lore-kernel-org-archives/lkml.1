Return-Path: <linux-kernel-owner+w=401wt.eu-S1763437AbXGFOly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763437AbXGFOly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbXGFOlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:41:47 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:45548 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753948AbXGFOlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:41:46 -0400
Date: Fri, 6 Jul 2007 10:41:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070706144144.GC32754@Krystal>
References: <20070705215152.GA4865@Krystal> <p73myy9215m.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <p73myy9215m.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:34:34 up 5 days,  9:17,  3 users,  load average: 0.11, 0.45, 0.73
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > Thread Migration Preemption
> > 
> > This patch adds the ability to protect critical sections from migration to
> > another CPU without disabling preemption.
> 
> Good idea.
> 
> I sometimes think we could have avoided _much_ trouble
> if that had been always default for processes running 
> in kernel space.
>  

I haven't thought about making it the default for kernel space
preemption, but yes, it would make sense.

> > This will be useful to minimize the amount of preemption disabling for the -rt
> > patch. It will help leveraging improvements brought by the local_t types in
> > asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
> > variables protected by migration_disable must be either atomic or protected from
> > concurrent updates done by other threads.
> > 
> > Typical use:
> > 
> > migration_disable();
> > local_inc(&__get_cpu_var(&my_local_t_var));
> > migration_enable();
> 
> It seems strange to have a new interface for this. We already 
> have get_cpu()/put_cpu(). So why not use that?
> 

Because get/put_cpu() implicitly insure mutual exclusion between threads
on the same CPU by disabling preemption. migration_disable() does not:
this is why I only do local atomic operations on these variables.


> >  	unsigned long		flags;		/* low level flags */
> >  	__u32			cpu;
> >  	__s32			preempt_count;	/* 0 => preemptable, <0 => BUG */
> > +	int			migration_count;/* 0: can migrate, <0 => BUG */
> 
> Can you turn preempt_count into a short first and use a short? That should be enough
> and cache line usage wouldn't be increased. That's ok on x86; on RISCs 
> int might be faster
> 

using a short instead of an int on modern x86 will cause pipeline stalls
due to partial register use. Also, it won't really reduce the cache line
usage, since it is followed by an unsigned long; gcc structure alignment
will put padding instead of the integer, which does not buy us anything
space-wise. If you find me a case on some architectures where it
improves performances, I will be more than happy to change it, but as
things are, an int seems as efficient, and even more due to partial
register stalls on x86, than a short.

Regards,

Mathieu

> 
> -Andi

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
