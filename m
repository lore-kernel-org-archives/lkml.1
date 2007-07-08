Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbXGHWhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbXGHWhD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 18:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbXGHWgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 18:36:53 -0400
Received: from smtp3.Stanford.EDU ([171.67.20.26]:39489 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbXGHWgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 18:36:51 -0400
Subject: Re: v2.6.21.5-rt19
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rui Nuno Capela <rncbc@rncbc.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.Stanford.EDU>,
       Carsten Emde <carsten.emde@osadl.org>, nando@ccrma.Stanford.EDU
In-Reply-To: <20070707092401.GB21234@elte.hu>
References: <1183582155.3291.160.camel@chaos>
	 <9609.194.65.103.1.1183731007.squirrel@www.rncbc.org>
	 <1183758545.20747.34.camel@cmn3.stanford.edu>
	 <20070707092401.GB21234@elte.hu>
Content-Type: text/plain
Date: Sun, 08 Jul 2007 15:36:45 -0700
Message-Id: <1183934205.11854.11.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-07 at 11:24 +0200, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > > > Changes since 2.6.21.5-rt18:
> > > >
> > > > - Fixed a nasty and hard to track down slowness / boot problem on SMP
> > > > machines with CONFIG_NOHZ enabled. The problem was caused by the timer
> > > > wheel base lock held during the get_next_timer_interrupt() call in the
> > > > idle path, which eventually led to a bogus PI boosting of the idle task
> > > > and in consequence a stale wrong scheduler selection for the affected idle
> > > > task.
> > > >
> > > > Kudos to Carsten Emde, who patiently and meticulously isolated the
> > > > problem and provided the traces, which allowed to identify the root cause.
> > > >
> > > > Problem solution: Prevent idle task boosting
> 
> > > Maybe someone remember me whining about troubles with 2.6.21-rt2..18 
> > > on my Core2 T7200 laptop (fujitsu-siemens amilo i1520).
> > > 
> > > Althought I'm still with my fingers crossed, I can tell the good 
> > > news are that 2.6.21.5-rt19 (and -rt20) does behave far better now 
> > > on the very same box.
> > 
> > Yes, it works much better indeed...
> > 
> > Ingo: is there a place where I can read about the changes in different 
> > rtxx releases? What is new/better/fixed in rt20? (I see scheduler 
> > stuff in a diff from rt19 to rt20 but I don't really know what it 
> > means).
> 
> and rt18 was a -rt-only NOHZ fix, that bug got introduced in rt11 when 
> CFS was merged.
> 
> i _think_ Rui might have seen two separate problems. Perhaps by the time 
> we fixed the first problem (which Rui saw since -rt2) we introduced the 
> other one via -rt11 - which then got fixed in -rt19.

Ahh, CFS is now part of rt, I was obviously not paying attention... I'm
really trying to provide a "stable" rt kernel for audio usage and
including another subsystem into rt is - IMHO - not going to help.
What's the chance of splitting things?

> btw., we'd love to get more feedback regarding CFS. CFS is a completely 
> new scheduler for Linux. 

Then I'd rather have it separate from rt. 

> It has a design centered around keeping 
> application latencies down, so it is ultimately real-time friendly, and 
> it should also make things work better for desktop-ish and audio-ish 
> stuff as well. (even under SCHED_OTHER)

Maybe this is CFS related? (tail of a thread in the Planet CCRMA mailing
list):

On Sun, 2007-07-08 at 15:26 -0400, Hector Centeno wrote:
> Ok, so just to confirm, that 2.6.21-0182.rt19.1.fc7.ccrmart works fine
> on my desktop but on my laptop it makes Firefox and Tomboy to crash.
> On the same laptop using 2.6.21-0182.rt17.1.fc7.ccrmart there is no
> problem.
> 
> Cheers,
> 
> Hector
> 
> 
> On 7/7/07, Hector Centeno <hcengar@gmail.com> wrote:
>         Hi Fernando,
>         
>         I do have Flash installed but for me Firefox crashes when
>         trying to
>         access gmail (which AFAIK doesn't use Flash, does it?). Right
>         now
>         Firefox is frozen and I'm typing this email using Konkeror (in
>         Gnome). 
>         This is ps' output:
>         
>         hector    3595  1.1  2.2 194352 46336 ?        D    16:25
>         0:03
>         /usr/lib/firefox-2.0.0.4/firefox-bin
>         
>         I think the problem is not present in my Desktop but I have to
>         double 
>         check. In the same laptop using the stock fedora kernel both
>         Tomboy
>         and Firefox work fine. My laptop has a centrino duo processor,
>         2 gigs
>         of ram and the Inte GMA950 graphics chip.
>         
>         Hector

I managed to completely hang firefox (fc7) with flash 9 installed
(unkillable even with -9). Does not seem to happen with flash 7. Have
not tried yet with gmail and flash uninstalled. I'll try to strace it to
see when/why it hangs. 

-- Fernando


> So it would be nice if you could keep an extra eye on any scheduling 
> artifacts or regressions, and make sure your favorite workload is still 
> handled by the Linux scheduler in the utmost best way. I'd like to hear 
> about any sort of "scheduling behavior / interactivity" regression you 
> might see, relative to the vanilla kernel. Or if you can see no such 
> problems then a line of "it works as well as the previous scheduler" is 
> important info to us too. Thanks!


