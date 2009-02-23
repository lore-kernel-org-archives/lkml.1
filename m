Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZBWPd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZBWPd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZBWPdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:33:18 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:30038 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754315AbZBWPdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:33:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vBDgn7yRx9xilfR8JK/Uceege1Udk6s71GRr+hVImiRU03gpYYWOs/P7UcpVe4JMU2R+4SLJHjqYyGUba0TtjWyX030uxVCf5j1b3EnsL2ZIqnWFrq/LheSRJp25jycABSZZB9kA25Ve0Wm/p5x2+m/bkN61qUfeyLtJxm3yguI=  ;
X-YMail-OSG: v4X2YmkVM1n4x1uABlD6QkjiuXnqwbsCnQ7cEAdqyoWI9UJ7nNj02j7ig5nSEw3sGlXk4kfGJSfvBElUZM_B1KR5i0QcII0.oC13FRWd.t1xj7NT9MatCDzrGyW9u7XBdVYjy5Tq_CXP7_Yg9_c5iODlQYoDAu4mGVoN0yUPBTuMFedmVtZM4NkkzzExkA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 11/20] Inline get_page_from_freelist() in the fast-path
Date: Tue, 24 Feb 2009 02:32:37 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-12-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1235344649-18265-12-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240232.39140.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009 10:17:20 Mel Gorman wrote:
> In the best-case scenario, use an inlined version of
> get_page_from_freelist(). This increases the size of the text but avoids
> time spent pushing arguments onto the stack.

I'm quite fond of inlining ;) But it can increase register pressure as
well as icache footprint as well. x86-64 isn't spilling a lot more
registers to stack after these changes, is it?

Also,


> @@ -1780,8 +1791,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int
> order, if (!preferred_zone)
>  		return NULL;
>
> -	/* First allocation attempt */
> -	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
> +	/* First allocation attempt. Fastpath uses inlined version */
> +	page = __get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
>  			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
>  			preferred_zone, migratetype);
>  	if (unlikely(!page))

I think in a common case where there is background reclaim going on,
it will be quite common to fail this, won't it? (I haven't run
statistics though).

In which case you will get extra icache footprint. What speedup does
it give in the cache-hot microbenchmark case?

