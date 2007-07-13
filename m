Return-Path: <linux-kernel-owner+w=401wt.eu-S936168AbXGMIpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936168AbXGMIpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760446AbXGMIo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:44:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756479AbXGMIoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:44:55 -0400
Date: Fri, 13 Jul 2007 01:44:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Jin <joe.jin@oracle.com>
Cc: bill.irwin@oracle.com, linux-kernel@vger.kernel.org,
       gurudas.pai@oracle.com
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070713014432.074fc2de.akpm@linux-foundation.org>
In-Reply-To: <20070713083732.GC21833@joejin-pc.cn.oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
	<20070712234938.c77f3a48.akpm@linux-foundation.org>
	<20070713083732.GC21833@joejin-pc.cn.oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 16:37:32 +0800 Joe Jin <joe.jin@oracle.com> wrote:

> > 
> > if (nid > MAX_NUMNODES) then that is a bug and we should report it (doing
> > this via a BUG() is OK) rather than quietly covering it up.
> 
> I have create a patch to check if nid > MAX_NUMNODES, please apply it
> thanks
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> ---
> 
> --- linux-2.6.22/include/linux/gfp.h.orig	2007-07-12 15:06:23.000000000 +0800
> +++ linux-2.6.22/include/linux/gfp.h	2007-07-13 16:23:52.000000000 +0800
> @@ -127,6 +127,8 @@ FASTCALL(__alloc_pages(gfp_t, unsigned i
>  static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
>  						unsigned int order)
>  {
> +	BUG_ON(nid > MAX_NUMNODES);
> +
>  	if (unlikely(order >= MAX_ORDER))
>  		return NULL;
>  

nope ;)

Would really prefer not to go adding overhead like this into a
frequently-called and frequently-inlined codepath.

If we do have a bug in a caller then the code will go on to overindex
NODE_DATA() which will hopefully produce a nice oops for at least some
people, and that's good enough.

