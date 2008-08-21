Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYHUKFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYHUKFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYHUKF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:05:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56549 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYHUKF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:05:27 -0400
Date: Thu, 21 Aug 2008 19:04:28 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of CPUs
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com, travis <travis@sgi.com>
In-Reply-To: <1219311154.8651.96.camel@twins>
References: <20080821002757.b7c807ad.akpm@linux-foundation.org> <1219311154.8651.96.camel@twins>
Message-Id: <20080821183648.22AF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thank you good point out!

> > @@ -41,8 +41,8 @@ static unsigned long max_pages(unsigned 
> >  
> >  	max = node_free_pages / FRACTION_OF_NODE_MEM;
> >  
> > -	num_cpus_per_node = cpus_weight_nr(node_to_cpumask(node));
> > -	max /= num_cpus_per_node;
> > +	node_cpumask = node_to_cpumask(node);
> > +	max /= cpus_weight_nr(node_cpumask);
> >  
> >  	return max(max, min_pages);
> >  }
> 
> humm, I thought we wanted to keep cpumask_t stuff away from our stack -
> since on insanely large SGI boxen (/me looks at mike) the thing becomes
> 512 bytes.

Hm, interesting.
I think following patch fill your point, right?

but I worry about it works on sparc64...


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/quicklist.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: b/mm/quicklist.c
===================================================================
--- a/mm/quicklist.c
+++ b/mm/quicklist.c
@@ -26,7 +26,10 @@ DEFINE_PER_CPU(struct quicklist, quickli
 static unsigned long max_pages(unsigned long min_pages)
 {
 	unsigned long node_free_pages, max;
-	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
+	int node = numa_node_id();
+	struct zone *zones = NODE_DATA(node)->node_zones;
+	int num_cpus_on_node;
+	node_to_cpumask_ptr(cpumask_on_node, node);
 
 	node_free_pages =
 #ifdef CONFIG_ZONE_DMA
@@ -38,6 +41,10 @@ static unsigned long max_pages(unsigned 
 		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
 
 	max = node_free_pages / FRACTION_OF_NODE_MEM;
+
+	num_cpus_on_node = cpus_weight_nr(*cpumask_on_node);
+	max /= num_cpus_on_node;
+
 	return max(max, min_pages);
 }
 


