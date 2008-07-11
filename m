Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYGKUXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYGKUXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbYGKUXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:23:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbYGKUXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:23:19 -0400
Date: Fri, 11 Jul 2008 16:22:16 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: David Miller <davem@davemloft.net>
cc: fujita.tomonori@lab.ntt.co.jp, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
In-Reply-To: <20080711.124152.247767508.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0807111612270.8297@devserv.devel.redhat.com>
References: <20080711152054C.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0807110649510.16550@engineering.redhat.com>
 <20080711201558J.fujita.tomonori@lab.ntt.co.jp> <20080711.124152.247767508.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008, David Miller wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Fri, 11 Jul 2008 20:15:52 +0900
>
>> On Fri, 11 Jul 2008 06:52:09 -0400 (EDT)
>> Mikulas Patocka <mpatocka@redhat.com> wrote:
>>
>>> On Fri, 11 Jul 2008, FUJITA Tomonori wrote:
>>>
>>>> Yeah, IOMMUs can't guarantee that. The majority of architectures set
>>>> BIO_VMERGE_BOUNDARY to 0 so they don't hit this, I think.
>>>
>>> Yes, the architectures without IOMMU don't hit this problem.
>>
>> I meant that even if some architectures support IOMMUs, they set
>> BIO_VMERGE_BOUNDARY to 0.
>
> Keep in mind that these settings were added long before
> we supported segment boundary restrictions.
>
> Someone added code to handle segment boundaries, but didn't
> fix any of the block I/O layer infrastructure :-)
>
> Several platforms that have IOMMU but set these values to zero
> actually did so for another reason.  They considered being
> required to always merge page-adjacent mappings virtually too
> strong a requirement to meet %100 of the time.

It is broken on Sparc64 even without boundary restrictions --- if you skip 
over already allocated entry in IOMMU table, you don't merge too.

I'd just drop it, because these requirements seem to me too brittle to 
maintain. It is too easy to make bug here and too hard to check for it. 
Basically there are few independent code parts (I/O layer and 
arch-specific IOMMUs) that are attempting to do the same calculation and 
if they differ, the driver will crash. Even if we managed to fix it, 
someone will likely break it again after year or two :-(

Would it mean that nr_hw_segments entry in bio and request could be 
dropped too? Or is it used for some other purpose?


BTW.: what's the reason that by default (without any driver intervention) 
device DMA is restricted to cross 64k boundary?

Mikulas
