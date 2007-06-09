Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbXFIHz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbXFIHz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXFIHzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:55:21 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:60860 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbXFIHzU convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:55:20 -0400
Message-ID: <466A5CE3.7060307@de.ibm.com>
Date: Sat, 09 Jun 2007 09:55:15 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?UTF-8?B?SUJNIERldXRzY2hsYW5kIEVudHdpY2tsdW5nIEdtYkgsVm9ycw==?=
 =?UTF-8?B?aXR6ZW5kZXIgZGVzIEF1ZnNpY2h0c3JhdHM6IEpvaGFubiBXZWloZW4sR2VzY2g=?=
 =?UTF-8?B?w6RmdHNmw7xocnVuZzogSGVyYmVydCBLaXJjaGVyLFNpdHogZGVyIEdlc2VsbHM=?=
 =?UTF-8?B?Y2hhZnQ6IELDtmJsaW5nZW4sUmVnaXN0ZXJnZXJpY2h0OiBBbXRzZ2VyaWNodCA=?=
 =?UTF-8?B?U3R1dHRnYXJ0LCBIUkIgMjQzMjk0?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@lazybastard.org>
CC: carsteno@de.ibm.com, Christoph Hellwig <hch@infradead.org>,
       Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <46690A39.3010402@de.ibm.com> <20070608075717.GA16927@infradead.org> <46690C58.7090304@de.ibm.com> <20070608080401.GA17684@infradead.org> <6934efce0706080905h253d9e3apd4168c5d14d305e5@mail.gmail.com> <20070608160929.GA3366@infradead.org> <6934efce0706080911y601a8377oad7b1251a95acd64@mail.gmail.com> <20070608161526.GA3729@infradead.org> <20070608175152.GG20718@lazybastard.org> <4669A831.3040105@de.ibm.com> <20070608193606.GH20718@lazybastard.org>
In-Reply-To: <20070608193606.GH20718@lazybastard.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> Whenever writes/erases to the device happen, the device driver would
> need to call a function like
> 
> /**
>  * unmap_page_range - remove all mapping to the given range of an address space
>  * @mapping - the address space in question
>  * @start_index - index of the first page in the range
>  * @no_pages - number of pages to get unmapped
>  *
>  * Returns 0 on success or a negative errno value.
>  */
> int unmap_page_range(struct address_space *mapping, loff_t start_index,
> 		loff_t no_pages);
> 
> or implement something equivalent itself.  Your filesystem callback
> looks like it would be just that, although I may be misreading you.
No. That's how the callback could look alike.

> Either that or using standard mtd->read() and mtd->write() calls.  I see
> some advantages to mtd->write() in particular, as the device driver
> needs some notification to trigger unmap_page_range() before the actual
> write and chip state transitions happen.  mtd->write() seems much easier
> than something like
> 
> mtd->pre_write()
> get_xip_page()
> ...
> put_page()
> mtd->post_write()
> 
> If get_xip_page() only has userland consumers all the locking can be
> kept inside device drivers.
Hmmh. We won't need mtd->pre_write(), because the file system's 
get_xip_page aop will have to ask mtd for the address anyway similar 
to the way ext2_get_xip_page does call bdev_ops->direct_access.

If that call would pass the information whether the future access is 
read-only or read+write, the device driver could do its housekeeping.

I think we should also cover put_page() plus mtd->post_write() inside 
a put_xip_page() address space operation provided by the fs. This way 
calls are balanced, and we have stuff in a single place rather then 
duplicating code. The fs could rely on a generic implementation in 
filemap_xip in case it does'nt need to do its own magic here.

>> - the device driver can access page->count via a helper function 
>> provided by mm. This way, it can identify which pages are in use.
> 
> One of us is confused here.  The driver would have to check page->count
> for a large range of pages, usually the whole chip.  And it would have
> to tear down every single mapping before starting to write.  Is that
> possible and desirable to do with page->count?  Unsure.
That point was indeed confusing. Let my try again:

The only way, how an initial reference to a page can be retrieved, is 
from the driver by using a bdev_ops->direct_access alike call. The 
driver has to be able to check, if all references have been returned. 
That would be done in three steps:
1. stop handing out new references
2. use the unmap_page_range callback to get references for page table 
entries back
3. check if other (temporary) references are still handed out, wait 
until they get returned.

Using a helper function to look into page->count is a possible 
implementation for #3. And because the page->count cannot get changed 
while noone has a reference, I don't see a race condition in looping 
over all pages and checking page->count. This implementation has an 
advantage, if the device driver wants to make sure that a small page 
range is not accessed.

If the device driver needs to ensure that there are no references to 
any page on the enitre flash media, it might use a global counter to 
count the sum of references and save looping over all pages.

so long,
Carsten

