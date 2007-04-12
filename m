Return-Path: <linux-kernel-owner+w=401wt.eu-S1751024AbXDLQYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbXDLQYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXDLQYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:24:19 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47716 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXDLQYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:24:17 -0400
Date: Thu, 12 Apr 2007 09:23:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@novell.com>
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Message-Id: <20070412092348.70a4de05.akpm@linux-foundation.org>
In-Reply-To: <200704121136.03098.ak@novell.com>
References: <20070411162904.232696302@mvista.com>
	<20070411143357.e866b366.akpm@linux-foundation.org>
	<20070411173902.b2a9ab9d.akpm@linux-foundation.org>
	<200704121136.03098.ak@novell.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 11:36:02 +0200 Andi Kleen <ak@novell.com> wrote:

> 
> > OK, so I resurrected x86_64-mm-sched-clock-share.patch and
> > x86_64-mm-sched-clock64.patch.  The x86_64 box hangs on boot when using
> > netconsole and printk timestamps too.  Removing "time" from the kernel boot
> > command line prevents that.
> 
> Ah. But ktime_get shouldn't printk. Or did you change that?

I didn't change anything.

If we change printk() to do a read_seqretry(xtime_lock) (as your patches
apparently do), then any printk() inside write_seqlock(xtime_lock) will
hang.

> > 
> > This explains why the hang only happens with
> > x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch applied, too: that
> > patch must be triggering a printk inside xtime_lock.
> > 
> > Does someone want to cook up a lockless printk_clock() for i386 and x86_64?
> 
> Just use jiffies directly in printk. That's only HZ accurate, but should
> be good enough for printk.  

Bit sad.  printk timestamping was originally implemented as a way of
observing and measuring bootup delays.  It seems pretty popular now and
probably quite a few people like high resolution on it.

> One could use pure monotonic xtime as fallback instead of ktime_get in sched_clock. 
> The trouble is  just that they might cause sched_clock to go backwards during 
> a temporary instability period (cpufreq change) because the xtime will be 
> always a bit behind the TSC and a TSC->xtime conversion will lose time.
> At least the scheduler doesn't handle backwards time warp on a CPU gratefully.
> Ok I guess it could  return max(last_value_before_instability, xtime) 
> 

I wasn't proposing any change in sched_clock().

I was proposing that i386 and x86_64 be given a new, lockless,
high-resolution printk_clock().  Presently x86 uses the default
printk_clock(), which uses sched_clock().  Presumably copying the
pre-x86_64-mm-sched-clock-share.patch version of sched_clock() into
printk_clock() will suffice.

