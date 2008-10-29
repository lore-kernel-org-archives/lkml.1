Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYJ2CZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYJ2CZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 22:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYJ2CYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 22:24:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13756 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYJ2CYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 22:24:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=cellWI9vZ40nkFL+ybEW7GvvNmE53jUDPq//O4YJTUjVocArFTG1HcsiE/vrA8e38
	I9Wj4F1LpJ05IBUj+yIng==
Date: Tue, 28 Oct 2008 19:24:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] cpusets: add dirty map to struct address_space
In-Reply-To: <alpine.DEB.1.10.0810281722290.23743@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0810281922320.32430@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com> <1225215459.15763.33.camel@lappy.programming.kicks-ass.net> <alpine.DEB.1.10.0810281337530.6470@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0810281722290.23743@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, David Rientjes wrote:

> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2413,10 +2413,7 @@ EXPORT_SYMBOL_GPL(cpuset_mem_spread_node);
>  #if MAX_NUMNODES > BITS_PER_LONG
>  /*
>   * Special functions for NUMA systems with a large number of nodes.  The
> - * nodemask is pointed to from the address_space structure.  The attachment of
> - * the dirty_nodes nodemask is protected by the tree_lock.  The nodemask is
> - * freed only when the inode is cleared (and therefore unused, thus no locking
> - * is necessary).
> + * nodemask is pointed to from the address_space structure.
>   */
>  void cpuset_update_dirty_nodes(struct address_space *mapping,
>  			       struct page *page)
> @@ -2424,14 +2421,18 @@ void cpuset_update_dirty_nodes(struct address_space *mapping,
>  	nodemask_t *nodes = mapping->dirty_nodes;
>  	int node = page_to_nid(page);
>  
> +	spin_lock_irq(&mapping->dirty_nodes_lock);
>  	if (!nodes) {
>  		nodes = kmalloc(sizeof(nodemask_t), GFP_ATOMIC);
> -		if (!nodes)
> +		if (!nodes) {
> +			spin_unlock_irq(&mapping->dirty_nodes_lock);
>  			return;
> +		}
>  
>  		*nodes = NODE_MASK_NONE;
>  		mapping->dirty_nodes = nodes;
>  	}
> +	spin_unlock_irq(&mapping->dirty_nodes_lock);
>  	node_set(node, *nodes);
>  }
>  

Would need to be

	spin_lock_irq(&mapping->dirty_nodes_lock);
	nodes = mapping->dirty_nodes;
	if (!nodes) {
		nodes = kmalloc(sizeof(nodemask_t), GFP_ATOMIC);
		if (!nodes) {
			spin_unlock_irq(&mapping->dirty_nodes_lock);
			return;
		}
		...
	}
	spin_unlock_irq(&mapping->dirty_nodes_lock);

but this shouldn't add much locking overhead without mapping->tree_lock.
