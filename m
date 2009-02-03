Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZBCAox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZBCAox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZBCAoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:44:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbZBCAoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:44:44 -0500
Date: Mon, 2 Feb 2009 16:44:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <1233620590.18767.138.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902021635240.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>  <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>  <1233614927.18767.121.camel@pasglop>  <200902030000.18049.rjw@sisk.pl> <1233620590.18767.138.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> IE, you should have something to ensure, before you turn interrupts off,
> that nobody else is inside the AML interpreter. You already know there
> are no other CPUs, so it's just a matter of making sure no other process
> has scheduled while holding that mutex.
> 
> The easy way to do that is to do something like taking the mutex
> yourself and then setting a flag so that the intepreter stops trying to
> take it or release it itself, maybe just using the global system state.
> 
> Then release the mutex on resume.

Why do you think this improves on anything?

Basically, it turns the mutex into a non-entity - but if your whole 
argument is that it might as well be a non-entity because nobody else can 
take it anyway, then why not just leave it around?

IOW, if your argument boils down to "there can be no contention", then you 
might as well say "just use the mutex, it will never block".

So the only thing you really need is to just disable the _debugging_ code 
that mutexes have (if they get built with debugging in the first place). 

I can't find the bothersome code anyway: I do find

	DEBUG_LOCKS_WARN_ON(in_interrupt());

but that's just saying that you shouldn't be using mutexes from 
interrupts, not from irq-off segments. There's probably something I'm 
missing, like the preempt_check_resched() causing a schedule event with 
irq's disabled, and the "might_sleep()" thing. But the latter should 
already be disabled by the "system_state != SYSTEM_RUNNING" thing.

Oh, except we don't seem to have a SYSTEM_SUSPEND thing. Is that what 
people are complaining about?

Just do

	system_state = SYSTEM_SUSPEND;
	..
	system_state = SYSTEM_RUNNING;

around the irqs-off section in suspending if so.

			Linus
