Return-Path: <linux-kernel-owner+w=401wt.eu-S932507AbXIEQYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbXIEQYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbXIEQYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:24:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114AbXIEQYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:24:30 -0400
Message-ID: <46DED83A.8070104@redhat.com>
Date: Wed, 05 Sep 2007 12:24:26 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel 2.6.22: what IS the VM doing?
References: <20070830115429.w2puzet5sllhccdk@m.safari.iki.fi> <46DE085F.2040306@redhat.com> <20070905114545.2hydqpasqx56afkf@m.safari.iki.fi>
In-Reply-To: <20070905114545.2hydqpasqx56afkf@m.safari.iki.fi>
Content-Type: multipart/mixed;
 boundary="------------080300030305040306080805"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080300030305040306080805
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sami Farin wrote:
> On Tue, Sep 04, 2007 at 21:37:35 -0400, Rik van Riel wrote:
>> Is the system trying to evict pages like crazy when your
>> system becomes unusable?
> 
> I think so..
> 
>> If so, I wonder if kswapd is simply doing the wrong thing
>> and trying to evict data from all zones, simply because the
>> highmem zone is low on free pages...
> 
> *shrug*

The attached patch should make sure kswapd does not free an
excessive number of pages in zone_normal just because the
pages in zone_highmem are difficult to free.

It does give kswapd a large margin to continue putting equal
pressure on all zones in normal situations.

Sami, could you try out this patch to see if it helps your
situation?

Signed-off-by: Rik van Riel <riel@redhat.com>

--------------080300030305040306080805
Content-Type: text/x-patch;
 name="linux-2.6-excessive-pageout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6-excessive-pageout.patch"

--- linux-2.6.22.noarch/mm/vmscan.c.excessive	2007-09-05 12:19:49.000000000 -0400
+++ linux-2.6.22.noarch/mm/vmscan.c	2007-09-05 12:21:40.000000000 -0400
@@ -1371,7 +1371,13 @@ loop_again:
 			temp_priority[i] = priority;
 			sc.nr_scanned = 0;
 			note_zone_scanning_priority(zone, priority);
-			nr_reclaimed += shrink_zone(priority, zone, &sc);
+			/*
+			 * We put equal pressure on every zone, unless one
+			 * zone has way too many pages free already.
+			 */
+			if (!zone_watermark_ok(zone, order, 8*zone->pages_high,
+						end_zone, 0))
+				nr_reclaimed += shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
 						lru_pages);

--------------080300030305040306080805--
