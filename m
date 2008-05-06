Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbYEFVAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbYEFVAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764545AbYEFU7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:59:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52438 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674AbYEFU7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:59:44 -0400
Date: Tue, 6 May 2008 16:59:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210093586.17132.169.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0805061635450.28962@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com> 
 <1209753250.25628.34.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com> 
 <1209754467.25628.42.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com> 
 <1210003265.17132.6.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com> 
 <1210004376.17132.14.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com> 
 <1210007084.17132.32.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com> 
 <1210013938.17132.55.camel@localhost.localdomain> 
 <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de> 
 <1210025532.17132.82.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805060634330.12081@gandalf.stny.rr.com> 
 <1210089922.17132.132.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805061218260.16363@gandalf.stny.rr.com>
 <1210093586.17132.169.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 6 May 2008, Daniel Walker wrote:
> >
> > But you admit that you didn't do that yourself. This is also the time that
> > we were very busy at working on ftrace and hoping it would make it into
> > 2.6.26 (which it did not). Remember our goal is to get as much as possible
> > into mainline Linux. And getting something from -rt (ftrace) into Linux
> > was the higher priority for me than to go review your series after you
> > tell me that you dropped archs and made changes to the code for the sake
> > of bisectability.
>
> Who am I to dictate priorities to you? However, that's no excuse for
> ignoring something important.

It is only important for merging to a new tree, nothing more here. A
bisectable tree is important to make sure all new enhancements can be
tracked to see which feature broke the kernel. The reason we want it
bisectable in Linux, is when a bug appears we can do a binary search
(git-bisect) to find the culprit.

Doing this with the -rt patch doesn't solve that key issue. The reason why
is that new enhancements to the -rt patch happen in small patches. In
fact, by folding in a bunch of patches, we have just lost that ability!
The -rt patch has a bunch of features that it adds to the kernel. Having
the -rt patch queue bisectable doesn't find the bug that was introduced by
a new change to a patch deep in the queue (caused by folding). Ideally,
and I've done this to an extent, is to have each change as a separate
patch. This can help us find which change caused a bug.

Having the -rt patch queue as a bisectable queue (all 350+ patches) ONLY
HELPS IN FORWARD PORTING TO ANOTHER VERSION OF LINUX! That said, it is
usually the maintainers that do this. I have certain points in the queue
that I make sure can compile and test a new feature, to make sure
something didn't break in the port. I don't need each patch of that
feature bisectable, because the feature in the whole may be broken by
something that happened in upstream.


>
> > I thought my response was good enough to give you a clue that you needed
> > to show that your work didn't make any changes. Making the tree bisectable
> > is a "clean up" not a code design. And with all clean ups, they should not
> > cause any changes to code behaviour. You've been doing kernel development
> > long enough to know this. I'm not about to hold your hand and step you
> > through the proper process of getting things accepted.
>
> Setting a requirement of binary compatibility is un-reasonable. I told
> you it wasn't making functional changes, that combined with a concerned
> review of the code should have been enough.

I told you what to do, and so did Thomas. It's not rocket science, and it
is something I would do to make sure as well. Hell, Ingo and Thomas did
this for the x86 merge which was 10 times more complex than making the -rt
queue bisectable.

This is what you should have done.

1) if you needed to make changes to the code (your renaming), do that at
the end with extra patches.

2) save that final result.

3) go through and modify all the patches to your hearts content, to get a
bisectable queue out the door.

4) compare the end result with the result from step 2.

What's so fscking difficult about the above?????

If Ingo and Thomas told Linus to just accept the x86 merge without doing
this exact thing, and then told Linus that it is his job as maintainer to
review the changes to make sure they are correct, there would have not
been any x86 merge today. In fact, if they had the nerve to do that, they
would have lost all respect in the Linux community.

Guess what? You're doing exactly what I said Ingo and Thomas DID NOT DO!


>
> > If you don't make an effort to work with the maintainers instead of just
> > shoving out a bunch of code and expect us to do the dirty work to make
> > sure its ok, then you might as well give up. Take a lesson from Gregory
> > Haskins. He came out with a lot of changes that were controversial at the
> > time. Instead of shoving his code down our throats, he took our critisms
> > seriously and worked hard to work with us. Now most of his code, even the
> > controversial parts, has been incorporated.
>
> You have a responsibility as a maintainer .. You have to at least look
> at code, and decided exactly how to handle it. You have to decided how
> you want to merge the code, and when to merge the code.

The patch queue is 350+ patches. It is not up to me to go through and sort
out exactly what you did. That would take me a week to look at each
individual patch and know what was in your head. Sorry, that is your
responsibilty to help out here.

>
> Bisection is not an optional feature. It's default acceptable, and it
> should have been first on your merge list.

As I said, the paradigm for the -rt patch is completely different. Having
a bisectable patch queue to go into Linux is to find out where a bug was
introduced. Linux evolves in a simple straight time order of events. This
is not true with the -rt patch. To do this, I would keep all patches
unchanged in the tree, and only add new patches at the end, and never fold
anything. We do this to a point, and after a few releases, we start to
fold patches in that we feel are stable.

Again, having a bisectable -rt tree is to help with forward porting only.
And it doesn't even need to be fully bisectable. Just needs to have
certain points to verify.  Usually a bug is introduced by something that
changed in upstream that gets broken not by one patch in the -rt tree, but
by the new concept that the -rt tree introduces. For example, something
might break because we have interrupts as threads. This isn't found by a
bisectable tree, its found by turning off different configuration options
of the -rt patch.


>
> Instead you didn't want it. You default rejected it. From my perspective
> not wanting to merge something like that is itself unreasonable.

I did not default reject it. I told you what we wanted, and you made
absolutely no effort in complying. So in return, I made absolutely no
effort in looking at what you did.

>
> How is discussing this shoving my code down your throat?


Because you refuse to listen to what we say, and you keep pandering that
your changes are so damn important that we need to forget all our own
principles to listen to the word of Daniel.

-- Steve

