Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbYCDPF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbYCDPF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbYCDPFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:05:46 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:37645 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbYCDPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:05:45 -0500
Subject: Re: [patch 12/21] No Reclaim LRU Infrastructure
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080304192441.1EA2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080228192908.126720629@redhat.com>
	 <20080228192929.031646681@redhat.com>
	 <20080304192441.1EA2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 04 Mar 2008 10:05:58 -0500
Message-Id: <1204643158.5338.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 19:46 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> sorry for late review.
> 
> > 
> > Index: linux-2.6.25-rc2-mm1/mm/Kconfig
> > ===================================================================
> > --- linux-2.6.25-rc2-mm1.orig/mm/Kconfig	2008-02-19 16:23:09.000000000 -0500
> > +++ linux-2.6.25-rc2-mm1/mm/Kconfig	2008-02-28 11:05:04.000000000 -0500
> > @@ -193,3 +193,13 @@ config NR_QUICK
> >  config VIRT_TO_BUS
> >  	def_bool y
> >  	depends on !ARCH_NO_VIRT_TO_BUS
> > +
> > +config NORECLAIM
> > +	bool "Track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"
> > +	depends on EXPERIMENTAL && 64BIT
> 
> as far as I remembered, somebody said CONFIG_NORECLAIM is easy confusable.
> may be..
> 
> IMHO insert "lru" word is better.
> example,
> 
> config NORECLAIM_LRU
> 	bool "Zone LRU of track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"
> 	depends on EXPERIMENTAL && 64BIT

OK.  But, I'd suggest the 'bool' description be something like:

config NORECLAIM_LRU
	bool "Add LRU list to track non-reclaimable pages (EXPERIMENTAL; 64BIT only)"

> 
> 
> > @@ -356,8 +380,10 @@ void release_pages(struct page **pages, 
> >  				zone = pagezone;
> >  				spin_lock_irqsave(&zone->lru_lock, flags);
> >  			}
> > -			VM_BUG_ON(!PageLRU(page));
> > -			__ClearPageLRU(page);
> > +			is_lru_page = PageLRU(page);
> > +			VM_BUG_ON(!(is_lru_page));
> > +			if (is_lru_page)
> > +				__ClearPageLRU(page);
> >  			del_page_from_lru(zone, page);
> >  		}
> 
> it seems unnecessary change??

Hmmm.  Not sure what I was thinking here.  Might be a relic of some
previous debug instrumentation.  Guess I don't have any problem with
removing this change.

Lee

