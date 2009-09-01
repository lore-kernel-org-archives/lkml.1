Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbZIAU0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbZIAU0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZIAU0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:26:31 -0400
Received: from relay4-v.mail.gandi.net ([217.70.178.78]:49744 "EHLO
	relay4-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbZIAU0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:26:30 -0400
Date: Tue, 1 Sep 2009 13:26:51 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
       Tim Pepper <lnxninja@linux.vnet.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       John Stultz <johnstul@us.ibm.com>, Jamey Sharp <jamey@minilop.net>
Subject: Re: [RFC PATCH] Turn off the tick even when not idle
Message-ID: <20090901202651.GA2760@josh-work.beaverton.ibm.com>
References: <20090901154327.GA10024@feather>
 <alpine.DEB.1.10.0909011554590.12112@V090114053VZO-1>
 <20090901180825.GA3621@josh-work.beaverton.ibm.com>
 <alpine.DEB.1.10.0909011831530.25607@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909011831530.25607@V090114053VZO-1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 06:35:34PM -0400, Christoph Lameter wrote:
> On Tue, 1 Sep 2009, Josh Triplett wrote:
> 
> > Thanks; exactly what I hoped to demonstrate.  Actually making the timer
> > interrupt go away will require finding a more appropriate place to run
> > all the code that otherwise polls periodically, but this patch lets us
> > cheat and see the result before that happens. :)
> 
> Well not necessarily. Since the process is not doing system calls some of
> the checks can be skipped. In order to bring about a quiet state for the
> VM one could fold the vm counters and dump the queues. Then maintenance is
> unnecessary as long as no system activity occurs on a processor.

Yes, I agree that most of these checks don't need to happen.  When I
said "finding a more appropriate place", I primarily mean either making
these things event-driven or making them happen only when needed, not
just moving the polling elsewhere.  For instance, process time
accounting need not happen every timer tick; it can happen the next time
the process runs in the kernel, and then just add all the time elapsed
since then.  If some rlimit or POSIX cpu timer exists, the kernel can
figure out when that will trigger, and set a timer for that point.

> > I ran the benchmark at realtime priority, and affinitized to a single
> > CPU.  I used ftrace to confirm that after the initial program setup
> > (shared library loads, memory allocation, etc), no code runs in the
> > kernel during the number-crunching; this makes sense, since I ran at
> > higher priority than all the random affinitized kernel threads, and I
> > pushed everything else (tasks and interrupts) onto another CPU.
> 
> Interesting.
> 
> > Long-term I'd like to solve the problem of those kernel threads, but
> > realtime priority can mitigate those.  The new interrupt threading bits
> > may help with other interrupts and avoid the need to set interrupt
> > affinity.  The timer interrupt, though, represents the one and only
> > thing I can't mitigate, hence why I'd like to make it go away.
> 
> Well it would be best if we can guarantee that there is no system activity
> starting. What you have done is analyze all the causes for your particular
> situation and mitigated them. Not everyone is a specialist able to figure
> out these causes.

Agreed entirely.  I want cases like this to work without any tuning or
mitigation required.  If userspace doesn't need anything from the
kernel, and the hardware doesn't need attention from the kernel, then
the kernel should have no work to do.

Unfortunately, I don't think any blanket solution exists to fix all of
these issues; each cause of random system activity needs addressing.  As
it turns out, many of the difficult-to-deal-with bits of activity occur
on the timer interrupt, making it hard to track them down individually,
hence why I wanted to start there.

- Josh Triplett
