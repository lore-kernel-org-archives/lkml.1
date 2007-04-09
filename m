Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbXDITwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbXDITwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965034AbXDITwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:52:09 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57588 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbXDITwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:52:07 -0400
Date: Mon, 9 Apr 2007 12:51:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <9B6136A3-52B4-4AE2-9805-21634E25530A@mac.com>
Message-ID: <Pine.LNX.4.64.0704091239030.6730@woody.linux-foundation.org>
References: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
 <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
 <20070406163100.GA554@tv-sign.ru> <Pine.LNX.4.64.0704061119090.8738@alien.or.mcafeemobile.com>
 <m1wt0p5o1y.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704061214450.8738@alien.or.mcafeemobile.com>
 <20070406191945.GA18255@elte.hu> <Pine.LNX.4.64.0704061427130.8738@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0704061449231.6730@woody.linux-foundation.org>
 <20070409082847.GA2228@elte.hu> <461A816F.4050507@tmr.com>
 <9B6136A3-52B4-4AE2-9805-21634E25530A@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Apr 2007, Kyle Moffett wrote:
> 
> Maybe "struct posix_process" is more descriptive?  "struct process_posix"?
> "Ugly POSIX process semantics data" seems simple enough to stick in a struct
> name.  "struct uglyposix_process"?

Guys, you didn't read my message.

It's *not* about "process" stuff.  Anything that tries to call it a 
"process" is *by*definition* worse than what it is now. Processes have all 
the things that we've cleanly separated out for filesystem, VM, SysV 
semaphore state, namespaces etc.

The "struct signal_struct" is the random *leftovers* from all the other 
stuff. It's *not* about "processes". Never has been, and never will be. 

It's mainly about signal cruft, because that's the nastiest part of POSIX 
threads behaviour, and that can't be clearly separated as one clear 
structure. 

So
 - it really *is* mostly about signal handling and signal sources. 
 - it has some random *cruft* in it that isn't about signals, but even 
   that is mostly a matter of "it was random cruft in the original task 
   structure too, and it DID NOT MERIT a flag of its own"
 - if you wanted to clean things up, you'd actually make things like 
   the "rlimit" info structures of their own, and have pointers to them. 

So that cruft largely got put into "signal_struct" just because they were 
the last thing to be moved out, along with the signal stuff (which was the 
big and painful part). NOT because "struct signal_struct" is somehow about 
"process state".

So stop blathering about processes. It has *nothing* to do with processes. 
It's primarily about signals, but it has "cruft" in it.

So an accurate name is

	struct signal_struct_with_some_cruft_in_it_that_did_not_merit_a_struct_of_its_own

but that's actually fairly unwieldly to type, and so in the name of sanity 
and clear source code, it's called

	struct signal_struct

and that's it.

And people who have argued for renaming it don't even seem to understand 
what it's *about*, so the arguments for renaming it have been very weak 
indeed so far.

IT IS NOT ABOUT "PROCESSES".

To be a "posix process", you have to share *everything*. The signal-struct 
isn't even a very important part of that sharing. In fact, it's quite 
arguably the *least* important part to share, which is why it was 
separated out as a separate thing absolutely *last*, and which is why we 
could do without it for quite long, with just some annoyingly subtle 
non-POSIX semantics.

Get it? It's the structure that is *least* important for a "process".

So stop blathering about "processes". Anybody who does that, just shows 
that they haven't thought it through!

			Linus
