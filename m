Return-Path: <linux-kernel-owner+w=401wt.eu-S1161053AbXCHXVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161053AbXCHXVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161060AbXCHXVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:21:47 -0500
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:59862 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161053AbXCHXVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:21:45 -0500
Date: Fri, 9 Mar 2007 00:21:35 +0100 (CET)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: hugh@veritas.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about memory mapping mechanism
In-Reply-To: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
Message-ID: <Pine.LNX.4.64.0703082354530.25365@kepler.fjfi.cvut.cz>
References: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Martin Drab wrote:

> Hi,
> 
> I'm writing a driver for a sampling device that is constantly delivering a 
> relatively high amount of data (about 16 MB/s) and I need to deliver the 
> data to the user-space ASAP. To prevent data loss I create a queue of 
> buffers (consisting of few pages each) which are more or less directly 
> filled by the device and then mapped to the user-space via mmap().
> 
> The thing is that I'd like to prevent kernel to swap these pages out, 
> because then I may loose some data when they are not available in time 
> for the next round.
> 
> My original idea (that used to work in the past) was to allocate the 
> buffers using __get_free_pages(), then pin the pages down by setting their 
> PG_reserved bit in the page flags before using them. And then set the 
> VM_RESERVED flag of the appropriate VMA when mmap() is called for these 
> pages that are then mapped using nopage() mechanism.
> 
> But this way no longer seems to work correctly, it kind of works, but I'm 
> getting following messages for each mmapped page upon munmap() call:
> 
> --------------------------------------
> [19172.939248] Bad page state in process 'dtrtest'
> [19172.939249] page:ffff81000160a978 flags:0x001a000000000404 mapping:0000000000000000 mapcount:0 count:0
> [19172.939251] Trying to fix it up, but a reboot is needed
> [19172.939253] Backtrace:
> [19172.939256]
> [19172.939257] Call Trace:
> [19172.939273]  [<ffffffff802adc37>] bad_page+0x57/0x90
> [19172.939280]  [<ffffffff8020b92f>] free_hot_cold_page+0x7f/0x180
> [19172.939287]  [<ffffffff80207a90>] unmap_vmas+0x450/0x750
> [19172.939308]  [<ffffffff80212867>] unmap_region+0xb7/0x160
> [19172.939318]  [<ffffffff80211918>] do_munmap+0x238/0x2f0
> [19172.939325]  [<ffffffff802656c5>] __down_write_nested+0x35/0xf0
> [19172.939334]  [<ffffffff80215ffd>] sys_munmap+0x4d/0x80
> [19172.939341]  [<ffffffff8025f11e>] system_call+0x7e/0x83
> -------------------------------
> 
> Aparently due to the PG_reserved bit set.
> 
> So my question is: What is currently a proper way to do all this cleanly?

Ah, OK, so as I found here:

http://www-gatago.com/linux/kernel/14660780.html

I do not need to worry about the just-in-kernel pages being swapped out 
and thus need not set the PG_reserved. Good.

On the other hand, if I understand it correctly, then the buffer may 
potentionally become the lru if it is not used for a long time (which may 
happen, since there may be buffers that are used just from time to time to 
compensate a temporal disability of the application to process the data 
for some time. Or is it not the case?

How does a page get onto an lru list? Is there a way to prevent that at 
all costs? Or do I just need to hope that all the buffers will be used 
every now and then to prevent getting there.

I thought I would store the free waiting-to-be-used buffers in a LIFO 
stack rather then a classical FIFO ring queue to restrict the accesses to 
as little amount of memory as possible (for better caching perhaps?) and 
also perhaps to be able to keep some statistics about the usage of the 
buffers on the buffer stack, so that if some buffers are not going to 
be used for a long time (meaning that the application can process the data 
quickly without big problems), some buffers may be freed to free the 
memory (there may potentially be a huge amount of buffers consuming a 
lot of memory to prevent loosing any of the constantly incomming data if 
the application is temporally unable to process them for some reason).

That means, that the buffers at the bottom of the stack can be there 
unused for quite some while. Does it mean that they can potentially be 
automatically placed on the lru list? Because then when they would really 
be needed and they were swapped out, that would be a problem.

And about the user-space VMA mapping: Do I need to set the VM_RESERVED on 
the VMA when mmapping? I suppose I do. Or do I?

Martin
