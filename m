Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbXLCMOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbXLCMOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 07:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXLCMOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 07:14:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50852 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbXLCMN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 07:13:59 -0500
Date: Mon, 3 Dec 2007 13:13:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203121357.GB2986@one.firstfloor.org>
References: <20071202204725.GA25891@one.firstfloor.org> <20071202144331.6abf1289@laptopd505.fenrus.org> <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org> <20071203103815.GA2707@elte.hu> <20071203110412.GD28560@one.firstfloor.org> <20071203115900.GB8432@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203115900.GB8432@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 12:59:00PM +0100, Ingo Molnar wrote:
> no. (that's why i added the '(or a kill -9)' qualification above - if 
> NFS is mounted noninterruptible then standard signals (such as Ctrl-C) 
> should not have an interrupting effect.)

NFS is already interruptible with umount -f (I use that all the time...), 
but softlockup won't know that and throw the warning anyways.

> your syslet snide comment aside (which is quite incomprehensible - a 

For the record I have no principle problem with syslets, just I do
consider them roughly equivalent in end result to a explicit retry based
AIO implementation.

> retry based asynchonous IO model is clearly inferior even if it were 
> implemented everywhere), i do think that most if not all of these 
> supposedly "difficult to fix" codepaths are just on the backburner out 
> of lack of a clear blame vector.

Hmm. -ENOPARSE. Can you please clarify?

> 
> "audit thousands of callsites in 8 million lines of code first" is a 
> nice euphemism for hiding from the blame forever. We had 10 years for it 

Ok your approach is then to "let's warn about it and hope
it will go away" 

> and it didnt happen. As we've seen it again and again, getting a 
> non-fatal reminder in the dmesg about the suckage is quite efficient at 

It's not universal suckage I would say, but sometimes unavoidable
conditions. Now it is better of course to have these all TASK_KILLABLE,
but then fixing that all in the kernel will probably a long term
project. I'm not arguing against that, just forcing it through
backtraces before even starting all that is probably not the right
strategy to do that.

> getting people to fix crappy solutions, and gives users and exact blame 
> point of where to start. That will create pressure to fix these 
> problems.

After impacting the user base -- many of these conditions are infrequent
enough that we will likely only see them during real production. Throwing
warnings for lots of known cases is probably ok for a -mm kernel
(where users expect things lik that), but not a "release" (be it
Linus release or any kind of end user distribution) imho.

I don't think there is a real alternative to code audit first
(and someone doing all the work of fixing all these first) 
 

> 
> > > I think you are somehow confusing two issues: this patch in no way 
> > > declares that "long waits are bad" - if the user _choses_ to wait 
> > > for
> > 
> > Throwing a backtrace is the kernel's way to declare something as bad. 
> > The only more clear ways to that I know of would be BUG or panic().
> 
> there are various levels of declarig something bad, and you are quite 
> wrong to suggest that a BUG() would be the only recourse.

I didn't write that, please reread my sentence.. 

But we seem to agree that a backtrace is something "declared bad" anyways,
which was my point.


> 
> > > way to stop_ are quite likely bad".
> > 
> > The user will just see the backtraces and think the kernel has 
> > crashed.
> 
> i've just changed the message to:
> 
>   INFO: task keventd/5 blocked for more than 120 seconds.
>   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message

That's better, but the backtrace is still there isn't it?

Anyways I think I could live with it a one liner warning (if it's
seriously rate limited etc.) and a sysctl to enable the backtraces;
off by default. Or if you prefer that record 
the backtrace always in a buffer and make it available somewhere in /proc
or /sys or /debug. Would that work for you? 

-Andi
