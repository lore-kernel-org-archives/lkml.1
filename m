Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYJ1Rb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYJ1Rb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYJ1Rbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:31:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:37578 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYJ1Rbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:31:45 -0400
Subject: Re: [patch 3/7] mm: make page writeback obey cpuset constraints
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810280301300.15270@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0810280301300.15270@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:31:33 +0100
Message-Id: <1225215093.15763.25.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 09:08 -0700, David Rientjes wrote:

> +/*
> + * Calculate the limits relative to the current cpuset
> + *
> + * We do not disregard highmem because all nodes (except maybe node 0) have
> + * either all memory in HIGHMEM (32-bit) or all memory in non-HIGHMEM (64-bit).
> + * If we would disregard highmem, then cpuset throttling would not work on
> + * 32-bit.
> + */
> +int cpuset_populate_dirty_limits(struct dirty_limits *dl,
> +				 unsigned long *dirtyable_memory,
> +				 unsigned long *nr_mapped,
> +				 const nodemask_t *nodes)
> +{
> +	int node;
> +
> +	if (likely(!nodes || nodes_subset(node_online_map, *nodes)))
> +		return 0;
> +	for_each_node_mask(node, *nodes) {
> +		if (!node_online(node))
> +			continue;
> +		dl->nr_dirty += node_page_state(node, NR_FILE_DIRTY);
> +		dl->nr_unstable += node_page_state(node, NR_UNSTABLE_NFS);
> +		dl->nr_writeback += node_page_state(node, NR_WRITEBACK);
> +		dirtyable_memory +=

*dirtyable_memory perhaps?

> +			node_page_state(node, NR_ACTIVE_ANON) +
> +			node_page_state(node, NR_ACTIVE_FILE) +
> +			node_page_state(node, NR_INACTIVE_ANON) +
> +			node_page_state(node, NR_INACTIVE_FILE) +
> +			node_page_state(node, NR_FREE_PAGES);
> +		nr_mapped +=

idem?

> +			node_page_state(node, NR_FILE_MAPPED) +
> +			node_page_state(node, NR_ANON_PAGES);
> +	}
> +	return 1;
> +}



