Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbZDQOw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbZDQOw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761657AbZDQOwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:52:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60479 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762100AbZDQOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:51:59 -0400
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0904171021360.20239@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
	 <1239951613.23397.4107.camel@laptop>
	 <alpine.DEB.1.10.0904170941020.11877@qirst.com>
	 <1239977776.23397.4590.camel@laptop>
	 <alpine.DEB.1.10.0904171021360.20239@qirst.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 16:51:41 +0200
Message-Id: <1239979901.23397.4638.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 10:29 -0400, Christoph Lameter wrote:

> > With something like that you could say, the jiffy tick went from 0.8+-.1
> > to 1.1+-.1 us or somesuch.
> 
> Well yeah we can look at this but there seem to be regressions in a lot of
> other subsystems as well. Rescheduling is another thing that we tracked.
> Its interesting that the holdoffs varied at lot during the scheduler
> transition to CFS and then stayed high after that was complete.
> 
> > After that, you could possibly use oprofile or readprofile or
> > perf-counters to get an idea where the time is spend. I did a quick
> > profile on one of my machines, and about half the kernel time spend in a
> > while(1) loop comes from __do_softirq().
> >
> > Really, I should not have to tell you this...
> 
> I can get down there but do you really want me to start hacking on the
> scheduler again? This seems to be a regression from what we had working
> fine before.

I won't mind you sending patches. But really, the first thing to do is
figuring out what is taking time.

And a random 1us cutoff, is well, random.

If you want to reduce interrupts, that's fine, but not counting an
interrupt because its below the magic 1us marker sounds a bit, well,
magic -- might work for you, might not for me on another machine, might
even be compiler dependent.

So 5 <1us interruption are not at all accounted, whereas a single 1>us
interruption is. I'd rather get rid of those 5 than try and shave a bit
of the one, if you get what I mean.

I'm pretty sure if we run the current kernel on a 5GHz machine all
interrupts are under 1us again :-), problem fixed? I don't think so.

Furthermore, yes the scheduler is one of those jiffy tick users, but
there are more. We can do ntp/gtod things in there, there is process
accounting, there is some RCU machinery, timers etc..

Like said, I did a profile on current -tip and __do_softirq was about
half the time spend in kernel. I'm not sure why it would be, maybe we're
doing tons of cache misses there for some reason, I dunno.



