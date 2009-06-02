Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbZFBNe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbZFBNe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZFBNeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:34:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55145 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbZFBNeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:34:18 -0400
Date: Tue, 2 Jun 2009 15:41:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090602134126.GM1065@one.firstfloor.org>
References: <20090528095934.GA10678@localhost> <20090528122357.GM6920@wotan.suse.de> <20090528135428.GB16528@localhost> <20090601115046.GE5018@wotan.suse.de> <20090601183225.GS1065@one.firstfloor.org> <20090602120042.GB1392@wotan.suse.de> <20090602124757.GG1065@one.firstfloor.org> <20090602125713.GG1392@wotan.suse.de> <20090602132538.GK1065@one.firstfloor.org> <20090602132441.GC6262@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602132441.GC6262@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 03:24:41PM +0200, Nick Piggin wrote:
> On Tue, Jun 02, 2009 at 03:25:38PM +0200, Andi Kleen wrote:
> > On Tue, Jun 02, 2009 at 02:57:13PM +0200, Nick Piggin wrote:
> > > > > not a big deal and just avoids duplicating code. I attached an
> > > > > (untested) patch.
> > > > 
> > > > Thanks. But the function in the patch is not doing the same what
> > > > the me_pagecache_clean/dirty are doing. For once there is no error
> > > > checking, as in the second try_to_release_page()
> > > > 
> > > > Then it doesn't do all the IO error and missing mapping handling.
> > > 
> > > Obviously I don't mean just use that single call for the entire
> > > handler. You can set the EIO bit or whatever you like. The
> > > "error handling" you have there also seems strange. You could
> > > retain it, but the page is assured to be removed from pagecache.
> > 
> > The reason this code double checks is that someone could have 
> > a reference (remember we can come in any time) we cannot kill immediately.
> 
> Can't kill what? The page is gone from pagecache. It may remain
> other kernel references, but I don't see why this code will
> consider this as a failure (and not, for example, a raised error
> count).

It's a failure because the page was still used and not successfully
isolated.

> +        * remove_from_page_cache assumes (mapping && !mapped)
> +        */
> +       if (page_mapping(p) && !page_mapped(p)) {

Ok you're right. That one is not needed. I will remove it.

> > 
> > User page tables was on the todo list, these are actually relatively
> > easy. The biggest issue is to detect them.
> > 
> > Metadata would likely need file system callbacks, which I would like to 
> > avoid at this point.
> 
> So I just don't know why you argue the point that you have lots
> of large holes left.

I didn't argue that. My point was just that I currently don't have
data what holes are the worst on given workloads. If I figure out at
some point that writeback pages are a significant part of some important
workload I would be interested in tackling them.
That said I think that's unlikely, but I'm not ruling it out.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
