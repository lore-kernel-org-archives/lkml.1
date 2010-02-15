Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab0BOUEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:04:50 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54457 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab0BOUEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:04:49 -0500
X-SpamScore: -30
X-BigFish: VPS-30(zz1432R98dN936eM62a3L9371Pzz1202hzzz32i6bh1f2h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KXWFRP-01-2EC-02
X-M-MSG: 
Date: Mon, 15 Feb 2010 21:04:37 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/3 v2] new nmi_watchdog using perf events
Message-ID: <20100215200437.GM13205@erda.amd.com>
References: <bd4cb8901002120812n7da16b6k29dd9b950ac68f25@mail.gmail.com>
 <20100212165920.GB3062@redhat.com>
 <bd4cb8901002120912x2f5b62b0r983c8595e250fdbd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <bd4cb8901002120912x2f5b62b0r983c8595e250fdbd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Feb 2010 20:04:38.0394 (UTC) FILETIME=[1A4C6DA0:01CAAE7A]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.02.10 18:12:47, Stephane Eranian wrote:
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
> > You are right.  Originally when I read the code I thought perf_event just
> > grabbed all the PMUs in reserve_pmc_init().  But I see that only happens
> > when someone actually creates a PERF_TYPE_HARDWARE event, which the new
> > nmi watchdog does.  Those PMUs only get released when the event is
> > destroyed which my new code only does when the cpu disappears.
> >
> > So yeah, I have effectively blocked oprofile from working.  I can change
> > my code such that when you disable the nmi_watchdog, you can release the
> > PMUs and let oprofile work.
> >
> > But then I am curious, considering that perf and oprofile do the same
> > thing, how much longer do we let competing subsystems control the same
> > hardware?  I thought the point of the perf_event subsystem was to have a
> > proper framework on top of the PMUs such that anyone who wants to use it
> > just registers themselves, which is what the new nmi_watchdog is doing.

There is the perfctr reservation framework what is used by all
subsystems. Perf reserves all counters if there is one event actively
running. This is ok as long you use perf from the userspace for
profiling. Nobody uses 2 different profilers at the same time. But if
the counters are also for implementing in-kernel features such as a
watchdog that is enabled all the time, perf must be modified to only
allocate those counters that are actually needed, and events may not
be scheduled on counters that are already reserved.

> > I can add code that allows oprofile and the new nmi watchdog to coexist,
> > but things get a little ugly to maintain.  Just wondering what the
> > gameplan is here?

There is no longer kernel feature implementation for oprofile. But it
will be still in the kernel for a while until we can completely switch
to perf. Perf is improving very fast, compared to the ongoing
development the implementation effort for coexistence is small. So I
think we all can spend some time to also improve the counter
reservation code.

> I believe OProfile should eventually be removed from the kernel. I suspect
> much of the functionalities it needs are already provided by perf_events.
> But that does not mean the OProfile user level tool must disappear. There is
> a very large user community. I think it could and should be ported to use
> perf_events instead. Given that the Oprofile users only interact through
> opcontrol, opreport, opannotate and such, they never "see" the actual kernel
> API. Thus by re-targeting the scripts, this should be mostly transparent to
> end-users.

I think, porting the oprofile userland to work on top of a performance
library (libpapi or libpfm) would be the cleanest solution. Alternativly
we could also port the kernel part to use the in-kernel perf api.

> 
> But for now, I believe the most practical solution is to release the perf_event
> event when you disable the NMI watchdog. That would at least provide a
> way to run OProfile.

This solution is fine to me. The current implemenation also has some
limitations for oprofile if the watchdog is enabled.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

