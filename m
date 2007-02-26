Return-Path: <linux-kernel-owner+w=401wt.eu-S1751038AbXBZBwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbXBZBwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 20:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXBZBwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 20:52:24 -0500
Received: from pool-71-111-73-6.ptldor.dsl-w.verizon.net ([71.111.73.6]:27960
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751029AbXBZBwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 20:52:23 -0500
Date: Sun, 25 Feb 2007 17:52:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: BUG in 2.6.20-rt8
Message-ID: <20070226015230.GN5049@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070225050212.GA17258@linux.vnet.ibm.com> <20070225062747.GA13432@elte.hu> <20070224.223744.59470086.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070224.223744.59470086.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 10:37:44PM -0800, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 25 Feb 2007 07:27:47 +0100
> 
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > I got the following running stock 2.6.20-rt8 on an 4-CPU 1.8GHz 
> > > Opteron box.  The machine continued to run a few rounds of kernbench 
> > > and LTP. Looks a bit scary -- a tasklet was "stolen" from 
> > > __tasklet_action().
> > > 
> > > Thoughts?  In the meantime, kicking it off again to see if it repeats.
> > 
> > > BUG: at kernel/softirq.c:559 __tasklet_action()
> > 
> > this seems to happen very sporadically. Seems to happen more likely on 
> > hyperthreading CPUs. It is very likely caused by the 
> > redesign-tasklet-locking-to-be-sane patch below - which is a quick hack 
> > of mine from early -rt days. Can you see any obvious bug in it? The 
> > cmpxchg logic is certainly a bit ... tricky, locking-wise.
> 
> Ingo, please don't use cmpxchg() in generic code, we support several
> processors that simply cannot do it.

OK, I will bite...

Why doesn't the traditional hash table of locks work here?  Use the
cache-line address as input to the hash function, take the corresponding
lock, do the compare-and-exchange by hand, and then release the lock.
What am I missing here?  Address aliasing do to memory being mapped into
multiple locations or something?  (In that case, use only the portion
of the address within the page, right?)

I will agree that cmpxchg() has been abused pretty thoroughly in
some venues, but it does have legitimate uses.

						Thanx, Paul

> Instead of saying "it's just something special in -rt for now", take
> it out now so that what you do eventually push upstream does get
> tested.
