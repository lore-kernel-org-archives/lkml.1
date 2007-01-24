Return-Path: <linux-kernel-owner+w=401wt.eu-S1751319AbXAXMdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbXAXMdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 07:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXAXMdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 07:33:49 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:37325 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbXAXMds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 07:33:48 -0500
Message-ID: <45B75208.90208@linux.vnet.ibm.com>
Date: Wed, 24 Jan 2007 18:03:12 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Aubrey Li <aubreylee@gmail.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Lameter wrote:
> This is a patch using some of Aubrey's work plugging it in what is IMHO
> the right way. Feel free to improve on it. I have gotten repeatedly
> requests to be able to limit the pagecache. With the revised VM statistics
> this is now actually possile. I'd like to know more about possible uses of
> such a feature.
> 
> 

[snip]

Hi Christoph,

With your patch, MMAP of a file that will cross the pagecache limit hangs the
system.  As I mentioned in my previous mail, without subtracting the
NR_FILE_MAPPED, the reclaim will infinitely try and fail.

I have tested your patch with the attached fix on my PPC64 box.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

---
 mm/page_alloc.c |    3 ++-
 mm/vmscan.c     |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.20-rc5.orig/mm/page_alloc.c
+++ linux-2.6.20-rc5/mm/page_alloc.c
@@ -1171,7 +1171,8 @@ zonelist_scan:
                                goto try_next_zone;

                if ((gfp_mask & __GFP_PAGECACHE) &&
-                               zone_page_state(zone, NR_FILE_PAGES) >
+                               (zone_page_state(zone, NR_FILE_PAGES) -
+                                zone_page_state(zone, NR_FILE_MAPPED)) >
                                        zone->max_pagecache_pages)
                                goto try_next_zone;

--- linux-2.6.20-rc5.orig/mm/vmscan.c
+++ linux-2.6.20-rc5/mm/vmscan.c
@@ -936,7 +936,8 @@ static unsigned long shrink_zone(int pri
         * If the page cache is too big then focus on page cache
         * and ignore anonymous pages
         */
-       if (sc->may_swap && zone_page_state(zone, NR_FILE_PAGES)
+       if (sc->may_swap && (zone_page_state(zone, NR_FILE_PAGES) -
+                       zone_page_state(zone, NR_FILE_MAPPED))
                        > zone->max_pagecache_pages)
                sc->may_swap = 0;
