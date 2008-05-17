Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYEQBxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYEQBxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 21:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYEQBxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 21:53:39 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:58379 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYEQBxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 21:53:39 -0400
Date: Fri, 16 May 2008 19:55:39 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Top kernel oopses/warnings for the week of May 16th 2008
In-reply-to: <fa.LFS/TATb5YijFetLw6A+gczrVAQ@ifi.uio.no>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, andrea@qumranet.com,
       Jens Axboe <jens.axboe@oracle.com>
Message-id: <482E3B1B.9070400@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.LFS/TATb5YijFetLw6A+gczrVAQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Rank 10: __alloc_pages
>     Reported 16 times (31 total reports)
>     Sleeping allocation in interrupt context, some in netlink, some in 
> the nv sata driver
>     This oops was last seen in version 2.6.25.3, and first seen in 
> 2.6.18-rc1.
>     More info: 
> http://www.kerneloops.org/searchweek.php?search=__alloc_pages

In the case of the sata_nv error, it appears this is happening now 
because blk_queue_bounce_limit is initializing emergency ISA pools which 
can't be done under spinlock. This is happening because the code in 
blk_queue_bounce_limit now thinks that a 32-bit DMA mask requires 
allocating with GFP_DMA. This is only needed for a DMA mask less than 
32-bit, which is what the original code did. It looks like this was 
broken by this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=00d61e3e8c12d5f395b167856d2b3c430816afb0

author	Andrea Arcangeli <andrea@qumranet.com>
	Wed, 2 Apr 2008 07:06:44 +0000 (09:06 +0200)
committer	Jens Axboe <jens.axboe@oracle.com>
	Wed, 2 Apr 2008 07:06:44 +0000 (09:06 +0200)

Fix bounce setting for 64-bit

Not sure what this was intended to fix, but I don't think it's right..
