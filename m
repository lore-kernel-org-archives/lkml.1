Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYJBWVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYJBWVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYJBWUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:20:54 -0400
Received: from kroah.org ([198.145.64.141]:38916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752618AbYJBWUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:20:53 -0400
Date: Thu, 2 Oct 2008 15:17:45 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove completion from struct klist_node
Message-ID: <20081002221745.GC10485@kroah.com>
References: <20081002214308.GP13822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002214308.GP13822@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 03:43:08PM -0600, Matthew Wilcox wrote:
> 
> Removing the completion from klist_node reduces its size from 64 bytes
> to 28 on x86-64.  To maintain the semantics of klist_remove(), we add
> a single list of klist nodes which are pending deletion and scan them.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
>  include/linux/klist.h |    2 --
>  lib/klist.c           |   48 ++++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 44 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/klist.h b/include/linux/klist.h
> index 06c338e..989a335 100644
> --- a/include/linux/klist.h
> +++ b/include/linux/klist.h
> @@ -13,7 +13,6 @@
>  #define _LINUX_KLIST_H
>  
>  #include <linux/spinlock.h>
> -#include <linux/completion.h>
>  #include <linux/kref.h>
>  #include <linux/list.h>
>  
> @@ -41,7 +40,6 @@ struct klist_node {
>  	struct klist		*n_klist;
>  	struct list_head	n_node;
>  	struct kref		n_ref;
> -	struct completion	n_removed;
>  };
>  
>  extern void klist_add_tail(struct klist_node *n, struct klist *k);
> diff --git a/lib/klist.c b/lib/klist.c
> index cca37f9..2b609ee 100644
> --- a/lib/klist.c
> +++ b/lib/klist.c
> @@ -36,7 +36,7 @@
>  
>  #include <linux/klist.h>
>  #include <linux/module.h>
> -
> +#include <linux/sched.h>
>  
>  /**
>   * klist_init - Initialize a klist structure.
> @@ -77,7 +77,6 @@ static void add_tail(struct klist *k, struct klist_node *n)
>  static void klist_node_init(struct klist *k, struct klist_node *n)
>  {
>  	INIT_LIST_HEAD(&n->n_node);
> -	init_completion(&n->n_removed);
>  	kref_init(&n->n_ref);
>  	n->n_klist = k;
>  	if (k->get)
> @@ -140,12 +139,36 @@ void klist_add_before(struct klist_node *n, struct klist_node *pos)
>  }
>  EXPORT_SYMBOL_GPL(klist_add_before);
>  
> +struct klist_waiter {
> +	struct klist_waiter *next;
> +	struct klist_node *node;
> +	struct task_struct *process;
> +	int woken;
> +};

Why not use the built-in list.h functions here?

Other than that, looks good, thanks.

greg k-h
