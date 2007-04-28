Return-Path: <linux-kernel-owner+w=401wt.eu-S965953AbXD1Qko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965953AbXD1Qko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965961AbXD1Qko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:40:44 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:28057 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965949AbXD1Qjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dKsi6+mY1D6NMfWLRVtTEu6DTc3iNP636473ZdiZkwDTRGfhKQglDqhdfmK72YmMKd/hrFJsx2jE5Aiv32GW/vjbKo41YQDPohcUja2wIknbwgaqpVAc+rEKezuO3etEhtUwHkb8IEAvCFiY+eM17vcg0FjtGyuQQZUyC7pgqP0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: clameter@sgi.com
Subject: Re: [00/17] Large Blocksize Support V3
Date: Sat, 28 Apr 2007 19:39:27 +0300
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>
References: <20070424222105.883597089@sgi.com>
In-Reply-To: <20070424222105.883597089@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704281939.28868.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 01:21, clameter@sgi.com wrote:

> Rationales:
>
> 1. We have problems supporting devices with a higher blocksize than
>    page size. This is for example important to support CD and DVDs that
>    can only read and write 32k or 64k blocks. We currently have a shim
>    layer in there to deal with this situation which limits the speed
>    of I/O. The developers are currently looking for ways to completely
>    bypass the page cache because of this deficiency.
>
> 2. 32/64k blocksize is also used in flash devices. Same issues.
>
> 3. Future harddisks will support bigger block sizes that Linux cannot
>    support since we are limited to PAGE_SIZE. Ok the on board cache
>    may buffer this for us but what is the point of handling smaller
>    page sizes than what the drive supports?
>
> 4. Reduce fsck times. Larger block sizes mean faster file system checking.
>
> 5. Performance. If we look at IA64 vs. x86_64 then it seems that the
>    faster interrupt handling on x86_64 compensate for the speed loss due to
>    a smaller page size (4k vs 16k on IA64). Supporting larger block sizes
>    sizes on all allows a significant reduction in I/O overhead and
> increases the size of I/O that can be performed by hardware in a single
> request since the number of scatter gather entries are typically limited
> for one request. This is going to become increasingly important to support
> the ever growing memory sizes since we may have to handle excessively large
> amounts of 4k requests for data sizes that may become common soon. For
> example to write a 1 terabyte file the kernel would have to handle 256
> million 4k chunks.
>
> 6. Cross arch compatibility: It is currently not possible to mount
>    an 16k blocksize ext2 filesystem created on IA64 on an x86_64 system.
>    With this patch this becoems possible.
>

Hi. 

	I have a few questions about that patchset:

1) Is it possible for block device to assume that it will alway get big 
requests (and aligned by big blocksize) ?

2) Does metadata reading/writing occuress also using same big blocksize ?

3 If so, How __bread/__getblk are affrected? Does returned buffer_head point 
to whole block ?

And what do you think about mine design ?
I want to link parts of compound page through buffer_heads
So the head page's bh points to second page (tail page ) bh's, and from this 
bh it is possible to reference the page itself and so on.
(This will allow a compound page be physicly fragmented)


Best regards, 
	Maxim Levitsky

PS:

I ask questions since this patchset does matter to me, I really like to see 
this <= 4K limit lifted (all software limits are bad)
And finaly get good packet writing... I miss DirectCD much...
Altough >4K blocksizes are really only first step.
To make really fast packet writing, the UDF filesystem should be rewritten as 
well.
