Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbXHaIi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbXHaIi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 04:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXHaIiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 04:38:14 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:8367 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbXHaIiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 04:38:12 -0400
Date: Fri, 31 Aug 2007 12:36:32 +0400
From: Dmitry Monakhov <dmonakhov@sw.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [11/36] Use page_cache_xxx in fs/buffer.c
Message-ID: <20070831083632.GA12619@dnb.acronis.ru>
Mail-Followup-To: Christoph Lameter <clameter@sgi.com>,
	Jens Axboe <jens.axboe@oracle.com>, torvalds@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	David Chinner <dgc@sgi.com>, Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Fengguang Wu <fengguang.wu@gmail.com>,
	swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
	"H. Peter Anvin" <hpa@zytor.com>, joern@lazybastard.org,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0708301843280.13292@schroedinger.engr.sgi.com> <20070831065613.GH29452@kernel.dk> <Pine.LNX.4.64.0708310003280.14375@schroedinger.engr.sgi.com> <20070831071142.GI29452@kernel.dk> <Pine.LNX.4.64.0708310012370.14375@schroedinger.engr.sgi.com> <20070831072611.GK29452@kernel.dk> <Pine.LNX.4.64.0708310028160.14632@schroedinger.engr.sgi.com> <20070831074338.GL29452@kernel.dk> <Pine.LNX.4.64.0708310049110.14743@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708310049110.14743@schroedinger.engr.sgi.com>
Organization: SWsoft.
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:52 Fri 31 Aug     , Christoph Lameter wrote:
> On Fri, 31 Aug 2007, Jens Axboe wrote:
> 
> > They have nothing to do with each other, you are mixing things up. It
> > has nothing to do with the device being able to dma into that memory or
> > not, we have fine existing infrastructure to handle that. But different
> > hardware have different characteristics on what a single segment is. You
> > can say "a single segment cannot cross a 32kb boundary". So from the
> > example above, your single 64k page may need to be split into two
> > segments. Or it could have a maximum segment size of 32k, in which case
> > it would have to be split as well.
> > 
> > Do you see what I mean now?
> 
> Ok. So another solution maybe to limit the blocksizes that can be used 
> with a device?
IMHO It is not good because after fs was created with big blksize it's image
cant be used on other devices. 
We may just rewrite submit_bh simular to drivers/md/dm-io.c:do_region
with following pseudocode:

remaning = super_page_size();
while (remaining) {
	init_bio(bio);
	/*Try and add as many pages as possible*/
	while (remaining) {
		dp->get_page(dp, &page, &len, &offset);
		len = min(len,
		to_bytes(remaining));
        	if(!bio_add_page(bio, page, len, offset))
		break;
        	offset = 0;
		remaining -= to_sector(len);
		dp->next_page(dp);
		}
	atomic_inc(&io->count);
	submit_bio(rw, bio);
}
> > > How do we split that up today? We could add processing to submit_bio
> > > to check for the boundary and create two bios.
> > 
> > But we do not split them up today - see what I wrote! Today we impose
> > the restriction that a device must be able to handle a single "normal"
> > page, and if it can't do that, it has to split it up itself.
> > 
> > But yes, you would have to create some out-of-line function to use
> > bio_split() until you have chopped things down enough. It's not a good
> > thing for performance naturally, but if we consider this a "just make it
> > work" fallback, I don't think it's too bad. You want to make a note of
> > that it is happening though, so people realize that it is happening.
> 
> Hmmmm.. We could keep the existing scheme too and check that device 
> drivers split things up if they are too large? Isnt it possible today
> to create a huge bio of 2M for huge pages and send it to a device?

