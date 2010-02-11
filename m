Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0BKM7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:59:38 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58065 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab0BKM7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:59:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=SOu3yUzlNP2DNOO5pMdCyO1uKkI1uk7c6Rrl/CYxxVCGfhAPhPxx9w4oJ2ExM6+0Js
         D2NYSkS2yFxWWQV9DI5fT2qV3ZIe2dBuyK5xE7DtL+iu+Ce26C1mx+06ttZSi+si+y0u
         HrPWCa6VJ/0aXeBZK9bqUwLLli4OCtb7o2sok=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH 1/4] block: implement compatible DISCARD support
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
	<20100211122154.GA12417@infradead.org>
Date: Thu, 11 Feb 2010 15:59:31 +0300
In-Reply-To: <20100211122154.GA12417@infradead.org> (Christoph Hellwig's
	message of "Thu, 11 Feb 2010 07:21:54 -0500")
Message-ID: <87d40cq66k.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Feb 11, 2010 at 01:53:45PM +0300, Dmitry Monakhov wrote:
>> Currently there are no many discs has native TRIM (aka) discard
>> feature support. But in fact this is good feature. We can easily
>> simlulate it for devices which has not native support.
>> In compat mode discard dequest transforms in to simple zerofiled
>> write request.
>> In fact currently blkdev_issue_discard function implemented
>> incorrectly.
>> 1) Whait flags not optimal we dont have to wait for each bio in flight.
>
> Indeed.
>
>> 2) Not wait by default. Which makes it fairly useless.
>
> Not sure what you mean with that.  We do not need to wait for the
> discard request for the "online" type of use - the barrier flag
> means we can't re-order I/O before and after the request so there
> is no reason to wait - it stays in the places where it needs to be
> in the I/O stream.
I mean that it is impossible to know was it really successful or not.
We may just replace this function with this following function.
const char* make_me_hapy()
{
   return "you are happy already.";
}

AFAIK Currently there is no any generic block interface which send
io requests without ability to check the result. 
The question is should it be sync or async it is not easy to design
simple async interface so let's use sync by default
BTW: That's why blkdev_issue_barrier has to wait by default. 
>
>> 3) Send each bio with barrier flag(if requested). Which result in
>>    bad performance. In fact caller just want to make shure that full
>>    request is completed and ordered against other requests.
>
> Yes, we need to ensure ordering only against reordering with other
> requests.  Your patch only issues a cache flush, which means that
> we miss the queue drain before submitting the discard bios
Yes you right from theoretical point of view. But practically
It is hard to imagine that some one send something like this:
read_bio(sectcor,..)
discard_bio(sector,..BARRIER)
But off course you right, I'll add ability to pass pre_flush
barrier in next patch version.
>
>> 5) It use allocated_page instead of ZERO_PAGE.
>
> That's incorrect - both the scsi WRITE SAME and ATA UNMAP
> implementations write to the payload. 
WOW. What for?
> I have some plans to change that
> an get rid of the payload entirely, but I need to get back to the
> discard work and look at it in more detail.

>
>> This patch introduce generic blkdev_issue_zeroout() function which also
>> may be used for native discard request support, in this case zero payload
>> simply ignored.
>
> Which is a bit different from fixing efficiency issues in discard, I'd
> prefer that to be split into a separate patch, especially as there might
> be quite a bit of discussion on the zeroout behaviour.
Seems that you also right here. At list it is not obvious how we should
send compat_discard bios WRITE,WRITE_SYNC or WRITE_SYNC_PLUG?
But blkdev_issue_zeroout() interface allow all this flags.
let's wait a bit and i'll redesign the patchset correspondingly
>
> Note that a discard is not actually required to zero out data it
> has discarded, it's an optional feature in the command sets. 
Yes, i know. But zero payload will be used only by compat mode.
We assumes that default compat mode zero data on descard.
