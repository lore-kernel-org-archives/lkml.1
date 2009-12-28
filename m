Return-Path: <linux-kernel-owner+w=401wt.eu-S1751304AbZL1BI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbZL1BI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 20:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZL1BI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 20:08:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54206 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZL1BI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 20:08:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 10:05:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
Subject: Re: [RFC PATCH] asynchronous page fault.
Message-Id: <20091228100514.ec6f9949.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091228005746.GE3601@balbir.in.ibm.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	<1261912796.15854.25.camel@laptop>
	<20091228005746.GE3601@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 06:27:46 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

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
> 
>From following reasons.
  - What we have to avoid is not to touch unkonwn memory via broken pointer.
    This is speculative look up and can miss vmas. So, even if tree is broken,
    there is no problem. Broken pointer which points to places other than rb-tree
    is problem.
  - rb-tree's rb_left and rb_right don't points to memory other than
    rb-tree. (or NULL)  And vmas are not freed/reused while rcu_read_lock().
    Then, we don't dive into unknown memory.
  - Then, we can skip rcu_assign_pointer().

Thanks,
-Kame

