Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbXFWKbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbXFWKbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 06:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbXFWKax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:30:53 -0400
Received: from 1wt.eu ([62.212.114.60]:3105 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXFWKaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:30:52 -0400
Date: Sat, 23 Jun 2007 12:30:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alberto Gonzalez <info@gnebu.es>
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about fair schedulers
Message-ID: <20070623103012.GC7070@1wt.eu>
References: <200706230007.15622.info@gnebu.es> <200706231001.02497.info@gnebu.es> <20070623082320.GX943@1wt.eu> <200706231118.43408.info@gnebu.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706231118.43408.info@gnebu.es>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 11:18:43AM +0200, Alberto Gonzalez wrote:
> On Saturday 23 June 2007, Willy Tarreau wrote:
> > On Sat, Jun 23, 2007 at 10:01:02AM +0200, Alberto Gonzalez wrote:
> > > I see. So you mean that in 90% of the cases the mainline scheduler
> > > behaves better than fair schedulers, but when its "logic" fails it
> > > behaves much worse (the other 10% cases)? In my very simple test scenario
> > > the mainline scheduler did behave much better. Maybe the problem comes
> > > with very complex scenarios like the ones I've seen when testing these 2
> > > fair schedulers (something like compiling a kernel while you open 5
> > > instances of glxgears, write an email, play music in Amarok and watch 2
> > > HD videos all at the same time). The question would then be if these kind
> > > of situations are likely to happen in real world, or even if it doesn't
> > > make more sense to try to improve the logic of the mainline scheduler so
> > > that those 10% cases are handled better instead of writing a new one that
> > > would behave worse in 90% of the cases and better in the other 10%.
> >
> > No, in fact, the mainline scheduler is good only for the very particular
> > cases you propose here. But on some fairly trivial situations (such as two
> > processes consuming very close to 50% CPU), it can be a disaster. I've had
> > proxies under medium load slow down sshd so much that it was impossible to
> > log in. Most of the worst situations have been fixed since the early 2.6
> > versions (2.6.11 was still horrible), but it's the general design which
> > makes such cases hard to find and to fix.
> 
> I see. I was sure I was missing something, since everyone around here are 
> praising these new schedulers. However, the example you provide is not so 
> much about fair/unfair, but about good/bad scheduler. I mean, if a process 
> consumes 48% CPU and the other one also consumes 48% (if each were running 
> alone), when you run them at the same time a fair scheduler would give them 
> 48% to each, but an unfair one should also give them 48% to each. I still 
> fail to see the advantages of the "fair scheduler" design (even if I accept 
> that CFS is technically much better than mainline and thus work better in 
> your example).
> 
> > Your situation is clearly something standard where only the user can decide
> > which application should get more CPU. You start two CPU hogs, and your
> > mind tells you that you would prefer the video not to skip and the encoding
> > to finish later. For other people, it might be the reverse because the
> > video will be there just for monitoring purposes. The nice command was
> > invented exactly for that, and people have been happily using it for the
> > last 30 years. I don't see why it should become hard to use ! Many
> > CPU-sensitive applications already provide the ability to change their nice
> > value themselves using a command line parameter.
> >
> > And if it is still too hard to assign nice values from within your
> > environment, then perhaps it's the environment which does not suit your
> > needs. Even Windows users can choose to assign more priorities to
> > foreground/background tasks, so it is something universally accepted,
> > and I would be really surprized that you would not have the ability
> > to proceed the same way.
> 
> I think you're not considering normal users here.

Yes I am.

> Believe it or not, 99% of 
> desktop users in the world just click on a icon to watch a video. And they DO 
> want watch them, not use them for monitoring purposes (whatever that means).

Of course, I was just trying to give you an example.

> I acknowledge it's impossible to be inside a user's mind to decide what it's 
> more important to him/her, but let's agree that clearly a audio/video player 
> should have by default a higher priority than an audio/video encoder, for the 
> simple reason that one task requires a certain amount of CPU to do the job 
> correctly, while the other one can do the job correctly regardless of how 
> much CPU time you give it. They are different in nature.

Yes, one of them works in real time, the other one does not.

> What I don't know is 
> if knowing this should belong to the CPU scheduler or to the application 
> itself.

In your opinion ? Who between a few hundred lines function designed to fit
all needs, and a specific MPEG player is the most aware that the MPEG player
is very likely to require real time scheduling by nature ? At least, the old
version of mplayer I have on my machine (1.0pre7) has a "-priority" option.
Also, I remember that cdrecord automatically tries to go realtime in order
to avoid underrunning the buffer.

> But the bottom line is that on a desktop, tasks should receive 
> different -unfair- amounts of CPU time to work correctly. The "fair" concept 
> still looks wrong to me.

"fair" means what it means : stop starving some tasks for no apparent reasons.
If one task adjusts its priority, it can get more CPU than others, but the
distribution will still be fair according to the priorities.

> Nicing tasks might not be hard at all, but expecting normal users to do so is 
> not realistic. Either the scheduler or the applications should make these 
> decisions for them (us).

No, I cannot agree with you. The users have to solutions to start their player:
  - typing "mplayer xxx.mpeg" on the command line ; then they can prepend
    "nice" in front of it

  - clicking on an icon in their windows-like window managers, which makes
    executes the command for them.

If they decide to use the second solution, it means that the default settings
assigned to the icon should fit the application (that applies to the nice
value too). And if their distro ships with those pre-defined icons with stupid
priorities, they should complain to the distro vendor or switch to another one.
And if the window manager by itself does not make it easy to adjust priorities
when starting processes, it's poorly designed because it is it and only it
which forces the user to open a command line and manually set "nice".

So there are plenty of really transparent solutions for the user, but maybe
there are a lot of wrong tools and configurations...

Regards,
Willy

