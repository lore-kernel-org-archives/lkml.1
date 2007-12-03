Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbXLCL7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbXLCL7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXLCL73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:59:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49341 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXLCL72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:59:28 -0500
Date: Mon, 3 Dec 2007 12:59:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203115900.GB8432@elte.hu>
References: <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202144331.6abf1289@laptopd505.fenrus.org> <20071203000741.GB26636@one.firstfloor.org> <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203095501.GB28560@one.firstfloor.org> <20071203111520.33ed2139@astralstorm.puszkin.org> <20071203102715.GC28560@one.firstfloor.org> <20071203103815.GA2707@elte.hu> <20071203110412.GD28560@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203110412.GD28560@one.firstfloor.org>
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

> On Mon, Dec 03, 2007 at 11:38:15AM +0100, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > Kernel waiting 2 minutes on TASK_UNINTERRUPTIBLE is certainly broken.
> > > 
> > > What should it do when the NFS server doesn't answer anymore or when 
> > > the network to the SAN RAID array located a few hundred KM away 
> > > develops some hickup?  [...]
> > 
> > maybe: if the user does a Ctrl-C (or a kill -9), the kernel should 
> > try
> 
> You mean NFS intr should be default? [...]

no. (that's why i added the '(or a kill -9)' qualification above - if 
NFS is mounted noninterruptible then standard signals (such as Ctrl-C) 
should not have an interrupting effect.)

> If you consider any of the arguments in the following paragraph "not 
> rational" please state your objection precisely. Thanks.
> 
> Consider the block case: First a lot of block IO runs over networks 
> too these days (iSCSI, drbd, nbd, SANs etc.) so the same 
> considerations as for other network file systems apply.  Networks can 
> have hickups and might take long to recover. Now implementing 
> TASK_KILLABLE in all block IO paths there properly is equivalent to 
> implementing EIOCBRETRY aio because it has to error out in near the 
> same ways in all the same places.  While I would like to see that (and 
> it would probably make syslets obsolete too ;-) it has been rejected 
> as too difficult in the past.

your syslet snide comment aside (which is quite incomprehensible - a 
retry based asynchonous IO model is clearly inferior even if it were 
implemented everywhere), i do think that most if not all of these 
supposedly "difficult to fix" codepaths are just on the backburner out 
of lack of a clear blame vector.

"audit thousands of callsites in 8 million lines of code first" is a 
nice euphemism for hiding from the blame forever. We had 10 years for it 
and it didnt happen. As we've seen it again and again, getting a 
non-fatal reminder in the dmesg about the suckage is quite efficient at 
getting people to fix crappy solutions, and gives users and exact blame 
point of where to start. That will create pressure to fix these 
problems.

> > I think you are somehow confusing two issues: this patch in no way 
> > declares that "long waits are bad" - if the user _choses_ to wait 
> > for
> 
> Throwing a backtrace is the kernel's way to declare something as bad. 
> The only more clear ways to that I know of would be BUG or panic().

there are various levels of declarig something bad, and you are quite 
wrong to suggest that a BUG() would be the only recourse.

> > way to stop_ are quite likely bad".
> 
> The user will just see the backtraces and think the kernel has 
> crashed.

i've just changed the message to:

  INFO: task keventd/5 blocked for more than 120 seconds.
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message

	Ingo
