Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab0CMRA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 12:00:27 -0500
Received: from www84.your-server.de ([213.133.104.84]:51942 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab0CMRAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 12:00:25 -0500
Subject: Re: [Patch] fix MTD CFI/LPDDR flash driver huge latency bug
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Kreuzer, Michael (NSN - DE/Ulm)" <michael.kreuzer@nsn.com>
In-Reply-To: <20100313062553.2bdec297.akpm@linux-foundation.org>
References: <1267894137.18869.0.camel@wall-e>
	 <20100312142344.174bd46f.akpm@linux-foundation.org>
	 <1268483490.6339.21.camel@wall-e>
	 <20100313062553.2bdec297.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 13 Mar 2010 18:00:44 +0100
Message-ID: <1268499644.27883.94.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 13.03.2010, 06:25 -0500 schrieb Andrew Morton:
> On Sat, 13 Mar 2010 13:31:30 +0100 Stefani Seibold <stefani@seibold.net> wrote:
> 
> > Am Freitag, den 12.03.2010, 14:23 -0800 schrieb Andrew Morton:
> > > On Sat, 06 Mar 2010 17:48:57 +0100
> > > Stefani Seibold <stefani@seibold.net> wrote:
> > > 
> > > The patch change all the use of spin_lock operations for xxxx->mutex
> > > > into mutex operations, which is exact what the name says and means. 
> > > > 
> > > > There is no performance regression since the mutex is normally not
> > > > acquired.
> > > 
> > > hm, big scary patch.  Are you sure this mutex is never taken from
> > > atomic or irq contexts?  Is it ully tested with all relevant debug options
> > > and lockdep enabled?
> > > 
> > > 
> > 
> > I have analyzed this drivers and IMHO i don't think there will be used
> > from irq or atomic contexts. There is no request interrupt and there are
> > a lot msleep and add_wait_queues/schedule calls during holding the
> > mutex, which are not very useful in a irq or atomic context. But i don't
> > know the whole mtd stack. 
> > 
> > I tested the patch with the following kernel debug options:
> > 
> > CONFIG_DEBUG_KERNEL=y
> > CONFIG_DETECT_SOFTLOCKUP=y
> > CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> > CONFIG_SCHED_DEBUG=y
> > CONFIG_SCHEDSTATS=y
> > CONFIG_TIMER_STATS=y
> > CONFIG_DEBUG_MUTEXES=y
> > CONFIG_DEBUG_SPINLOCK_SLEEP=y
> > 
> 
> Neato.  As was mentioned, one thing to check is the mtdoops path. 
> oopses can happen with locks held, from IRQ context, etc.
> 

Okay, i didn't checked that case. But the old code has also a dead lock,
if the oops occurred during the spinlock(xxx->mutex) was held. With the
new mutex solution the change is bigger to run into that deadlock due
the possible preemption. 

But i did a "grep" at the whole mtd code and there is no panic_write
function assigned to mtd_info struct for the CFI flash chips. So this
problem will currently never occure.

> If we're trying to take that mutex in oops context then I guess that's
> fixable by just not taking it and hoping for the best.  Or, better,
> mutex_trylock() and conditional mutex_unlock() to try to be nice to
> possible concurrent activity on other CPUs.
> 

Concurrent access are dangerous and in most cases are not possible,
that's why the spinlock(xxxx->mutex) was for.

I also did some concurrency checks like:

cat /dev/zero >/flash/aa & cat /dev/zero >/flash/bb

without and side effects.


