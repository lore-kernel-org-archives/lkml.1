Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbZBBVkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbZBBVkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758588AbZBBVjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:39:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35232 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877AbZBBVjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:39:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Mon, 2 Feb 2009 22:39:01 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain> <alpine.LFD.2.00.0902021251130.3247@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902021251130.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902022239.02453.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Linus Torvalds wrote:
> 
> On Mon, 2 Feb 2009, Linus Torvalds wrote:
> > 
> > I suspect that we could possibly make ACPI happy by actually leaving 
> > interrupts "enabled" in the suspend-late (and early-resume) paths, but 
> > with all hardware interrupts actually turned off. But that's really just a 
> > "let's fool people by turning off interrupts a different way" thing - it 
> > in no way really changes any fundamental issues.
> 
> Btw, I do think that we can make ACPI happy regardless.
> 
> We quite commonly call into ACPI during the early boot sequence, when 
> interrupts are disabled for all the same reasons. We don't get the 
> "might_sleep()" warnings, simply because we have these kinds of checks:
> 
> 	..
>         if ((!in_atomic() && !irqs_disabled()) ||
>                     system_state != SYSTEM_RUNNING || oops_in_progress)
> 		return;
> 	..
> 
> ie we know that "system_state != SYSTEM_RUNNING" is a special case where 
> things are allowed to do things that they aren't normally allowed to do.

Yes, which is why I thought it might be a good idea to make the AML interpreter
allow is to execute AML with interrupts off, so that we can put devices into
low power states and/or put them into D0 with interrupts off.

Then, we'll be able to make ACPI happy (up to some strange ordering
expectations of some insane BIOSes maybe) and fix the interrupts issue at
the same time.

The idea would be to have a special code path(s) where AML can be executed
with interrupts off and a couple of special entry points into the AML
interpreter for this purpose.

Thanks,
Rafael
