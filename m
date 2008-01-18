Return-Path: <linux-kernel-owner+w=401wt.eu-S1764381AbYARRc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764381AbYARRc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764317AbYARRcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:32:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764096AbYARRcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:32:11 -0500
Date: Fri, 18 Jan 2008 09:30:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jikos@jikos.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
In-Reply-To: <4790BDD1.40808@siemens.com>
Message-ID: <alpine.LFD.1.00.0801180918110.2957@woody.linux-foundation.org>
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com> <Pine.LNX.4.64.0801181203240.15647@twin.jikos.cz> <Pine.LNX.4.58.0801180634040.7574@gandalf.stny.rr.com> <4790BDD1.40808@siemens.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Jan 2008, Jan Kiszka wrote:
> Steven Rostedt wrote:
> ...
> > @@ -978,7 +980,13 @@ void release_console_sem(void)
> >  	console_locked = 0;
> >  	up(&console_sem);
> 
> Hmm, just looking at this fragment: Doesn't up() include the risk of
> running onto the runqueue lock as well?

In theory yes.

I suspect it would never ever be a problem in practice (the case we care 
about is running with interrupts disabled, and we got it with 
down_trylock()), so as this is only about essentially custon debug or oops 
things anyway, it's probably not worth fixing.

That said, you're definitely right in theory.

But *IF* we want to fix the almost certainly purely theoretical problem, 
it would be possible but fairly ugly.

We'd need to (a) make it a mutex rather than a semaphore (which is 
definitely not the ugly part), and then - the ugly part - (b) expose a 
whole new mutex interface: an enhanched version of "mutex_trylock()" that 
*also* keeps the mutex spinlock locked, and then instead of using 
"mutex_unlock()" we'd use a special "mutex_unlock_atomic()" that knows the 
spinlock was held over the whole time.

So it would then use something like

	if (mutex_trylock_atomic(..)) {

		mutex_unlock_atomic(..);
	}

and that would work out ok.

It's likely not that hard, and in fact this may be why "console_sem" was 
never converted to a mutex: I think Ingo tried, but it didn't work right 
with debugging enabled, and I can well imagine that it was all due to this 
issue. But if we do those _atomic() versions, we'd probably fix that 
problem.

So maybe the "ugly new interface" would actually be a cleanup in the long 
run, by possibly fixing the fact that things just *happened* to work with 
semaphores because they didn't do the fancy debug version..

Ingo?

			Linus
