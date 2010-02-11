Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0BKMV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:21:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab0BKMVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:21:55 -0500
Date: Thu, 11 Feb 2010 07:21:54 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH 1/4] block: implement compatible DISCARD support
Message-ID: <20100211122154.GA12417@infradead.org>
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 01:53:45PM +0300, Dmitry Monakhov wrote:
> Currently there are no many discs has native TRIM (aka) discard
> feature support. But in fact this is good feature. We can easily
> simlulate it for devices which has not native support.
> In compat mode discard dequest transforms in to simple zerofiled
> write request.
> In fact currently blkdev_issue_discard function implemented
> incorrectly.
> 1) Whait flags not optimal we dont have to wait for each bio in flight.

Indeed.

> 2) Not wait by default. Which makes it fairly useless.

Not sure what you mean with that.  We do not need to wait for the
discard request for the "online" type of use - the barrier flag
means we can't re-order I/O before and after the request so there
is no reason to wait - it stays in the places where it needs to be
in the I/O stream.

> 3) Send each bio with barrier flag(if requested). Which result in
>    bad performance. In fact caller just want to make shure that full
>    request is completed and ordered against other requests.

Yes, we need to ensure ordering only against reordering with other
requests.  Your patch only issues a cache flush, which means that
we miss the queue drain before submitting the discard bios

> 5) It use allocated_page instead of ZERO_PAGE.

That's incorrect - both the scsi WRITE SAME and ATA UNMAP
implementations write to the payload.  I have some plans to change that
an get rid of the payload entirely, but I need to get back to the
discard work and look at it in more detail.

> This patch introduce generic blkdev_issue_zeroout() function which also
> may be used for native discard request support, in this case zero payload
> simply ignored.

Which is a bit different from fixing efficiency issues in discard, I'd
prefer that to be split into a separate patch, especially as there might
be quite a bit of discussion on the zeroout behaviour.

Note that a discard is not actually required to zero out data it
has discarded, it's an optional feature in the command sets. 

