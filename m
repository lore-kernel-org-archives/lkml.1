Return-Path: <linux-kernel-owner+w=401wt.eu-S1161174AbXBAPMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161174AbXBAPMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXBAPMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:12:35 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54772 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030579AbXBAPMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:12:34 -0500
Date: Wed, 31 Jan 2007 21:46:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, josh@freedesktop.org,
       billh@gnuppy.monkey.org, nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 2/2] RCU priority boosting additions to rcutorture
Message-ID: <20070201054616.GA9969@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070201012136.GA21770@linux.vnet.ibm.com> <20070201012653.GB22922@linux.vnet.ibm.com> <1170295936.32500.1.camel@nigel.suspend2.net> <20070201023149.GV2574@linux.vnet.ibm.com> <1170297763.32500.7.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170297763.32500.7.camel@nigel.suspend2.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 01:42:42PM +1100, Nigel Cunningham wrote:
> Hi Paul.
> 
> On Wed, 2007-01-31 at 18:31 -0800, Paul E. McKenney wrote:
> > Good to hear from you, Nigel!
> 
> Thanks :)
> 
> > Should indeed be OK to freeze during suspend/hibernate.  Will my
> > schedule_timeout_interruptible() be sufficient to allow the freeze
> > to happen, or do I need to add an explicit try_to_freeze()?
> 
> You need a try_to_freeze() - the process has to enter the refrigerator()
> function to be counted as frozen.

Even though it explicitly sleeps each time through the loop?  Hmmm...

> > Ah, and I probably need to use the same trick that mtd_blktrans_thread()
> > does to avoid having all my sleeps killed of by an errant signal:
> > 
> > 	spin_lock_irq(&current->sighand->siglock);
> > 	sigfillset(&current->blocked);
> > 	recalc_sigpending();
> > 	spin_unlock_irq(&current->sighand->siglock);
> > 
> > Or is such paranoia unnecessary?
> 
> Yeah. try_to_freeze() is a function now, so you can do something if
> (try_to_freeze()) goto sleep_again if you so desire.

If try_to_freeze() succeeds, do I need to clean up signal state?
It didn't look like it to me, but thought I should ask the expert!

My guess is that I can simply do:

	try_to_freeze();
	schedule_timeout_interruptible(HZ);

The schedule_timeout_interruptible() might return early, but if I
don't care about getting a shorter than expected sleep, I am OK,
right?  Besides, one would have to get a couple of very closely
spaced freeze_processes() calls for this to happen.  ;-)

						Thanx, Paul
