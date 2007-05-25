Return-Path: <linux-kernel-owner+w=401wt.eu-S1764475AbXEYVJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764475AbXEYVJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765616AbXEYVIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:08:52 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46704 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765137AbXEYVIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:08:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
References: <20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<20070525052032.GB9386@suse.de>
	<m1myztaq5s.fsf@ebiederm.dsl.xmission.com>
	<20070525203501.GD5413@suse.de>
Date: Fri, 25 May 2007 15:06:22 -0600
In-Reply-To: <20070525203501.GD5413@suse.de> (Greg KH's message of "Fri, 25
	May 2007 13:35:01 -0700")
Message-ID: <m1k5uwaa0h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:
>> MSI appears to have enough problems that enabling it in a kernel
>> that is supposed to run lots of different hardware (like a distro
>> kernel) is a recipe for disaster.
>
> Oh, I agree it's a major pain in the ass at times...
>
> But I'm real hesitant to change things this way.  We'll get reports of
> people who used to have MSI working, and now it will not (like all AMD
> chipsets).  That's a regression...

You saw my quirk that enabled MSI if you happen to have a
hypertransport msi mapping capability.  That should take care of
all hypertransport compliant AMD chipsets.

So at least 90% of what we have now should work.

> Perhaps we can trigger off of the same flag that Vista uses like Andi
> suggested?  That's one way to "know" that the hardware works, right?

A little.  It is redefining the problem as squarely a BIOS writers
problem and possibly we want to do that in the presence of pci-express.

> For non-x86 arches, they all seem to want to always enable MSI as they
> don't have to deal with as many broken chipsets, if any at all.  So for
> them, we'd have to just whitelist the whole arch.  Does that really make
> sense?

Non-x86 (unless I'm confused) already has white lists or some
equivalent because they can't use generic code for configuring MSI
because non-x86 does not have a standard MSI target window with a
standard meaning for the bits.  So non-x86 has it's own set of arch
specific mechanisms to handle this, and they just don't want generic
code getting in the way.

So it may makes sense make the default all to be x86 specific.

> And again, over time, like years, this list is going to grow way beyond
> a managable thing, especially as any new chipset that comes out in 2009
> is going to have working MSI, right?

I haven't a clue.  I know we are in we are in the teething pain stage
now which just generally makes things difficult.

> I think our blacklist is easier to
> manage over time, while causing a problem for some users in trying to
> determine their broken hardware that they currently have.

Possibly.  It just doesn't seem straight forward to add something
safely to our blacklist.

> It's a trade off, and I'd like to choose the one that over the long
> term, causes the least ammount of work and maintaiblity.  I think the
> current blacklist meets that goal.

A reasonable goal.  I will come back to this after the long holiday
weekend here and see what makes sense.

I think for most of Intel I can reduce my test to:
If (bus == 0 , device == 0, function == 0 && vendor == Intel &&
    has a pci express capability) {
	Enable msi on all busses().
}

At which point I don't think we will need to do much maintenance.

Eric

