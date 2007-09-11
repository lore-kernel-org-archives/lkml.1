Return-Path: <linux-kernel-owner+w=401wt.eu-S1762805AbXIKITQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762805AbXIKITQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760614AbXIKITA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:19:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47014 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759586AbXIKIS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:18:59 -0400
Date: Tue, 11 Sep 2007 17:18:01 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mm] mm: Fix memory hotplug + sparsemem build.
In-Reply-To: <20070911072507.GB19260@linux-sh.org>
References: <20070911072507.GB19260@linux-sh.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070911170921.F137.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  	if (onlined_pages)
> -		node_set_state(zone->node, N_HIGH_MEMORY);
> +		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
>  
>  	setup_per_zone_pages_min();

Thanks Paul-san. 

I also have another issue around here.
(Kswapd doesn't run on memory less node now. It should run when
 the node has memory.)

I would like to merge them like following if you don't mind.


Bye.

---

Fix kswapd doesn't run when memory is added on memory-less-node.
Fix compile error of zone->node when CONFIG_NUMA is off.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>


---
 mm/memory_hotplug.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: current/mm/memory_hotplug.c
===================================================================
--- current.orig/mm/memory_hotplug.c	2007-09-07 18:08:07.000000000 +0900
+++ current/mm/memory_hotplug.c	2007-09-11 17:29:19.000000000 +0900
@@ -211,10 +211,12 @@ int online_pages(unsigned long pfn, unsi
 		online_pages_range);
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
-	if (onlined_pages)
-		node_set_state(zone->node, N_HIGH_MEMORY);
 
 	setup_per_zone_pages_min();
+	if (onlined_pages){
+		kswapd_run(zone_to_nid(zone));
+		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
+	}
 
 	if (need_zonelists_rebuild)
 		build_all_zonelists();
@@ -269,9 +271,6 @@ int add_memory(int nid, u64 start, u64 s
 		if (!pgdat)
 			return -ENOMEM;
 		new_pgdat = 1;
-		ret = kswapd_run(nid);
-		if (ret)
-			goto error;
 	}
 
 	/* call arch's memory hotadd */


-- 
Yasunori Goto 


