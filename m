Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZF3A6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZF3A6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZF3A62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:58:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:10277 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZF3A62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:58:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,312,1243839600"; 
   d="scan'208";a="159825825"
Date: Tue, 30 Jun 2009 08:58:28 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "mel@csn.ul.ie" <mel@csn.ul.ie>, "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: + memory-hotplug-update-zone-pcp-at-memory-online.patch added
	to -mm tree
Message-ID: <20090630005828.GC21254@sli10-desk.sh.intel.com>
References: <200906291949.n5TJno8X028680@imap1.linux-foundation.org> <alpine.DEB.1.10.0906291814150.21956@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906291814150.21956@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 06:17:52AM +0800, Christoph Lameter wrote:
> On Mon, 29 Jun 2009, akpm@linux-foundation.org wrote:
> 
> > In my test, 128M memory is hot added, but zone's pcp batch is 0, which is
> > an obvious error.  When pages are onlined, zone pcp should be updated
> > accordingly.
> 
> Another side effect of the checks for unpopulated zones....?
Even for populated zones, the pcp should be updated as its value might not
be good as more memory is added.

> > diff -puN mm/page_alloc.c~memory-hotplug-update-zone-pcp-at-memory-online mm/page_alloc.c
> > --- a/mm/page_alloc.c~memory-hotplug-update-zone-pcp-at-memory-online
> > +++ a/mm/page_alloc.c
> > @@ -3135,6 +3135,31 @@ int zone_wait_table_init(struct zone *zo
> >  	return 0;
> >  }
> >
> > +static int __zone_pcp_update(void *data)
> > +{
> > +	struct zone *zone = data;
> > +	int cpu;
> > +	unsigned long batch = zone_batchsize(zone), flags;
> > +
> > +	for (cpu = 0; cpu < NR_CPUS; cpu++) {
> 
> foreach possible cpu?
Just follows zone_pcp_init(), do you think we should change that too?

> > +		struct per_cpu_pageset *pset;
> > +		struct per_cpu_pages *pcp;
> > +
> > +		pset = zone_pcp(zone, cpu);
> > +		pcp = &pset->pcp;
> > +
> > +		local_irq_save(flags);
> > +		free_pages_bulk(zone, pcp->count, &pcp->list, 0);
> 
> There are no pages in the pageset since the pcp batch is zero right?
It might not be zero for a populated zone, see above comments.

Thanks,
Shaohua
