Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0CNHAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 03:00:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58436 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab0CNHAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 03:00:12 -0400
Date: Sun, 14 Mar 2010 07:59:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Jiri Kosina <jkosina@suse.cz>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
 commit a2db6842873c8e5a70652f278d469128cb52db70
Message-ID: <20100314065952.GA24489@elte.hu>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net>
 <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org>
 <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz>
 <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org>
 <m1fx43zhbd.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1003132131470.3719@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003132131470.3719@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 13 Mar 2010, Eric W. Biederman wrote:
> > 
> > It also only affects those fairly rare lockdep users as well, and the only
> > affect is to throw a nasty warning message.  Isn't lockdep all about throwing
> > nasty warning messages?
> 
> Hmm. The report has that "BUG: " message in it (and in the subject line), 
> but you're right - it ends up being just a warning, not actually a real 
> BUG() (which is a machine killer).
> 
> So yeah - it's not as bad as I thought. Sorry.
> 
> [ And that "BUG:" in turn seems to be due to Ingo for some reason wanting 
>   to confuse BUG_ON() messages (which have that "BUG: " prefix thing) with 
>   whatever warning conditions he adds.
> 
>   Our warnings used to have that bug too (see commit 8f53b6fcc4: "Don't 
>   call a warnign a bug. It's a warning.").
> 
>   Ingo: can we agree to not put "BUG: " messages in warnings, ok? It may 
>   be a bug (lower-case) that triggers them, but that whole "BUG()" thing 
>   has it's own semantics with rather more serious consequences than some 
>   warning that lets things continue.

Sure - will change those too over to the "INFO: " pattern we've been using for 
some time. All new warnings that come via our trees use 'INFO: ', the 'BUG: ' 
ones are there for historic reasons.

There's a few that are external to lockdep and are likely fatal conditions:

	printk(  "[ BUG: bad unlock balance detected! ]\n");
	printk(  "[ BUG: bad contention detected! ]\n");
	printk(  "[ BUG: held lock freed! ]\n");
	printk(  "[ BUG: lock held at task exit time! ]\n");

(these things often tend to cause hangs/crashes later on.)

and then there's a few that are mostly internal to lockdep, and should never 
be fatal:

		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
		printk("BUG: key %p not in .data!\n", key);
		printk("BUG: MAX_LOCKDEP_SUBCLASSES too low!\n");
		printk("BUG: MAX_LOCK_DEPTH too low!\n");

[ there's rare exceptions - i've seen 'BUG: key' + real crash on a few occasions,
  when the warning was caused by memory corruption. But typically the warning 
  is not fatal, and this is what matters to the severity of the message. ]

So i'm wondering whether we should/could keep those first four with a 'BUG: ' 
message, as lockdep wont crash the machine in the BUG() fashion. The other 7 
should definitely be less alarming messages.

	Ingo
