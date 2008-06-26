Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbYFZPUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbYFZPUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYFZPUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:20:04 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21901 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227AbYFZPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:20:03 -0400
Message-ID: <4863B2BF.10107@panasas.com>
Date: Thu, 26 Jun 2008 18:16:15 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stern@rowland.harvard.edu,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       antonio.lin@alcormicro.com, david.vrabel@csr.com,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Scatter-gather list constraints
References: <20080626110615U.fujita.tomonori@lab.ntt.co.jp> <20080626143928P.fujita.tomonori@lab.ntt.co.jp> <20080626063559.GJ20851@kernel.dk> <20080626155834I.fujita.tomonori@lab.ntt.co.jp> <20080626123936.GV20851@kernel.dk>
In-Reply-To: <20080626123936.GV20851@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2008 15:16:19.0985 (UTC) FILETIME=[96347010:01C8D79F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Jun 26 2008, FUJITA Tomonori wrote:
>> On Thu, 26 Jun 2008 08:35:59 +0200
>> Jens Axboe <jens.axboe@oracle.com> wrote:
>>
>>> On Thu, Jun 26 2008, FUJITA Tomonori wrote:
>>>> On Thu, 26 Jun 2008 11:06:03 +0900
>>>> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>>>
>>>>> On Wed, 25 Jun 2008 10:23:00 -0400 (EDT)
>>>>> Alan Stern <stern@rowland.harvard.edu> wrote:
>>>>>
>>>>>> On Wed, 25 Jun 2008, FUJITA Tomonori wrote:
>>>>>>
>>>>>>>> For example, suppose an I/O request starts out with two S-G elements
>>>>>>>> of 1536 bytes and 2048 bytes respectively, and the DMA requirement is
>>>>>>>> that all elements except the last must have length divisible by 1024.  
>>>>>>>> Then the request could be broken up into three requests of 1024, 512,
>>>>>>>> and 2048 bytes.
>>>>>>> I can't say that it's easy to implement a clean mechanism to break up
>>>>>>> a request into multiple requests until I see a patch.
>>>>>> And I can't write a patch without learning a lot more about how the
>>>>>> block core works.
>>>>>>
>>>>>>> What I said is that you think that this is about extending something
>>>>>>> in the block layer but it's about adding a new concept to the block
>>>>>>> layer.
>>>>>> Is it?  What does the block layer do when it receives an I/O request
>>>>>> that don't satisfy the other constraints (max_sectors or
>>>>>> dma_alignment_mask, for example)?
>>>>> As I explained, you need something new.
>>>>>
>>>>> I don't think that max_sectors works as you expect.
>>>> The block layer looks at max_sectors when merging two things (or add
>>>> one to another). So the test fails, it doesn't merge them.
>>>>
>>>>
>>>>> dma_alignment_mask is not used in the FS path. And I think that
>>>>> dma_alignment_mask doens't solve your problems.
>>>> If dma_alignment_mask test fails, the block layer allocates temporary
>>>> buffers and does memory copies.
>>> I don't think adding anything in the general IO path makes a lot of
>>> sense, this is a really screwy case. I don't mind adding work-arounds to
>>> the block layer to cater for hardware weirdness, but this is getting a
>>> little silly. We could provide a helper function for 'bouncing' this
>>> request and thus reuse the block bounce buffer for this, but I'm not
>>> even sure how to simply express this generically. As it is likely of no
>>> use outside of this specific case, putting it in the driver (or usb
>>> layer, if you expect more of these similar cases) is the best option.
>> Yeah, agreed, as I wrote in the first mail:
>>
>> http://marc.info/?l=linux-kernel&m=121430416329618&w=2
>>
>> I guess that a generic mechanism reserving some buffers in the block
>> layer might work for them. I also need such a mechnism to convert sg
>> and st to use the block layer (yeah, it's overdue but still on my todo
>> list).
> 
> On the fs side, just setting a hw block size of 1k should fix the
> problem, since that'd be your minimum transfer size AND alignment there
> even for O_DIRECT IO.

Please forgive my ignorance, is there a way for devices to specify
minimum block size to upper layer, say if we have a new sata with 1k
sectors?

If not should we include it in Martin's "I/O hints work", if it is
not already included? (CCed)

Not that all this will help with a device that already has a file system
with 512 block size, say from another OS. That could be supported with
that special needed bouncing.

> 
> So that leaves SG_IO (and similar) issued IO, which are typically really
> small (and thus not an issue, since it'll be a single sg element). For
> the bigger ones, sg elements should be tightly packed (eg page size)
> except the last one.
> 
> Alan, in what specific cases have you observed IO requests that violate
> the rules you gave? The example of:
> 
> "For example, suppose an I/O request starts out with two S-G elements of
> 1536 bytes and 2048 bytes respectively, and the DMA requirement is"
> 
> really sounds concocted, have you ever seen something like that?
> 

Boaz
