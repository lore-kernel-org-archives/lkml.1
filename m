Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbYBKW6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbYBKW6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758736AbYBKW5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:57:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758805AbYBKW5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:57:54 -0500
Date: Mon, 11 Feb 2008 14:56:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, andrea@qumranet.com, vegard.nossum@gmail.com
Subject: Re: [patch] avoid kmemcheck warning in epoll
Message-Id: <20080211145644.d940ad07.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802101323140.27286@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0802101323140.27286@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 13:32:01 -0800 (PST)
Davide Libenzi <davidel@xmailserver.org> wrote:

> Epoll calls rb_set_parent(n, n) to initialize the rb-tree node, but 
> rb_set_parent() accesses node's pointer in its code. This creates a 
> warning in kmemcheck (reported by Vegard Nossum) about an uninitialized 
> memory access. The warning is harmless since the following rb-tree node 
> insert is going to overwrite the node data. In any case I think it's 
> better to not have that happening at all, and fix it by properly 
> initializing the data.
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> 
> - Davide
> 
> 
> ---
>  fs/eventpoll.c         |    2 +-
>  include/linux/rbtree.h |   12 ++++++++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.mod/fs/eventpoll.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/eventpoll.c	2008-02-10 12:36:20.000000000 -0800
> +++ linux-2.6.mod/fs/eventpoll.c	2008-02-10 12:50:41.000000000 -0800
> @@ -260,7 +260,7 @@
>  /* Special initialization for the RB tree node to detect linkage */
>  static inline void ep_rb_initnode(struct rb_node *n)
>  {
> -	rb_set_parent(n, n);
> +	rb_init_node(n, n);
>  }
>  
>  /* Removes a node from the RB tree and marks it for a fast is-linked check */
> Index: linux-2.6.mod/include/linux/rbtree.h
> ===================================================================
> --- linux-2.6.mod.orig/include/linux/rbtree.h	2008-02-10 12:36:13.000000000 -0800
> +++ linux-2.6.mod/include/linux/rbtree.h	2008-02-10 12:51:57.000000000 -0800
> @@ -112,6 +112,18 @@
>  	struct rb_node *rb_node;
>  };
>  
> +/**
> + * rb_init_node - Initializes the node internal data
> + *
> + * @node: Pointer to the RB-Tree node
> + * @parent: Pointer to the parent node, or NULL
> + *
> + */
> +static inline void rb_init_node(struct rb_node *node, struct rb_node *parent)
> +{
> +	node->rb_parent_color = (unsigned long) parent;
> +	node->rb_left = node->rb_right = NULL;
> +}

Is epoll the only rbtree-using code which exhibits this problem?  If so,
what is epoll doing differently from all the others?
