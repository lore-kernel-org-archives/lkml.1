Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0BAQZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:25:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337Ab0BAQZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:25:16 -0500
Date: Mon, 1 Feb 2010 08:23:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task switch
 at runqueue lock/unlock
In-Reply-To: <20100201160929.GA3032@Krystal>
Message-ID: <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.446503342@polymtl.ca> <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain> <20100201160929.GA3032@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Feb 2010, Mathieu Desnoyers wrote:
> 
> However, this does not deal with mm_cpumask update, and we cannot use
> the per-cpu rq lock, as it's a process-wide data structure updated with
> clear_bit/set_bit in switch_mm(). So at the very least, we would have to
> add memory barriers in switch_mm() on some architectures to deal with
> this.

I'd much rather have a "switch_mm()" is a guaranteed memory barrier logic, 
because quite frankly, I don't see how it ever couldn't be one anyway. It 
fundamentally needs to do at least a TLB context switch (which may be just 
switching an ASI around, not flushing the whole TLB, of course), and I bet 
that for 99% of all architectures, that is already pretty much guaranteed 
to be equivalent to a memory barrier.

It certainly is for x86. "mov to cr0" is serializing (setting any control 
register except cr8 is serializing). And I strongly suspect other 
architectures will be too.

Btw, one reason to strongly prefer "switch_mm()" over any random context 
switch is that at least it won't affect inter-thread (kernel or user-land) 
switching, including switching to/from the idle thread.

So I'd be _much_ more open to a "let's guarantee that 'switch_mm()' always 
implies a memory barrier" model than to playing clever games with 
spinlocks.

			Linus
