Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbXDXXnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbXDXXnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 19:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbXDXXnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 19:43:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656AbXDXXnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 19:43:14 -0400
Date: Tue, 24 Apr 2007 16:41:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070424212408.GD16457@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de>
 <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de>
 <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net>
 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Apr 2007, Pavel Machek wrote:
> > 
> > If the code just moved somewhere else, it's not "less code".
> 
> It is not "just moved". It is in userspace, where we can use liblzf /
> gcrypt / ( and vbetool for s2ram/s2both) as libraries. We have about
> 7000 LoC of userland code (that is not libraries).

If it's in user land, we also have 

 - communication difficulties between two parts, and all the *crap* that 
   tends to entail (ie legacy interfaces forever, and upgrading one 
   without the other etc)

 - people who work on the kernel part are working "blind" (ie they are at 
   the mercy of whatever userland does, and it's not a "contained" 
   subsystem). This just ends up becoming worse when you then interact 
   with ten different versions of the user-land stuff, thanks to small 
   tweaks by five different vendors, and a hundred random people.

And don't tell me that doesn't happen. Maybe it doesn't happen _now_, 
because people who use it all get the patches from one place, but the 
moment we start talking about integration into the standard kernel, that 
means that the kernel needs to work regardless of whether somebody uses 
SuSE, RH, Fedora, Ubuntu or cooked his own distro entirely using some 
development version of the suspend user-space tools.

This is why I don't believe in the whole kernel-line-counting thing. I'm 
personally 100% convinced that it's better to have ten times as many lines 
in the kernel, if it means that you can just forget about version skew and 
bad user-space interfaces etc.

So if you want to enumerate "good" points, you'd damn well also face the 
_problems_.

This is why there's a lot to be said for

	echo mem > /sys/power/state

and being able to follow the path through _one_ object (the kernel) over 
trying to figure out the interaction between many different parts with 
different versions.

> I believe uswsusp user/kernel separation is clean enough. Kernel
> provides "snapshot image" and "resume image". (Thanks go to Rafael for
> very clean interface).

Now, *that* is the kind of argument that matters.

Quite frankly, if you want to convince me, it's not by "lines of kernel 
code", but by talking about easy-to-understand interfaces that actuually 
do one thing and do it well (and by "one thing", I mean "one _whole_ 
thing"). Because I care a lot less about lines of code than about 
"maintainable interfaces that people can think about and debug".

I absolutely detest all suspend-to-disk crap. Quite frankly, I hate the 
whole thing. I think they've _all_ caused problems for the "true" suspend 
(suspend-to-ram), and the last thing I want to see is three or four 
different suspend-to-disk implementations.  So unlike Ingo, I don't think 
"let's just integrate them all side-by-side and maintain them and look who 
wins" is really a good idea.

How many different magic ioctl's does the thing introduce? Is it really 
just *two* entry-points (and how simple are they, interface-wise), and 
nothing else?

		Linus
