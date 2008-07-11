Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbYGKAw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbYGKAw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYGKAwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:52:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbYGKAwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:52:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: Linus Torvalds's message of  Thursday, 10 July 2008 15:51:48 -0700 <alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080710215039.2A143154218@magilla.localdomain>
	<alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org>
	<20080710224256.AD038154218@magilla.localdomain>
	<alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
Emacs: anything free is worth what you paid for it.
Message-Id: <20080711005243.ADE90154218@magilla.localdomain>
Date: Thu, 10 Jul 2008 17:52:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You're ignoring the background question - we expressly _stopped_ doing 
> this long ago. So the real issue was the ".. if you really .." part.
> 
> Do we really? What's the actual downside here?

I'm not convinced it was real "express".  It was never expressed in a
comment or log entry.  The change came in (pre-git) with:
    [PATCH] x86-64 architecture specific sync for 2.5.8
and commit 10ffdbb8d605be88b148f127ec86452f1364d4f0 "cleaned up slightly"
making the other paths match, with no explanation on the subject.

i386 has never behaved this way, and still doesn't.  I would doubt any
other arch ever has.  (My fix makes x86_64 and i386 treatment of
_TIF_WORK_MASK and any related signal race issues identical.)

The behavior of the test case I posted is just demonstrably wrong.  I
know you're never swayed by the fact that it has always been specified
and documented clearly to behave this way (in the case of multiple
pending signals like the test case).  Since it always did on i386, it's
easy to expect that there may be all manner of applications lurking
around that have depended on the correct semantics in subtle (and
probably intermittent) ways their poor users and maintainers may never
figure out.

What really irks me about the thought of leaving this wrong is that we
have spent so much effort lately on establishing a simple rule that when
you set TIF_SIGPENDING it will be acted on.  We did this after a lot of
painful time from a lot of people went into tracking down subtle weird
problems and races.  So, KISS.  Make a rule we can rely on, and then be
damn careful that we don't break the rule.  That's been serving us well,
which is to say preventing it going from two people who can keep track
of what's going with signals on any given day, to zero.  Now that rule
that kept life barely comprehensible is amended with, unless it's
already inside signals code or some nearby arch code, or it's a race,
or, yeah, I think that's all the cases, but check with--well, noone
really knows, so I don't know who you check with, sorry.  You just can't
reason about the code if you don't maintain the invariants.

The "actual" downsides include numerous unknowns, and I always forget
not to be surprised when you aren't scared that we have no idea what-all
the code might actually do.  The easy scenarios to think of off hand
have downsides like loss of timely signal delivery, where something can
chew 15ms of CPU after you killed it.  If I try all day I can come up
with more specific cases and maybe even some with instantly terrible
outcomes.  But I won't think of them all.  The worst ones will come up
much later (or are already dogging someone unwitting now), when someone
else sinks lots of time and effort trying to figure out strange
misbehaviors in their systems.


Thanks,
Roland
