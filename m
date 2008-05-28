Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYE1NBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYE1NBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYE1NBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:01:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbYE1NBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:01:09 -0400
Date: Wed, 28 May 2008 09:01:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pavel Machek <pavel@ucw.cz>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
In-Reply-To: <20080525180122.GA4247@ucw.cz>
Message-ID: <Pine.LNX.4.58.0805280855250.25179@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
 <20080525180122.GA4247@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 May 2008, Pavel Machek wrote:
> > +		if (unlikely(cpu != smp_processor_id())) {
> > +			if (loops <= TSC_MIGRATE_COUNT)
> > +				break;
> > +			cpu = smp_processor_id();
> > +			rdtscl(bclock);
> > +			loops -= TSC_MIGRATE_COUNT;
> > +		} else {
> > +			rdtscl(now);
> > +			if ((now - bclock) >= loops)
> > +				break;
> > +			loops -= (now - bclock);
> > +			bclock = now;
>
> What happens with different cpus running on different frequencies...?
> Cpufreq?

It's not even protected with the old code.

inline void __const_udelay(unsigned long xloops)
{
	__delay(((xloops * HZ *
		cpu_data(raw_smp_processor_id()).loops_per_jiffy) >> 32) + 1);
}

Here it calculates the loops_per_jiffy for the CPU and calls into __delay.
But it can easily be preempted here and the delay could run on another
CPU.

-- Steve

