Return-Path: <linux-kernel-owner+w=401wt.eu-S1423063AbXBHPCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423063AbXBHPCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423048AbXBHPCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:02:31 -0500
Received: from mercury.realtime.net ([205.238.132.86]:46074 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423063AbXBHPCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:02:30 -0500
X-Greylist: delayed 2410 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 10:02:30 EST
In-Reply-To: <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com>
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com> <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <b682962303654f4958a6c2c50d805907@bga.com>
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, oprofile-list@lists.sourceforge.net
From: Milton Miller <miltonm@bga.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Date: Thu, 8 Feb 2007 08:18:35 -0600
To: Carl Love <cel@us.ibm.com>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 6, 2007, at 5:02 PM, Carl Love wrote:

> This is the first update to the patch previously posted by Maynard
> Johnson as "PATCH 4/4. Add support to OProfile for profiling CELL".
>
> This repost fixes the line wrap issue that Ben mentioned.  Also the 
> kref
> handling for the cached info has been fixed and simplified.
>
> There are still a few items from the comments being discussed
> specifically how to profile the dynamic code for the SPFS context 
> switch
> code and how to deal with dynamic code stubs for library support.  Our
> proposal is to assign the samples from the SPFS and dynamic library 
> code
> to an anonymous sample bucket.  The support for properly handling the
> symbol extraction in these cases would be deferred to a later SDK.
>
> There is also a bug in profiling overlay code that we are 
> investigating.

I'd like to talk about about both some of the concepts, including what
is logged and what the kernel API is, and provide some directed comments
on the code in the patch as it stands.

[Ok, the background and concepts portion is big enough, I'll send
this to the several lists for comment, and the code comments to
just cbe-oss-dev]

First, I'll give some background and my understanding of both the
hardware, and some of the linux interface.  I'm not consulting any
manuals, so I could be mistaken.   I'm basing this on a combination
of past reading of the kernel, this patch, a discussion with Arnd,
and my knowledge of the PowerPC processor and other IBM processors.
Hopefully this will be of use to other reviewers.

Background:

The cell broadband architecture consists of PowerPC processors
and synergistic processing units, or SPUs.  The current chip has
a multi-threaded PowerPC core and 8 SPUs.   Each SPU has an
execution core (running its own instruction set), a 256kB
private memory (local store), and DMA engine that can access
the coherent memory domain of the PowerPC processor(s).  Multiple
chips can be connected together in a single coherent SMP system.
The addresses provided to the DMA engine are effective, translated
through virtual to real address spaces like the PowerPC MMU.
The SPUs are intended to run application threads, and require
the PowerPC to perform exception handling and other operating
system tasks.

Because of the limited address space of the SPU (18
bits), the compilers (gcc) have support for code
overlays.  The ELF format defines these overlays
including file offsets, sizes, load address, and
a unique word to identify the overlay.  The toolchain
has support to check that an overlay is present and
setup the DMA engine to load it if it is not present.

In Linux, the SPUs are controlled through spufs.  Once
a SPU context is created, the local store and registers can be
modified through the file system.  A linux thread makes
a syscall requesting the context to run.  This call is
blocking to that thread; it waits for an event from the
SPU (either an exception or a reschedule). In this regard
the syscall can be thought of as a cross instruction set
function call.  The contents of the local store are
initialized and modified via read/write or mmap and memcopy
of a spufs file. Specifically, pages are not mapped into the
local store, they are copied into it.  The SPU context is
tied to the creating mm; this provides a clear context for
the DMA engine (controlled by the program in the SPU).

To assist with the use of the SPUs, and to provide some
portability to other environments, a library, libpse, is
available and widely used.   Among other items, it provides
an elf loader for SPU elf objects.  Applications may mmap
external objects or embed the elf objects into their
executable (as data).  The contained objects copied to the
SPU local store as dictated by the elf header.   To assist
other tools, spufs provides an object-id file.   Before this
patch, it has been treated as an opaque number. Although not
present in the first release of libpse, current versions write
the virtual address of the elf header to this file
when the loader is called.

This patch is trying to enable oprofile to collect and
analyze SPU execution, using the trace collection
hardware of the processor.   The trace collection hardware
consists of a LFSR (linear-feedback shift register) counter
and an array 256 bits wide and 256 entries deep.  When the
counter matches the programed value, it causes an entry
to be written to the trace array and the counter to be
reloaded.  On chip logic tracks how many entries have
been written and not yet read.  When programed to trace
the SPUs, the trace entry consists of the upper 16 bits of
the 18 bit program counter for each SPU; the 8 SPUs split
over the two words.  By their nature, LFSRs require a minimum
of hardware (typically 3 exclusive-or gates and a shift
register), but the count sequence is pseudo-random.

The oprofile system is designed to collect a stream of trace
data and context information to and provide it to user space
for post processing and analysis.   While at the lowest level
the data is a stream of words, the kernel and user space tools
agree on a protocol that provides meaning to the words by
prefixing stream elements with escape sequences to pass
infrequent context to interpret the trace data.

For most streams today, the kernel translates a hardware
collected address through the mm struct and vma list to
the backing file and offset in that file.  A given file
is hashed to a word by providing a "dcookie" that maps
through the dcache to a given file and path.  The user
space tool that collects the data from the kernel trace
buffer queries the kernel and translates the stream back to
files in the file system and offsets into those files.   The
user space analysis tools can then take that information
and display the file name, instructions, and symbolic
debug information that may be contained in the typical
elf executable or other binary format.


1) sample rate setup

    In the current patch, the user specifies a sample rate as a time 
interval.
    The kernel is (a) calling cpufreq to get the current cpu frequency, 
(b)
    converting the rate to a cycle count, (c) converting this to a 24 bit
    LFSR count, an iterative algorithm (in this patch, starting from
    one of 256 values so a max of 2^16 or 64k iterations), (d) 
calculating
    an trace unload interval.   In addition, a cpufreq notifier is 
registered
    to recalculate on frequency changes.

    The obvious problem is step (c), running a loop potentially 64 
thousand
    times in kernel space will have a noticeable impact on other threads.

    I propose instead that user space perform the above 4 steps, and 
provide
    the kernel with two inputs: (1) the value to load in the LFSR and (2)
    the periodic frequency / time interval at which to empty the hardware
    trace buffer, perform sample analysis, and send the data to the 
oprofile
    subsystem.

    There should be no security issues with this approach.   If the LFSR 
value
    is calculated incorrectly, either it will be too short, causing the 
trace
    array to overfill and data to be dropped, or it will be too long, and
    there will be fewer samples.   Likewise, the kernel periodic poll 
can be
    too long, again causing overflow, or too frequent, causing only timer
    execution overhead.

    Various data is collected by the kernel while processing the 
periodic timer,
    this approach would also allow the profiling tools to control the
    frequency of this collection.   More frequent collection results in 
more
    accurate sample data, with the linear cost of poll execution 
overhead.

    Frequency changes can be handled either by the profile code setting
    collection at a higher than necessary rate, or by interacting with 
the
    governor to limit the speeds.

    Optionally, the kernel can add a record indicating that some data was
    likely dropped if it is able to read all 256 entries without 
underflowing
    the array.  This can be used as hint to user space that the kernel 
time
    was too long for the collection rate.


Data collected

The trace hardware provides the execution address of the SPUs in their
local store at some time in the past.   The samples are read most
efficiently in batch.

To be of use to oprofile, the raw address must be translated to the
execution context, and ideally to the persistent file system object
where the code is stored.   In addition, for the case where the elf
image is embedded in another file as data, the start of the elf
image is needed.

By draining the trace array on context switch, the kernel can map the
SPU number to the SPU context and linux thread id (and hence the mm
context of the process).  However, the SPU address recorded has an
arbitrary mapping to source address in that thread's context.   Because
the SPU is executing a copy of object mapped into its private, always
writable store, the normal oprofile mm lookup is ineffective.  In 
addition,
because of the active use of overlays, the mapping of SPU address to
source vm address changes over time.   The oprofile driver is 
necessarily
reading the sample later in time.

The current patch starts tackling these translation issues for the
presently common case of a static self contained binary from a single
file, either single separate source file or embedded in the data of
the host application.   When creating the trace entry for a SPU
context switch, it records the application owner, pid, tid, and
dcookie of the main executable.   It addition, it looks up the
object-id as a virtual address and records the offset if it is non-zero,
or the dcookie of the object if it is zero.   The code then creates
a data structure by reading the elf headers from the user process
(at the address given by the object-id) and building a list of
SPU address to elf object offsets, as specified by the ELF loader
headers.   In addition to the elf loader section, it processes the
overlay headers and records the address, size, and magic number of
the overlay.

When the hardware trace entries are processed, each address is
looked up this structure and translated to the elf offset.  If
it is an overlay region, the overlay identify word is read and
the list is searched for the matching overlay.  The resulting
offset is sent to the oprofile system.

The current patch specifically identifies that only single
elf objects are handled.  There is no code to handle dynamic
linked libraries or overlays.   Nor is there any method to
present samples that may have been collected during context
switch processing, they must be discarded.


My proposal is to change what is presented to user space.  Instead
of trying to translate the SPU address to the backing file
as the samples are recorded, store the samples as the SPU
context and address.  The context switch would record tid,
pid, object id as it does now.   In addition, if this is a
new object-id, the kernel would read elf headers as it does
today.  However, it would then proceed to provide accurate
dcookie information for each loader region and overlay.  To
identify which overlays are active, (instead of the present
read on use and search the list to translate approach) the
kernel would record the location of the overlay identifiers
as it parsed the kernel, but would then read the identification
word and would record the present value as an sample from
a separate but related stream.   The kernel could maintain
the last value for each overlay and only send profile events
for the deltas.

This approach trades translation lookup overhead for each
recorded sample for a burst of data on new context activation.
In addition it exposes the sample point of the overlay identifier
vs the address collection.  This allows the ambiguity to be
exposed to user space.   In addition, with the above proposed
kernel timer vs sample collection, user space could limit the
elapsed time between the address collection and the overlay
id check.

This approach allows multiple objects by its nature.  A new
elf header could be constructed in memory that contained
the union of the elf objects load segments, and the tools
will magically work.   Alternatively the object id could
point to a new structure, identified via a new header, that
it points to other elf headers (easily differentiated by the
elf magic headers).   Other binary formats, including several
objects in a ar archive, could be supported.

If better overlay identification is required, in theory the
overlay switch code could be augmented to record the switches
(DMA reference time from the PowerPC memory and record a
relative decrementer in the SPU), this is obviously a future
item.  But it is facilitated by having user space resolve the
SPU to source file translation.

milton
--
miltonm@bga.com   Milton Miller
Speaking for myself only.

