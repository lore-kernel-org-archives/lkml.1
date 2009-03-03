Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbZCCNqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbZCCNqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbZCCNpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:45:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56546 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZCCNpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:45:50 -0500
Message-ID: <49AD342D.6030609@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 21:44:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/6] rcu: introduce kfree_rcu V2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are 23 instances where the rcu callback just does

	kfree(containerof(head,struct whatever_struct,rcu_member));

The 23 instances exist because there are 23 'struct whatever_struct' with
their individual rcu_member. These patches creates a generic kfree_rcu()
function that removes the need for these 23 helpers.

The number of this kind of rcu callback will increase, for this is the
most common way to use rcu and define rcu callback.

And kfree_rcu() is also help for unloadable modules, kfree_rcu() does not
queue any function which belong to the module, so a rcu_barrier() can
be avoid when module exit. (If we queue any other function by call_rcu(),
rcu_barrier() is still needed.)

Changed from V1:
1) Implement kfree_rcu() in slab layer.
   In V1, the offset from the container struct to the rcu member
   is calculated at compile time and stored in head->func instead of the
   function pointer. This disarrange rcu's algorithm a little, there is
   no bad side effect when we implement kfree_rcu() in slab layer.

2) kfree_rcu() API is changed, use the version that Manfred Spraul designed.
   This one allows compiler do more checking.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---







