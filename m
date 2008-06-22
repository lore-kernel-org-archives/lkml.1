Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYFVVDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYFVVDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbYFVVDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:03:02 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:33327 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbYFVVDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:03:01 -0400
Date: Sun, 22 Jun 2008 14:02:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, josh@freedesktop.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, dino@in.ibm.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vegard.nossum@gmail.com, adobriyan@gmail.com, oleg@tv-sign.ru,
       bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent rcutorture less power-hungry
Message-ID: <20080622210255.GF22569@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080618122144.GA27143@linux.vnet.ibm.com> <20080618162649.GA18326@linux.vnet.ibm.com> <20080622200638.GA25328@linux.vnet.ibm.com> <20080622131712.54ba732c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622131712.54ba732c@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 01:17:12PM -0700, Arjan van de Ven wrote:
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

Good point!!!  As follows, on top of the previous one.

This patch aligns the rcutorture wakeup times to align with all other
multiple-of-a-second wakeups to further decrease power consumption.

Suggested-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut3-procq/kernel/rcutorture.c linux-2.6.26-rc4-rcut4-procqp/kernel/rcutorture.c
--- linux-2.6.26-rc4-rcut3-procq/kernel/rcutorture.c	2008-06-22 12:20:10.000000000 -0700
+++ linux-2.6.26-rc4-rcut4-procqp/kernel/rcutorture.c	2008-06-22 13:53:22.000000000 -0700
@@ -1,3 +1,4 @@
+
 /*
  * Read-Copy Update module-based torture test facility
  *
@@ -199,7 +200,7 @@ rcu_stutter_wait(void)
 		if (rcutorture_runnable)
 			schedule_timeout_interruptible(1);
 		else
-			schedule_timeout_interruptible(HZ);
+			schedule_timeout_interruptible(round_jiffies_relative(HZ));
 }
 
 /*
