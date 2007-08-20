Return-Path: <linux-kernel-owner+w=401wt.eu-S1761521AbXHTXPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761521AbXHTXPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbXHTXPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:15:00 -0400
Received: from ozlabs.org ([203.10.76.45]:34223 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbXHTXO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:14:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18122.7841.346681.488204@cargo.ozlabs.ibm.com>
Date: Tue, 21 Aug 2007 09:07:13 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com
Subject: Re: [accounting regression since rc1]  scheduler updates
In-Reply-To: <20070820180810.GA25160@elte.hu>
References: <20070812163225.GA11996@elte.hu>
	<200708141037.48001.borntraeger@de.ibm.com>
	<20070820154529.GA300@elte.hu>
	<1187629438.8541.40.camel@localhost>
	<20070820180810.GA25160@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> We seem to agree wrt. sched_clock()'s behavior while the virtual CPU is 
> busy: sched_clock() very much wants to track virtual time. (real time is 
> pretty much meaningless and coupling sched_clock() to real time would 
> make the virtual machine's behavior dependent on the host's load, which 
> breaks the "seemless virtualization to inside observers" common-sense 
> requirement of virtual-CPU scheduling.)

OK, that would imply that virtualized powerpc machines want to use the
PURR register for sched_clock().  The PURR basically counts time that
this virtual CPU (SMT thread) spends dispatching instructions, so it
excludes both the time taken by the hypervisor and the time (dispatch
cycles) taken by the other thread.

> For sched_clock()'s behavior while the virtual CPU is idle: my current 
> idea for that is the patch below (a loosely analoguous problem exists 
> with nohz/dynticks): it makes sched_clock() valid across idle periods 
> too and uses wall-clock time for that.

The straightforward thing is just to use the PURR all the time, even
during idle.  What that means is this:

* If the other thread is active then sched_clock() will continue to
  advance at a slow rate during idle (reflecting the fact that the
  active thread is getting almost all of the dispatch cycles).

* If the other thread is idle and the partition is a "shared
  processor" partition then sched_clock() not advance since in that
  case we idle in the hypervisor.

* If the other thread is idle and the partition is a "dedicated
  processor" partition then sched_clock() will advance at half speed
  on both threads, since the two threads each get half of the dispatch
  cycles.

It sounds like this behaviour should be OK - do you agree?

> If a virtual CPU is idle then i think the "real = steal, virtual = 0" 
> way of thinking about idle looks a bit unnatural to me - wouldnt it be 
> better to think in terms of "steal = 0, virtual = real" ? Basically a 

Stolen time while the virtual CPU is idle gets (or at least, used to
get :) accounted as idle time.

Paul.
