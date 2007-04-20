Return-Path: <linux-kernel-owner+w=401wt.eu-S1422689AbXDTFQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422689AbXDTFQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422651AbXDTFQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:16:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:43526 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1422854AbXDTFQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:16:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19hjUZ5Hgthxao097zAiUDZE/6rAlaHVTopBDxCJS
	wxVv9gmc07q/Wg
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Mike Galbraith <efault@gmx.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704190845430.31693@alien.or.mcafeemobile.com>
References: <20070418055525.GS11115@waste.org>
	 <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
	 <20070418152355.GU11115@waste.org>
	 <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
	 <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu>
	 <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0704181304250.25880@alien.or.mcafeemobile.com>
	 <20070418214816.GA10902@elte.hu>
	 <1176965560.6408.60.camel@Homer.simpson.net>
	 <20070419070921.GA28528@elte.hu>
	 <1176967937.6408.81.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0704190845430.31693@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 07:16:17 +0200
Message-Id: <1177046177.6309.72.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 09:55 -0700, Davide Libenzi wrote:
> On Thu, 19 Apr 2007, Mike Galbraith wrote:
> 
> > On Thu, 2007-04-19 at 09:09 +0200, Ingo Molnar wrote:
> > > * Mike Galbraith <efault@gmx.de> wrote:
> > > 
> > > > With a heavily reniced X (perfectly fine), that should indeed solve my 
> > > > daily usage pattern nicely (always need godmode for shells, but not 
> > > > for mozilla and ilk. 50/50 split automatic without renice of entire 
> > > > gui)
> > > 
> > > how about the first-approximation solution i suggested in the previous 
> > > mail: to add a per UID default nice level? (With this default defaulting 
> > > to '-10' for all root-owned processes, and defaulting to '0' for 
> > > everything else.) That would solve most of the current CFS regressions 
> > > at hand.
> > 
> > That would make my kernel builds etc interfere with my other self's
> > surfing and whatnot.  With it by EUID, when I'm surfing or whatnot, the
> > X portion of my Joe-User activity pushes the compile portion of root
> > down in bandwidth utilization automagically, which is exactly the right
> > thing, because the root me in not as important as the Joe-User me using
> > the GUI at that time.  If the idea of X disturbing root upsets some,
> > they can move X to another UID.  Generally, it seems perfect for here.
> 
> Now guys, I did not follow the whole lengthy and feisty thread, but IIRC 
> Con's scheduler has been attacked because, among other argouments, was 
> requiring X to be reniced. This happened like a month ago IINM.

I don't object to renicing X if you want it to receive _more_ than it's
fair share. I do object to having to renice X in order for it to _get_
it's fair share.  That's what I attacked.

> I did not have time to look at Con's scheduler, and I only had a brief 
> look at Ingo's one (looks very promising IMO, but so was the initial O(1) 
> post before all the corner-cases fixes went in).
> But this is not a about technical merit, this is about applying the same 
> rules of judgement to others as well to ourselves.

I'm running the same tests with CFS that I ran for RSDL/SD.  It falls
short in one key area (to me) in that X+client cannot yet split my box
50/50 with two concurrent tasks.  In the CFS case, renicing both X and
client does work, but it should not be necessary IMHO.  With RSDL/SD
renicing didn't help.

> We went from a "renicing X to -10 is bad because the scheduler should 
> be able to correctly handle the problem w/out additional external plugs" 
> to a totally opposite "let's renice -10 X, the whole SCHED_NORMAL kthreads 
> class, on top of all the tasks owned by root" [1].
> >From a spectator POV like myself in this case, this looks rather "unfair".

Well, for me, the renicing I mentioned above is only interesting as a
way to improve long term fairness with schedulers with no history.

I found Linus' EUID idea intriguing in that by putting the server
together with a steady load in one 'fair' domain, and clients in
another, X can, if prioritized to empower it to do so, modulate the
steady load in it's domain (but can't starve it!), the clients modulate
X, and the steady load gets it all when X and clients are idle.  The
nice level of X determines to what _extent_ X can modulate the constant
load rather like a mixer slider.  The synchronous (I'm told) nature of
X/client then becomes kind of an asset to the desktop instead of a
liability.

The specific case I was thinking about is the X+Gforce test where both
RSDL and CFS fail to provide fairness (as defined by me;).  X and Gforce
are mostly not concurrent.  The make -j2 I put them up against are
mostly concurrent.  I don't call giving 1/3 of my CPU to X+Client fair
at _all_, but that's what you'll get if your fairstick of the instant
generally can't see the fourth competing task.  Seemed pretty cool to me
because it creates the missing connection between client and server,
though also likely complicated (and maybe full of perils, who knows).

	-Mike

