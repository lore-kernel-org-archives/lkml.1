Return-Path: <linux-kernel-owner+w=401wt.eu-S1946689AbXBISER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946689AbXBISER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 13:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946688AbXBISER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 13:04:17 -0500
Received: from mercury.realtime.net ([205.238.132.86]:55655 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946679AbXBISEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 13:04:14 -0500
In-Reply-To: <45CBB976.6010209@us.ibm.com>
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com> <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com> <b682962303654f4958a6c2c50d805907@bga.com> <45CBB976.6010209@us.ibm.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <a49ce56978da5cb449697fd5ddb07791@bga.com>
Content-Transfer-Encoding: 7bit
Cc: cbe-oss-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Carl Love <cel@us.ibm.com>,
       oprofile-list@lists.sourceforge.net
From: Milton Miller <miltonm@bga.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Date: Fri, 9 Feb 2007 12:03:52 -0600
To: Maynard Johnson <maynardj@us.ibm.com>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8, 2007, at 5:59 PM, Maynard Johnson wrote:

> Milton,
> Thank you for your comments.  Carl will reply to certain parts of your 
> posting where he's more knowledgeable than I.  See my replies below.
>

Thanks for the pleasant tone and dialog.

> Milton Miller wrote:
>> On Feb 6, 2007, at 5:02 PM, Carl Love wrote:
>>> This is the first update to the patch previously posted by Maynard
>>> Johnson as "PATCH 4/4. Add support to OProfile for profiling CELL".
>>

>> Data collected
>>
>>
>> The current patch starts tackling these translation issues for the
>> presently common case of a static self contained binary from a single
>> file, either single separate source file or embedded in the data of
>> the host application.   When creating the trace entry for a SPU
>> context switch, it records the application owner, pid, tid, and
>> dcookie of the main executable.   It addition, it looks up the
>> object-id as a virtual address and records the offset if it is 
>> non-zero,
>> or the dcookie of the object if it is zero.   The code then creates
>> a data structure by reading the elf headers from the user process
>> (at the address given by the object-id) and building a list of
>> SPU address to elf object offsets, as specified by the ELF loader
>> headers.   In addition to the elf loader section, it processes the
>> overlay headers and records the address, size, and magic number of
>> the overlay.
>>
>> When the hardware trace entries are processed, each address is
>> looked up this structure and translated to the elf offset.  If
>> it is an overlay region, the overlay identify word is read and
>> the list is searched for the matching overlay.  The resulting
>> offset is sent to the oprofile system.
>>
>> The current patch specifically identifies that only single
>> elf objects are handled.  There is no code to handle dynamic
>> linked libraries or overlays.   Nor is there any method to
>>
> Yes, we do handle overlays.  (Note: I'm looking into a bug
> right now in our overlay support.)

I knew you handled overlays, and I did not mean to say that
you did not.   I am not sure how that got there.  I may have
been thinking of the kernel supplied context switch code
discussion, or how the code supplied dcookie or offset but
not both.  Actually, I might have been referring to the
fact that overlays are guessed rather than recorded.

>> present samples that may have been collected during context
>> switch processing, they must be discarded.
>>
>>
>> My proposal is to change what is presented to user space.  Instead
>> of trying to translate the SPU address to the backing file
>> as the samples are recorded, store the samples as the SPU
>> context and address.  The context switch would record tid,
>> pid, object id as it does now.   In addition, if this is a
>> new object-id, the kernel would read elf headers as it does
>> today.  However, it would then proceed to provide accurate
>> dcookie information for each loader region and overlay.  To
>> identify which overlays are active, (instead of the present
>> read on use and search the list to translate approach) the
>> kernel would record the location of the overlay identifiers
>> as it parsed the kernel, but would then read the identification
>> word and would record the present value as an sample from
>> a separate but related stream.   The kernel could maintain
>> the last value for each overlay and only send profile events
>> for the deltas.
>>
> Discussions on this topic in the past have resulted in the
> current implementation precisely because we're able to record
> the samples as fileoffsets, just as the userspace tools expect.

I was not part of the previous discussions, so please forgive me.

> I haven't had time to check out how much this would impact the
> userspace tools, but my gut feel is that it would be quite
> significant.  If we were developing this module with a matching
> newly-created userspace tool, I would be more inclined to agree
> that this makes sense.

I have not yet studied the user space tool.   In fact, when I
made this proposal, I had not studied the kernel oprofile code
either, although I had read the concepts and discussion of the
event buffer when the base patch was added to the kernel.

I have read and now consider myself to have some understanding
of the kernel side.  I note that the user space tool calls itself
alpha and the kernel support experimental.   I only looked at
the user space enough to determine it is written in C++.

I would hope the tool would be modular enough to insert a data
transformation pass to do this conversion that the kernel is
doing.

> But you give no rationale for your
> proposal that justifies the change.  The current implementation
> works, it has no impact on normal, non-profiling behavior,  and
> the overhead during profiling is not noticeable.

I was proposing this for several of reasons.

One, there were expressed limitations  in the current
proposal.  There is a requirement that everything be linked
into one ELF object for it to be profiled seemed significant
to me.  This implies that shared libraries (well, dynamic
linked ones) have no path forward in this framework.

Two, there was a discussion of profiling the kernel context
switch, that seemed to be deferred.

Three, I saw the amount of code added to create the buffer
stream, but had not studied it yet.   It appeared to be
creating a totally new stream to be interpreted by user space.
With that in mind, I was exploring what the right interface
should be with more freedom.

Fourth, the interpretation was being done by heuristics and not
first source data.  By this I mean that both the overlay
identification is delayed, and that the code being executed
is a copy from the file.   While existing users may leave
the code mapped into the host process, there is no inherent
requirement to do so.  Now that I understand overlays, I see
they would have to remain mapped.

Of these, I think the fourth is the most compelling argument,
although the first and the second were what caused me to
try to understand why all this new code was needed.

My proposal was an attempt to expose the raw data, providing
user space what we know vs some guess.  I was trying to provide
the information that was needed to perform the translation
in user space with at least the same accuracy, but with the
ambiguities exposed.


>> This approach trades translation lookup overhead for each
>> recorded sample for a burst of data on new context activation.
>> In addition it exposes the sample point of the overlay identifier
>> vs the address collection.  This allows the ambiguity to be
>> exposed to user space.   In addition, with the above proposed
>> kernel timer vs sample collection, user space could limit the
>> elapsed time between the address collection and the overlay
>> id check.
>>
> Yes, there is a window here where an overlay could occur before
> we finish processing a group of samples that were actually taken
> from a different overlay.  The obvious way to prevent that is
> for the kernel (or SPUFS) to be notified of the overlay and let
> OProfile know that we need to drain (perhaps discard would be
> best) our sample trace buffer.  As you indicate above, your
> proposal faces the same issue, but would just decrease the number
> of bogus samples.

Actually, with my proposal, I let user space decide how to handle
the ambiguity.   If the SPU periodically switches between two
overlays then the sampling will be out of sync.   Flags could be
passed to the user space decoder to influence the overlay; for
instance one flag might say place all samples on each overlay
in turn, or create separate buckets when the overlay was known
to change during sample collection (or just discard those samples).

> I contend that the relative number of bogus samples will be
> quite low in either case.

I think this totally depends on the frequency of overlay changes.
If an application frequently swaps between overlays then the
data could be wrong more than it is right.   If instead
the overlay is only switched when a fundamental phase change
in data processing occurs, then the ambiguity will have
little affect on the sample quality.


> Ideally, we should have a mechanism to eliminate them completely
> so as to avoid confusion the user's part when they're looking at
> a report.  Even a few bogus samples in the wrong place can be
> troubling.  Such a mechanism will be a good future enhancement.

I think the obvious most accurate to resolve this would be to have
the overlay load code record an event in a buffer with a
timestamp, the kernel record a timestamp periodically during
collection, and the user space do the correlation.   However,
this obviously involves both space and time overhead, as Arnd
pointed out.


Actually, if we record in the data stream that the overlay
changed from last read, then user space could know that samples
from that overlay are suspect, during that portion.   We
would need to mark both the beginning and end of that trace
array unload.


When I started to write this reply, I had done my review of
the existing kernel code, and thought I would severely back
off from this proposal.  However, now that I have written
my reasons for the proposal, I think I would still like to
have it explored.

Now that I have read the kernel code and slept on it, let
me also propose, in the alternative, an approach that tries
to reuse the existing sample framework be used instead of
the total re-implemntation.  This idea is still mostly
concept, so please bear with me.  That is to say I read
the headers, and have some understanding of how the stages
of data collection fit together, but have not studied the
actual impact to the implentation.

Even if we do stay with the kernel resolution of the SPU
address to source in the process vm, why do we need to
write new buffer sync code?   Instead of recording the hit
as an ELF object source, why not resolve it to the threads
context vm address, and let the existing oprofile code
lookup the dcookie and offset?

1) The  user space needs to find the elf header of embedded
objects.   Answer: on context switch pass the object-id as
a sample, with appropriate escape code.

2) THe offset will be file relative instead of elf object
relative.   Answer: user space has to account for this
offset either when reading the instructions for decode or
when doing the sample lookup.   Answer b: if the context
id dcookie is for the same file, subtract its offset.
Actually, only do this if its in range of the file size
as indicated in the ELF headers.   Hmmm.. this would imply
a artifical dcookie for the offset object-id case.

3) In addition to the additional records to record the
context-id on switch, the existing interfaces assume the
sample is being recorded from the context of the running
thread, implicitly reading cpu number and active mm.
Answer: Yes, but factoring and code reuse should be
possible.


[I wonder if any other nommu architectures use overlays
like this.  I would not be surprised if the answer is
no, they have enough address space.]

milton
--
miltonm@bga.com   Milton Miller
Speaking for myself only.

