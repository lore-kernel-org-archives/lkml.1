Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbXDHNJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbXDHNJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 09:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXDHNJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 09:09:47 -0400
Received: from aeimail.aei.ca ([206.123.6.84]:41233 "EHLO aeimail.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbXDHNJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 09:09:46 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: Ten percent test
Date: Sun, 8 Apr 2007 09:08:59 -0400
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
References: <200703290237.38777.kernel@kolivas.org> <20070406100333.GA19855@elte.hu> <200704071650.43905.kernel@kolivas.org>
In-Reply-To: <200704071650.43905.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704080909.00472.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am one of those who have been happily testing Con's patches.  

They work better than mainline here.

There seems to be a disconnect on what Con is trying to achieve with SD.
They do not improve interactivity per say.  Instead they make the scheduler 
predictable by removing the alchemy used by the interactivity estimator.   
Mikes patches may be better alchemy but they continue down the same 
path - from prior experience, we can say with fairly good confidence, that
 there will be new corner cases that trigger problems.

With SD, if you ask too much of the machine it slows down.  You can fix this,
if required, by renicing tasks some tasks - or by reducing the load on the box.

If one really needs some sort of interactivity booster (I do not with SD), why
not move it into user space?  With SD it would be simple enough to export
some info on estimated latency.  With this user space could make a good
attempt to keep latency within bounds for a set of tasks just by renicing.... 

Thanks
Ed Tomlinson

PS.  Get well soon Con.

On Saturday 07 April 2007 02:50, Con Kolivas wrote:
> On Friday 06 April 2007 20:03, Ingo Molnar wrote:
> > * Con Kolivas <kernel@kolivas.org> wrote:
> > > > I was more focused on the general case, but all I should have to do
> > > > to de-claw all of these sleep exploits is account rr time (only a
> > > > couple of lines, done and building now).  It's only a couple of
> > > > lines.
> > >
> > > The more you try to "de-claw" these sleep exploits the less effective
> > > you make your precious interactive estimator. Feel free to keep adding
> > > endless tweaks to undo the other tweaks in order to try and achieve
> > > what SD has by design.
> >
> > firstly, testing on various workloads Mike's tweaks work pretty well,
> > while SD still doesnt handle the high-load case all that well. Note that
> > it was you who raised this whole issue to begin with: everything was
> > pretty quiet in scheduling interactivity land.
> 
> I'm terribly sorry but you have completely missed my intentions then. I was 
> _not_ trying to improve mainline's interactivity at all. My desire was to fix 
> the unfairness that mainline has, across the board without compromising 
> fairness. You said yourself that an approach that fixed a lot and had a small 
> number of regressions would be worth it. In a surprisingly ironic turnaround 
> two bizarre things happened. People found SD fixed a lot of their 
> interactivity corner cases which were showstoppers. That didn't surprise me 
> because any unfair design will by its nature get it wrong sometimes. The even 
> _more_ surprising thing is that you're now using interactivity as the 
> argument against SD. I did not set out to create better interactivity, I set 
> out to create widespread fairness without too much compromise to 
> interactivity. As I said from the _very first email_, there would be cases of 
> interactivity in mainline that performed better.
> 
> > (There was one person who 
> > reported wide-scale interactivity regressions against mainline but he
> > didnt answer my followup posts to trace/debug the scenario.)
> 
> That was one user. As I mentioned in an earlier thread, the problem with email 
> threads on drawn out issues on lkml is that all that people remember is the 
> last one creating noise, and that has only been the noise from Mike for 2 
> weeks now. Has everyone forgotten the many many users who reported the 
> advantages first up which generated the interest in the first place? Why have 
> they stopped reporting? Well the answer is obvious; all the signs suggest 
> that SD is slated for mainline. It is on the path, Linus has suggested it and 
> now akpm is asking if it's ready for 2.6.22. So they figure there is no point 
> testing and replying any further. SD is ready for prime time, finalised and 
> does everything I intended it to. This is where I have to reveal to them the 
> horrible truth. This is no guarantee it will go in. In fact, this one point 
> that you (Ingo) go on and on about is not only a quibble, but you will call 
> it an absolute showstopper. As maintainer of the cpu scheduler, in its 
> current form you will flatly refuse it goes to mainline citing the 5% of 
> cases where interactivity has regressed. So people will tell me to fix it, 
> right?... Read on for this to unfold.
> 
> > SD has a built-in "interactivity estimator" as well, but hardcoded into
> > its design. SD has its own set of ugly-looking tweaks as well - for
> > example the prio_matrix.
> 
> I'm sorry but this is a mis-representation to me, as I suggested on an earlier 
> thread where I disagree about what an interactivity estimator is. The idea of 
> fence posts in a clock that are passed as a way of metering out 
> earliest-deadline-first in a design is well established. The matrix is simply 
> an array designed for O(1) lookups of the fence posts. That is not the same 
> as "oh how much have we slept in the last $magic_number period and how much 
> extra time should we get for that".
> 
> > So it all comes down on 'what interactivity 
> > heuristics is enough', and which one is more tweakable. So far i've yet
> > to see SD address the hackbench and make -j interactivity
> > problems/regression for example, while Mike has been busy addressing the
> > 'exploits' reported against mainline.
> 
> And BANG there is the bullet you will use against SD from here to eternity. SD 
> obeys fairness at all costs. Your interactivity regression is that SD causes 
> progressive slowdown with load which by definition is fairness. You 
> repeatedly ask me to address it and there is on unfailing truth; the only way 
> to address it is to add unfairness to the design. So why don't I? Because the 
> simple fact is that any unfairness no matter how carefully administered or 
> metered will always have cases where it's wrong. Look at the title of this 
> email for example - it's yet another exploit for the mainline sleep/run 
> mechanism. This does _not_ mean I'm implying people are logging into servers 
> and running ./tenp to hang the machine. What it demonstrates is a way of 
> reproducing the scenario which is biting people with real world loads. It's 
> entirely believable that a simple p2p app could be behaving like tenp, only 
> generating a small load and it could take ages to log in and use the console. 
> Willy has complained this is why people stick to 2.4. Sure I can create 
> interactivity tweaks worse than anyone else. I will not, though, because that 
> precisely undoes what is special about SD. It never looks backwards, and is 
> predictable to absurdity. So you'll argue that mainline can manage it 
> below...
> 
> > > You'll end up with an incresingly complex state machine design of
> > > interactivity tweaks and interactivity throttlers all fighting each
> > > other to the point where the intearactivity estimator doesn't do
> > > anything. [...]
> >
> > It comes down to defining interactivity by scheduling behavior, and
> > making that definition flexible. SD's definition of interactivity is
> > rigid (but it's still behavior-based, so not fundamentally different
> > from an explicit 'interactivity estimator'), and currently it does not
> > work well under high load. But ... i'm still entertaining the notion
> > that it might be good enough, but you've got to demonstrate the design's
> > flexibility.
> 
> I have yet to see someone find an "exploit" for SD's current design. Mainline 
> is all about continually patching up the intrinsic design (and fixing this 
> one test case is not the be all and end all).
> 
> > furthermore, your description does not match my experience when using
> > Mike's tweaks and comparing it to SD on the same hardware. According to
> > your claim i should have seen regressions popping up in various,
> > already-fixed corners, but it didnt happen in practice. But ... i'm
> > awaiting further SD and Mike tweaks, the race certainly looks
> > interesting ;)
> 
> Well you see a race. I do not. I see a flat predictable performance from SD 
> where there will always be slowdown with load. I have no intention of 
> changing that. Mike is making an admirable attempt to fix issues as they are 
> pointed out. You say there are no regressions but I see absolutely no testers 
> of his patches besides himself and you. If I introduce any unfairness based 
> on sleep behaviour into SD I'll be undoing the whole point of the design and 
> end up chasing new regressions. So I won't quibble over the numbers. SD has 
> produced a lot of improvements and fairness that mainline struggles with ever 
> increasing patches to emulate, but SD does so at the expense of proportional 
> slowdown with load. At least I accept that and will no longer put my health 
> at risk trying to "fix" it by "breaking" it. SD is done.
> 
> I feel sorry for the many users out there who are simply "waiting for it to 
> end up in mainline" who just discovered you will veto it on that basis. 
> lwn.net had it wrong; this was far more painful than any previous attempt to 
> get anything into mainline.
> 
> My health has been so badly affected by this that I've been given an ultimatum 
> and must turn my computer off till I get well now which may be weeks. I 
> already know the massive flameage and last-word comments that are likely to 
> be fired off before the inevitable decision to veto it.
> 
> > 	Ingo
> 
> さようなら
> 
