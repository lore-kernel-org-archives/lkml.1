Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0BKNJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 08:09:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab0BKNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:09:46 -0500
Date: Thu, 11 Feb 2010 08:09:45 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH 1/4] block: implement compatible DISCARD support
Message-ID: <20100211130945.GA7644@infradead.org>
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org> <20100211122154.GA12417@infradead.org> <87d40cq66k.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d40cq66k.fsf@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 03:59:31PM +0300, Dmitry Monakhov wrote:
> I mean that it is impossible to know was it really successful or not.
> We may just replace this function with this following function.
> const char* make_me_hapy()
> {
>    return "you are happy already.";
> }

Which is an entirely valid, although suboptimal implementation.

> AFAIK Currently there is no any generic block interface which send
> io requests without ability to check the result. 
> The question is should it be sync or async it is not easy to design
> simple async interface so let's use sync by default
> BTW: That's why blkdev_issue_barrier has to wait by default. 

This is going to kill performance.

> > That's incorrect - both the scsi WRITE SAME and ATA UNMAP
> > implementations write to the payload. 
> WOW. What for?

Becuase these commands contain ranges of to be flushed blocks
in their payload.

> > Which is a bit different from fixing efficiency issues in discard, I'd
> > prefer that to be split into a separate patch, especially as there might
> > be quite a bit of discussion on the zeroout behaviour.
> Seems that you also right here. At list it is not obvious how we should
> send compat_discard bios WRITE,WRITE_SYNC or WRITE_SYNC_PLUG?
> But blkdev_issue_zeroout() interface allow all this flags.
> let's wait a bit and i'll redesign the patchset correspondingly

The !wait case is ansynchronous, so WRITE seems fine.  The wait and
!barrier case is more interesting, as this one is very close to
synchrous write semantics.  But I'm not sure it's really worth
optimization for that, this case is not used for online discarding
but things like mkfs that have the filesystem for itself, or that
not yet merged background discard for xfs which doesn't care too
much about I/O priority.

