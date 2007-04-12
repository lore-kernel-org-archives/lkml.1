Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbXDLAjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbXDLAjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 20:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXDLAjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 20:39:18 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38686 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbXDLAjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 20:39:17 -0400
Date: Wed, 11 Apr 2007 17:39:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Message-Id: <20070411173902.b2a9ab9d.akpm@linux-foundation.org>
In-Reply-To: <20070411143357.e866b366.akpm@linux-foundation.org>
References: <20070411162904.232696302@mvista.com>
	<20070411133122.badf1c4f.akpm@linux-foundation.org>
	<1176324881.20237.39.camel@imap.mvista.com>
	<20070411143357.e866b366.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 14:33:57 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > Here is the call ordering ,
> > 
> > ktime_get()
> >  ktime_get_ts() -> read_seqretry(&xtime_lock, seq)
> >   getnstimeofday()
> >    __get_realtime_clock_ts() -> read_seqretry(&xtime_lock, seq)
> > 
> > 
> > I wonder if there is a weird case which case this to loop forever .. But
> > as said , it's just something I noticed so I don't know if it's
> > related .
> > 
> 
> hm.
> 
> Bear in mind that printk calls sched_clock() for each line of output. 
> (with the "time" kernel boot parameter).
> 
> If we're doing a read_seqretry() in sched_clock() then bascially any printk
> inside the write_seqlock() will cause a lockup.
> 
> So in fact, this explains my hang: I was debugging it with printk and I
> noticed that the printk before the write_seqlock() came out and the one
> after it did not.  Presumably if I wasn't using "time", that hang wouldn't
> have happened.
> 
> Which means that I still don't have a clue why Andi's patch is locking up
> the Vaio.
> 
> It's a bad idea to make sched_clock() this complex - we've gone and
> degraded kernel debuggability somewhat.
> 
> We have provision for fixing this: the architecture can provide its own
> printk_clock().  We should do something quick-n-dirty in printk_clock()
> which doesn't require any locks.
> 

OK, so I resurrected x86_64-mm-sched-clock-share.patch and
x86_64-mm-sched-clock64.patch.  The x86_64 box hangs on boot when using
netconsole and printk timestamps too.  Removing "time" from the kernel boot
command line prevents that.

This explains why the hang only happens with
x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch applied, too: that
patch must be triggering a printk inside xtime_lock.

Does someone want to cook up a lockless printk_clock() for i386 and x86_64?

