Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbYHTSMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbYHTSMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYHTSL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:11:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37671 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYHTSL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:11:56 -0400
Subject: Re: [BUG] Make setup_zone_migrate_reserve() aware of overlapping
	nodes
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Adam Litke <agl@us.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       nacc <nacc@linux.vnet.ibm.com>, mel@csn.ul.ie, apw <apw@shadowen.org>,
       agl <agl@linux.vnet.ibm.com>
In-Reply-To: <1219252134.13885.25.camel@localhost.localdomain>
References: <1218837685.12953.11.camel@localhost.localdomain>
	 <1219252134.13885.25.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 Aug 2008 11:11:51 -0700
Message-Id: <1219255911.8960.41.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 12:08 -0500, Adam Litke wrote:
> I have gotten to the root cause of the hugetlb badness I reported back
> on August 15th.  My system has the following memory topology (note the
> overlapping node):
> 
> 	﻿Node 0 Memory: 0x8000000-0x44000000
> 	﻿Node 1 Memory: 0x0-0x8000000 0x44000000-0x80000000
> 
> setup_zone_migrate_reserve() scans the address range 0x0-0x8000000
> looking for a pageblock to move onto the MIGRATE_RESERVE list.  Finding
> no candidates, it happily continues the scan into 0x8000000-0x44000000.
> When a pageblock is found, the pages are moved to the MIGRATE_RESERVE
> list on the wrong zone.  Oops.

This eventually gets down into move_freepages() via:

	->setup_zone_migrate_reserve()
	 ->move_freepages_block()
	  ->move_freepages()
right?

It looks like there have been bugs in this area before in
move_freepages().  Should there be a more stringent check in *there*?
Maybe a warning?
> ﻿
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2512,6 +2512,10 @@ static void setup_zone_migrate_reserve(struct
> zone *zone)
>                                                         pageblock_order;
>  
>         for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
> +               /* Watch out for overlapping nodes */
> +               if (!early_pfn_in_nid(pfn, zone->node))
> +                       continue;

zone->node doesn't exist on !CONFIG_NUMA. :(

You probably want:

	if (!early_pfn_in_nid(pfn, zone_to_nid(zone)))
		continue;

Are you sure you need the "early_" variant here?  We're not using
early_pfn_valid() right below it.  I guess you could also use:

	if (!page_to_nid(page) != zone_to_nid(zone))
		continue;

-- Dave

