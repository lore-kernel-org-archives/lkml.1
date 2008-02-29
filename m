Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbYB2SNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbYB2SNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYB2SN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:13:28 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbYB2SN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:13:27 -0500
Date: Fri, 29 Feb 2008 10:12:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Michael Kerrisk <michael.kerrisk@googlemail.com>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <1204306934.6243.119.camel@lappy>
Message-ID: <alpine.LFD.1.00.0802290956110.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>  <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>  <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>  <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org> 
 <1204305488.6243.113.camel@lappy>  <alpine.LFD.1.00.0802290928200.17889@woody.linux-foundation.org> <1204306934.6243.119.camel@lappy>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Peter Zijlstra wrote:
> 
> > More importantly, isn't it better to just use the whole stack size then 
> 
> Well, we ran into trouble of freshly spawned tasks faulting on the first
> stack grow. The /4 thing was to avoid that situation.

Yeah, I do see the point of wanting slop, but maybe the right thing to do 
is simply to just not make the slop be 75% of it all ;)

The thing is, RLIMIT_STACK has never been "exact" in the first place (ie 
it has *always* contained the argument and environment as a part of it), 
and that is really traditional behaviour even outside of Linux.

And I seriously doubt that RLIMIT_ARG_MAX really buys people anything 
truly wonderful, and it definitely adds just another thing you can screw 
up and make the system just behave differently depending on a config value 
that doesn't even matter to the kernel. In fact, even with that patch, 
it's *still* not going to handle the difference between the actual string 
space and the pointers themselves, or even all the other setup stuff that 
the binary loaders will put on the stack.

So it's not *going* to be exact even with RLIMIT_ARG_MAX, because it's 
going to have all those other issues to contend with - on a 64-bit 
architecture, the argument _pointers_ are often within an order of 
magnitude of the argument strings themselves, and I don't think your patch 
counted them as part of the argument/environemnt size (I was too lazy to 
check the sources, but I'm pretty sure argv/env_start/end is just the 
string space, not the pointers).

So rather than introduce a new thing that is not going to be trustworthy 
anyway, I'd much rather just remove the limit entirely.

Also, it all boils down to the fact that the whole argument is utter crap:

> POSIX disallows sysconf() variables to change during the execution of a
> process, so even if it would ask the kernel for a value, we could not
> give a sane answer.

If the resource limits change, then it makes not a whit of a difference 
whether _SC_ARG_MAX changes or not, because it's not going to reflect 
reality. So you might as well just continue to give the value we've always 
given (128k? I don't remember). Because it's not going to be the "real" 
value *anyway*.

This whole argument seems pointless. Has anybody ever really cared? Why 
not just keep _SC_ARG_MAX at the old (small) limit, and then the fact that 
99% of all programs won't even care, and that they can actually use much 
larger limits in real life is just gravy.

A *good* implementation would generally just do the execve() with the 
maximal arguments, and only bother to see "oh, maybe I can split it up" if 
it returns ENOMEM or whatever it does. 

So I don't see the practical value here - _SC_ARG_MAX is not worth having 
another tweaking value for that people will just always get wrogn anyway 
because there is no right answer (except "I don't want my stack to grow 
too large" where it's just one of the relevant things)

			Linus
