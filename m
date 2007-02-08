Return-Path: <linux-kernel-owner+w=401wt.eu-S1423236AbXBHRWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423236AbXBHRWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 12:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423239AbXBHRWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 12:22:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:51169 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965737AbXBHRWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 12:22:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Date: Thu, 8 Feb 2007 18:21:56 +0100
User-Agent: KMail/1.9.5
Cc: Milton Miller <miltonm@bga.com>, Carl Love <cel@us.ibm.com>,
       linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com> <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com> <b682962303654f4958a6c2c50d805907@bga.com>
In-Reply-To: <b682962303654f4958a6c2c50d805907@bga.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702081821.57358.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18ZHEUVfJX3UPX/LW//5WINfZ/dXRIA3yfkpi+q6ZJ3lJV32yi+kmzQIfSBXdIT4VRTMsM/Euj/m0cipLxgaRDRNkJhHFJI0+iTujjb2K0LiQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 February 2007 15:18, Milton Miller wrote:

> 1) sample rate setup
> 
>     In the current patch, the user specifies a sample rate as a time 
> interval.
>     The kernel is (a) calling cpufreq to get the current cpu frequency, 
> (b)
>     converting the rate to a cycle count, (c) converting this to a 24 bit
>     LFSR count, an iterative algorithm (in this patch, starting from
>     one of 256 values so a max of 2^16 or 64k iterations), (d) 
> calculating
>     an trace unload interval.   In addition, a cpufreq notifier is 
> registered
>     to recalculate on frequency changes.
> 
>     The obvious problem is step (c), running a loop potentially 64 
> thousand
>     times in kernel space will have a noticeable impact on other threads.
> 
>     I propose instead that user space perform the above 4 steps, and 
> provide
>     the kernel with two inputs: (1) the value to load in the LFSR and (2)
>     the periodic frequency / time interval at which to empty the hardware
>     trace buffer, perform sample analysis, and send the data to the 
> oprofile
>     subsystem.
> 
>     There should be no security issues with this approach.   If the LFSR 
> value
>     is calculated incorrectly, either it will be too short, causing the 
> trace
>     array to overfill and data to be dropped, or it will be too long, and
>     there will be fewer samples.   Likewise, the kernel periodic poll 
> can be
>     too long, again causing overflow, or too frequent, causing only timer
>     execution overhead.
> 
>     Various data is collected by the kernel while processing the 
> periodic timer,
>     this approach would also allow the profiling tools to control the
>     frequency of this collection.   More frequent collection results in 
> more
>     accurate sample data, with the linear cost of poll execution 
> overhead.
> 
>     Frequency changes can be handled either by the profile code setting
>     collection at a higher than necessary rate, or by interacting with 
> the
>     governor to limit the speeds.
> 
>     Optionally, the kernel can add a record indicating that some data was
>     likely dropped if it is able to read all 256 entries without 
> underflowing
>     the array.  This can be used as hint to user space that the kernel 
> time
>     was too long for the collection rate.

Moving the sample rate computation to user space sounds like the right
idea, but why not have a more drastic version of it:

Right now, all products that support this feature run at the same clock
rate (3.2 Ghz), with cpufreq, we can reduce this to 1.6 Ghz. If I understand
this correctly, the value depends only on the frequency, so we could simply
hardcode this in the kernel, and print out a warning message if we ever
encounter a different frequency, right?

> The current patch specifically identifies that only single
> elf objects are handled.  There is no code to handle dynamic
> linked libraries or overlays.   Nor is there any method to
> present samples that may have been collected during context
> switch processing, they must be discarded.

I thought it already did handle overlays, what did I miss here?

> My proposal is to change what is presented to user space.  Instead
> of trying to translate the SPU address to the backing file
> as the samples are recorded, store the samples as the SPU
> context and address.  The context switch would record tid,
> pid, object id as it does now.   In addition, if this is a
> new object-id, the kernel would read elf headers as it does
> today.  However, it would then proceed to provide accurate
> dcookie information for each loader region and overlay.

Doing the translation in two stages in user space, as you
suggest here, definitely makes sense to me. I think it
can be done a little simpler though:

Why would you need the accurate dcookie information to be
provided by the kernel? The ELF loader is done in user
space, and the kernel only reproduces what it thinks that
came up with. If the kernel only gives the dcookie information
about the SPU ELF binary to the oprofile user space, then
that can easily recreate the same mapping.

The kernel still needs to provide the overlay identifiers
though.

> To identify which overlays are active, (instead of the present
> read on use and search the list to translate approach) the
> kernel would record the location of the overlay identifiers
> as it parsed the kernel, but would then read the identification
> word and would record the present value as an sample from
> a separate but related stream.   The kernel could maintain
> the last value for each overlay and only send profile events
> for the deltas.

right.

> This approach trades translation lookup overhead for each
> recorded sample for a burst of data on new context activation.
> In addition it exposes the sample point of the overlay identifier
> vs the address collection.  This allows the ambiguity to be
> exposed to user space.   In addition, with the above proposed
> kernel timer vs sample collection, user space could limit the
> elapsed time between the address collection and the overlay
> id check.

yes, this sounds nice. But tt does not at all help accuracy,
only performance, right?
 
> This approach allows multiple objects by its nature.  A new
> elf header could be constructed in memory that contained
> the union of the elf objects load segments, and the tools
> will magically work.   Alternatively the object id could
> point to a new structure, identified via a new header, that
> it points to other elf headers (easily differentiated by the
> elf magic headers).   Other binary formats, including several
> objects in a ar archive, could be supported.

Yes, that would be a new feature if the kernel passed dcookie
information for every section, but I doubt that it is worth
it. I have not seen any program that allows loading code
from more than one ELF file. In particular, the ELF format
on the SPU is currently lacking the relocation mechanisms
that you would need for resolving spu-side symbols at load
time.
 
> If better overlay identification is required, in theory the
> overlay switch code could be augmented to record the switches
> (DMA reference time from the PowerPC memory and record a
> relative decrementer in the SPU), this is obviously a future
> item.  But it is facilitated by having user space resolve the
> SPU to source file translation.

This seems to incur a run-time overhead on the SPU even if not
profiling, I would consider that not acceptable.

	Arnd <><
