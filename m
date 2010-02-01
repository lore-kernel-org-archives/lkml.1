Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab0BAPln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:41:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47325 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab0BAPll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:41:41 -0500
X-Authority-Analysis: v=1.0 c=1 a=fit60_cKBCMA:10 a=7U3hwN5JcxgA:10 a=rKfxgNviwc8VJ289WGEA:9 a=F3XU-sL7yAqTcUyoxDQA:7 a=XIKPD3dIBwKB67mVqNbsAsMyeU0A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 1/3] Create spin lock/spin unlock with distinct memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <alpine.LFD.2.00.1002010701270.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.265317204@polymtl.ca>
	 <alpine.LFD.2.00.1002010701270.4206@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Feb 2010 10:41:39 -0500
Message-ID: <1265038899.29013.24.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 07:22 -0800, Linus Torvalds wrote:
> 

> If you need other smp barriers at the lock, then what about the non-locked 
> accesses _while_ the lock is held? You get no ordering guarantees there. 
> The whole thing sounds highly dubious. 

The issues is not about protecting data, it was all about ordering an
update of a variable (mm_cpumask) with respect to scheduling. The lock
was just a convenient place to add this protection. The memory barriers
here would allow the syscall to use memory barriers instead of locks.

> 
> And all of this for something that is a new system call that nobody 
> actually uses? To optimize the new and experimental path with some insane 
> lockfree model, while making the core kernel more complex?  A _very_ 
> strong NAK from me.

I totally agree with this. The updates here were from the fear of
grabbing all rq spinlocks (one at a time) called by a syscall would open
up a DoS (or as Nick said RoS - Reduction of Service). If someone called
this syscall within a while(1) loop on some large # CPU box, it could
cause cache thrashing.

But this is all being paranoid, and not worth the complexity in the core
scheduler. We don't even know if this fear is founded.

-- Steve


