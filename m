Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYHSLSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYHSLSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYHSLSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:18:08 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:46443 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751832AbYHSLSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:18:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TOaAxLeDwKfZaX9/gFXgcQoZcU2d/0ZKaWfsVCUjLBxJrylOIALWAtqRREDc4bKNOZZ27Btoicee4i5RY5Zj9/z+IIGm0/SgRayar3OxuFNkh2G8Jbzm1ETS1UDqdKZcZuKqmZDLpA6ffAGJZ7mKnHdpABbQM+5kbt4RebRXU8M=  ;
X-YMail-OSG: Cwng2BsVM1mdWsDmRY52kWnaBf7rRHbpdZyKS5XcyBGYluBZ4ilb1t8l3TiHM6lPQtuohi.hx.SyaWfXF38NRspVKZ4HcInH61D2lrs0a1JsovDvv5FR8Fl26V83bpSWEp.4qZtigjOCygFxJszLuVYu
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Tue, 19 Aug 2008 21:17:51 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080819103301.787700742@chello.nl> <20080819103844.459178947@chello.nl> <20080819110557.GA18608@elte.hu>
In-Reply-To: <20080819110557.GA18608@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192117.52070.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008 21:05, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Disable bandwidth control by default.
> >
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/sched.c |   17 +++++++----------
> >  1 file changed, 7 insertions(+), 10 deletions(-)
> >
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -824,9 +824,9 @@ static __read_mostly int scheduler_runni
> >
> >  /*
> >   * part of the period that we allow rt tasks to run in us.
> > - * default: 0.95s
> > + * default: inf
> >   */
> > -int sysctl_sched_rt_runtime = 950000;
> > +int sysctl_sched_rt_runtime = -1;
>
> The fixes look good to me, but this enabling of infinite RT task lockups
> is not an improvement.
>
> The thing is, i got far more bugreports about locked up RT tasks where
> the lockup was unintentional, than real bugreports about anyone
> _intending_ for the whole box to come to a grinding halt because a
> high-prio RT tasks is monopolizing the CPU.

Why are all these people running poorly written apps then?

We don't cater to poorly at the expense of the properly written
code.


> In fact there's only been this artificial test so far.

No, someone reported that it broke their app.


> So could you please just increase the chunking to 10 seconds or so, from
> the current 1 second? Anyone locking up the system for more than 10
> seconds via an RT task has to deal with many other issues already.
>
> I.e. keep the system borderline debuggable (up to 10 seconds delays are
> _not_ nice so people will notice) - but it's still a marked improvement
> from completly locked up desktops.
>
> And those who really need longer than 10 second periods can set it
> higher, or even (if they want to live dangerously or run POSIX
> conformance tests) make it infinite (set it to -1) - and will have to
> deal with other things like the softlockup watchdog as well.
>
> Ok?

Nack. Let's retain our API specifications and backwards compatibilty
by default. Advertise the sysrq switch and the setting of the sysctl
to throttle, but don't break this by default please.
