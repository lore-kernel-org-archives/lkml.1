Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZENJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZENJAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZENJAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:00:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11513 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbZENJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:00:20 -0400
Date: Thu, 14 May 2009 11:00:15 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] Physical Memory Management [0/1]
In-reply-to: <20090513151142.5d166b92.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
       kyungmin.park@samsung.com, linux-mm@kvack.org
Message-id: <op.utwwmpsf7p4s8u@amdc030>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.00 (Win32)
References: <op.utu26hq77p4s8u@amdc030>
 <20090513151142.5d166b92.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 00:11:42 +0200, Andrew Morton wrote:
> (please keep the emails to under 80 columns)

Yes, sorry about that. Apparently "Automatically wrap outgoing messages"
doesn't mean what I thought it does.

> Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:
>> 1. Each allocated block of memory has a reference counter so different  
>> kernel modules may share the same buffer with a well known get/put  
>> semantics.
>>
>> 2. It aggregates physical memory allocating and management API in one  
>> place. This is good because there is a single place to debug and test  
>> for all devices. Moreover, because each device does not need to reserve  
>> it's own area of physical memory a total size of reserved memory is  
>> smaller. Say, we have 3 accelerators. Each of them can operate on 1MiB  
>> blocks, so each of them would have to reserve 1MiB for itself (this  
>> means total of 3MiB of reserved memory). However, if at most two of  
>> those devices can be used at once, we could reserve 2MiB saving 1MiB.
>>
>> 3. PMM has it's own allocator which runs in O(log n) bound time where n  
>> is total number of areas and free spaces between them -- the upper time  
>> limit may be important when working on data sent in real time (for  
>> instance an output of a camera).  Currently a best-fit algorithm is  
>> used but you can easily replace it if it does not meet your needs.
>>
>> 4. Via a misc char device, the module allows allocation of continuous  
>> blocks from user space. Such solution has several advantages. In  
>> particular, other option would be to add a allocation calls for each  
>> individual devices (think hardware accelerators) -- this would double  
>> the same code in several drivers plus it would lead to inconsistent API  
>> for doing the very same think. Moreover, when creating pipelines (ie.  
>> encoded image --[decoder]--> decoded image --[scaler]--> scaled image)  
>> devices would have to develop a method of sharing buffers. With PMM  
>> user space program allocates a block and passes it as an output buffer  
>> for the first device and input buffer for the other.
>>
>> 5. PMM is integrated with System V IPC, so that user space programs may  
>> "convert" allocated block into a segment of System V shared memory.  
>> This makes it possible to pass PMM buffers to PMM-unaware but  
>> SysV-aware applications. Notable example are X11. This makes it  
>> possible to deploy a zero-copy scheme when communicating with X11. For  
>> instance, image scaled in previous example could be passed directly to  
>> X server without the need to copy it to a newly created System V shared  
>> memory.
>>
>> 6. PMM has a notion of memory types. In attached patch only a general  
>> memory type is defined but you can easily add more types for a given  
>> platform. To understand what in PMM terms is memory type we can use an  
>> example: a general memory may be a main RAM memory which we have a lot  
>> but it is quite slow and another type may be a portion of L2 cache  
>> configured to act as fast memory. Because PMM may be aware of those,  
>> again, allocation of different kinds of memory has a common, consistent  
>> API.

> OK, let's pretend we didn't see an implementation.

:]

I've never said it's perfect.  I'll welcome any constructive comments.

> What are you trying to do here?  What problem(s) are being solved?
> What are the requirements and the use cases?

Overall situation: UMA embedded system and many hardware
accelerators (DMA capable, no scatter-gather).  Three use cases:

1. We have a hardware JPEG decoder, we want to decode an image.

2. As above plus we have an image scaler, we want to scale decoded
   image.

3. As above plus we want to pass scaled image to X server.


Neither decoder nor scaler may operate on malloc(3)ed areas as
they aren't continuous in physical memory.  A copying of a
scattered buffer would have to be used.  This is a performance
cost.  It also doubles memory usage.

  PMM solves this as it lets user space allocate a continuous
  buffers which the devices may use directly.

It could be solved by letting each driver allocate its own buffers
during boot time and then let user space mmap(2) them.  However, with
10 hardware accelerators each needing 1MiB buffer we need to reserve
10MiB of memory.  If we know that at most 5 devices will be used at
the same time we could've reserve 5MiB instead of 10MiB.

  PMM solves this problem since the buffers are allocated when they
  are needed.

This could be solved by letting each driver allocate buffers when
requested (using bigphysarea for instance).  It has some minor issues
like implementing mmap file operation in all drivers and inconsistent
user space API but the most significant is it's not clear how to
implement 2nd use case.  If drivers expect to work on their own
buffers, decoder's output must be copied into scaler's input buffer.

  With PMM, drivers simply expect a continuous buffers and do not
  care where they came from or if other drivers use them as well.

Now, as of 3rd use case.  X may work with System V shared memory,
however, since shared memory segments (created via shmget(2)) are
not continuous, we cannot pass it to a scaler as an output buffer.

  PMM solves it, since it allows converting an area allocated via
  PMM into a System V shared memory segment.

-- 
Best regards,                                            _     _
 .o. | Liege of Serenly Enlightened Majesty of         o' \,=./ `o
 ..o | Computer Science,  Michał "mina86" Nazarewicz      (o o)
 ooo +-<m.nazarewicz@samsung.com>-<mina86@jabber.org>-ooO--(_)--Ooo--

