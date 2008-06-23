Return-Path: <linux-kernel-owner+w=401wt.eu-S1761888AbYFWRyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761888AbYFWRyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYFWRyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:54:04 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57219 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbYFWRyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:54:03 -0400
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent
	rcutorture less power-hungry
From: Darren Hart <dvhltc@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       josh@freedesktop.org, niv@us.ibm.com, dino@in.ibm.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vegard.nossum@gmail.com, adobriyan@gmail.com, oleg@tv-sign.ru,
       bunk@kernel.org, rjw@sisk.pl
In-Reply-To: <20080622131712.54ba732c@infradead.org>
References: <20080618122144.GA27143@linux.vnet.ibm.com>
	 <20080618162649.GA18326@linux.vnet.ibm.com>
	 <20080622200638.GA25328@linux.vnet.ibm.com>
	 <20080622131712.54ba732c@infradead.org>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 17:54:09 +0000
Message-Id: <1214243649.4440.10.camel@Aeon>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-22 at 13:17 -0700, Arjan van de Ven wrote:
> On Sun, 22 Jun 2008 13:06:38 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > This patch makes the non-module rcutorture a bit more friendly to
> > the power-conservation code.  This is a rather simple-minded approach.
> > More sophisticated approaches would get rid of the rcutorture tasks
> > while rcutorture execution was suppressed, but attempts thus far to
> > do this have not gone well -- calling rcu_torture_init() from a /proc
> > callout results in oopses.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> >  rcutorture.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff -urpNa -X dontdiff
> > linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c
> > linux-2.6.26-rc4-rcut3-procq/kernel/rcutorture.c ---
> > linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c	2008-06-22
> > 10:29:04.000000000 -0700 +++
> > linux-2.6.26-rc4-rcut3-procq/kernel/rcutorture.c	2008-06-22
> > 12:20:10.000000000 -0700 @@ -196,7 +196,10 @@ static void
> > rcu_stutter_wait(void) { while (stutter_pause_test
> > || !rcutorture_runnable)
> > -		schedule_timeout_interruptible(1);
> > +		if (rcutorture_runnable)
> > +			schedule_timeout_interruptible(1);
> > +		else
> > +			schedule_timeout_interruptible(HZ);
> >  }
> 
> could you also make it use round_jiffies_relative() to make the power
> impact even less.....
> (by coalescing various "once a second" timers like this)

I'm a little concerned about how this will affect real-time performance,
as queueing up lots of timers all at once can lead to long running timer
expiration handlers.  If just a schedule_timeout, I suppose we are only
looking at a process wakeup, as opposed to a softirq context callback
function?

Thanks,

-- 
Darren Hart
Real-Time Linux Team Lead
IBM Linux Technology Center

