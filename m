Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbXCMUdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbXCMUdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933307AbXCMUdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:33:00 -0400
Received: from gw.goop.org ([64.81.55.164]:49605 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933298AbXCMUc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:32:59 -0400
Message-ID: <45F70A71.9090205@goop.org>
Date: Tue, 13 Mar 2007 13:32:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org> <1173816769.22180.14.camel@localhost>
In-Reply-To: <1173816769.22180.14.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> My gut reaction would be to avoid using clocksources for now. While
> there is some thought going into how to expand clocksources for other
> uses (Daniel is working on this, for example), the design for
> clocksources has been very focused on its utility to timekeeping, so I'm
> hesitant to try complicate the clocksources in order to multiplex
> functionality until what is really needed is well understood.
>   

Yes, you could imagine adding it as a clocksource variant, by allowing a
clocksource to set a particular timebase:

enum clocksource_timebase {
	CLOCK_TIMEBASE_REALTIME,
	CLOCK_TIMEBASE_CPU_WORK,
	...
};

struct clocksource {
	enum clocksource_timebase timebase;
	...
}

Most of the existing clocksource infrastructure would only operate on
CLOCK_TIMEBASE_REALTIME clocksources, so I'm not sure how much overlap
there would be here.  In the case of dealing with cpufreq, there's a
certain appeal to manipulating the shift/mult parameters to reflect the
fractional speed of a cpu as it changes.

> I suspect the best approach would be see how the sched_clock interface
> can be reworked/used for what you want, as it's design goals map closest
> to the work-unit properties you list above.
>   

sched_clock would definitely be the interface which exposes all this
stuff to the rest of the kernel.  After all, its basically a very simple
interface, though the backend implementation details may not be.

We currently have a sched_clock interface in paravirt_ops to deal with
the hypervisor aspect.  It only occurred to me this morning that cpufreq
presents exactly the same problem to the rest of the kernel, and so
there's room for a more general solution.

    J
