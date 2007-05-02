Return-Path: <linux-kernel-owner+w=401wt.eu-S2992973AbXEBJvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992973AbXEBJvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992980AbXEBJvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:51:12 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:50940 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992973AbXEBJvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:51:11 -0400
Message-ID: <46385F07.9070608@linux.vnet.ibm.com>
Date: Wed, 02 May 2007 15:21:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@sw.ru>
CC: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Chandra Seetharaman <sekharan@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rohit Seth <rohitseth@google.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 8/8] Per-container pages reclamation
References: <461A3010.90403@sw.ru> <461A397A.8080609@sw.ru>
In-Reply-To: <461A397A.8080609@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> Implement try_to_free_pages_in_container() to free the
> pages in container that has run out of memory.
> 
> The scan_control->isolate_pages() function isolates the
> container pages only.
> 
> +#ifdef CONFIG_RSS_CONTAINER
> +unsigned long try_to_free_pages_in_container(struct rss_container *cnt)
> +{
> +	struct scan_control sc = {
> +		.gfp_mask = GFP_KERNEL,
> +		.may_writepage = 1,
> +		.swap_cluster_max = 1,
> +		.may_swap = 1,
> +		.swappiness = vm_swappiness,
> +		.cnt = cnt,
> +		.isolate_pages = isolate_pages_in_container,
> +	};
> +	int node;
> +	struct zone **zones;
> +
> +	for_each_node(node) {
> +#ifdef CONFIG_HIGHMEM
> +		zones = NODE_DATA(node)->node_zonelists[ZONE_HIGHMEM].zones;
> +		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
> +			return 1;
> +#endif
> +		zones = NODE_DATA(node)->node_zonelists[ZONE_NORMAL].zones;
> +		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
> +			return 1;
> +	}
> +	return 0;
> +}
> +#endif
> +

Hi, Pavel,

This patch fixes a bug in the RSS controller, where we walk through all
nodes during reclaim in try_to_free_pages_in_container(). Instead of
for_each_node(), we now use for_each_online_node() so that we do not
end up with invalid zones from nodes that are not online.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

  mm/vmscan.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~rss-fix-nodescan mm/vmscan.c
--- linux-2.6.20/mm/vmscan.c~rss-fix-nodescan	2007-05-02 14:47:09.000000000 
+0530
+++ linux-2.6.20-balbir/mm/vmscan.c	2007-05-02 14:47:25.000000000 +0530
@@ -1127,7 +1127,7 @@ unsigned long try_to_free_pages_in_conta
  	int node;
  	struct zone **zones;

-	for_each_node(node) {
+	for_each_online_node(node) {
  #ifdef CONFIG_HIGHMEM
  		zones = NODE_DATA(node)->node_zonelists[ZONE_HIGHMEM].zones;
  		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
