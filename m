Return-Path: <linux-kernel-owner+w=401wt.eu-S1030686AbXDLSgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030686AbXDLSgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030720AbXDLSgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:36:45 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:56305 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030685AbXDLSgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:36:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WrWzZbfYT1Nk21ulEhIkCCvCe72ALCkKxQEvpVJeWcczWtQ35fhdJGQa5v8fANQvKpOR4xmov27Ad5pZwrFVvBkvi9QxhhaqOe8gziRNs9pIGGC4s4iyt4Tc+8LzQ5bbrbb0o96lZALE/sj1grxDbXh6x/AThZr6Nm1zLrN9Z5s=
Message-ID: <5c49b0ed0704121136uce5b15ah3004cd19e44994f3@mail.gmail.com>
Date: Thu, 12 Apr 2007 11:36:42 -0700
From: "Nate Diller" <nate.diller@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [PATCH 1/17] cramfs: use read_mapping_page
Cc: "Christoph Hellwig" <hch@infradead.org>, "Andrew Morton" <akpm@osdl.org>,
       "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Kleikamp" <shaggy@austin.ibm.com>,
       "Anton Altaparmakov" <aia21@cantab.net>,
       "Evgeniy Dushistov" <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-dev@namesys.com
In-Reply-To: <Pine.LNX.4.64.0704121310090.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070412024938.27380.54538.patchbomb.py@localhost>
	 <20070412024938.27380.87060.patchbomb.py@localhost>
	 <20070412095428.GA22675@infradead.org>
	 <Pine.LNX.4.64.0704121310090.14457@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Thu, 12 Apr 2007, Christoph Hellwig wrote:
>
> > On Wed, Apr 11, 2007 at 07:49:38PM -0700, Nate Diller wrote:
> > > read_mapping_page_async() is going away, so convert its only user to
> > > read_mapping_page().  This change has not been benchmarked, however, in
> > > order to get real parallelism this wants something completely different,
> > > like __do_page_cache_readahead(), which is not currently exported.
> >
> > Why is read_mapping_page_async going away?  This probably needs a lot more
> > testing, and I'd be much happier if you split it out of the series and
> > sent it separately at the end.
>
> That function wasn't fully async anyway, as it would often sleep in
> lock_page(). AFAICT only in the special case of a partial written page
> would this function return a not yet uptodate page.

yes, exactly, the structure of read_cache_page() and friends is
totally not appropriate for doing async I/O to more than one page at a
time, and the whole point of the special treatment in cramfs was to
read 4 pages at once rather than synchronously reading each of the 4
seperately.  read_cache_page_async() is totally wrong for that use,
its purpose would be to get a reference to a single page that is
likely to be in cache already without having to take the page_lock.
Turns out nobody needs to do that, so there's no point in keeping it
around.

If the performance gain of reading all 4 pages at once would be worth
the effort, this code should be using __do_page_cache_readahead().
That function allocates all the pages first, then reads them in
asynchronously as a group.  It is currently not exported.

NATE
