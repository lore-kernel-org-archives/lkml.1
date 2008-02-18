Return-Path: <linux-kernel-owner+w=401wt.eu-S1760938AbYBRUBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbYBRUBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbYBRUBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:01:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:14787 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbYBRUBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:01:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WWY7MsLTuUKlmLe01swrR4/+UMo3hhomBOkX+WDw+ZM0xvjjvJoD37wzDZR1uuiIwBvfDhzxFtXlWqsIsuf+EsveIuuLhS7zrcNsHZqkMuX6IXcU9iC3xwfxDHwOIDw00PYmOAT8rMSFnEDKeZAnztqohycRwRBeJX0ecFND9a4=
Message-ID: <6101e8c40802181201o4e997b4w1525281ec93072e1@mail.gmail.com>
Date: Mon, 18 Feb 2008 21:01:11 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y #2] quicklists: Only consider memory that can be used with GFP_KERNEL
Cc: "Oliver Pinter" <oliver.pntr@gmail.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Greg KH" <gregkh@suse.de>, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy. Dunlap" <rdunlap@xenotime.net>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Dave Jones" <davej@redhat.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>
In-Reply-To: <6101e8c40802170918x69a98d96n6c13e2c23f28acfb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40802170918x69a98d96n6c13e2c23f28acfb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From fcae8056673aa7b5b55d669fe5255ae76a93ae53 Mon Sep 17 00:00:00 2001
 From: Christoph Lameter <clameter@sgi.com>
 Date: Wed, 16 Jan 2008 00:21:19 +0530
 Subject: [PATCH] quicklists: Only consider memory that can be used
 with GFP_KERNEL
 
 patch 96990a4ae979df9e235d01097d6175759331e88c in mainline.
 
 Quicklists calculates the size of the quicklists based on the number of
 free pages.  This must be the number of free pages that can be allocated
 with GFP_KERNEL.  node_page_state() includes the pages in ZONE_HIGHMEM and
 ZONE_MOVABLE which may lead the quicklists to become too large causing OOM.
 
 Signed-off-by: Christoph Lameter <clameter@sgi.com>
 Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
 Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
 Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
 Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
 Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>
 
 diff --git a/mm/quicklist.c b/mm/quicklist.c
 index ae8189c..3f703f7 100644
 --- a/mm/quicklist.c
 +++ b/mm/quicklist.c
 @@ -26,9 +26,17 @@ DEFINE_PER_CPU(struct quicklist,
 quicklist)[CONFIG_NR_QUICK];
  static unsigned long max_pages(unsigned long min_pages)
  {
  	unsigned long node_free_pages, max;
 +	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
 +
 +	node_free_pages =
 +#ifdef CONFIG_ZONE_DMA
 +		zone_page_state(&zones[ZONE_DMA], NR_FREE_PAGES) +
 +#endif
 +#ifdef CONFIG_ZONE_DMA32
 +		zone_page_state(&zones[ZONE_DMA32], NR_FREE_PAGES) +
 +#endif
 +		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
 
 -	node_free_pages = node_page_state(numa_node_id(),
 -			NR_FREE_PAGES);
  	max = node_free_pages / FRACTION_OF_NODE_MEM;
  	return max(max, min_pages);
  }
 
 
 -- 
 Thanks,
 Oliver
