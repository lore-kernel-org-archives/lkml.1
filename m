Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZCCPLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZCCPLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZCCPLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:11:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:53788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbZCCPLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:11:19 -0500
Date: Tue, 3 Mar 2009 16:11:13 +0100
From: Nick Piggin <npiggin@suse.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/6] rcu: introduce kfree_rcu V2
Message-ID: <20090303151113.GC18142@wotan.suse.de>
References: <49AD342D.6030609@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AD342D.6030609@cn.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

On Tue, Mar 03, 2009 at 09:44:13PM +0800, Lai Jiangshan wrote:
> 
> There are 23 instances where the rcu callback just does
> 
> 	kfree(containerof(head,struct whatever_struct,rcu_member));
> 
> The 23 instances exist because there are 23 'struct whatever_struct' with
> their individual rcu_member. These patches creates a generic kfree_rcu()
> function that removes the need for these 23 helpers.
> 
> The number of this kind of rcu callback will increase, for this is the
> most common way to use rcu and define rcu callback.

I don't like this too much. It is a great idea for the common code,
but it adds overhead and complexity in slab. SLQB in particular I
really don't want to use the last field in the struct page struct
(there are various things I can use it for in SLQB core which I
haven't been able to show are worthwhile, but they may be, or something
else might come up).

You have proposed an alternative that doesn't use as much space, but
it still uses space (just with a denser encoding), will probably reduce
efficiency of operations on those fields on some CPUs.

These callers could also use my proposed kfree_size() API, which the
allocator can use to speed up kfree, and a constant size helps.

I don't think the simple call_rcu/kfree pattern is really problematic
enough to justify this patch.


> And kfree_rcu() is also help for unloadable modules, kfree_rcu() does not
> queue any function which belong to the module, so a rcu_barrier() can
> be avoid when module exit. (If we queue any other function by call_rcu(),
> rcu_barrier() is still needed.)

