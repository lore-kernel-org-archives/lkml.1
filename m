Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbXLLEER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbXLLEER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbXLLEDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:03:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758012AbXLLEDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:03:31 -0500
Date: Wed, 12 Dec 2007 05:03:28 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>, cotte@de.ibm.com
Subject: Re: [patch] mm: fix XIP file writes
Message-ID: <20071212040328.GA23914@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <20071204113549.GA6751@wotan.suse.de> <20071204130050.GB6751@wotan.suse.de> <200712101538.20619.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712101538.20619.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 03:38:20PM +0100, Christian Borntraeger wrote:
> Hi Nick,
> 
> > Here we go. See, brd already found a bug ;)
> > Can you apply the ext2 XIP patch too? And I'll resend the brd XIP patch.
> [...]
> > Writing to XIP files at a non-page-aligned offset results in data corruption
> > because the writes were always sent to the start of the page.
> [...]
> > @@ -314,7 +314,7 @@ __xip_file_write(struct file *filp, cons
> >  		fault_in_pages_readable(buf, bytes);
> >  		kaddr = kmap_atomic(page, KM_USER0);
> >  		copied = bytes -
> > -			__copy_from_user_inatomic_nocache(kaddr, buf, bytes);
> > +			__copy_from_user_inatomic_nocache(kaddr + offset, buf, bytes);
> >  		kunmap_atomic(kaddr, KM_USER0);
> >  		flush_dcache_page(page);
> 
> I asked myself why this problem never happened before. So I asked our testers
> to reproduce this problem on 2.6.23 and service levels. As the testcase did
> not trigger, I looked into the 2.6.23 code. This problem was introduced by
> commit 4a9e5ef1f4f15205e477817a5cefc34bd3f65f55 (mm: write iovec cleanup from
> Nick Piggin) during 2.6.24-rc:
> --------snip-------
> -		copied = filemap_copy_from_user(page, offset, buf, bytes);
> [...]
> +		copied = bytes -
> +			__copy_from_user_inatomic_nocache(kaddr, buf, bytes);
> -------------------
> 
> So yes, its good to have xip on brd. It even tests your changes ;-)
> Good news is, that we dont need anything for stable.

Heh ;) that explains a lot. Thanks!
