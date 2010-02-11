Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0BKOGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:06:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51758 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab0BKOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:06:49 -0500
Date: Thu, 11 Feb 2010 09:06:48 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH 1/4] block: implement compatible DISCARD support
Message-ID: <20100211140648.GA13756@infradead.org>
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org> <20100211122154.GA12417@infradead.org> <87d40cq66k.fsf@openvz.org> <20100211130945.GA7644@infradead.org> <87tytnga3a.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tytnga3a.fsf@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 04:45:13PM +0300, Dmitry Monakhov wrote:
> >> The question is should it be sync or async it is not easy to design
> >> simple async interface so let's use sync by default
> >> BTW: That's why blkdev_issue_barrier has to wait by default. 
> In fact wait is the only interface for issue_barrier.
> > This is going to kill performance.
> But it may be reasonable to allow caller to choose would it
> wait and work fair, or to cheat in a name of performance.

It's not a cheat.  The discard is a _hint_ to the hardware that it
can reclaim space.  Think become a bit different when we start relying
on the zeroing behaviour for hardware that supports it, but so far
we don't.  And given that out of two TRIM capable devices I have one
does not reliably zero the trimmed regions I'm not sure it's a good
idea to rely on that yet, either.

> libata-scsi.c: ata_scsi_write_same_xlat
>                   ata_set_lba_range_entries
> It's was not obvious from the first glance. But it is the way how it
> works for now. But seems what we still optimize things a bit
> 1) alloc page with GFP_HIGHUSER (because x86 arch still used)

I'm not sure it's worth over-optimization this.

> 2) Share page between eight bios.

If we introduce the common completion handler for a batch of bios as
your patch does we can do that.

