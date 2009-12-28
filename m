Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbZL1IkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbZL1IkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZL1Ij7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:39:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZL1Ij6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:39:58 -0500
Subject: Re: [RFC PATCH] asynchronous page fault.
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
In-Reply-To: <20091228005746.GE3601@balbir.in.ibm.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261912796.15854.25.camel@laptop>
	 <20091228005746.GE3601@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 09:32:53 +0100
Message-ID: <1261989173.7135.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 06:27 +0530, Balbir Singh wrote:
> * Peter Zijlstra <peterz@infradead.org> [2009-12-27 12:19:56]:
> 
> > Your changelog states as much.
> > 
> > "Even if RB-tree rotation occurs while we walk tree for look-up, we just
> > miss vma without oops."
> > 
> > However, since this is the case, do we still need the
> > rcu_assign_pointer() conversion your patch does? All I can see it do is
> > slow down all RB-tree users, without any gain.
> 
> Don't we need the rcu_assign_pointer() on the read side primarily to
> make sure the pointer is still valid and assignments (writes) are not
> re-ordered? Are you suggesting that the pointer assignment paths be
> completely atomic?

rcu_assign_pointer() is the write side, but if you need a barrier, you
can make do with a single smp_wmb() after doing the rb-tree op. There is
no need to add multiple in the tree-ops themselves.

You cannot make the assignment paths atomic (without locks) that's the
whole problem.

