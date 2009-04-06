Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZDFUfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZDFUfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbZDFUey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:34:54 -0400
Received: from mga10.intel.com ([192.55.52.92]:52356 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753841AbZDFUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:34:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,332,1235980800"; 
   d="scan'208";a="679250603"
Date: Mon, 6 Apr 2009 13:34:51 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/5] Block: Discard may need to allocate pages
Message-ID: <20090406203451.GA24758@linux.intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D8A3D7.5070507@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 03:28:07PM +0300, Boaz Harrosh wrote:
> > +	if (bio_has_data(bio))
> > +		__free_page(bio_page(bio));
> 
> Page freed which was allocated by the LLD

Not by the LLD.  By the ULD.

> blkdev_issue_discard() and blk_ioctl_discard() has half a page
> of common (and changing) code, could be done to use a common
> helper that sets policy about bio allocation sizes and such.

Sure, could be done.

> > -		req->q->prepare_discard_fn(req->q, req);
> > +		req->q->prepare_discard_fn(req->q, req, bio);
> 
> Allocation of bio page could be done commonly here.

Not all prepare_discard_fn() implementations need or want a bio page.
The CFA ERASE SECTORS command is a non-data command, for example.

> The prepare_discard_fn() is made to return the needed size. It is not as if we actually
> give the driver a choice about the allocation.

Umm ... prepare_discard_fn() needs to fill in the page.  I don't
understand what code you propose here.

> > -		bio = bio_alloc(GFP_KERNEL, 0);
> > +		bio = bio_alloc(GFP_KERNEL, 1);
> 
> This is deja vu, don't you think ;)

Yep.

> I have one question:
> 
> At [PATCH 4/5] and [PATCH 4/5] you do:
> +	struct page *page = alloc_page(GFP_KERNEL);
> 
> does that zero the alloced page? since if I understand correctly this page
> will go on the wire, a SW target on the other size could snoop random Kernel
> memory, is that allowed? OK I might be totally clueless here.

The prepare_discard_fn() is responsible for not leaking data.  The ATA
one does it via memset() to a 512 byte boundary.  The SCSI one
initialises the 24 bytes that it sends on the wire.  I don't think
either implementation leaks uninitialised data.
