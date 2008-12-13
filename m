Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYLMBnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYLMBnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 20:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYLMBnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 20:43:05 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:43226 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbYLMBnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 20:43:03 -0500
Date: Fri, 12 Dec 2008 19:41:33 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 6/7] fs: struct file move from call_rcu() to
 SLAB_DESTROY_BY_RCU
In-Reply-To: <4941EC65.5040903@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0812121934510.14878@quilx.com>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <493100B0.6090104@cosmosbay.com>
 <494196DD.5070600@cosmosbay.com> <200707241113.46834.nickpiggin@yahoo.com.au>
 <4941EC65.5040903@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008, Eric Dumazet wrote:


> > This is a non-trivial change, because that put_filp may drop the last
> > reference to the file. So now we have the case where we free the file
> > from a context in which it had never been allocated.
>
> If we got at this point, we :
>
> Found a non NULL pointer in our fd table.
> Then, another thread came, closed the file while we not yet added our reference.
> This file was freed (kmem_cache_free(filp_cachep, file))
> This file was reused and inserted on another thread fd table.
> We added our reference on refcount.
> We checked if this file is still ours (in our fd tab).
> We found this file is not anymore the file we wanted.
> Calling put_filp() here is our only choice to safely remove the reference on
> a truly allocated file. At this point the file is
> a truly allocated file but not anymore ours.
> Unfortunatly we added a reference on it : we must release it.
> If the other thread already called put_filp() because it wanted to close its new file,
> we must see f_refcnt going to zero, and we must call __fput(), to perform
> all the relevant file cleanup ourself.

Correct. That was the idea.

> A final point is that SLUB doesnt need to allocate or free a slab in many cases.
> (This is probably why Christoph needed this patch in 2006 :) )

We needed this patch in 2006 because the AIM9 creat-clo test showed
regressions after the rcu free was put in (discovered during SLES11
verification cycle). All slab allocators do at least defer frees until all
objects in the page are freed if not longer.

> In my case, I need all these patches to speedup http servers.
> They obviously open and close many files per second.

Run AIM9 creat-close tests....

> SLAB_DESTROY_BY_RCU is a must on current hardware, where memory cache line
> misses costs become really problematic. This patch series clearly demonstrate
> it.

Well the issue becomes more severe as accesses to cold memory become more
extensive. Thanks for your work on this.
