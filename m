Return-Path: <linux-kernel-owner+w=401wt.eu-S1750911AbXC0HvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbXC0HvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXC0HvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:51:03 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:40936 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbXC0HvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:51:00 -0400
Date: Tue, 27 Mar 2007 09:50:57 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Prarit Bhargava <prarit@redhat.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Subject: Re: [patch 1/2] Ignore stolen time in the softlockup watchdog
Message-Id: <20070327095057.f4df0abc.dada1@cosmosbay.com>
In-Reply-To: <4608C3F5.1030106@goop.org>
References: <20070327053816.881735237@goop.org>
	<20070327054106.664262413@goop.org>
	<4608C121.4050309@cosmosbay.com>
	<4608C3F5.1030106@goop.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 00:12:53 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Eric Dumazet wrote:
> > Jeremy Fitzhardinge a écrit :
> >
> >> +static DEFINE_PER_CPU(unsigned long long, touch_timestamp);
> >
> > ...
> >
> >>  void touch_softlockup_watchdog(void)
> >>  {
> >> -    __raw_get_cpu_var(touch_timestamp) = jiffies;
> >> +    __raw_get_cpu_var(touch_timestamp) = sched_clock();
> >>  }
> >
> > Not very clear if this is safe on 32bit, since this is not anymore
> > atomic.
> 
> Hm, good point.  Don't think it matters very much.  These values are
> per-cpu, and if an interrupt happens between the word updates and the
> intermediate values causes a timeout, then it was pretty marginal
> anyway.  I guess the worst case is if the low-word gets written first,
> and it goes from a high value to low, then it could be sampled as if
> time had gone back by up to ~4 seconds.
> 
> I'll give it another look.

OK thanks. I noticed another 'not clear' bit in your second patch :

void softlockup_enable(void)
{
	touch_softlockup_watchdog();
	wmb();			/* update timestamp before enable */
	__get_cpu_var(enabled) = 1;
}


Are you sure wmb() is needed here ?

I think a barrier() (compiler barrier) should be enough. If not, a nice comment would help too :)

