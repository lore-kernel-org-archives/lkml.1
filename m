Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0BNIba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 03:31:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39985 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab0BNIb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 03:31:28 -0500
Date: Sun, 14 Feb 2010 09:31:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Robert Richter <robert.richter@amd.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3 v2] new nmi_watchdog using perf events
Message-ID: <20100214083113.GB12658@elte.hu>
References: <bd4cb8901002120812n7da16b6k29dd9b950ac68f25@mail.gmail.com>
 <20100212165920.GB3062@redhat.com>
 <bd4cb8901002120912x2f5b62b0r983c8595e250fdbd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8901002120912x2f5b62b0r983c8595e250fdbd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> Don,
> 
> On Fri, Feb 12, 2010 at 5:59 PM, Don Zickus <dzickus@redhat.com> wrote:
> > On Fri, Feb 12, 2010 at 05:12:38PM +0100, Stephane Eranian wrote:
> >> Don,
> >>
> >> How is this new NMI watchdog code going to work when you also have OProfile
> >> enabled in your kernel?
> >>
> >> Today, perf_event disables the NMI watchdog while there is at least one event.
> >> By releasing the PMU registers, it also allows for Oprofile to work.
> >>
> >> But now with this new NMI watchdog code, perf_event never releases the PMU.
> >> Thus, I suspect Oprofile will not work anymore, unless the NMI watchdog is
> >> explicitly disabled. Up until now OProfile could co-exist with the NMI watchdog.
> >
> > You are right. ??Originally when I read the code I thought perf_event just
> > grabbed all the PMUs in reserve_pmc_init(). ??But I see that only happens
> > when someone actually creates a PERF_TYPE_HARDWARE event, which the new
> > nmi watchdog does. ??Those PMUs only get released when the event is
> > destroyed which my new code only does when the cpu disappears.
> >
> > So yeah, I have effectively blocked oprofile from working. ??I can change
> > my code such that when you disable the nmi_watchdog, you can release the
> > PMUs and let oprofile work.
> >
> > But then I am curious, considering that perf and oprofile do the same
> > thing, how much longer do we let competing subsystems control the same
> > hardware? ??I thought the point of the perf_event subsystem was to have a
> > proper framework on top of the PMUs such that anyone who wants to use it
> > just registers themselves, which is what the new nmi_watchdog is doing.
> >
> > I can add code that allows oprofile and the new nmi watchdog to coexist,
> > but things get a little ugly to maintain. ??Just wondering what the
> > gameplan is here?
>
> I believe OProfile should eventually be removed from the kernel. I suspect 
> much of the functionalities it needs are already provided by perf_events. 
> But that does not mean the OProfile user level tool must disappear. There 
> is a very large user community. I think it could and should be ported to 
> use perf_events instead. Given that the Oprofile users only interact 
> through opcontrol, opreport, opannotate and such, they never "see" the 
> actual kernel API. Thus by re-targeting the scripts, this should be mostly 
> transparent to end-users.

Agreed, i suggested this a few months ago. (In theory the oprofile user-space 
tooling might even use something like libpapi or the perfmon library, instead 
of directly binding to the perf syscall.)

Until that is done we can keep the parallel oprofile infrastructure i guess, 
as a legacy option.

Then again, when it comes to profiling, i cannot see anyone not wanting to 
use perf itself, it's so much easier to use (and more capable) than the 
oprofile tooling in pretty much any area. Basically all instrumentation and 
profiling development happens in that space these days as well.

Those few places where you cannot use perf yet (on weird or old CPUs) are 
being filled in quickly as well - so it might be easier to just widen PMU 
support to all relevant places instead of spending effort on oprofile 
compatibility.

> But for now, I believe the most practical solution is to release the 
> perf_event event when you disable the NMI watchdog. That would at least 
> provide a way to run OProfile.

Agreed.

	Ingo
