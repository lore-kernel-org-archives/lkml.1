Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYEQOMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYEQOMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 10:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYEQOMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 10:12:44 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41179
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYEQOMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 10:12:43 -0400
Date: Sat, 17 May 2008 16:12:35 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Top kernel oopses/warnings for the week of May 16th 2008
Message-ID: <20080517141235.GA13130@duo>
References: <fa.LFS/TATb5YijFetLw6A+gczrVAQ@ifi.uio.no> <482E3B1B.9070400@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482E3B1B.9070400@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 07:55:39PM -0600, Robert Hancock wrote:
> Arjan van de Ven wrote:
>> Rank 10: __alloc_pages
>>     Reported 16 times (31 total reports)
>>     Sleeping allocation in interrupt context, some in netlink, some in the 
>> nv sata driver
>>     This oops was last seen in version 2.6.25.3, and first seen in 
>> 2.6.18-rc1.
>>     More info: 
>> http://www.kerneloops.org/searchweek.php?search=__alloc_pages
>
> In the case of the sata_nv error, it appears this is happening now because 
> blk_queue_bounce_limit is initializing emergency ISA pools which can't be 
> done under spinlock. This is happening because the code in 
> blk_queue_bounce_limit now thinks that a 32-bit DMA mask requires 
> allocating with GFP_DMA. This is only needed for a DMA mask less than 
> 32-bit, which is what the original code did. It looks like this was broken 
> by this commit:

Looks like or you're certain? I ask because I had your exact same
problem with a regression introduced in 2.6.25-rc, and my patch
attempted to fix it. It looks like it wasn't enough to fix all of it,
but at least it looked like to improve things a bit to reduce the
regression impact without introducing any other problem compared to
the previous 2.6.25-rc code.

> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=00d61e3e8c12d5f395b167856d2b3c430816afb0
>
> author	Andrea Arcangeli <andrea@qumranet.com>
> 	Wed, 2 Apr 2008 07:06:44 +0000 (09:06 +0200)
> committer	Jens Axboe <jens.axboe@oracle.com>
> 	Wed, 2 Apr 2008 07:06:44 +0000 (09:06 +0200)
>
> Fix bounce setting for 64-bit
>
> Not sure what this was intended to fix, but I don't think it's right..

The reason I touched that code, is that a change introduced during
2.6.25-rc initialized the isa dma pool even if not necessary and that
broke the reserved-ram patch that requires no __GFP_DMA
allocations. There was no crash in 2.6.24 based kernels, the
regression started in 2.6.25-rc.

I think my patch isn't enough yet as I had another crash for the same
reason but it doesn't seem to trigger with all controllers, simulated
ata under kvm looked ok so I thought the regression was fixed after
the problem was gone under kvm, but it seems other hardware
configuration can still trigger the same problem. At least my patch
reduced the impact of the regression.

Please try to backout my patch, I suspect it'll make thing worse for
you and no btter. You'll have to backout the other change as well to
get back to 2.6.24 correct behavior like I still have too.

Then the fact that the isa pool may be initialized under spinlock that
seems another orthogonal problem, the reason I noticed this wasn't
because of some debug check but because there are no __GFP_DMA pages
in my boot.

Can't work on this right now, but I'm confident my change only
improved things, and the real trouble was with the previous commit.
