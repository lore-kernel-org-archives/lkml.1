Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbXBFR1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbXBFR1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933002AbXBFR1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:27:07 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:32891 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932999AbXBFR1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:27:05 -0500
Date: Tue, 6 Feb 2007 09:26:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, GOTO <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
In-Reply-To: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0702060925130.9812@schroedinger.engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007, KAMEZAWA Hiroyuki wrote:

> This means an access to NULL,here.
> ==
> unsigned slab_node(struct mempolicy *policy)
> {
>         case MPOL_BIND:
>                 /*
>                  * Follow bind policy behavior and start allocation at the
>                  * first node.
>                  */
>                 return zone_to_nid(policy->v.zonelist->zones[0]);
> }
> ==
> length of this zonelist was 0.
> It seems fixing a NULL access here is also O.K. 
> This patch is just an idea.

Hmmm... Remove the node from the node_online_map instead?

>  	}
> -	return nodes_subset(*nodes, node_online_map) ? 0 : -EINVAL;
> +	nodes_clear(node_with_memory);
> +	for_each_online_node(nd) {
> +		if (node_present_pages(nd))
> +			node_set(nd, node_with_memory);
> +	}
> +	return nodes_subset(*nodes, node_with_memory) ? 0 : -EINVAL;
>  }

Uhh. No loops here please. If we really need this then we need to have 
some sort of set operation here.


