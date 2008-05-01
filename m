Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbYEAEbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbYEAEbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYEAEa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:30:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43675 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYEAEa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:30:57 -0400
Date: Wed, 30 Apr 2008 21:30:52 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 02/10] Introduce the ridr structure
Message-ID: <20080501043051.GA30274@tpepper-t42p.dolavim.us>
References: <20080429143304.741001000@bull.net> <20080429143728.904849000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429143728.904849000@bull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29 Apr at 16:33:06 +0200 Nadia.Derbey@bull.net said:

> Index: linux-2.6.25-mm1/include/linux/ridr.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.25-mm1/include/linux/ridr.h	2008-04-29 13:08:00.000000000 +0200
> @@ -0,0 +1,50 @@
> +/*
> + * include/linux/ridr.h
> + *
> + * Small id to pointer translation service avoiding fixed sized
> + * tables. RCU-based implmentation of IDRs.
> + */
                        ^^^^^^^
s/implmentation/reimplementation

Additional comment here might be nice here since this amounts to a mostly
copy of idr.h and its backing implementation, with all the associated
maintenance headaches if both are in tree.

> +/*
> + * The idr_layer part should stay at the beginning of the structure
> + */
> +struct ridr_layer {
> +	struct idr_layer idr;
> +	struct rcu_head	 rcu_head;
> +};

Why does it have to be at the beginning?  So an ridr_layer can be used as
an idr_layer?  This doesn't help review.  As previous commenters noted,
review would be a lot easier if this was incremental on idr.

> Index: linux-2.6.25-mm1/lib/Makefile
> ===================================================================
> --- linux-2.6.25-mm1.orig/lib/Makefile	2008-04-25 15:29:00.000000000 +0200
> +++ linux-2.6.25-mm1/lib/Makefile	2008-04-25 15:57:39.000000000 +0200
> @@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
>  	 rbtree.o radix-tree.o dump_stack.o \
>  	 idr.o int_sqrt.o extable.o prio_tree.o \
>  	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
> -	 proportions.o prio_heap.o ratelimit.o
> +	 proportions.o prio_heap.o ratelimit.o ridr.o

I vaguely recall past discussion of preferred insertion point, but
lacking something in CodingStyle and especially given the redundancy
here it could be nice to add ridr.o next to idr.o.

> ===================================================================
> --- linux-2.6.25-mm1.orig/lib/idr.c	2008-04-25 17:22:43.000000000 +0200
> +++ linux-2.6.25-mm1/lib/idr.c	2008-04-29 13:08:05.000000000 +0200
> @@ -342,7 +342,7 @@ static void sub_remove(struct idr *idp, 
>  	while ((shift > 0) && p) {
>  		n = (id >> shift) & IDR_MASK;
>  		__clear_bit(n, &p->bitmap);
> -		*++paa = &p->ary[n];
> +		*++paa = (struct idr_layer **) &p->ary[n];
>  		p = p->ary[n];
>  		shift -= IDR_BITS;
>  	}

For shifty use of an ridr_layer as an idr_layer?

> Index: linux-2.6.25-mm1/include/linux/idr.h
> ===================================================================
> --- linux-2.6.25-mm1.orig/include/linux/idr.h	2008-04-25 17:22:43.000000000 +0200
> +++ linux-2.6.25-mm1/include/linux/idr.h	2008-04-29 13:08:00.000000000 +0200
> @@ -48,9 +48,9 @@
>  #define IDR_FREE_MAX MAX_LEVEL + MAX_LEVEL
> 
>  struct idr_layer {
> -	unsigned long		 bitmap; /* A zero bit means "space here" */
> -	struct idr_layer	*ary[1<<IDR_BITS];
> -	int			 count;	 /* When zero, we can release it */
> +	unsigned long	 bitmap; /* A zero bit means "space here" */
> +	void		*ary[1<<IDR_BITS];
> +	int		 count;	 /* When zero, we can release it */
>  };
> 
>  struct idr {
> 

This hunk is white space only...

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
