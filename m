Return-Path: <linux-kernel-owner+w=401wt.eu-S2992758AbXBITLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992758AbXBITLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423237AbXBITLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:11:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:62474 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423209AbXBITLB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:11:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Milton Miller <miltonm@bga.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Date: Fri, 9 Feb 2007 20:10:26 +0100
User-Agent: KMail/1.9.5
Cc: cbe-oss-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Carl Love <cel@us.ibm.com>,
       oprofile-list@lists.sourceforge.net
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com> <200702081821.57358.arnd@arndb.de> <890c329e3f6e16e1af5b177d4b3622f5@bga.com>
In-Reply-To: <890c329e3f6e16e1af5b177d4b3622f5@bga.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702092010.27162.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18xuBC8QmqZHwETD+WvxTyL2DCv8fEzUZ0rHq1xXMaTh3Um3/ASRKcfyc0uoTGgzXPYq170DGfV25YqEBkejVyq3eZfJB98nwSlT+IZaA7M9A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 19:47, Milton Miller wrote:
> On Feb 8, 2007, at 11:21 AM, Arnd Bergmann wrote:
> 

> > Doing the translation in two stages in user space, as you
> > suggest here, definitely makes sense to me. I think it
> > can be done a little simpler though:
> >
> > Why would you need the accurate dcookie information to be
> > provided by the kernel? The ELF loader is done in user
> > space, and the kernel only reproduces what it thinks that
> > came up with. If the kernel only gives the dcookie information
> > about the SPU ELF binary to the oprofile user space, then
> > that can easily recreate the same mapping.
> 
> Actually, I was trying to cover issues such as anonymous
> memory.   If the kernel doesn't generate dcookies for
> the load segments the information is not recoverable once
> the task exits.  This would also allow the loader to create
> an artifical elf header that covered both the base executable
> and a dynamicly linked one.
> 
> Other alternatives exist, such as a structure for context-id
> that would have its own identifing magic and an array of elf
> header pointers.

But _why_ do you want to solve that problem? we don't have
dynamically linked binaries and I really don't see why the loader
would want to create artificial elf headers...

> > The kernel still needs to provide the overlay identifiers
> > though.
> 
> Yes, which means it needs to parse the header (or libpse
> be enhanced to write the monitor info to a spufs file).

we thought about this in the past and discarded it because of
the complexity of an spufs interface that would handle this
correctly. 

> > yes, this sounds nice. But tt does not at all help accuracy,
> > only performance, right?
> 
> It allows the user space to know when the sample was taken
> and  be aware of the ambiguity.   If the sample rate is
> high enough in relation to the overlay switch rate, user space
> could decide to discard the ambiguous samples.

yes, good point.

> >> This approach allows multiple objects by its nature.  A new
> >> elf header could be constructed in memory that contained
> >> the union of the elf objects load segments, and the tools
> >> will magically work.   Alternatively the object id could
> >> point to a new structure, identified via a new header, that
> >> it points to other elf headers (easily differentiated by the
> >> elf magic headers).   Other binary formats, including several
> >> objects in a ar archive, could be supported.
> >
> > Yes, that would be a new feature if the kernel passed dcookie
> > information for every section, but I doubt that it is worth
> > it. I have not seen any program that allows loading code
> > from more than one ELF file. In particular, the ELF format
> > on the SPU is currently lacking the relocation mechanisms
> > that you would need for resolving spu-side symbols at load
> > time
> 
> Actually, It could check all load segments, and only report
> those where the dcookie changes (as opposed to the offset).

I'm not really following you here, but probably you misunderstood
my point as well.

> > This seems to incur a run-time overhead on the SPU even if not
> > profiling, I would consider that not acceptable.
> 
> It definitely is overhead.  Which means it would have to be
> optional, like gprof.

There is some work going on for another profiler independent
of the hardware feature that only relies on instrumenting the
spu executable for things like DMA transfers and overlay
changes. 

	Arnd <><
