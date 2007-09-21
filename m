Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbXIUUBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbXIUUBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761891AbXIUUBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:01:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:46200 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761306AbXIUUBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=mvIHtC5v3pnTYgDhbyjV6DQ+n2v2vJH3fLa3nVzjr3yrhieDl0cRsv/7a90MRd+cfvPpSEvHDy//qXyLXb6EQcS9ZPSleksvs38mqsNyXA7TGuWJu/1pWk8WLZIc9QJOnzXFQOMaKSSYY8TPEDarRpmLHT9FvO1u8nT1Pab3sPU=
Date: Sat, 22 Sep 2007 00:00:26 +0400
To: linux-kernel@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com, akpm@osdl.org
Subject: Re: + oom-move-constraints-to-enum.patch added to -mm tree
Message-ID: <20070921200026.GD1857@martell.zuzino.mipt.ru>
References: <200709210910.l8L9Avh2028189@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709210910.l8L9Avh2028189@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 02:10:57AM -0700, akpm@linux-foundation.org wrote:
> The OOM killer's CONSTRAINT definitions are really more appropriate in an
> enum, so define them in include/linux/oom.h.

OK with enum, but this series do not bring user outside of
mm/oom_kill.c, so why move them to header.

> --- a/include/linux/oom.h~oom-move-constraints-to-enum
> +++ a/include/linux/oom.h
> @@ -11,6 +11,15 @@
>  
>  #ifdef __KERNEL__
>  
> +/*
> + * Types of limitations to the nodes from which allocations may occur
> + */
> +enum oom_constraint {
> +	CONSTRAINT_NONE,
> +	CONSTRAINT_CPUSET,
> +	CONSTRAINT_MEMORY_POLICY,
> +};
> +
>  extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
>  extern int register_oom_notifier(struct notifier_block *nb);
>  extern int unregister_oom_notifier(struct notifier_block *nb);
> diff -puN mm/oom_kill.c~oom-move-constraints-to-enum mm/oom_kill.c
> --- a/mm/oom_kill.c~oom-move-constraints-to-enum
> +++ a/mm/oom_kill.c
> @@ -164,16 +164,10 @@ unsigned long badness(struct task_struct
>  }
>  
>  /*
> - * Types of limitations to the nodes from which allocations may occur
> - */
> -#define CONSTRAINT_NONE 1
> -#define CONSTRAINT_MEMORY_POLICY 2
> -#define CONSTRAINT_CPUSET 3
> -
> -/*
>   * Determine the type of allocation constraint.
>   */
> -static inline int constrained_alloc(struct zonelist *zonelist, gfp_t gfp_mask)
> +static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
> +						    gfp_t gfp_mask)
>  {
>  #ifdef CONFIG_NUMA
>  	struct zone **z;
> @@ -393,7 +387,7 @@ void out_of_memory(struct zonelist *zone
>  	struct task_struct *p;
>  	unsigned long points = 0;
>  	unsigned long freed = 0;
> -	int constraint;
> +	enum oom_constraint constraint;
