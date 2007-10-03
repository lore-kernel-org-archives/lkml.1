Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbXJCEwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbXJCEwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbXJCEwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:52:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbXJCEwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:52:30 -0400
Date: Tue, 2 Oct 2007 21:52:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Davidsen <davidsen@tmr.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
   Control Kernel
In-Reply-To: <4703126D.70703@tmr.com>
Message-ID: <alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org>
References: <46FEEBD4.5050401@schaufler-ca.com>  <20070930011618.ccb8351b.akpm@linux-foundation.org>
  <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au> 
 <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
 <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
 <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
 <4702B1D5.5050502@tmr.com> <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
 <4703126D.70703@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Oct 2007, Bill Davidsen wrote:
> 
> Unfortunately not so, I've been looking at schedulers since MULTICS, and
> desktops since the 70s (MP/M), and networked servers since I was the ARPAnet
> technical administrator at GE's Corporate R&D Center. And on desktops response
> is (and should be king), while on a server, like nntp or mail, I will happily
> go from 1ms to 10sec for a message to pass through the system if only I can
> pass 30% more messages per hour, because in virtually all cases transit time
> in that range is not an issue. Same thing for DNS, LDAP, etc, only smaller
> time range. If my goal is <10ms, I will not sacrifice capacity to do it.

Bill, that's a *tuning* issue, not a scheduler logic issue.

You can do that today. The scheduler has always had (well, *almost* 
always: I think the really really original one didn't) had tuning knobs.

It in no way excuses any "pluggable scheduler", because IT DOES NOT CHANGE 
THE PROBLEM.

[ Side note: not only doesn't it change the problem, but a good scheduler 
  tunes itself rather naturally for most things. In particular, for things 
  that really are CPU-limited, the scheduler should be able to notice 
  that, and will not aim for latency to the same degree.

  In fact, what is really important is that the scheduler notice that some 
  programs are latency-critical AT THE SAME TIME as other programs sharing 
  that CPU are not, which very much implies that you absolutely MUST NOT 
  have a scheduler that done one or the other: it needs to know about 
  *both* behaviors at the same time.

  IOW, it is very much *not* about multiple different "pluggable modules", 
  because the scheduler must be able to work *across* these kinds of 
  barriers. ]

So for example, with the current scheduler, you can actually set things 
like scheduler latency. Exactly so you can tune things. However, I 
actually would argue that you generally shouldn't need to, and if you 
really do need to, and it's a huge deal for a real load (and not just a 
few percent for a benchmark), we should consider that a scheduler problem.

So your "argument" is nonsense. You're arguing for something else than 
what you _claim_ to be arguing for. What you state that you want actually 
has nothing what-so-ever to do with pluggable schedulers, quite the 
reverse!

It's also totally incorrect to state that this is somehow intrisicly a 
feature of a "server load". Many server loads have very real latency 
constraints. No, not the traditional UNIX loads of SMPT and NNTP, but in 
many loads the latency guarantees are a rather important part of it, and 
you'll have benchmarks that literally test how high the load can be until 
latency reaches some intolerable value - ie latency ends up being the 
critical part.

There's also a meta-development issue here: I can state with total 
conviction that historically, if we had had a "server scheduler" and a 
"desktop scheduler", we'd have been in much worse shape than we are now. 

Not only are a lot of the loads the same or at least similar (and aiming 
for _one_ scheduler - especially one that auto-tunes itself at least to to 
some degree - gets you lots of good testing), but the hardware situation 
changes.

For example, even just five years ago, there would have been people who 
thought that multiprocessing is a server load - and they'd have been 
largely right at the time. Would you have wanted a "server" (SMP, screw 
latency) scheduler, a "workstation" (SMP but low-latency) scheduler and a 
"desktop" (UP) scheduler for the different cases?

Because yes, SMP does impact the scheduler a lot... The locking, the 
migration between CPU's, the CPU affinity.. Things that gamers five years 
ago would have felt was just totally screwing them over and making the 
scheduler slower and more complex "for no gain".

See? Pluggable things are generally a *bad* thing. You should generally 
aim for *never* being pluggable if you can at all avoid it, because it not 
only fragments the developer base over totally different code bases, it 
generates unmaintainable decisions as the problem space evolves.

To get back to security: I didn't want pluggable security because I 
thought that was a technically good solution. No, the reason Linux has LSM 
(and yes, I was the one who pushed hard for the whole thing, even if I 
didn't actually write any of it) was because the problem wasn't technical 
to begin with.

It was social/political and administrative.

See? Another fundamental difference between schedulers and security 
modules. 

> > I don't know who came up with it, or why people continue to feed the insane
> > ideas. Why do people think that servers don't care about latency?   
> 
> Because people who run servers for a living, and have to live with limited
> hardware capacity realize that latency isn't the only issue to be addressed,
> and that the policy for degradation of latency vs. throughput may be very
> different on one server than another or a desktop.

Quite frankly a lot of other people run servers for a living too, and 
their main issue is often latency. And no, they don't do NNTP or SMTP, 
they do strange java things around databases with thousands of threads. 

Should they use a "desktop" scheduler? Because clearly their loads have 
nothing what-so-ever in common with yours?

Or can you possibly admit that it's really the exact same problem? 

Really: tell me what the difference is between "desktop" and "server" 
scheduling. There is absolutely *none*.

Yes, there are differences in tuning, but those have nothing to do with 
the basic algorithm. They have to do with goals and trade-offs, and most 
of the time we should aim for those things to auto-tune (we do have the 
things in /proc/sys/kernel/, but I really hope very few people use them 
other than for testing or for some extreme benchmarking - at least I 
don't personally consider them meant primarily for "production" use).

> > Why do people believe that desktop doesn't have multiple processors or
> > through-put intensive loads? Why are people continuing this *idiotic*
> > scheduler discussion?
> 
> Because people can't get you to understand that one size doesn't fit all (and
> I doubt I've broken through).

I understand the "one size" argument, I just disagree vehemently about it 
having anything to do with a pluggable scheduler. The scheduler does have 
tuning, most of it 100% automatic (that's what the "fairness" thing is all 
about!), and none of it needs - or would even remotely be helped by - 
pluggability.

Take a really simple example: you have fifty programs all wanting to run 
on the same machine at the same time. There simply *needs* to be some 
single scheduler that picks which one to run. At some point, you have to 
make the decision. And no, they are not all "throughput" or all 
"latency", and you cannot make your decision based on a "global pluggable 
scheduler policy". 

Some of the processes may be purely about throughput, some may be purely 
about latency, and some may change over their lifetime.

Not very amenable to "pluggable" things, is it? Especially since the 
thing that eventually needs to give the CPU time to *somebody* simply 
needs to understand all these different needs at some level anyway. It 
always ends up having to be *something* that decides, and it can 
absolutely never ignore the other "somethings". So a set of independent 
pluggable modules simply wouldn't work.

See?

(Sure you could make a multi-level scheduler with different pluggable ones 
for different levels, but that really doesn't work very well, since even 
in a multi-level one, you do want to have some generic notion of "this one 
cares about latency" and "this process is about throughput", so then the 
pluggable stuff wouldn't add any advantage _anyway_ - the top-level 
decision would have all the complexities of the one "perfect" scheduler 
you want in the first place!)

In contrast, look at fifty programs that all want to run on the same 
machine at the same time, but we have security issues. Now, security 
pretty much by definition cuts _across_ those programs, with the whole 
point generally being to make one machine secure, so almost always you'd 
generally want to have "a security model" for the whole machine (or at 
least virtual machine) - it's just that the policies may be totally 
different in different circumstances and across different machines.

But even if you were to *not* want to have one single policy, but have 
different policies for different processes, it at least still makes 
some conceptual sense, in ways it does not to try to have independent 
schedulers. For schedulers, at some point, it just hits the hardware 
resource: the CPU needs to be given to *one* of them. For a security 
policy, it's all software choices - you don't need to limit yourself to 
one choice at any time.

So a pluggable module makes more sense there anyway.

But no, that's not really why we have LSM. I'd have *much* preferred to 
have one unified security module setup that we could all agree on, and no 
pluggable security modules. It was not to be - and the reason we have LSM 
is not because "it makes more sense than a CPU scheduler", but simply 
because "people didn't actually get anything done at all, because they 
just argued about what to do".

In the CPU schedulers, Ingo still gets work done, even though people argue 
about it. So we haven't needed to go to the extreme of an "LSM for CPU 
schedulers", because the arguments don't actually hold up the work.

And THAT is what matters in the end.

		Linus
