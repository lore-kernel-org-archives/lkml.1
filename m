Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZFIMwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZFIMwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZFIMv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:51:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:11256 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbZFIMv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:51:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,331,1241420400"; 
   d="scan'208";a="152243782"
Date: Tue, 9 Jun 2009 20:51:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [10/16] HWPOISON: Handle poisoned pages in
	set_page_dirty()
Message-ID: <20090609125139.GE5589@localhost>
References: <20090603846.816684333@firstfloor.org> <20090603184644.190E71D0281@basil.firstfloor.org> <20090609095920.GD14820@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609095920.GD14820@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 05:59:20PM +0800, Nick Piggin wrote:
> On Wed, Jun 03, 2009 at 08:46:43PM +0200, Andi Kleen wrote:
> > 
> > Bail out early in set_page_dirty for poisoned pages. We don't want any
> > of the dirty accounting done or file system write back started, because
> > the page will be just thrown away.
> 
> I don't agree with adding overhead to fastpaths like this. Your
> MCE handler should have already taken care of this so I can't
> see what it can gain.

Agreed to remove this patch. The poisoned page should already be
isolated (in normal cases), and won't reach this code path.

Thanks,
Fengguang

> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > 
> > ---
> >  mm/page-writeback.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > Index: linux/mm/page-writeback.c
> > ===================================================================
> > --- linux.orig/mm/page-writeback.c	2009-06-03 19:36:20.000000000 +0200
> > +++ linux/mm/page-writeback.c	2009-06-03 19:36:23.000000000 +0200
> > @@ -1304,6 +1304,10 @@
> >  {
> >  	struct address_space *mapping = page_mapping(page);
> >  
> > +	if (unlikely(PageHWPoison(page))) {
> > +		SetPageDirty(page);
> > +		return 0;
> > +	}
> >  	if (likely(mapping)) {
> >  		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
> >  #ifdef CONFIG_BLOCK
