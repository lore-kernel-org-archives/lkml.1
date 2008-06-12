Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYFLTff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYFLTff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYFLTfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:35:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397AbYFLTfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:35:20 -0400
Date: Thu, 12 Jun 2008 12:34:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, paulmck@us.ibm.com
Subject: Re: [patch] radix-tree: fix small lockless radix-tree bug
Message-Id: <20080612123443.e4682b3f.akpm@linux-foundation.org>
In-Reply-To: <200806130503.45369.nickpiggin@yahoo.com.au>
References: <200806130503.45369.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 05:03:45 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> @@ -124,6 +175,17 @@ static void radix_tree_node_rcu_free(str
>  {
>  	struct radix_tree_node *node =
>  			container_of(head, struct radix_tree_node, rcu_head);
> +
> +	/*
> +	 * must only free zeroed nodes into the slab. radix_tree_shrink
> +	 * can leave us with a non-NULL entry in the first slot, so clear
> +	 * that here to make sure.
> +	 */
> +	tag_clear(node, 0, 0);
> +	tag_clear(node, 1, 0);
> +	node->slots[0] = NULL;
> +	node->count = 0;
> +
>  	kmem_cache_free(radix_tree_node_cachep, node);
>  }

oic, that stuff got moved from the synchronous case into the RCU callback
case.
