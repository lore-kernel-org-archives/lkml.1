Return-Path: <linux-kernel-owner+w=401wt.eu-S933986AbZLOW2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986AbZLOW2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761385AbZLOW2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:28:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43281 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760335AbZLOW2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:28:05 -0500
Date: Tue, 15 Dec 2009 17:27:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <alpine.LFD.2.00.0912151337350.14385@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912151719300.4055-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, Linus Torvalds wrote:

> On Tue, 15 Dec 2009, Alan Stern wrote:
> > 
> > Okay.  This obviously implies that if/when cardbus bridges are
> > converted to async suspend/resume, the driver should make sure that the
> > lower-numbered devices wait for their sibling higher-numbered devices
> > to suspend (and vice versa for resume).  Awkward though it may be.
> 
> Yes. However, this is an excellent case where the whole "the device layer 
> does things asynchronously" is really rather awkward.
> 
> For cardbus, the nicest model really would be for the _driver_ to decide 
> to do some things asynchronously, after having done some other things 
> synchronously (to make sure of ordering).

Have you considered the possibility of augmenting the design to allow 
this?  Perhaps reserve a particular return code from the suspend 
routine to mean that asynchronous operations are still underway, so the 
PM core shouldn't automatically do the complete_all().

> So I suspect that we _can_ just do cardbus bridges asynchronously too, but 
> it really needs some care. I suspect to a first approximation we would 
> want to do the easy cases first, and ignore cardbus as being "known to 
> possibly have issues".

Certainly.  Start with the easy things and leave harder devices like 
cardbus bridges for later.

> > > Subtle? Hell yes.
> > 
> > I don't disagree.  However the subtlety lies mainly in the matter of
> > non-obvious dependencies.
> 
> Yes. But we don't necessarily even _know_ those dependencies.

Yep.  Both non-obvious and non-known.

> The Cardbus ones I know about, but really only because I wrote much of 
> that code initially when converting cardbus to look like the PCI bridge it 
> largely is. But how many other cases like that do we have that we have 
> perhaps never even hit, because we've never done anything out of order.
> 
> > The ACPI relations are definitely something to worry about.  It would
> > be a good idea, at an early stage, to add those dependencies
> > explicitly.  I don't know enough about them to say more; perhaps Rafael 
> > does.
> 
> Quite frankly, I would really not want to do ACPI first at all.

Dear me, no!  I wasn't saying ACPI should be made async; I was saying
that ACPI "shadow" devices should be made to wait for their async PCI
counterparts.

> > Indeed.  Perhaps you were too hasty in suggesting that PCI bridges 
> > should be async.
> 
> Oh, yes. I would suggest that first we do _nothing_ async except for 
> within just a single USB tree, and perhaps some individual drivers like 
> the PS/2 keyboard controller (and do even that perhaps only for the PC 
> version, which we know is on the southbridge and not anywhere else).
> 
> If that ends up meaning that we block due to PCI bridges, so be it. I 
> really would prefer baby steps over anything more complete.

Agreed.  I'm not in any hurry.

Alan Stern

