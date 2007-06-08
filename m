Return-Path: <linux-kernel-owner+w=401wt.eu-S970639AbXFHSQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970639AbXFHSQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031119AbXFHSQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:16:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40011 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031116AbXFHSQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:16:14 -0400
Date: Fri, 8 Jun 2007 11:16:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 00/12] Slab defragmentation V3
In-Reply-To: <466999A2.8020608@googlemail.com>
Message-ID: <Pine.LNX.4.64.0706081110580.1464@schroedinger.engr.sgi.com>
References: <20070607215529.147027769@sgi.com> <466999A2.8020608@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Michal Piotrowski wrote:

> bash shared mapping + your script in a loop
> while true;  do sudo ./run.sh; done > res3.txt

Hmmmm... Seems to be triggered from the reclaim path kmem_cache_defrag 
rather than the manual triggered one from the script. Taking the slub_lock 
on the reclaim path is an issue it seems.

Maybe we need to do a trylock in kmem_cache_defrag to defuse the 
situation? This is after all an optimization so we can bug out.

Does this fix it?

---
 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-06-08 11:12:40.000000000 -0700
+++ slub/mm/slub.c	2007-06-08 11:14:34.000000000 -0700
@@ -2738,7 +2738,9 @@ int kmem_cache_defrag(int percent, int n
 	unsigned long pages = 0;
 	void *scratch;
 
-	down_read(&slub_lock);
+	if (!down_read_trylock(&slub_lock))
+		return 0;
+
 	list_for_each_entry(s, &slab_caches, list) {
 
 		/*


