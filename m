Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbXE3I0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbXE3I0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXE3I0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:26:45 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:42046 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXE3I0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:26:44 -0400
Date: Wed, 30 May 2007 09:26:40 +0100 (IST)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Christoph Lameter <clameter@sgi.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 7/7] Add /proc/sys/vm/compact_node for the explicit
 compaction of a node
In-Reply-To: <Pine.LNX.4.64.0705292109460.29854@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705300920150.16108@skynet.skynet.ie>
References: <20070529173609.1570.4686.sendpatchset@skynet.skynet.ie>
 <20070529173830.1570.91184.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0705292109460.29854@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Christoph Lameter wrote:

> On Tue, 29 May 2007, Mel Gorman wrote:
>
>> +	if (nodeid < 0)
>> +		return -EINVAL;
>> +
>> +	pgdat = NODE_DATA(nodeid);
>> +	if (!pgdat || pgdat->node_id != nodeid)
>> +		return -EINVAL;
>
> You cannot pass an arbitrary number to node data since NODE_DATA may do a
> simple array lookup.
>
> Check for node < nr_node_ids first.
>

Very good point. Will fix

> pgdat->node_id != nodeid? Sounds like something you should BUG() on.
>

On non-NUMA, NODE_DATA(anything) returns contig_page_data. I was catching 
where the node ID's didn't match up because node 0 was always returned. 
Checking nr_node_ids is the correct way of doing this.

It's not a BUG() if bad ID is passed in here because we're checking user 
input. By returning -EINVAL the proc writer knows something bad happened 
without making a big deal about it.

> IA64's NODE_DATA is
>
> struct ia64_node_data {
>        short                   active_cpu_count;
>        short                   node;
>        struct pglist_data      *pg_data_ptrs[MAX_NUMNODES];
> };
>
> /*
> * Given a node id, return a pointer to the pg_data_t for the node.
> *
> * NODE_DATA    - should be used in all code not related to system
> *                initialization. It uses pernode data structures to minimize
> *                offnode memory references. However, these structure are not
> *                present during boot. This macro can be used once cpu_init
> *                completes.
> */
> #define NODE_DATA(nid)          (local_node_data->pg_data_ptrs[nid])
>
> x86_64 also does
>
> #define NODE_DATA(nid)          (node_data[nid])
>

All spot on. Will fix.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
