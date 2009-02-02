Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbZBBU4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbZBBU4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZBBU4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:56:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbZBBU4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:56:21 -0500
Date: Mon, 2 Feb 2009 12:55:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Schwab <schwab@suse.de>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902021251130.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>  <1233568479.18767.86.camel@pasglop>  <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain> <1233606805.18767.97.camel@pasglop> <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Feb 2009, Linus Torvalds wrote:
> 
> I suspect that we could possibly make ACPI happy by actually leaving 
> interrupts "enabled" in the suspend-late (and early-resume) paths, but 
> with all hardware interrupts actually turned off. But that's really just a 
> "let's fool people by turning off interrupts a different way" thing - it 
> in no way really changes any fundamental issues.

Btw, I do think that we can make ACPI happy regardless.

We quite commonly call into ACPI during the early boot sequence, when 
interrupts are disabled for all the same reasons. We don't get the 
"might_sleep()" warnings, simply because we have these kinds of checks:

	..
        if ((!in_atomic() && !irqs_disabled()) ||
                    system_state != SYSTEM_RUNNING || oops_in_progress)
		return;
	..

ie we know that "system_state != SYSTEM_RUNNING" is a special case where 
things are allowed to do things that they aren't normally allowed to do.

I suspect that late-suspend/early-resume is just exactly the same. It's a 
boot, after all. Just let ACPI do its odd things, despite the fact that 
interrupts are disabled. The fact that doing them while the system is 
_running_ is invalid doesn't necessarily mean that it is invalid under 
bootup or suspend/resume.

We might even make it possible to have timers going, if we end up saying 
"we'll mask all hardware interrupts _except_ for the timer". I'm not sure 
that is necessarily something we can do portably, though..

			Linus
