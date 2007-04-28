Return-Path: <linux-kernel-owner+w=401wt.eu-S965838AbXD1Ohx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838AbXD1Ohx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965839AbXD1Ohx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:37:53 -0400
Received: from holomorphy.com ([66.93.40.71]:48711 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965838AbXD1Ohw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:37:52 -0400
Date: Sat, 28 Apr 2007 07:37:53 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070428143753.GV19966@holomorphy.com>
References: <20070427163620.GI32602149@melbourne.sgi.com> <20070427173432.GJ32602149@melbourne.sgi.com> <20070427121108.9ee05710.akpm@linux-foundation.org> <20070428031739.GK32602149@melbourne.sgi.com> <20070427215634.325606a9.akpm@linux-foundation.org> <20070428104328.0b609fb6@the-village.bc.nu> <20070428025801.eca77146.akpm@linux-foundation.org> <20070428112117.6170f581@the-village.bc.nu> <20070428032530.2e9c9e55.akpm@linux-foundation.org> <20070428122908.58f81808@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428122908.58f81808@the-village.bc.nu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 12:29:08PM +0100, Alan Cox wrote:
> Not neccessarily. If you use 16K contiguous pages you have to do
> more work to get memory contiguously and you have less cache efficiency
> both of which will do serious damage to performance with poor I/O
> subsystems for all the extra paging and I/O, and probably way more than
> sglist stuff on PC class boxes. (yes its probably a win on your 32GB SGI
> monster)

Some of this happens anyway with readahead window sizes and the like.
jejb's also seen gains from my fiddling with mm/page_alloc.c so that
pages come out in the right order (which has since regressed and they
don't anymore; odds are s/list_add/list_add_tail/ in one or two places
will fix it), though that didn't involve crappy controllers.

It may be that readahead needs to be less aggressive for PC class boxes,
but I expect that's already been dealt with.


On Sat, Apr 28, 2007 at 12:29:08PM +0100, Alan Cox wrote:
> That aside you are improving things for most but not all half-assed
> controllers (some sglists are simply page pointers for each 4K page or
> have different efficient encoding for page sized chunks (I2O). If you are
> reading large chunks on a really crap controller (eg IDE in PIO) then the
> fact you pull 16K when you need 4K will also wipe out any gains.

Sorry about the "back to basics" bit here, but...

It might help me to follow the discussion if what's meant by a "crappy
controller" could be clarified. The notion I had in mind to date was
poor or absent support for scatter gather, where deficiencies can take
the form of limited sglist element size, limited sglist length, or gross
inefficiency in processing large sglists (e.g. implemented internally as
a series of requests, one for each sglist element).

I would think that the gains from cramming larger amounts of data into
an individual command would largely be due to avoiding artificially
serializing IO so the speedup comes about from concurrent processing of
the IO within the controller or disk as opposed to, say, reducing the
overhead of issuing commands. Maybe clarifying why we expect larger IO's
to be faster would help, too.

Those clarifications might help more precisely define what issue all
this is meant to address.


-- wli
