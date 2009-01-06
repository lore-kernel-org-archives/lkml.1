Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbZAFQyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbZAFQyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZAFQyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:54:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52412 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbZAFQyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:54:38 -0500
Date: Tue, 6 Jan 2009 17:54:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Message-ID: <20090106165409.GA32608@elte.hu>
References: <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain> <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain> <alpine.LFD.2.00.0901060833060.3057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901060833060.3057@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 6 Jan 2009, Linus Torvalds wrote:
> > 
> > So it should be renamed. Something like "task_is_oncpu()" or whatever.
> 
> Another complaint, which is tangentially related in that it actually 
> concerns "current".
> 
> Right now, if some process deadlocks on a mutex, we get hung process, 
> but with a nice backtrace and hopefully other things (that don't need 
> that lock) still continue to work.
> 
> But if I read it correctly, the adaptive spin code will instead just 
> hang. Exactly because "task_is_current()" will also trigger for that 
> case, and now you get an infinite loop, with the process spinning until 
> it looses its own CPU, which obviously will never happen.
> 
> Yes, this is the behavior we get with spinlocks too, and yes, lock 
> debugging will talk about it, but it's a regression. We've historically 
> had a _lot_ more bad deadlocks on mutexes than we have had on spinlocks, 
> exactly because mutexes can be held over much more complex code. So 
> regressing on it and making it less debuggable is bad.
> 
> IOW, if we do this, then I think we need a
> 
> 	BUG_ON(task == owner);
> 
> in the waiting slow-path. I realize the test already exists for the 
> DEBUG case, but I think we just want it even for production kernels. 
> Especially since we'd only ever need it in the slow-path.

yeah, sounds good.

One thought:

BUG_ON()'s do_exit() shows a slightly misleading failure pattern to users: 
instead of a 'hanging' task, we'd get a misbehaving app due to one of its 
tasks exiting spuriously. It can even go completely unnoticed [users dont 
look at kernel logs normally] - while a hanging task generally does get 
noticed. (because there's no progress in processing)

So instead of the BUG_ON() we could emit a WARN_ONCE() perhaps, plus not 
do any spinning and just block - resulting in an uninterruptible task 
(that the user will probably notice) and a scary message in the syslog? 
[all in the slowpath]

So in this case WARN_ONCE() is both more passive (it does not run 
do_exit()), and shows the more intuitive failure pattern to users. No 
strong feelings though.

	Ingo
