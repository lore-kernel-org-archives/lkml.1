Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0CNRXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 13:23:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab0CNRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 13:23:41 -0400
Date: Sun, 14 Mar 2010 10:20:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
 commit a2db6842873c8e5a70652f278d469128cb52db70
In-Reply-To: <20100314065952.GA24489@elte.hu>
Message-ID: <alpine.LFD.2.00.1003140954530.3719@i5.linux-foundation.org>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net> <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org> <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz> <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org>
 <m1fx43zhbd.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1003132131470.3719@i5.linux-foundation.org> <20100314065952.GA24489@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 14 Mar 2010, Ingo Molnar wrote:
> > 
> >   Ingo: can we agree to not put "BUG: " messages in warnings, ok? It may 
> >   be a bug (lower-case) that triggers them, but that whole "BUG()" thing 
> >   has it's own semantics with rather more serious consequences than some 
> >   warning that lets things continue.
> 
> Sure - will change those too over to the "INFO: " pattern we've been using for 
> some time. All new warnings that come via our trees use 'INFO: ', the 'BUG: ' 
> ones are there for historic reasons.

Yeah, I assumed so. I just did a quick "git blame" to see where the code 
came from, I didn't delve any deeper.

> There's a few that are external to lockdep and are likely fatal conditions:
> 
> 	printk(  "[ BUG: bad unlock balance detected! ]\n");
> 	printk(  "[ BUG: bad contention detected! ]\n");
> 	printk(  "[ BUG: held lock freed! ]\n");
> 	printk(  "[ BUG: lock held at task exit time! ]\n");
> 
> (these things often tend to cause hangs/crashes later on.)
> 
> and then there's a few that are mostly internal to lockdep, and should never 
> be fatal:
> 
> 		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
> 		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
> 		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
> 		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
> 		printk("BUG: key %p not in .data!\n", key);
> 		printk("BUG: MAX_LOCKDEP_SUBCLASSES too low!\n");
> 		printk("BUG: MAX_LOCK_DEPTH too low!\n");
> 
> [ there's rare exceptions - i've seen 'BUG: key' + real crash on a few occasions,
>   when the warning was caused by memory corruption. But typically the warning 
>   is not fatal, and this is what matters to the severity of the message. ]
> 
> So i'm wondering whether we should/could keep those first four with a 'BUG: ' 
> message, as lockdep wont crash the machine in the BUG() fashion. The other 7 
> should definitely be less alarming messages.

At least my personal "mental expectation" is that BUG() implies that there 
was not even a try at recovering from the situation (ie our traditional 
"panic()" behavior), and that we didn't even continue. IOW, we actually 
terminated a process or effectively killed the machine.

If it's "just" a case of "something is wrong, but I'm just reporting it 
and continuing", then warning/info would be better. At least that's what 
my personal expectations are, and why I reacted so strongly to the whole 
BUG thing in this thread.

Btw, tangentially on a similar kind of "expectations of a debug message 
with call trace": I wonder if those things could be made to trigger all 
the fancy new automatic oops reporting.

The simplest thing to do would be to just replace _all_ of the printk + 
dump_stack with just "WARN_ON()", and then append the lockdep info later. 
At least then the fact that lockdep triggered would be noted by modern 
user space (and perhaps logged to kerneloops etc). 

A fancier thing might be to print the lockdep state _inside_ the whole 
"--- [ cut here ] ---" region, so that the lockdep stuff also gets logged, 
but I don't think we have the infrastructure to do that cleanly now (ie 
wa have that whole "warn_slowpath_*()" thing, but it allows for a single 
line printout format, not for a generic "print out debug info" function)

			Linus
