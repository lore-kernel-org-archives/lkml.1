Return-Path: <linux-kernel-owner+w=401wt.eu-S1761912AbYDAVFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761912AbYDAVFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761352AbYDAVD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:03:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761346AbYDAVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:03:27 -0400
Date: Tue, 1 Apr 2008 13:52:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebmunson@us.ibm.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, agl@us.ibm.com
Subject: Re: [PATCH] hugetlb: vmstat events for huge page allocations
Message-Id: <20080401135204.d3aff907.akpm@linux-foundation.org>
In-Reply-To: <1206978548.8042.7.camel@grover.beaverton.ibm.com>
References: <1206978548.8042.7.camel@grover.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008 23:49:08 +0800
Eric B Munson <ebmunson@us.ibm.com> wrote:

> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -25,6 +25,12 @@
>  #define HIGHMEM_ZONE(xx)
>  #endif
>  
> +#ifdef CONFIG_HUGETLB_PAGE
> +#define HTLB_STATS	HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
> +#else
> +#define HTLB_STATS
> +#endif
> +
>  #define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
>  
>  enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
> @@ -36,7 +42,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		FOR_ALL_ZONES(PGSCAN_KSWAPD),
>  		FOR_ALL_ZONES(PGSCAN_DIRECT),
>  		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
> -		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
> +		PAGEOUTRUN, ALLOCSTALL, PGROTATED, HTLB_STATS
>  		NR_VM_EVENT_ITEMS
>  };

The requirement that HTLB_STATS not have a comma after it is just a bit too
weird, methinks.

I did this:

--- a/include/linux/vmstat.h
+++ a/include/linux/vmstat.h
@@ -25,11 +25,6 @@
 #define HIGHMEM_ZONE(xx)
 #endif
 
-#ifdef CONFIG_HUGETLB_PAGE
-#define HTLB_STATS	HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
-#else
-#define HTLB_STATS
-#endif
 
 #define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
 
@@ -42,7 +37,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		PAGEOUTRUN, ALLOCSTALL, PGROTATED, HTLB_STATS
+		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+#ifdef CONFIG_HUGETLB_PAGE
+		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 

