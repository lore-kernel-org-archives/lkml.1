Return-Path: <linux-kernel-owner+w=401wt.eu-S1767701AbXCJBCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767701AbXCJBCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767702AbXCJBCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:02:33 -0500
Received: from waste.org ([66.93.16.53]:41774 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767701AbXCJBCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:02:31 -0500
Date: Fri, 9 Mar 2007 18:49:48 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070310004948.GN10394@waste.org>
References: <20070309053931.GA10459@waste.org> <200703100918.05547.kernel@kolivas.org> <20070309222923.GK10394@waste.org> <200703101134.26313.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703101134.26313.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 11:34:26AM +1100, Con Kolivas wrote:
> On Saturday 10 March 2007 09:29, Matt Mackall wrote:
> > On Sat, Mar 10, 2007 at 09:18:05AM +1100, Con Kolivas wrote:
> > > On Saturday 10 March 2007 08:57, Con Kolivas wrote:
> > > > On Saturday 10 March 2007 08:39, Matt Mackall wrote:
> > > > > On Sat, Mar 10, 2007 at 08:19:18AM +1100, Con Kolivas wrote:
> > > > > > On Saturday 10 March 2007 08:07, Con Kolivas wrote:
> > > > > > > On Saturday 10 March 2007 07:46, Matt Mackall wrote:
> > > > > > > > My suspicion is the problem lies in giving too much quanta to
> > > > > > > > newly-started processes.
> > > > > > >
> > > > > > > Ah that's some nice detective work there. Mainline does some
> > > > > > > rather complex accounting on sched_fork including (possibly) a
> > > > > > > whole timer tick which rsdl does not do. make forks off
> > > > > > > continuously so what you say may well be correct. I'll see if I
> > > > > > > can try to revert to the mainline behaviour in sched_fork (which
> > > > > > > was obviously there for a reason).
> > > > > >
> > > > > > Wow! Thanks Matt. You've found a real bug too. This seems to fix
> > > > > > the qemu misbehaviour and bitmap errors so far too! Now can you
> > > > > > please try this to see if it fixes your problem?
> > > > >
> > > > > Sorry, it's about the same. I now suspect an accounting glitch
> > > > > involving pipe wake-ups.
> > > > >
> > > > > 5x memload: good
> > > > > 5x execload: good
> > > > > 5x forkload: good
> > > > > 5 parallel makes: mostly good
> > > > > make -j 5: bad
> > > > >
> > > > > So what's different between makes in parallel and make -j 5? Make's
> > > > > job server uses pipe I/O to control how many jobs are running.
> > > >
> > > > Hmm it must be those deep pipes again then. I removed any quirks
> > > > testing for those from mainline as I suspected it would be ok. Guess
> > > > I"m wrong.
> > >
> > > I shouldn't blame this straight up though if NO_HZ makes it better.
> > > Something else is going wrong... wtf though?
> >
> > Just so we're clear, dynticks has only 'fixed' the single non-parallel
> > make load so far.
> 
> Ok, so some of the basics then. Can you please give me the output of 'top -b' 
> running for a few seconds during the whole affair?

Here you go:

http://selenic.com/baseline
http://selenic.com/underload
 
This is with 2.6.20+rsdl+tickfix at HZ=250.

Something I haven't mentioned about my setup is that I'm using ccache.
And it turns out disabling ccache makes a large difference. Going to
switch back to a NO_HZ kernel and see what that looks like.

-- 
Mathematics is the supreme nostalgia of our time.
