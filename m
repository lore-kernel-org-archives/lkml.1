Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbXHaH0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbXHaH0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 03:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXHaH0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 03:26:15 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22186 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXHaH0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 03:26:14 -0400
Date: Fri, 31 Aug 2007 09:26:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Dmitry Monakhov <dmonakhov@sw.ru>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [11/36] Use page_cache_xxx in fs/buffer.c
Message-ID: <20070831072611.GK29452@kernel.dk>
References: <20070828190551.415127746@sgi.com> <20070828190730.220393749@sgi.com> <20070830092038.GD22586@dnb.sw.ru> <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0708301843280.13292@schroedinger.engr.sgi.com> <20070831065613.GH29452@kernel.dk> <Pine.LNX.4.64.0708310003280.14375@schroedinger.engr.sgi.com> <20070831071142.GI29452@kernel.dk> <Pine.LNX.4.64.0708310012370.14375@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708310012370.14375@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31 2007, Christoph Lameter wrote:
> On Fri, 31 Aug 2007, Jens Axboe wrote:
> 
> > > Could you be more specific?
> > 
> > Size of a single segment, for instance. Or if the bio crosses a dma
> > boundary. If your block is 64kb and the maximum segment size is 32kb,
> > then you would need to clone the bio and split it into two.
> 
> A DMA boundary cannot be crossed AFAIK. The compound pages are aligned to 
> the power of two boundaries and the page allocator will not create pages 
> that cross the zone boundaries.

With a 64k page and a dma boundary of 0x7fff, that's two segments.

> It looks like the code will correctly signal a failure if you try to write 
> a 64k block on a device with a maximum segment size of 32k. Isnt this 
> okay? One would not want to use a larger block size than supported by the 
> underlying hardware?

That's just the size in sectors limitation again. And that also needs to
be handled, the fact that it currently errors out is reassuring but
definitely a long term solution. You don't want to knowingly setup such
a system where the fs block size is larger than what the hardware would
want, but it should work. You could be moving hardware around, for
recovery or otherwise.

> > Things like that. This isn't a problem with single page requests, as we
> > based the lower possible boundaries on that.
> 
> submit_bh() is used to submit a single buffer and I think that was our 
> main concern here.

And how large can that be?

-- 
Jens Axboe

