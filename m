Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbXEYF65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbXEYF65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXEYF6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:58:49 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56340 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbXEYF6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:58:49 -0400
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
References: <20070514093829.377e04bc@osprey.hogchain.net>
	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	<20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<20070525052032.GB9386@suse.de>
Date: Thu, 24 May 2007 23:57:13 -0600
In-Reply-To: <20070525052032.GB9386@suse.de> (Greg KH's message of "Thu, 24
	May 2007 22:20:32 -0700")
Message-ID: <m1fy5lcuo6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Thu, May 24, 2007 at 10:19:09PM -0600, Eric W. Biederman wrote:
>> 
>> Currently we blacklist known bad msi configurations which means we
>> keep getting MSI enabled on chipsets that either do not support MSI,
>> or MSI is implemented improperly.  Since the normal IRQ routing
>> mechanism seems to works even when MSI does not, this is a bad default
>> and causes non-functioning systems for no good reason.
>> 
>> So this patch inverts the sense of the MSI bus flag to only enable
>> MSI on known good systems.  I am seeding that list with the set of
>> chipsets with an enabled hypertransport MSI mapping capability.  Which
>> is as close as I can come to an generic MSI enable.  So for actually
>> using MSI this patch is a regression, but for just having MSI enabled
>> in the kernel by default things should just work with this patch
>> applied.
>> 
>> People can still enable MSI on a per bus level for testing by writing
>> to sysfs so discovering chipsets that actually work (assuming we are
>> using modular drivers) should be pretty straight forward.
>
> Originally I would have thought this would be a good idea, but now that
> Vista is out, which supports MSI, I don't think we are going to need
> this in the future.  All new chipsets should support MSI fine and this
> table will only grow in the future, while the blacklist should not need
> to have many new entries added to it.
>
> So I don't think this is a good idea, sorry.

For me seeing is believing.  I don't see that yet.

What I see is myself pointed at a growing pile of bug reports
of chipsets where MSI does not work.

What I see is a steadily growing black list that looks like it should
include every non-Intel x86 pci-express chipset.  Despite the fact
the fact it requires skill to show a chipset does not support MSI
properly, and to generate the patch, and that MSI I/O devices are
still fairly rare.

Meanwhile I have written in a day something that does the nearly
the equivalent of our current black list.  A white list looks
much easier to maintain.

Further if we want to invert the list for a given vendor that we trust
I don't think it would be hard to write an inverse quirk that enables
MSI on chipsets that are new enough for some version of new enough.
In particular it probably makes sense to do that for Intel pci-express
chipsets.


In part I have a problem with the current black list because a number
of the entries appear to be flat out hacks.

When you add to this the fact that MSI can be implemented on simple
pci devices and those pci devices can potentially be plugged into old
machines.  (Say someone buys a new pci cards as an upgrade).  I
don't see how we can successfully setup a black list of every
historical chipset that supports pci.

Further there are a number of outstanding bugs that are there
simply because msi is currently enabled by default on chipsets
that don't support it.


So I see the current situation as a maintenance disaster.  People are
not stepping up to the plate fast enough to grow the black list to the
set of chipsets and motherboards that don't implement MSI, don't
implement MSI correctly, or only sometimes implement MSI correctly.

So Greg if you want to volunteer to comb through all of the existing
pci express chipsets and figure out what is needed to test to see
if the are setup correctly and to black list them if they are not
setup correctly, and to unconditionally black list them if we don't
support MSI more power to you.

Right now I want code that works, and this is the best path I can
see to that.

Eric
