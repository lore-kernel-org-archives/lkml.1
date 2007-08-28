Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbXH1Tri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbXH1Tri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbXH1TrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:47:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36935 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881AbXH1TrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:47:10 -0400
Subject: Re: [PATCH] SLUB use cmpxchg_local
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <Pine.LNX.4.64.0708281235170.16473@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca>
	 <20070820201822.597720007@polymtl.ca>
	 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
	 <20070820204126.GA22507@Krystal>
	 <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
	 <20070820212922.GA27011@Krystal>
	 <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
	 <20070820215413.GA28452@Krystal>
	 <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
	 <20070821173849.GA8360@Krystal>
	 <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
	 <1188197539.6114.426.camel@twins>
	 <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0708271514020.8891@schroedinger.engr.sgi.com>
	 <1188285159.6112.4.camel@twins>
	 <Pine.LNX.4.64.0708281235170.16473@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 21:46:52 +0200
Message-Id: <1188330413.11709.27.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-08-28 at 12:36 -0700, Christoph Lameter wrote:
> On Tue, 28 Aug 2007, Peter Zijlstra wrote:
> 
> > On Mon, 2007-08-27 at 15:15 -0700, Christoph Lameter wrote:
> > > Hmmmm. One wild idea would be to use a priority futex for the slab lock? 
> > > That would make the slow paths interrupt safe without requiring interrupt 
> > > disable? Does a futex fit into the page struct?
> > 
> > Very much puzzled at what you propose. in-kernel we use rt_mutex (has
> > PI) or mutex, futexes are user-space. (on -rt spinlock_t == mutex ==
> > rt_mutex)
> > 
> > Neither disable interrupts since they are sleeping locks.
> > 
> > That said, on -rt we do not need to disable interrupts in the allocators
> > because its a bug to call an allocator from raw irq context.
> 
> Right so if a prioriuty futex 

futex stands for Fast Userspace muTEX, please lets call it a rt_mutex.

> would have been taken from a process 
> context and then an interrupt thread (or so no idea about RT) is scheduled 
> then the interrupt thread could switch to the process context and complete 
> the work there before doing the "interrupt" work. So disabling interrupts 
> is no longer necessary.

-rt does all of the irq handler in thread (process) context, the hard
irq handler just does something akin to a wakeup.

These irq threads typically run fifo/50 or simething like that.

[ note that this allows a form of irq priorisation even if the hardware
  doesn't. ]

