Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYLUQ2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYLUQ2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 11:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYLUQ2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 11:28:15 -0500
Received: from www.tglx.de ([62.245.132.106]:40305 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYLUQ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 11:28:14 -0500
Date: Sun, 21 Dec 2008 17:26:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <200812182319.57235.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <1229592279.9487.133.camel@twins> <20081218123924.GH25715@elte.hu> <200812182319.57235.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008, Rafael J. Wysocki wrote:

> On Thursday, 18 of December 2008, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > Rafael, would something like this explain why we had to revert Shaggy's 
> > > patch?
> 
> Well, I have yet to understand what the suspend-resume of the timekeeping code
> actually does.

Thats rather simple:

suspend() saves the current time of the persistent clock (if
available), forwards the timekeeping variables so they can be reused
on resume, disables timekeeping activities and shuts down the clock
events layer.
 
resume() estimates the suspend time via persistent clock (if
available) and update xtime with the sleep length. After that it
reactivates timekeeping and resumes clock events and high resolution
timers.

So the sole purpose is:
   - dis/enable timekeeping and clock event devices.
   - keep track of the suspend time (if a persistent clock is available)

We reactivate clock event devices and hrtimers from timekeeping_resume
because clock events depend on functional timekeeping.

> The original description sounds worrisome to me, it looks like we've overlooked
> something at least.

Care to explain ?

> > > His patch fixes the backward motion filter and I'm at an utter  
> > > loss why that would break suspend.
> > 
> > yes, i'd love to have this commit reinstated:
> > 
> >  5b7dba4: sched_clock: prevent scd->clock from moving backwards
> > 
> > and the bug triggered by hibernation fixed instead.

Hmm. Depending on the hibernation sleep time we can end up with a
pretty long delta between the pre suspend and the post resume call to
__update_sched_clock().

I have the feeling that sched_clock looks into stale values after
resume and the first call to __update_sched_clock() trips over the
stale scd->clock value. Shaggy's patch brings scd->clock into the mix
and that might cause the whole machinery to blow up on resume.

Also we need to investigate whether sched_clock is referencing gtod
values _before_ timekeeping is resume.

Thanks,

	tglx

