Return-Path: <linux-kernel-owner+w=401wt.eu-S965534AbXFGTh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534AbXFGTh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964926AbXFGThS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:37:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47699 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802AbXFGThR (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:37:17 -0400
Date: Thu, 7 Jun 2007 20:37:07 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, carsteno@de.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070607193707.GA17144@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com> <20070606161621.GA20247@infradead.org> <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 11:26:38AM -0700, Jared Hulbert wrote:
> >FYI: Cartsten had an xip fs for s390 aswell, and that evolved into
> >the filemap.c bits after a lot of rework an quite a few round of
> >review.
> 
> Right.  So now we leverage this filemap_xip.c in cramfs.  Why is this a 
> problem?

Using filemap_xip.c is of course good.  Hacking cramfs up to contain
totally different codepathes is not.

> >> What??  You mean like use xip_file_mmap() and implement
> >> get_xip_page()?  Did you read my latest patch?
> >
> >Yes.  This is the highlevel way to go, just please don't hack it into
> >cramfs.
> 
> Right, so this latest patch _does_ implement get_xip_page() and
> xip_file_mmap().  Why not hack it into cramfs?

cramfs used to be a block based filesystem.  You hack in support to
work directly on physical addresses.  Your create a lot of different
codepathes that are only used for one of the usecases.

Instead of just talking here I've hacked up a small demo on how this
should be approached.  I've taken cramfs with your modification and
remove all the support for block devices.  In addition we now could
rip out the mutex serializing all reads and clean up the way xip
support is hooked in.  The result is a slightly smaller and cleaner
filesystem that even more important doesn't require pulling in
the whole block layer which is especially important for embedded
devices at the lower end of the scala.  This is just a proof of
concept and thus is still named cramfs, no docs or copyrights etc
are updated.  It's still incomplete aswell because we'd probably
want a better selection of files to use xip for, and we'd need
a real API to talk to the lowlevel driver for xip instead of the
physical address hack.  I still think it'd be even better to just
hook xip support into jffs or logfs because they give you a full
featured flash filesystem for all needs without the complexity
of strictly partitioning between xip-capable and write parts
of your storage.

The code is at http://verein.lst.de/~hch/cramfs-xip.tar.gz.
