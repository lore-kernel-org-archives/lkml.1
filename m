Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbXEYFXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbXEYFXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbXEYFXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:23:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51153 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758109AbXEYFXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:23:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org>
	<46470209.9000502@bellsouth.net> <46470515.50000@NineX.eu.org>
	<464707F7.6080600@bellsouth.net>
	<m1irawpwy2.fsf@ebiederm.dsl.xmission.com>
	<20070513204407.7ba35010@osprey.hogchain.net>
	<4647FA38.3090108@NineX.eu.org> <46480EA5.40400@NineX.eu.org>
	<20070514053406.478bf93f@osprey.hogchain.net>
	<m1d513oddj.fsf@ebiederm.dsl.xmission.com>
	<20070514093829.377e04bc@osprey.hogchain.net>
	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	<20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<20070524213157.1d39458f.akpm@linux-foundation.org>
Date: Thu, 24 May 2007 23:20:51 -0600
In-Reply-To: <20070524213157.1d39458f.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 24 May 2007 21:31:57 -0700")
Message-ID: <m1myztcwcs.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 24 May 2007 22:19:09 -0600 ebiederm@xmission.com (Eric W. Biederman)
> wrote:
>
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
> Yup.
>
> Do we have a feel for how much performace we're losing on those 
> systems which _could_ do MSI, but which will end up defaulting
> to not using it?

I don't have any good numbers, although it is enough that you can
measure the difference.  I think Roland Drier and the other IB
guys have actually made the measurements.  For low-end hardware
I expect the performance difference is currently in the noise.

However because MSI irqs are not shared a lot of things are
simplified.  In particular it means that you should be able to have an
irq fastpath that does not read the hardware at all, and hardware
register reads can be comparatively very slow.

Further because all MSI irq are not shared and edge triggered we don't
have a danger of screaming irqs or drivers not handling a shared
irq properly.

The big performance win is most likely to be for fast I/O devices
where the multiple IRQs per card will allow the irqs for different
flows of data to be directed to different cpus.

So for the short term I don't think there is much downside in having
MSI disabled.  For the long term I think MSI will be quite useful.

Further my gut feel is that my two patches together will enable MSI on
most of the x86 chipsets where it currently works.  Because most
chipsets are either from Intel or are hypertransport based.

Eric
