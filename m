Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYLaWjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYLaWjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYLaWi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:38:58 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:32821 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYLaWi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:38:57 -0500
Date: Wed, 31 Dec 2008 16:37:44 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, miaox@cn.fujitsu.com,
       menage@google.com, penberg@cs.helsinki.fi, mpm@selenic.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] cpuset,mm: fix allocating page cache/slab object on the
 unallowed node when memory spread is set
In-Reply-To: <200812311413.45127.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0812311633150.21130@quilx.com>
References: <49547B93.5090905@cn.fujitsu.com> <20081230142805.3c6f78e3.akpm@linux-foundation.org>
 <200812311413.45127.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008, Nick Piggin wrote:

> These paths are pretty performance critical. Why don't cpusets code do this
> work in the slowpath where the cpuset's mems_allowed gets changed rather
> than putting these calls all over the place with apparently no real rhyme or
> reason :( (this is not against your patch, but just this part of the cpusets
> design)

Right.

> > d) How does slub handle this problem?
>
> SLUB seems to do a "sloppy" kind of memory policy allocation, where it just
> relies on the page allocator to hand us the correct page and AFAIKS does not
> exactly obey this stuff all the time.

Slub avoids hanlding memory policy decisions and lets the page allocator
deal with it. That means that memory policies are not enforced on an
object basis but on a page basis. If you allocate a series of objects
under MPOL_INTERLEAVE then SLAB will give you one object from each node.
SLUB will give you objects from one page until the objects in a page are
exhausted. The next page will be acquired according to the current
memory policy. Meaning the page will come from the next node if
MPOL_INTERLEAVE is set. The following set of objects will be allocated
from that node. This allows a faster allocation for NUMA since the cachelines
for allocation can be kept hot. The page are still allocated from all
nodes.



