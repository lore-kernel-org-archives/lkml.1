Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbYJ0R0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbYJ0R0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJ0R0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:26:05 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58371 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYJ0R0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:26:03 -0400
Subject: Re: [PATCH] memory hotplug: fix page_zone() calculation in
	test_pages_isolated()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: gerald.schaefer@de.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com
In-Reply-To: <4905F114.3030406@de.ibm.com>
References: <4905F114.3030406@de.ibm.com>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 10:25:59 -0700
Message-Id: <1225128359.12673.101.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 17:49 +0100, Gerald Schaefer wrote:
> My last bugfix here (adding zone->lock) introduced a new problem: Using
> pfn_to_page(pfn) to get the zone after the for() loop is wrong. pfn then
> points to the first pfn after end_pfn, which may be in a different zone
> or not present at all. This may lead to an addressing exception in
> page_zone() or spin_lock_irqsave().

I'm not sure I follow.  Let's look at the code, pre-patch:

> 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
>                 page = __first_valid_page(pfn, pageblock_nr_pages);
>                 if (page && get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
>                         break;
>         }
>         if (pfn < end_pfn)
>                 return -EBUSY;

We have two ways out of the loop:
1. 'page' is valid, and not isolated, so we did a 'break'
2. No page hit (1) in the range and we broke out of the loop because
   of the for() condition: (pfn < end_pfn).  

So, when the condition happens that you mentioned in your changelog
above: "pfn then points to the first pfn after end_pfn", we jump out at
the 'return -EBUSY;'.  We don't ever do pfn_to_page() in that case since
we've returned befoer.

Either 'page' is valid *OR* you return -EBUSY.  I don't think you need
to check both.

> Using the last valid page that was found inside the for() loop, instead
> of pfn_to_page(), should fix this.
> @@ -130,10 +130,10 @@ int test_pages_isolated(unsigned long st
> 		if (page && get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
> 			break;
> 	}
> -	if (pfn < end_pfn)
> +	if ((pfn < end_pfn) || !page)
> 		return -EBUSY;
> 	/* Check all pages are free or Marked as ISOLATED */
> -	zone = page_zone(pfn_to_page(pfn));
> +	zone = page_zone(page);

I think this patch fixes the bug, but for reasons other than what you
said. :)

The trouble here is that the 'pfn' could have been in the middle of a
hole somewhere, which __first_valid_page() worked around.  Since you
saved off the result of __first_valid_page(), it ends up being OK with
your patch.

Instead of using pfn_to_page() you could also have just called
__first_valid_page() again.  But, that would have duplicated a bit of
work, even though not much in practice because the caches are still hot.

Technically, you wouldn't even need to check the return from
__first_valid_page() since you know it has a valid result because you
made the exact same call a moment before.

Anyway, can you remove the !page check, fix up the changelog and resend?

-- Dave

