Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZFDNU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZFDNU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZFDNUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:20:51 -0400
Received: from mail.pentek.com ([12.35.250.145]:2988 "HELO mailhost.pentek.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751099AbZFDNUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:20:50 -0400
Message-ID: <4A27CA0A.7060400@pentek.com>
Date: Thu, 04 Jun 2009 09:20:10 -0400
From: Steve Rottinger <steve@pentek.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jens Axboe <jens.axboe@oracle.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>
Subject: Re: splice methods in character device driver
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk> <4A0AFC62.3090002@pentek.com> <c384c5ea0906031432x2675c5a4xcc940a567ca408b8@mail.gmail.com> <20090604073218.GT11363@kernel.dk>
In-Reply-To: <20090604073218.GT11363@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I was working with a memory region that didn't have any "struct pages"
associated with it  (or at least I wasn't able to find a way to retrieve
them for
this space),  I took the approach of generating fake struct pages, which
I passed
through the pipe.  Unfortunately, this also required me to make some
rather hanus
hacks to various kernel macros to get them to handle the fake pages; ie:
page_to_phys.
I'm not sure if this was the best way to do it, but it was the only way
that I could come
up with.  ->map didn't help, since I am in O_DIRECT mode -- I wanted the
disk controller's
DMA to directly transfer from PCI memory.

As this point,  I have proof of concept, since I am now able to transfer
some data directly from
PCI space to disk; however,  I am still wrestling with some issues:

-  I'm not sure at what point it is safe to free up the pages that I am
passing
through the pipe. I tried doing it in the "release" method, however,
this is apparently too
soon, since this results in a crash.  How do I know when the system is
done with them?

- The performance is poor, and much slower than transferring directly from
main memory with O_DIRECT.  I suspect that this has a lot to do with
large amount of
systems calls required to move the data, since each call moves only
64K.  Maybe I'll
try increasing the pipe size, next.

Once I get past these issues, and I get the code in a better state, I'll
be happy to share what
I can.

-Steve



Jens Axboe wrote:
> On Wed, Jun 03 2009, Leon Woestenberg wrote:
>   
>> Hello all,
>>
>> On Wed, May 13, 2009 at 6:59 PM, Steve Rottinger <steve@pentek.com> wrote:
>>     
>>> is passing in the pages into splice_to_pipe.  The pages are associated
>>> with a PCI BAR, not main memory.  I'm wondering if this could be a problem?
>>>
>>>       
>> Good question; my newbie answer would be the pages need to be mapped
>> in kernel space.
>>     
>
> That is what the ->map() hook is for.
>
>   
>> I have a similar use case but with memory being DMA'd to host main
>> memory (instead of the data sitting in your PCI device) in a character
>> device driver. The driver is a complete rewrite from scratch from
>> what's currently sitting-butt-ugly in staging/altpcichdma.c
>> so-please-don't-look-there.
>>
>> I have already implemented zero-latency overlapping transfers in the
>> DMA engine (i.e. it never sits idle if async I/O is performed through
>> threads), now it would be really cool to add zero-copy.
>>
>> What is it my driver is expected to do?
>>
>> .splice_read:
>>
>> - Allocate a bunch of single pages
>> - Create a scatter-gather list
>> - "stuff the data pages in question into a struct page *pages[]." a la
>> "fs/splice.c:vmsplice_to_pipe()"
>> - Start the DMA from the device to the pages (i.e. the transfer)
>> - Return.
>>
>> .splice_write:
>>
>> - Create a scatter-gather list
>>
>> interrupt handler / DMA service routine:
>> - device book keeping
>> - wake_up_interruptible(transfer_queue)
>>
>> .confirm():
>>
>> "then you need to provide a suitable ->confirm() hook that can wait on
>> this IO to complete if needed."
>> - wait_on_event_interruptibe(transfer_queue)
>>
>> .release():
>>
>> - release the pages
>>
>> .steal():
>>
>> unsure
>>     
>
> This is what allows zero copy throughout the pipe line. ->steal(), if
> sucesful, should pass ownership of that page to the caller. The previous
> owner must no longer modify it.
>
>   
>> .map
>>
>> unsure
>>     
>
> See above :-)
>
>   

