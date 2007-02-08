Return-Path: <linux-kernel-owner+w=401wt.eu-S1422636AbXBIAAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636AbXBIAAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422710AbXBHX77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:59:59 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:51481 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636AbXBHX76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:59:58 -0500
Message-ID: <45CBB976.6010209@us.ibm.com>
Date: Thu, 08 Feb 2007 17:59:50 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: Carl Love <cel@us.ibm.com>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net, cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
 patch
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com> <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com> <b682962303654f4958a6c2c50d805907@bga.com>
In-Reply-To: <b682962303654f4958a6c2c50d805907@bga.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Milton,
Thank you for your comments.  Carl will reply to certain parts of your 
posting where he's more knowledgeable than I.  See my replies below.

-Maynard

Milton Miller wrote:

>On Feb 6, 2007, at 5:02 PM, Carl Love wrote:
>
>  
>
>>This is the first update to the patch previously posted by Maynard
>>Johnson as "PATCH 4/4. Add support to OProfile for profiling CELL".
>>
>>
>>    
>>
>  
>
[snip]

>
>Data collected
>
>
>The current patch starts tackling these translation issues for the
>presently common case of a static self contained binary from a single
>file, either single separate source file or embedded in the data of
>the host application.   When creating the trace entry for a SPU
>context switch, it records the application owner, pid, tid, and
>dcookie of the main executable.   It addition, it looks up the
>object-id as a virtual address and records the offset if it is non-zero,
>or the dcookie of the object if it is zero.   The code then creates
>a data structure by reading the elf headers from the user process
>(at the address given by the object-id) and building a list of
>SPU address to elf object offsets, as specified by the ELF loader
>headers.   In addition to the elf loader section, it processes the
>overlay headers and records the address, size, and magic number of
>the overlay.
>
>When the hardware trace entries are processed, each address is
>looked up this structure and translated to the elf offset.  If
>it is an overlay region, the overlay identify word is read and
>the list is searched for the matching overlay.  The resulting
>offset is sent to the oprofile system.
>
>The current patch specifically identifies that only single
>elf objects are handled.  There is no code to handle dynamic
>linked libraries or overlays.   Nor is there any method to
>  
>
Yes, we do handle overlays.  (Note: I'm looking into a bug right now in 
our overlay support.)

>present samples that may have been collected during context
>switch processing, they must be discarded.
>
>
>My proposal is to change what is presented to user space.  Instead
>of trying to translate the SPU address to the backing file
>as the samples are recorded, store the samples as the SPU
>context and address.  The context switch would record tid,
>pid, object id as it does now.   In addition, if this is a
>new object-id, the kernel would read elf headers as it does
>today.  However, it would then proceed to provide accurate
>dcookie information for each loader region and overlay.  To
>identify which overlays are active, (instead of the present
>read on use and search the list to translate approach) the
>kernel would record the location of the overlay identifiers
>as it parsed the kernel, but would then read the identification
>word and would record the present value as an sample from
>a separate but related stream.   The kernel could maintain
>the last value for each overlay and only send profile events
>for the deltas.
>  
>
Discussions on this topic in the past have resulted in the current 
implementation precisely because we're able to record the samples as 
fileoffsets, just as the userspace tools expect.   I haven't had time to 
check out how much this would impact the userspace tools, but my gut 
feel is that it would be quite significant.  If we were developing this 
module with a matching newly-created userspace tool, I would be more 
inclined to agree that this makes sense.  But you give no rationale for 
your proposal that justifies the change.  The current implementation 
works, it has no impact on normal, non-profiling behavior,  and the 
overhead during profiling is not noticeable.

>This approach trades translation lookup overhead for each
>recorded sample for a burst of data on new context activation.
>In addition it exposes the sample point of the overlay identifier
>vs the address collection.  This allows the ambiguity to be
>exposed to user space.   In addition, with the above proposed
>kernel timer vs sample collection, user space could limit the
>elapsed time between the address collection and the overlay
>id check.
>  
>
Yes, there is a window here where an overlay could occur before we 
finish processing a group of samples that were actually taken from a 
different overlay.  The obvious way to prevent that is for the kernel 
(or SPUFS) to be notified of the overlay and let OProfile know that we 
need to drain (perhaps discard would be best) our sample trace buffer.  
As you indicate above, your proposal faces the same issue, but would 
just decrease the number of bogus samples.  I contend that the relative 
number of bogus samples will be quite low in either case.  Ideally, we 
should have a mechanism to eliminate them completely so as to avoid 
confusion the user's part when they're looking at a report.  Even a few 
bogus samples in the wrong place can be troubling.  Such a mechanism 
will be a good future enhancement.

[snip]

>milton
>--
>miltonm@bga.com   Milton Miller
>Speaking for myself only.
>
>_______________________________________________
>Linuxppc-dev mailing list
>Linuxppc-dev@ozlabs.org
>https://ozlabs.org/mailman/listinfo/linuxppc-dev
>  
>


