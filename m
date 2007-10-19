Return-Path: <linux-kernel-owner+w=401wt.eu-S936473AbXJSXP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936473AbXJSXP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 19:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759645AbXJSXPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 19:15:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43730 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337AbXJSXPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 19:15:13 -0400
Date: Sat, 20 Oct 2007 01:14:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Git pull] arch/x86 updates
Message-ID: <20071019231455.GA2267@elte.hu>
References: <alpine.LFD.0.9999.0710192334440.22770@localhost.localdomain> <alpine.LFD.0.999.0710191459340.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710191459340.26902@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 19 Oct 2007, Thomas Gleixner wrote:
> > 
> > Pavel Emelyanov (1):
> >       i386: consolidate show_regs and show_registers for i386
> 
> While I think this is good otherwise, why does it do
> 
> 	printk(".. comm: %.*s .."
> 		TASK_COMM_LEN, current->comm,
> 
> instead of just using "%s" and "current->comm"? I only noticed because 
> there was an unrelated conflict around that thing.
> 
> That "current->comm" had better be NUL-terminated already, we use it 
> as such all over the place. And if it's not, *that* should be fixed.
> 
> I'm editing it back to the simpler pure string.

it might make some marginal sense to get an oops message out when 
there's stack overflow/corruption that damages task->comm. I've seen a 
good number of traces that printed out task->comm as an overlength 
string - which obscured other, possibly more important info that could 
have been printed until the system became so hosed that it would not 
print anything.

but ... this is really splitting hairs and even when the stack and hence 
the task struct is corrupted, an accidental NIL character is almost 
always a certainty. I remember only a single case in the past ~10 years 
where an oops would print a "never ending" p->comm because the 
corruption was a runaway memset to a non-0 value.

so printing it as %s should be perfectly fine too, for all practical 
purposes. (and printing it _without_ the TASK_COMM_LEN complication 
might help get out information faster in some other crash situations - 
so the argument can be made in the opposite direction too.)

	Ingo
