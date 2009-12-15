Return-Path: <linux-kernel-owner+w=401wt.eu-S934001AbZLOWQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001AbZLOWQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbZLOWQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:16:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761359AbZLOWQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:38 -0500
Date: Tue, 15 Dec 2009 13:54:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <Pine.LNX.4.44L0.0912151444010.2643-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912151337350.14385@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912151444010.2643-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Dec 2009, Alan Stern wrote:
> 
> Okay.  This obviously implies that if/when cardbus bridges are
> converted to async suspend/resume, the driver should make sure that the
> lower-numbered devices wait for their sibling higher-numbered devices
> to suspend (and vice versa for resume).  Awkward though it may be.

Yes. However, this is an excellent case where the whole "the device layer 
does things asynchronously" is really rather awkward.

For cardbus, the nicest model really would be for the _driver_ to decide 
to do some things asynchronously, after having done some other things 
synchronously (to make sure of ordering).

That said, I think we are ok for at least Yenta resume, because the really 
ordering-critical stuff we tend to do at "resume_early", which wouldn't be 
asynchronous anyway.

But for an idea of what I'm talking about, look at the o2micro stuff in 
drivers/pcmcia/o2micro.h, and notice how it does certain things only for 
the "PCI_FUNC(..devfn) == 0" case.

So I suspect that we _can_ just do cardbus bridges asynchronously too, but 
it really needs some care. I suspect to a first approximation we would 
want to do the easy cases first, and ignore cardbus as being "known to 
possibly have issues".

> > Subtle? Hell yes.
> 
> I don't disagree.  However the subtlety lies mainly in the matter of
> non-obvious dependencies.

Yes. But we don't necessarily even _know_ those dependencies.

The Cardbus ones I know about, but really only because I wrote much of 
that code initially when converting cardbus to look like the PCI bridge it 
largely is. But how many other cases like that do we have that we have 
perhaps never even hit, because we've never done anything out of order.

> The ACPI relations are definitely something to worry about.  It would
> be a good idea, at an early stage, to add those dependencies
> explicitly.  I don't know enough about them to say more; perhaps Rafael 
> does.

Quite frankly, I would really not want to do ACPI first at all.

We already handle batteries specially, but any random system device? Don't 
touch it, is my suggestion. There is just too many ways it can fail. Don't 
tell me that things "should work" - we know for a fact that BIOS tables 
almost always have every single bug they could possibly have).

> > And PCIE bridges? Should be safe these days, but it wasn't quite as 
> > obvious, because a PCIE bridge actually has a driver unlike a regular 
> > plain PCI-PCI bridge.
> > 
> > Subtle, subtle.
> 
> Indeed.  Perhaps you were too hasty in suggesting that PCI bridges 
> should be async.

Oh, yes. I would suggest that first we do _nothing_ async except for 
within just a single USB tree, and perhaps some individual drivers like 
the PS/2 keyboard controller (and do even that perhaps only for the PC 
version, which we know is on the southbridge and not anywhere else).

If that ends up meaning that we block due to PCI bridges, so be it. I 
really would prefer baby steps over anything more complete.


			Linus
