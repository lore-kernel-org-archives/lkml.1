Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXLCM3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXLCM3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 07:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXLCM25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 07:28:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38798 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbXLCM24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 07:28:56 -0500
Date: Mon, 3 Dec 2007 13:28:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203122833.GA20232@elte.hu>
References: <20071202144331.6abf1289@laptopd505.fenrus.org> <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org> <20071203103815.GA2707@elte.hu> <20071203110412.GD28560@one.firstfloor.org> <20071203115900.GB8432@elte.hu> <20071203121357.GB2986@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203121357.GB2986@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Mon, Dec 03, 2007 at 12:59:00PM +0100, Ingo Molnar wrote:
> > no. (that's why i added the '(or a kill -9)' qualification above - if 
> > NFS is mounted noninterruptible then standard signals (such as Ctrl-C) 
> > should not have an interrupting effect.)
> 
> NFS is already interruptible with umount -f (I use that all the 
> time...), but softlockup won't know that and throw the warning 
> anyways.

umount -f is a spectacularly unintelligent solution (it requires the 
user to know precisely which path to umount, etc.), TASK_KILLABLE is a 
lot more useful.

> > your syslet snide comment aside (which is quite incomprehensible - a
> 
> For the record I have no principle problem with syslets, just I do 
> consider them roughly equivalent in end result to a explicit retry 
> based AIO implementation.

which suggests you have not really understood syslets. Syslets have no 
"retry" component, they just process straight through the workflow. 
Retry based AIO has a retry component, which - as its name suggests 
already - retries operations instead of processing through the workload 
intelligently. Depending on how "deep" the context of an operation the 
retries might or might not make a noticeable difference in performance, 
but it sure is an inferior approach.

> > retry based asynchonous IO model is clearly inferior even if it were 
> > implemented everywhere), i do think that most if not all of these 
> > supposedly "difficult to fix" codepaths are just on the backburner 
> > out of lack of a clear blame vector.
> 
> Hmm. -ENOPARSE. Can you please clarify?

which bit was unclear to you? The retry bit i've explained above, lemme 
know if there's any other unclarity.

> > "audit thousands of callsites in 8 million lines of code first" is a 
> > nice euphemism for hiding from the blame forever. We had 10 years 
> > for it
> 
> Ok your approach is then to "let's warn about it and hope it will go 
> away"

s/hope//, but yes. Surprisingly, this works quite well :-) [as long as 
the warnings are not excessively bogus, of course]

and note that this is just a happy side-effect - the primary motivation 
is to get warnings about tasks that are uninterruptible forever. (which 
is a quite common kernel bug pattern.)

> Anyways I think I could live with it a one liner warning (if it's 
> seriously rate limited etc.) and a sysctl to enable the backtraces; 
> off by default. Or if you prefer that record the backtrace always in a 
> buffer and make it available somewhere in /proc or /sys or /debug. 
> Would that work for you?

you are over-designing it way too much - a backtrace is obviously very 
helpful and it must be printed by default. There's enough 
configurability in it already so that you can turn it off if you want. 
(And you said SLES has softlockup turned off already so it shouldnt 
affect you anyway.)

	Ingo
