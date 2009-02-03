Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbZBCAWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbZBCAWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbZBCAVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:21:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759765AbZBCAVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:21:41 -0500
Date: Mon, 2 Feb 2009 16:21:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <1233619881.18767.131.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902021617390.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>  <alpine.LFD.2.00.0902021413040.3247@localhost.localdomain>  <200902022333.51017.rjw@sisk.pl>  <200902022356.33094.rjw@sisk.pl> <1233619881.18767.131.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> > * Memory allocations with GFP_KERNEL are made, which is even worse, because
> >   we really shouldn't do that during suspend _at_ _all_, even during the regular
> >   ->suspend() with interrupts on, because there's not guarantee that swap will
> >   will be available at that time.  So, for the sake of correctness, we should
> >   get rid of the GFP_KERNEL from the ACPI code paths executed during
> >   suspend-resume anyway.
> 
> Well, as I said, this is a problem with more than just ACPI and again, I
> don't think the fix is to be done in ACPI itself. The buddy and slab
> should basically stick NOIO or ATOMIC to any allocation done after we
> started suspending the system.

We already do have magic code for things like PF_MEMALLOC (recursion), or 
TIF_MEMDIE (oom) or "(rt_task(p)) && !in_interrupt()" (give RT tasks 
higher priorities) in the page allocator.

Having a special case for NOT_RUNNING wouldn't be _pretty_, but it 
certainly isn't totally unreasonable either.

			Linus
