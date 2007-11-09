Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbXKIPpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbXKIPpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbXKIPpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:45:36 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37225 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753943AbXKIPpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:45:35 -0500
Date: Fri, 9 Nov 2007 07:45:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie>
 <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007, Mel Gorman wrote:

>  struct page * fastcall
>  __alloc_pages(gfp_t gfp_mask, unsigned int order,
>  		struct zonelist *zonelist)
>  {
> +	/*
> +	 * Use a temporary nodemask for __GFP_THISNODE allocations. If the
> +	 * cost of allocating on the stack or the stack usage becomes
> +	 * noticable, allocate the nodemasks per node at boot or compile time
> +	 */
> +	if (unlikely(gfp_mask & __GFP_THISNODE)) {
> +		nodemask_t nodemask;

Hmmm.. This places a potentially big structure on the stack. nodemask can 
contain up to 1024 bits which means 128 bytes. Maybe keep an array of 
gfp_thisnode nodemasks (node_nodemask?) and use node_nodemask[nid]?

> +
> +		return __alloc_pages_internal(gfp_mask, order,
> +			zonelist, nodemask_thisnode(numa_node_id(), &nodemask));

Argh.... GFP_THISNODE must use the nid passed to alloc_pages_node and 
*not* the local numa node id. Only if the node specified to alloc_pages 
nodes is -1 will this work.

