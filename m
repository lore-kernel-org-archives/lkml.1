Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbZBYQVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbZBYQVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbZBYQVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:21:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382AbZBYQVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:21:05 -0500
Date: Wed, 25 Feb 2009 08:19:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, penberg@cs.helsinki.fi, riel@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org,
       hannes@cmpxchg.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       ming.m.lin@intel.com, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 20/20] Get rid of the concept of hot/cold page freeing
Message-Id: <20090225081954.8776ba9b.akpm@linux-foundation.org>
In-Reply-To: <20090225160124.GA31915@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	<1235344649-18265-21-git-send-email-mel@csn.ul.ie>
	<20090223013723.1d8f11c1.akpm@linux-foundation.org>
	<20090223233030.GA26562@csn.ul.ie>
	<20090223155313.abd41881.akpm@linux-foundation.org>
	<20090224115126.GB25151@csn.ul.ie>
	<20090224160103.df238662.akpm@linux-foundation.org>
	<20090225160124.GA31915@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 16:01:25 +0000 Mel Gorman <mel@csn.ul.ie> wrote:

> ...
>
> > That would rub out the benefit which that microbenchmark
> > demonstrated?
> > 
> 
> It'd impact it for sure. Due to the non-temporal stores, I'm surprised
> there is any measurable impact from the patch.  This has likely been the
> case since commit 0812a579c92fefa57506821fa08e90f47cb6dbdd. My reading of
> this (someone correct/enlighten) is that even if the data was cache hot,
> it is pushed out as a result of the non-temporal access.

yup, that's my understanding.

> The changelog doesn't give the reasoning for using uncached accesses but maybe
> it's because for filesystem writes, it is not expected that the data will be
> accessed by the CPU any more and the storage device driver has less work to
> do to ensure the data in memory is not dirty in cache (this is speculation,
> I don't know for sure what the expected benefit is meant to be but it might
> be in the manual, I'll check later).
> 
> Thinking of alternative microbenchmarks that might show this up....

Well, 0812a579c92fefa57506821fa08e90f47cb6dbdd is beeing actively
discussed over in the "Performance regression in write() syscall"
thread.  There are patches there which disable the movnt for
less-than-PAGE_SIZE copies.  Perhaps adapt those to disable movnt
altogether to then see whether the use of movnt broke the advantages
which hot-cold-pages gave us?

argh.

Sorry to be pushing all this kernel archeology at you.  Sometimes I
think we're insufficiently careful about removing old stuff - it can
turn out that it wasn't that bad after all!  (cf slab.c...)

> Repeated setup, populate and teardown of pagetables might show up something
> as it should benefit if the pages were cache hot but the cost of faulting
> and zeroing might hide it.

Well, pagetables have been churning for years, with special-cased
magazining, quicklists, magazining of known-to-be-zeroed pages, etc.

I've always felt that we're doing that wrong, or at least awkwardly. 
If the magazining which the core page allocator does is up-to-snuff
then it _should_ be usable for pagetables.

The magazining of known-to-be-zeroed pages is a new requirement.  But
it absolutely should not be done private to the pagetable page
allocator (if it still is - I forget), because there are other
callsites in the kernel which want cache-hot zeroed pages, and there
are probably other places which free up known-to-be-zeroed pages.

