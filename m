Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbZDBVmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbZDBVmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759974AbZDBVmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:42:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759683AbZDBVmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:42:37 -0400
Date: Thu, 2 Apr 2009 14:39:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Fix slab corruption caused by
 alloc_cpumask_var_node()
Message-Id: <20090402143932.79a15852.akpm@linux-foundation.org>
In-Reply-To: <20090402212751.GA11495@sgi.com>
References: <20090402212751.GA11495@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 16:27:51 -0500
Jack Steiner <steiner@sgi.com> wrote:

> Fix for slab corruption caused by alloc_cpumask_var_node() overwriting
> the tail end of an off-stack cpumask.

changelog is crappy.

> --- linux.orig/lib/cpumask.c	2009-04-02 15:30:05.000000000 -0500
> +++ linux/lib/cpumask.c	2009-04-02 15:57:44.000000000 -0500
> @@ -109,10 +109,10 @@ bool alloc_cpumask_var_node(cpumask_var_
>  #endif
>  	/* FIXME: Bandaid to save us from old primitives which go to NR_CPUS. */
>  	if (*mask) {
> +		unsigned char *ptr = (unsigned char *)cpumask_bits(*mask);
>  		unsigned int tail;
>  		tail = BITS_TO_LONGS(NR_CPUS - nr_cpumask_bits) * sizeof(long);
> -		memset(cpumask_bits(*mask) + cpumask_size() - tail,
> -		       0, tail);
> +		memset(ptr + cpumask_size() - tail, 0, tail);
>  	}
>  

It appears that the bug is that cpumask_bits() returns an `unsigned
long *', except the pointer arithmetic in there is designed to operate
on char*/void*/etc, correct?

This fix is needed in 2.6.29 as well, correct?
