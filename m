Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251Ab0AJLuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab0AJLuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 06:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076Ab0AJLuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 06:50:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43052 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab0AJLuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 06:50:13 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=moSYiK5oFxBz3Lh-O-gA:9 a=c5-4bB1Gwe75iQvcAT8A:7 a=s6lAlBlFzxEQ5XMqFJDIaxWbKx8A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100110052508.GG9044@linux.vnet.ibm.com>
References: <20100109012128.GF6816@linux.vnet.ibm.com>
	 <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com>
	 <20100109192006.GA23672@Krystal>
	 <1263078327.28171.3792.camel@gandalf.stny.rr.com>
	 <1263079000.28171.3795.camel@gandalf.stny.rr.com>
	 <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo>
	 <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo>
	 <20100110052508.GG9044@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sun, 10 Jan 2010 06:50:09 -0500
Message-ID: <1263124209.28171.3798.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 21:25 -0800, Paul E. McKenney wrote:
> On Sat, Jan 09, 2010 at 09:12:58PM -0500, Steven Rostedt wrote:

> > >         < user space >
> > > 
> > >         < misses that CPU 2 is in rcu section >
> > 
> > 
> > If the TLB flush misses that CPU 2 has a threaded task, and does not
> > flush CPU 2s TLB, it can also risk the same type of crash.
> 
> But isn't the VM's locking helping us out in that case?
> 
> > >         [CPU 2's ->curr update now visible]
> > > 
> > >         [CPU 2's rcu_read_lock() store now visible]
> > > 
> > >         free(obj);
> > > 
> > >                                         use_object(obj); <=== crash!
> > > 
> > 
> > Think about it. If you change a process mmap, say you updated a mmap of
> > a file by flushing out one page and replacing it with another. If the
> > above missed sending to CPU 2, then CPU 2 may still be accessing the old
> > page of the file, and not the new one.
> > 
> > I think this may be the safe bet.
> 
> You might well be correct that we can access that bitmap locklessly,
> but there are additional things (like the loading of the arch-specific
> page-table register) that are likely to be helping in the VM case, but
> not necessarily helping in this case.


Then perhaps the sys_membarrier() should just do a flush_tlb()? That
should guarantee the synchronization, right?

-- Steve


