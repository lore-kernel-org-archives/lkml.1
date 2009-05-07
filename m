Return-Path: <linux-kernel-owner+w=401wt.eu-S1762420AbZEGPSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762420AbZEGPSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZEGPSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:18:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:43794 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZEGPS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:18:29 -0400
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
 class citizen
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20090507151039.GA2413@cmpxchg.org>
References: <20090430174536.d0f438dd.akpm@linux-foundation.org>
	 <20090430205936.0f8b29fc@riellaptop.surriel.com>
	 <20090430181340.6f07421d.akpm@linux-foundation.org>
	 <20090430215034.4748e615@riellaptop.surriel.com>
	 <20090430195439.e02edc26.akpm@linux-foundation.org>
	 <49FB01C1.6050204@redhat.com>
	 <20090501123541.7983a8ae.akpm@linux-foundation.org>
	 <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins>
	 <20090507121101.GB20934@localhost>  <20090507151039.GA2413@cmpxchg.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 07 May 2009 17:17:46 +0200
Message-Id: <1241709466.11251.164.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 17:10 +0200, Johannes Weiner wrote:

> > @@ -1269,8 +1270,15 @@ static void shrink_active_list(unsigned 
> >  
> >  		/* page_referenced clears PageReferenced */
> >  		if (page_mapping_inuse(page) &&
> > -		    page_referenced(page, 0, sc->mem_cgroup))
> > +		    page_referenced(page, 0, sc->mem_cgroup)) {
> > +			struct address_space *mapping = page_mapping(page);
> > +
> >  			pgmoved++;
> > +			if (mapping && test_bit(AS_EXEC, &mapping->flags)) {
> > +				list_add(&page->lru, &l_active);
> > +				continue;
> > +			}
> > +		}
> 
> Since we walk the VMAs in page_referenced anyway, wouldn't it be
> better to check if one of them is executable?  This would even work
> for executable anon pages.  After all, there are applications that cow
> executable mappings (sbcl and other language environments that use an
> executable, run-time modified core image come to mind).

Hmm, like provide a vm_flags mask along to page_referenced() to only
account matching vmas... seems like a sensible idea.

