Return-Path: <linux-kernel-owner+w=401wt.eu-S1422663AbXCNVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422663AbXCNVdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422670AbXCNVdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 17:33:19 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52150 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422663AbXCNVdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 17:33:19 -0400
Date: Wed, 14 Mar 2007 22:33:17 +0100
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Ashif Harji <asharji@cs.uwaterloo.ca>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] mm/filemap.c: unconditionally call mark_page_accessed
Message-ID: <20070314213317.GA22234@rhlx01.hs-esslingen.de>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca> <20070312142012.GH30777@atrey.karlin.mff.cuni.cz> <20070312143900.GB6016@wotan.suse.de> <20070312151355.GB23532@duck.suse.cz> <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca> <20070312173500.GF23532@duck.suse.cz> <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca> <20070313185554.GA5105@duck.suse.cz> <Pine.GSO.4.64.0703141218530.28958@cpu102.cs.uwaterloo.ca> <1173905741.8763.36.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173905741.8763.36.camel@kleikamp.austin.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 14, 2007 at 03:55:41PM -0500, Dave Kleikamp wrote:
> On Wed, 2007-03-14 at 15:58 -0400, Ashif Harji wrote:
> > This patch unconditionally calls mark_page_accessed to prevent pages, 
> > especially for small files, from being evicted from the page cache despite 
> > frequent access.
> 
> I guess the downside to this is if a reader is reading a large file, or
> several files, sequentially with a small read size (smaller than
> PAGE_SIZE), the pages will be marked active after just one read pass.
> My gut says the benefits of this patch outweigh the cost.  I would
> expect real-world backup apps, etc. to read at least PAGE_SIZE.

I also think that the patch is somewhat problematic, since the original
intention seems to have been a reduction of the number of (expensive?)
mark_page_accessed() calls, but this of course falls flat on its face in case
of permanent single-page accesses or accesses with progressing but very small
read size (single-byte reads or so), since the cached page content will expire
eventually due to lack of mark_page_accessed() updates; thus this patch
decided to call mark_page_accessed() unconditionally which may be a large
performance penalty for subsequent tiny-sized reads.

I've been thinking hard how to avoid the mark_page_accessed() starvation in
case of a fixed, (almost) non-changing access state, but this seems hard since
it'd seem we need some kind of state management here to figure out good
intervals of when to call mark_page_accessed() *again* for this page. E.g.
despite non-changing access patterns you could still call mark_page_accessed()
every 32 calls or so to avoid expiry, but this would need extra helper
variables.

A rather ugly way to do it may be to abuse ra.cache_hit or ra.mmap_hit content
with a
	if ((prev_index != index) || (ra.cache_hit % 32 == 0))
		mark_page_accessed(page);
This assumes that ra.cache_hit gets incremented for every access (haven't
checked whether this is the case).
That way (combined with an enhanced comment properly explaining the dilemma)
you would avoid most mark_page_accessed() invocations of subsequent same-page reads
but still do page status updates from time to time to avoid page deprecation.

Does anyone think this would be acceptable? Any better idea?

Andreas Mohr

P.S.: since I'm not too familiar with this area I could be rather wrong after all...
