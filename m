Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0BAUxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:53:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118Ab0BAUxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:53:34 -0500
Date: Mon, 1 Feb 2010 12:52:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task switch
 at runqueue lock/unlock
In-Reply-To: <1265056389.29013.126.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1002011244020.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca>  <20100131210013.446503342@polymtl.ca>  <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>  <20100201160929.GA3032@Krystal>  <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain> 
 <20100201164856.GA3486@Krystal>  <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain>  <20100201174500.GA13744@Krystal>  <alpine.LFD.2.00.1002011028190.4206@localhost.localdomain> <1265056389.29013.126.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Feb 2010, Steven Rostedt wrote:
> 
> But a race exists between the reading of the mm_cpumask and sending the
> IPI. There is in fact two different problems with this race. One is that
> a thread scheduled away, but never issued an mb(), the other is that a
> running task just came in and we never saw it.

I get it. But the thing I object to here is that Mathieu claims that we 
need _two_ memory barriers in the switch_mm() code.

And I'm still not seeing it.

You claim that the rule is that "you have to do a mb on all threads", and 
that there is a race if a threads switches away just as we're about to do 
that.

Fine. But why _two_? And what's so magical about the mm_cpumask that it 
needs to be around it?

If the rule is that we do a memory barrier as we switch an mm, then why 
does that single one not just handle it? Either the CPU kept running that 
mm (and the IPI will do the memory barrier), or the CPU didn't (and the 
switch_mm had a memory barrier).

Without locking, I don't see how you can really have any stronger 
guarantees, and as per my previous email, I don't see what the smp_mb() 
around mm_cpumask accesses help - because the other CPU is still not going 
to atomically "see the mask and IPI". It's going to see one value or the 
other, and the smp_mb() around the access doesn't seem to have anything to 
do with which value it sees.

So I can kind of understand the "We want to guarantee that switching MM's 
around wants to be a memory barrier". Quite frankly, I haven't though even 
that through entirely, so who knows... But the "we need to have memory 
barriers on both sides of the bit setting/clearing" I don't get. 

IOW, show me why that cpumask is _so_ important that the placement of the 
memory barriers around it matters, to the point where you want to have it 
on both sides.

Maybe you've really thought about this very deeply, but the explanations 
aren't getting through to me. Educate me.

			Linus
