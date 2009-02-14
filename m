Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbZBNH3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbZBNH3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 02:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZBNH3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 02:29:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbZBNH3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 02:29:34 -0500
Date: Fri, 13 Feb 2009 23:29:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/7] async: Asynchronous function calls to speed up
 kernel boot
Message-Id: <20090213232926.924d8740.akpm@linux-foundation.org>
In-Reply-To: <20090213205949.1ebb441d@infradead.org>
References: <20090107151151.458333c1@infradead.org>
	<20090107151226.58264d07@infradead.org>
	<20090213162200.8fea7e0c.akpm@linux-foundation.org>
	<20090213205949.1ebb441d@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009 20:59:49 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 13 Feb 2009 16:22:00 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > It means that sometimes, very rarely, the callback function will be
> > called within the caller's context.
> 
> for the cases that use it right now it is ok.

That doesn't mean it's any good!  There are only two callsites.

Plus there's the issue which I mentioned: if someone _does_ call this
from atomic context they'll only find out about their bug when the
GFP_ATOMIC allocation fails.  This is bad!

> > 
> > Hence this interface cannot be used to call might-sleep functions from
> > within atomic contexts.  Which should be a major application of this
> > code!
> 
> That is not what this was originally designed for. The original design
> goal was to offload existing function calls out of the synchronous
> execution path.

I'm desperately trying to avoid us ending up with multiple
different-but-similar thread pool implementations.  It's really quite
important that the one which got there first (actually, it's
approximately our fourth) be usable in place of Evgeniy's one and
dhowells' one.

> Now I understand that it would be nice to do what you propose, but it
> needs a little different interface for that; specifically, the caller
> will need to pass in the memory for the administration.

yep.  And we should change the existing interface to take an additional
gfp_t argument.  Because it's silly doing an unreliable GFP_ATOMIC when
the caller's context doesn't require that.

As for the fallback-to-synchronous-panics-the-kernel trap: I don't know
how we can save people from falling into that one.

> 
> > 
> > Furthermore:
> > 
> > - If the callback function can sleep then the caller must be able to
> >   sleep, so the GFP_ATOMIC is unneeded and undesirable, and the
> > comment is wrong.
> 
> And if the callback function does not sleep it can be used in atomic
> context just fine. Hence the GFP_ATOMIC.
> .
> 
> > 
> > I can't immediately think of a fix, apart from overhauling the
> > implementation and doing it in the proper way: caller-provided storage
> > rather than callee-provided (which always goes wrong).
> > schedule_work() got this right.
> 
> schedule_work() got it part right. Pushing the administration to the
> caller means the caller needs to allocate the memory or use static
> memory and then make sure it doesn't get reused for a 2nd piece of work.
> (schedule_work doesn't care, it will just execute it once in that case.
> Here we do absolutely care).

Caller needs to allocate storage for each invocation - that's fine.

It would be sensible for the code to be able to detect when the caller
tries to use the same storage concurrently, and go BUG.

> The caller only rarely can deal better with the memory allocation and
> lifetime rules than the implementation can.

Nonsense.  The caller *always* knows better.  That's a core design
decision in Linux and we relearn it over and over again.  Examples
are the radix-tree code, where we went to exorbitant lengths to make
callee-allocation reliable, and the IDR code, which completely sucks.

> In fact, for the scenario of
> "I want to take this bit of code out of the synchronous path
> normally".. it is just fine and most easy this way; moving this to the
> caller just makes things more fragile.

The code now is fragile.  Requiring caller-provided storage and adding
debugging to detect when the caller screws up is solid as a rock.

> So yes based on the discussions on lkml in the last week I was going to
> add an interface where you can pass in your own memory, but I want to
> get the interface right such that it is low complexity for the caller,
> and really hard to get wrong.. and that does involve dealing with the
> "how to do static allocation while doing multiple parallel calls"
> problem.

An alternative is to keep doing the allocation in the callee, add a
gfp_t argument and require that callers be able to handle the resulting
-ENOMEM.

But this is bad because the caller's -ENOMEM handling will remain
basically untested.

