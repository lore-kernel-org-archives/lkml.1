Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZHNAUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZHNAUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 20:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZHNAUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 20:20:05 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:50271 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZHNAUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 20:20:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QA1gaYPu2js499i/7qv+2Xni5jEV0Nix/dXnBm2sMkMHJAnVusEWGoe/RaL7B2gC5N
         eFY9PuJShlE1kItcyyVnE/ggW67BPZr24YAdJdWT8GaZtsqbNjJvLXRyQGFijsEwAEIf
         95BI6Eu1jo2x2AaBmj1YFzcOQi45P6P/pbhJc=
MIME-Version: 1.0
In-Reply-To: <46b8a8850908131520s747e045cnd8db9493e072939d@mail.gmail.com>
References: <200908122007.43522.ngupta@vflare.org>
	 <Pine.LNX.4.64.0908122312380.25501@sister.anvils>
	 <20090813151312.GA13559@linux.intel.com>
	 <20090813162621.GB1915@phenom2.trippelsdorf.de>
	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	 <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
	 <87f94c370908131428u75dfe496x1b7d90b94833bf80@mail.gmail.com>
	 <46b8a8850908131520s747e045cnd8db9493e072939d@mail.gmail.com>
Date: Thu, 13 Aug 2009 20:19:57 -0400
Message-ID: <87f94c370908131719l7d84c5d0x2157cfeeb2451bce@mail.gmail.com>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap 
	slot is freed)
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Richard Sharpe <realrichardsharpe@gmail.com>
Cc: david@lang.hm, Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 6:20 PM, Richard
Sharpe<realrichardsharpe@gmail.com> wrote:
> On Thu, Aug 13, 2009 at 2:28 PM, Greg Freemyer<greg.freemyer@gmail.com> wrote:
>> On Thu, Aug 13, 2009 at 4:44 PM, <david@lang.hm> wrote:
>>> On Thu, 13 Aug 2009, Greg Freemyer wrote:
>>>
>>>> On Thu, Aug 13, 2009 at 12:33 PM, <david@lang.hm> wrote:
>>>>>
>>>>> On Thu, 13 Aug 2009, Markus Trippelsdorf wrote:
>>>>>
>>>>>> On Thu, Aug 13, 2009 at 08:13:12AM -0700, Matthew Wilcox wrote:
>>>>>>>
>>>>>>> I am planning a complete overhaul of the discard work.  Users can send
>>>>>>> down discard requests as frequently as they like.  The block layer will
>>>>>>> cache them, and invalidate them if writes come through.  Periodically,
>>>>>>> the block layer will send down a TRIM or an UNMAP (depending on the
>>>>>>> underlying device) and get rid of the blocks that have remained
>>>>>>> unwanted
>>>>>>> in the interim.
>>>>>>
>>>>>> That is a very good idea. I've tested your original TRIM implementation
>>>>>> on
>>>>>> my Vertex yesterday and it was awful ;-). The SSD needs hundreds of
>>>>>> milliseconds to digest a single TRIM command. And since your
>>>>>> implementation
>>>>>> sends a TRIM for each extent of each deleted file, the whole system is
>>>>>> unusable after a short while.
>>>>>> An optimal solution would be to consolidate the discard requests, bundle
>>>>>> them and send them to the drive as infrequent as possible.
>>>>>
>>>>> or queue them up and send them when the drive is idle (you would need to
>>>>> keep track to make sure the space isn't re-used)
>>>>>
>>>>> as an example, if you would consider spinning down a drive you don't hurt
>>>>> performance by sending accumulated trim commands.
>>>>>
>>>>> David Lang
>>>>
>>>> An alternate approach is the block layer maintain its own bitmap of
>>>> used unused sectors / blocks. Unmap commands from the filesystem just
>>>> cause the bitmap to be updated.  No other effect.
>>>
>>> how does the block layer know what blocks are unused by the filesystem?
>>>
>>> or would it be a case of the filesystem generating discard/trim requests to
>>> the block layer so that it can maintain it's bitmap, and then the block
>>> layer generating the requests to the drive below it?
>>>
>>> David Lang
>>
>> Yes, my thought.was that block layer would consume the discard/trim
>> requests from the filesystem in realtime to maintain the bitmap, then
>> at some later point in time when the system has extra resources it
>> would generate the calls down to the lower layers and eventually the
>> drive.
>
> Why should the block layer be forced to maintain something that is
> probably of use for only a limited number of cases? For example, the
> devices I work on already maintain their own mapping of HOST-visible
> LBAs to underlying storage, and I suspect that most such devices do.
> So, you are duplicating something that we already do, and there is no
> way that I am aware of to synchronise the two.
>
> All we really need, I believe is for the UNMAP requests to come down
> to us with writes barriered until we respond, and it is a relatively
> cheap operation, although writes that are already in the cache and
> uncommitted to disk present some issues if an UNMAP request comes down
> for recently written blocks.
>

Richard,

Quoting the original email I saw in this thread:

>
>The unfortunate thing about the TRIM command is that it's not NCQ, so
>all NCQ commands have to finish, then we can send the TRIM command and
>wait for it to finish, then we can send NCQ commands again.
>
>So TRIM isn't free, and there's a better way for the drive to find
>out that the contents of a block no longer matter -- write some new
>data to it.  So if we just swapped a page in, and we're going to swap
>something else back out again soon, just write it to the same location
>instead of to a fresh location.  You've saved a command, and you've
>saved the drive some work, plus you've allowed other users to continue
>accessing the drive in the meantime.
>
>I am planning a complete overhaul of the discard work.  Users can send
>down discard requests as frequently as they like.  The block layer will
>cache them, and invalidate them if writes come through.  Periodically,
>the block layer will send down a TRIM or an UNMAP (depending on the
>underlying device) and get rid of the blocks that have remained unwanted
>in the interim.
>
>Thoughts on that are welcome.
>>

My thought was that a bitmap was a better solution than a cache of
discard commands.

One of the biggest reasons is that a bitmap can coalesce the unused
areas into much larger discard ranges than a queue that will only have
a limited number of discards to coalesce.

And both Enterprise scsi and mdraid are desirous of larger discard ranges.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Paper -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
