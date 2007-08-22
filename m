Return-Path: <linux-kernel-owner+w=401wt.eu-S934015AbXHVVLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015AbXHVVLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbXHVVLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:11:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:40583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638AbXHVVLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:11:01 -0400
Date: Thu, 23 Aug 2007 00:04:51 +0200
From: Andi Kleen <ak@suse.de>
To: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070822220451.GJ8058@bingen.suse.de>
References: <46CBC842.4070100@vmware.com> <20070822102217.GE2642@bingen.suse.de> <46CC68D9.5060200@vmware.com> <20070822175918.GB8058@bingen.suse.de> <46CC6D63.2010204@vmware.com> <20070822194632.GD8058@bingen.suse.de> <46CC9FF2.3040406@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CC9FF2.3040406@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> No, you can't ignore it.  The page protections won't change between the 
> GP and the decoder execution, but the instruction can, causing you to 
> decode into the next page where the processor would not have.  !P 
> becomes obvious, but failure to respect NX or U/S is an exploitable 
> bug.  Put a 1 byte instruction at the end of a page crossing into a NX 
> (or supervisor page).  Remotely, change keep switching between the 
> instruction and a segment override.

Then you do this check only if the instruction crosses a page.
That is very cheap to test.

> Result: user executes instruction on supervisor code page, learning data 
> as a result of this; code on NX page gets executed.

Most systems probably have gaps between user and supervisor
(like Linux), but ok.

> We already have drivers for all of our hardware in Linux.  Most of the 
> hardware we emulate is physical hardware, and there are no virtual 
> drivers for it.  Should we take the BusLogic driver and "paravirtualize" 
> it by adding VMI hypercalls? 

You're proposing instead to paravirtualize all drivers, even if 99.99%
of those will never ever have a driver model.

> We might benefit from it, but would the 
> BusLogic driver?  It sets a nasty precedent for maintenance as different 
> hypervisors and emulators hack up different drivers for their own 
> performance.

I still think it's preferable to change some drivers than everybody.

AFAIK BusLogic as real hardware is pretty much dead anyways,
so you're probably the only primary user of it anyways.
Go wild on it!

If you worry about it do your own drivers like the other hypervisors.
I still suspect you could go faster if you use a paravirtualy
optimized driver, but and I'm not going to speculate on the 
reasons why you don't want to do that.


> Our SCSI and IDE emulation and thus the drivers used by Linux are pretty 
> much fixed in stone; we are not going to go about changing a tricky 
> hardware interface to a virtual one, it is simply too risky for 

You wouldn't need to change it; just add a very simple new one
(e.g. the lguest interface is nearly trivial) 

> There is great advantage in talking to our existing device layer faster, 
> and this is something that is valuable today.

Well that might be. I just think it would be a mistake
to design paravirt_ops based on someone's short term release engineering
considerations.

> 
> >Really LinuxHAL^wparavirt ops is already so complicated that
> >any new hooks need an extremly good justification and that is
> >just not here for this.
> >
> >We can add it if you find an equivalent number of hooks
> >to eliminate.
> >  
> 
> Interesting trade.  What if I sanitized the whole I/O messy macros into 
> something fun and friendly:

That would be a cool project anyways. e.g. just moving 
the NUMAQ support separately would clean it up. But probably not enough
on its own, sorry.

But you'll need separate interfaces anyways if you want to
go down the BusLogic change path. That could well be coupled
with a cleanup.

> We might even be able to get rid of the umpteen different 
> places where drivers wrap iospace access with their own byte / word / 
> long functions so they can switch between port I/O and memory mapped I/O 
> by moving it all into common infrastructure.

I thought we had that already?  But can't find it now :/

> 
> We could make similar (unwelcome?) advances on the pte functions if it 
> were not for the regrettable disconnect between pte_high / pte_low and 
> the rest.  Perhaps if it was hidden in macros?

You want to do what exactly? 

If you mean PAE and non PAE In the same binary: that would likely
need abstracted page tables first.

-Andi

