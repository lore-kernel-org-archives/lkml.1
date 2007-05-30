Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbXE3EOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbXE3EOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 00:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXE3EO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 00:14:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56215 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbXE3EO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 00:14:26 -0400
Date: Tue, 29 May 2007 21:14:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 7/7] Add /proc/sys/vm/compact_node for the explicit
 compaction of a node
In-Reply-To: <20070529173830.1570.91184.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0705292109460.29854@schroedinger.engr.sgi.com>
References: <20070529173609.1570.4686.sendpatchset@skynet.skynet.ie>
 <20070529173830.1570.91184.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Mel Gorman wrote:

> +	if (nodeid < 0)
> +		return -EINVAL;
> +
> +	pgdat = NODE_DATA(nodeid);
> +	if (!pgdat || pgdat->node_id != nodeid)
> +		return -EINVAL;

You cannot pass an arbitrary number to node data since NODE_DATA may do a 
simple array lookup.

Check for node < nr_node_ids first.

pgdat->node_id != nodeid? Sounds like something you should BUG() on.

IA64's NODE_DATA is

struct ia64_node_data {
        short                   active_cpu_count;
        short                   node;
        struct pglist_data      *pg_data_ptrs[MAX_NUMNODES];
};

/*
 * Given a node id, return a pointer to the pg_data_t for the node.
 *
 * NODE_DATA    - should be used in all code not related to system
 *                initialization. It uses pernode data structures to minimize
 *                offnode memory references. However, these structure are not
 *                present during boot. This macro can be used once cpu_init
 *                completes.
 */
#define NODE_DATA(nid)          (local_node_data->pg_data_ptrs[nid])

x86_64 also does

#define NODE_DATA(nid)          (node_data[nid])

