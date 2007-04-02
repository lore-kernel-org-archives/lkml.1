Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbXDBHGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbXDBHGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXDBHGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:06:37 -0400
Received: from gw.goop.org ([64.81.55.164]:57755 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbXDBHGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:06:36 -0400
Message-ID: <4610AB6E.8020209@goop.org>
Date: Mon, 02 Apr 2007 00:06:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, john stultz <johnstul@us.ibm.com>
Subject: Re: [patch 17/17] Add a sched_clock paravirt_op
References: <20070402055652.610711908@goop.org> <200704020809.42373.ak@suse.de> <4610A70A.7010105@goop.org> <200704020850.32274.ak@suse.de>
In-Reply-To: <200704020850.32274.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Do you also get a clock for stolen nanoseconds? 
>   

What you actually get is how many ns the CPU spent in each state. 
Stolen is runnable+offline.

> No need for cycles, you could just subtract the stolen ns if you
> can get those.

It just seems like a simpler interface to just allow overriding
sched_clock, rather than exposing sched_clock's internals and fiddling
with those.  There's really nothing in the existing sched_clock which
can be profitably reused in the Xen case.  VMI can make use of the
cycles_2_ns conversion, which is why I made it available for its use.

To be specific, this is the whole Xen sched_clock function:

/* Xen sched_clock implementation.  Returns the number of RUNNING ns */
unsigned long long xen_sched_clock(void)
{
	struct vcpu_runstate_info state;
	cycle_t now;
	unsigned long long ret;

	preempt_disable();

	now = xen_clocksource_read();
	get_runstate_snapshot(&state);
	WARN_ON(state.state != RUNSTATE_running);

	ret = state.time[RUNSTATE_running] + (now - state.state_entry_time);

	preempt_enable();

	return ret;
}


    J
