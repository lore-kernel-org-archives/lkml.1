Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbXLCMly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbXLCMly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 07:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbXLCMlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 07:41:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36393 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbXLCMlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 07:41:46 -0500
Date: Mon, 3 Dec 2007 13:41:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203124144.GC2986@one.firstfloor.org>
References: <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org> <20071203103815.GA2707@elte.hu> <20071203110412.GD28560@one.firstfloor.org> <20071203115900.GB8432@elte.hu> <20071203121357.GB2986@one.firstfloor.org> <20071203122833.GA20232@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203122833.GA20232@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 01:28:33PM +0100, Ingo Molnar wrote:
> 
> > On Mon, Dec 03, 2007 at 12:59:00PM +0100, Ingo Molnar wrote:
> > > no. (that's why i added the '(or a kill -9)' qualification above - if 
> > > NFS is mounted noninterruptible then standard signals (such as Ctrl-C) 
> > > should not have an interrupting effect.)
> > 
> > NFS is already interruptible with umount -f (I use that all the 
> > time...), but softlockup won't know that and throw the warning 
> > anyways.
> 
> umount -f is a spectacularly unintelligent solution (it requires the 
> user to know precisely which path to umount, etc.),

lsof | grep programname

> TASK_KILLABLE is a lot more useful.

Not sure it is better on all measures.

One problem is how to distingush again between program abort
(which only affects the program) and IO abort (which leaves
EIO marked pages in the page cache affecting other processes too) 
umount -f does this at last.

I didn't think TASK_KILLABLE has solved that cleanly (although
I admit I haven't read the latest patchkit, perhaps that has changed
over the first iteration) 

But it also probably doesn't make things much worse than they were before.

> 
> > > your syslet snide comment aside (which is quite incomprehensible - a
> > 
> > For the record I have no principle problem with syslets, just I do 
> > consider them roughly equivalent in end result to a explicit retry 
> > based AIO implementation.
> 
> which suggests you have not really understood syslets. Syslets have no 

That's possible.

> "retry" component, they just process straight through the workflow. 
> Retry based AIO has a retry component, which - as its name suggests 
> already - retries operations instead of processing through the workload 
> intelligently. Depending on how "deep" the context of an operation the 
> retries might or might not make a noticeable difference in performance, 
> but it sure is an inferior approach.

Not sure what is that less intelligent in retry (you're
refering to more CPU cycles needed?), but I admit I haven't 
thought very deeply about that.

> 
> > > retry based asynchonous IO model is clearly inferior even if it were 
> > > implemented everywhere), i do think that most if not all of these 
> > > supposedly "difficult to fix" codepaths are just on the backburner 
> > > out of lack of a clear blame vector.
> > 
> > Hmm. -ENOPARSE. Can you please clarify?
> 
> which bit was unclear to you? The retry bit i've explained above, lemme 
> know if there's any other unclarity.

The clear blame vector bit was unclear.

> > > nice euphemism for hiding from the blame forever. We had 10 years 
> > > for it
> > 
> > Ok your approach is then to "let's warn about it and hope it will go 
> > away"
> 
> s/hope//, but yes. Surprisingly, this works quite well :-) [as long as 
> the warnings are not excessively bogus, of course]

Well i consider a backtrace excessively bogus.

> > Anyways I think I could live with it a one liner warning (if it's 
> > seriously rate limited etc.) and a sysctl to enable the backtraces; 
> > off by default. Or if you prefer that record the backtrace always in a 
> > buffer and make it available somewhere in /proc or /sys or /debug. 
> > Would that work for you?
> 
> you are over-designing it way too much - a backtrace is obviously very 
> helpful and it must be printed by default. There's enough 
> configurability in it already so that you can turn it off if you want. 

So it will hit everybody first before they can figure out how
to get rid of it? That was the part I was objecting too.

If it is decided to warn about something which is not 100% clear a bug
(and I think I have established this for now -- at least you didn't 
object to many of my examples...) then the likely
false positives shouldn't be too obnoxious. Backtraces are unfortunately
obnoxious and always come at a high cost (worried user, linux reputation
as a buggy OS, mailing list bandwidth, support load etc.) and having that 
for too many false positives is a bad thing.

> (And you said SLES has softlockup turned off already so it shouldnt 
> affect you anyway.)

My objection was not really for SLES, but for general Linux kernel
quality.

-Andi

