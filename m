Return-Path: <linux-kernel-owner+w=401wt.eu-S1946659AbXBISrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946659AbXBISrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 13:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946770AbXBISrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 13:47:52 -0500
Received: from mercury.realtime.net ([205.238.132.86]:33309 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946659AbXBISrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 13:47:51 -0500
In-Reply-To: <200702081821.57358.arnd@arndb.de>
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com> <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com> <b682962303654f4958a6c2c50d805907@bga.com> <200702081821.57358.arnd@arndb.de>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <890c329e3f6e16e1af5b177d4b3622f5@bga.com>
Content-Transfer-Encoding: 7bit
Cc: cbe-oss-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Carl Love <cel@us.ibm.com>,
       oprofile-list@lists.sourceforge.net
From: Milton Miller <miltonm@bga.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Date: Fri, 9 Feb 2007 12:47:33 -0600
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8, 2007, at 11:21 AM, Arnd Bergmann wrote:

> On Thursday 08 February 2007 15:18, Milton Miller wrote:
>
>> The current patch specifically identifies that only single
>> elf objects are handled.  There is no code to handle dynamic
>> linked libraries or overlays.   Nor is there any method to
>> present samples that may have been collected during context
>> switch processing, they must be discarded.
>
> I thought it already did handle overlays, what did I miss here?

It does, see my reply to Maynard.  Not sure what I was thinking
when I wrote this, possibly I was thinking of the inaccuracies.

>
>> My proposal is to change what is presented to user space.  Instead
>> of trying to translate the SPU address to the backing file
>> as the samples are recorded, store the samples as the SPU
>> context and address.  The context switch would record tid,
>> pid, object id as it does now.   In addition, if this is a
>> new object-id, the kernel would read elf headers as it does
>> today.  However, it would then proceed to provide accurate
>> dcookie information for each loader region and overlay.
>
> Doing the translation in two stages in user space, as you
> suggest here, definitely makes sense to me. I think it
> can be done a little simpler though:
>
> Why would you need the accurate dcookie information to be
> provided by the kernel? The ELF loader is done in user
> space, and the kernel only reproduces what it thinks that
> came up with. If the kernel only gives the dcookie information
> about the SPU ELF binary to the oprofile user space, then
> that can easily recreate the same mapping.

Actually, I was trying to cover issues such as anonymous
memory.   If the kernel doesn't generate dcookies for
the load segments the information is not recoverable once
the task exits.  This would also allow the loader to create
an artifical elf header that covered both the base executable
and a dynamicly linked one.

Other alternatives exist, such as a structure for context-id
that would have its own identifing magic and an array of elf
header pointers.


>
> The kernel still needs to provide the overlay identifiers
> though.

Yes, which means it needs to parse the header (or libpse
be enhanced to write the monitor info to a spufs file).

>
>> To identify which overlays are active, (instead of the present
>> read on use and search the list to translate approach) the
>> kernel would record the location of the overlay identifiers
>> as it parsed the kernel, but would then read the identification
>> word and would record the present value as an sample from
>> a separate but related stream.   The kernel could maintain
>> the last value for each overlay and only send profile events
>> for the deltas.
>
> right.
>
>> This approach trades translation lookup overhead for each
>> recorded sample for a burst of data on new context activation.
>> In addition it exposes the sample point of the overlay identifier
>> vs the address collection.  This allows the ambiguity to be
>> exposed to user space.   In addition, with the above proposed
>> kernel timer vs sample collection, user space could limit the
>> elapsed time between the address collection and the overlay
>> id check.
>
> yes, this sounds nice. But tt does not at all help accuracy,
> only performance, right?

It allows the user space to know when the sample was taken
and  be aware of the ambiguity.   If the sample rate is
high enough in relation to the overlay switch rate, user space
could decide to discard the ambiguous samples.

>
>> This approach allows multiple objects by its nature.  A new
>> elf header could be constructed in memory that contained
>> the union of the elf objects load segments, and the tools
>> will magically work.   Alternatively the object id could
>> point to a new structure, identified via a new header, that
>> it points to other elf headers (easily differentiated by the
>> elf magic headers).   Other binary formats, including several
>> objects in a ar archive, could be supported.
>
> Yes, that would be a new feature if the kernel passed dcookie
> information for every section, but I doubt that it is worth
> it. I have not seen any program that allows loading code
> from more than one ELF file. In particular, the ELF format
> on the SPU is currently lacking the relocation mechanisms
> that you would need for resolving spu-side symbols at load
> time

Actually, It could check all load segments, and only report
those where the dcookie changes (as opposed to the offset).

> .
>
>> If better overlay identification is required, in theory the
>> overlay switch code could be augmented to record the switches
>> (DMA reference time from the PowerPC memory and record a
>> relative decrementer in the SPU), this is obviously a future
>> item.  But it is facilitated by having user space resolve the
>> SPU to source file translation.
>
> This seems to incur a run-time overhead on the SPU even if not
> profiling, I would consider that not acceptable.

It definitely is overhead.  Which means it would have to be
optional, like gprof.


milton

