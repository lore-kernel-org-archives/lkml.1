Return-Path: <linux-kernel-owner+w=401wt.eu-S1760559AbXHaP2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559AbXHaP2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbXHaP2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:28:39 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59305 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757404AbXHaP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:28:37 -0400
Date: Fri, 31 Aug 2007 08:28:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dmitry Monakhov <dmonakhov@sw.ru>
cc: Jens Axboe <jens.axboe@oracle.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [11/36] Use page_cache_xxx in fs/buffer.c
In-Reply-To: <20070831083632.GA12619@dnb.acronis.ru>
Message-ID: <Pine.LNX.4.64.0708310822570.16456@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0708301113170.7975@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0708301843280.13292@schroedinger.engr.sgi.com>
 <20070831065613.GH29452@kernel.dk> <Pine.LNX.4.64.0708310003280.14375@schroedinger.engr.sgi.com>
 <20070831071142.GI29452@kernel.dk> <Pine.LNX.4.64.0708310012370.14375@schroedinger.engr.sgi.com>
 <20070831072611.GK29452@kernel.dk> <Pine.LNX.4.64.0708310028160.14632@schroedinger.engr.sgi.com>
 <20070831074338.GL29452@kernel.dk> <Pine.LNX.4.64.0708310049110.14743@schroedinger.engr.sgi.com>
 <20070831083632.GA12619@dnb.acronis.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007, Dmitry Monakhov wrote:

> > Ok. So another solution maybe to limit the blocksizes that can be used 
> > with a device?
> IMHO It is not good because after fs was created with big blksize it's image
> cant be used on other devices. 

Ok so a raw copy of the partition would do this?

> We may just rewrite submit_bh simular to drivers/md/dm-io.c:do_region
> with following pseudocode:
> 
> remaning = super_page_size();

That would be compound_size(page)

> while (remaining) {
> 	init_bio(bio);
> 	/*Try and add as many pages as possible*/

This seems to be doing the same as get_user_pages() serializing the 
compound page.

> 	while (remaining) {
> 		dp->get_page(dp, &page, &len, &offset);
> 		len = min(len,
> 		to_bytes(remaining));
>         	if(!bio_add_page(bio, page, len, offset))
> 		break;
>         	offset = 0;
> 		remaining -= to_sector(len);
> 		dp->next_page(dp);
> 		}
> 	atomic_inc(&io->count);
> 	submit_bio(rw, bio);
> }

Another solution may be to not serialize but instead determine the maximum 
segment length and generate bios that reference various subsection of the
compound page of that length? That way you do not serialize and later 
coalesce again.
