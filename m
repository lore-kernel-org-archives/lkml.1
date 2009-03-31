Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZCaJGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZCaJGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbZCaJFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:05:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:50920 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZCaJFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:05:50 -0400
Message-ID: <49D1DCE2.1050201@kernel.org>
Date: Tue, 31 Mar 2009 18:05:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc	cleanups
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <200903281451.01361.bzolnier@gmail.com> <20090328140405.GA2741@liondog.tnic> <49D08CEC.3010705@kernel.org> <49D0A985.7090307@panasas.com> <49D0FF56.3080205@kernel.org> <49D1D7A3.40303@panasas.com>
In-Reply-To: <49D1D7A3.40303@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 31 Mar 2009 09:05:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
> I hope you have not been working on stabilizing this code yet, I've
> just seen it this mornning (Israel time). It has obvious bugs, in
> the use of scatterlists.

Actually, I'm now and it's mostly working now.

> But before you go running to fix them. Don't. I don't like the
> scatter-list API at all. We where working hard to remove them from
> scsi and I don't like them for block layer either.
> 
> If it is for my personal needs then all I need is a simple: "I have
> this bio please attach it to a request". The reason I have a bio is
> because it comes from a filesystem and because I will be needing to
> use the raid engines that are bio based.
>
> I must have confused you with my blk_rq_map_pages() patches, these
> where made just as an example of the ugliness and fragility of not
> using bios. It was suppose to be a bad example, not to be
> accepted. (Hence the absence of my Singed-off-by:) Scatterlists are
> bad because they are two times too fat for what they do here, they
> need to be allocated, chained and slabbed, and finally they need to
> be converted to a bio. Working directly with a bio is the shortest
> route.

sgl or bvec doesn't make much of difference.  The only difference
between sgl and bvec is the extra entries for DMA mapping.  The
problem is that there needs to be common way to describe the pages.
The reason why the blk/bio mapping looks that complex is because all
four cases - user map/copy and kern map/copy - are similar but subtly
different.  Without a common medium to carry the list of pages, each
path ended up mixing what's common with what's different and thus the
not quite manageable code.

The reason why I want with sgl is because it's the sg mapping
iterator.  Other than that, using bvec or sgl wouldn't make any
difference.  All that's necessary is common carrier of page/offset/len
list.

But given the use of sgl there, I don't think the performance
arguments holds much ground.  How high performance or scalability is
required in PC bio map paths?  The added cost is at the most one more
sgl allocation and use of more sparse data structure which BTW
wouldn't be that large anyway.  Both aren't worth worrying about
considering how relative coldness of the path and other overhead of
doing IO.

If you think sgl is too heavy for things like this, the right way to
go is to introduce some generic mechanism to carry sg chunks and use
it in bio, but I don't think the overhead of the current sgl justifies
that.  If you have qualms about the sgl API, please clean it up.  I
just don't think bvec should be used outside of block/fs interface.
As I wrote before, non-FS users have no reason to worry about bio.
All it should think about is the requst it needs to issue and the
memory area it's gonna use as in/out buffers.  bio just doesn't have a
place there.

> I do not understand what was your intention for the
> blk_rq_map_kern_sgl() how's the user for it?

Well, the only in-kern user which was tinkering with rq/bio internals
was scsi_req_map_sg().  Do you have another user?

> BTW: now you absolutely must do something with the name of
> blk_rq_map_sg() which does not do any mapping and does not change
> request at all.

Heh... yeap, definitely.  Can you think of a good one?

Thanks.

-- 
tejun
