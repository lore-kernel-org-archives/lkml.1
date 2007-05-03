Return-Path: <linux-kernel-owner+w=401wt.eu-S1767273AbXECAKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767273AbXECAKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 20:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767277AbXECAKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 20:10:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767273AbXECAKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 20:10:12 -0400
Message-ID: <46392800.4090408@redhat.com>
Date: Wed, 02 May 2007 20:08:32 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/6] firewire: isochronous and asynchronous I/O
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <20070502192904.GB1248@infradead.org>
In-Reply-To: <20070502192904.GB1248@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>> +	for (i = 0; i < buffer->page_count; i++) {
>> +		buffer->pages[i] = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
>> +		if (buffer->pages[i] == NULL)
>> +			goto out_pages;
>> +
>> +		address = dma_map_page(card->device, buffer->pages[i],
>> +				       0, PAGE_SIZE, direction);
>> +		if (dma_mapping_error(address)) {
>> +			__free_page(buffer->pages[i]);
>> +			goto out_pages;
>> +		}
> 
> Are you sure using streaming dma mapping is safe here?  I don't see
> actual user in this patch, but doing the proper ownership protocol
> for them is quite difficult if you reuse them, and allocating them
> in kernelspace usually means you want to keep reusing them.

What other options are there?  The only user in the stack is the userspace 
interface, which lets you mmap the pages in the iso_buffer from an 
application.  The pages need to stay around and stay mapped as long as that 
buffer is mmapped by userspace.  The buffer can be several megabytes and I 
don't want to set up a kernel side virtual mapping for it.  The pages are only 
used for either outgoing or incoming data, never both, so device/driver 
ownership isn't too difficult to handle.

>> +#include <linux/kthread.h>
> 
> You don't actually seem to use this one ..
> 
>> +#include <asm/uaccess.h>
> 
> .. or this one ..
> 
>> +#include <asm/semaphore.h>
> 
> .. or this one.

Ah, right, I'll get rid of those.

>> +	retval = fw_core_add_address_handler(&topology_map,
>> +					     &topology_map_region);
>> +	BUG_ON(retval < 0);
>> +
>> +	retval = fw_core_add_address_handler(&registers,
>> +					     &registers_region);
>> +	BUG_ON(retval < 0);
>> +
>> +	/* Add the vendor textual descriptor. */
>> +	retval = fw_core_add_descriptor(&vendor_id_descriptor);
>> +	BUG_ON(retval < 0);
>> +	retval = fw_core_add_descriptor(&model_id_descriptor);
>> +	BUG_ON(retval < 0);
> 
> These kinds of bug checks look wrong.  Either the operations
> can't fail in which case they should not return an error value
> or you should handle them properly.

The fw_core_add_descriptor() checks that the descriptor block it's passed is 
internally consistent and is used for blocks passed in from userspace too.  In 
these two cases, the blocks are static const arrays in the driver and if 
fw_core_add_descriptor returns < 0 it's a bug in the driver.

> Both the previous and this patch contain quite a lot of GFP_ATOMIC
> allocation which are a sign of not having a very good layering.

Looking through the GFP_ATOMIC allocations, I see a couple that could be 
rolled back to GFP_KERNEL.  But I don't know that it means bad layering, I'm 
just typically using a GFP_ATOMIC kmalloc than, preallocating some fixed 
number of, say, packets or nodes or whatever.  For example, the old SBP-2 
(storage) driver uses a free-list of packets and grabs one from that list when 
the SCSI stacks asks it to send a request.  If that list is empty, it fails 
and lets the SCSI stack retry the command.  I'm using a GFP_ATOMIC kmalloc 
instead in that case, and I believe it's a better approach than implementing 
ad-hoc allocation data structures.

Thanks for the reviews, I'll look through your other emails.
Kristian
