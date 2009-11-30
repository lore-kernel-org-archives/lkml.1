Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZK3I1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZK3I1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZK3I1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:27:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZK3I1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:27:38 -0500
Date: Mon, 30 Nov 2009 09:27:44 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091130082744.GN17484@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258987059.6193.73.camel@marge.simson.net> <20091123151152.GA19175@wotan.suse.de> <1258989704.4531.574.camel@laptop> <20091123152931.GD19175@wotan.suse.de> <1258991617.6182.21.camel@marge.simson.net> <20091124065322.GC20981@wotan.suse.de> <1259052035.8843.106.camel@marge.simson.net> <1259053080.6081.2.camel@marge.simson.net> <20091124091124.GG21991@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124091124.GG21991@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:11:24AM +0100, Ingo Molnar wrote:
> 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Tue, 2009-11-24 at 09:40 +0100, Mike Galbraith wrote:
> > > On Tue, 2009-11-24 at 07:53 +0100, Nick Piggin wrote:
> > > > On Mon, Nov 23, 2009 at 04:53:37PM +0100, Mike Galbraith wrote:
> > > > > On Mon, 2009-11-23 at 16:29 +0100, Nick Piggin wrote:
> > > > > 
> > > > > > So basically about the least well performing or scalable possible
> > > > > > software architecture. This is exactly the wrong thing to optimise
> > > > > > for, guys.
> > > > > 
> > > > > Hm.  Isn't fork/exec our daily bread?
> > > > 
> > > > No. Not for handing out tiny chunks of work and attempting to do
> > > > them in parallel. There is this thing called Amdahl's law, and if
> > > > you write a parallel program that wantonly uses the heaviest
> > > > possible primitives in its serial sections, then it doesn't deserve
> > > > to go fast.
> > > 
> > > OK by me.  A bit if idle time for kbuild is easily cured with telling
> > > make to emit more jobs, so there's enough little jobs to go around.
> > > 
> > > If x264 is declared dainbramaged, that's fine with me too.
> > 
> > (P.S. I don't want to have to explain to users of any such thread 
> > happy applications why they suck rocks under Linux though)
> 
> The 68% of speedup is pretty valid for your change and the workload isnt 
> particularly odd beyond the fast creation rate of threads - but i'd not 
> blame the app for that, Linux creates/destroys threads very fast. Your 
> followup load-balancing fix got queued up in the scheduler tree for 
> v2.6.33 ~two weeks ago:
> 
>   1b9508f: sched: Rate-limit newidle
> 
> certainly handles some of the NUMA pain. If not, numbers telling us the 
> other story (and patches to extend 'perf bench sched' with matching 
> testcases) would be helpful, i'm not seeing problems on my NUMA testbox.

Yay for more complexity. And it doesn't fix all problems introduced
because it doesn't improve the now inherently far weaker NUMA affinity.


> 1b9508f was certainly too late for 2.6.32, but since it appears to be 
> fine it can be forwarded to stable@kernel.org so it makes it into 
> 2.6.32.1.

I totally disagree with this development / release process of yours.
In my opinion it is *not* ok to leave a wake of known regressions with
features that help some (non-regression) case.

If it was agreed that rate limiting newidle is the right fix for the
regression, and it was agreed that it is too late for the next release,
then IMO the correct way to approach the release is to revert the
offending patch until the new, combined, approach is tested and
validated.

Doing it your way, you release a 2.6.32 kernel with a known regression
and also a case that gets a big speedup. This makes it impossible now
to revert that patch without causing a regression for someone. And
then you think you have a way to fix it, but not enough testing so it
could be the case that it causes yet other regressions or does not fix
it well enough.


