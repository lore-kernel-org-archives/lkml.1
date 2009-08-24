Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZHXHW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZHXHW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbZHXHW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:22:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59432 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZHXHW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:22:58 -0400
Subject: Re: [PATCH RFC -tip 0/4] v3 RCU cleanups and simplified
 preemptable RCU
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josht@linux.vnet.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org
In-Reply-To: <20090727181401.GA14120@linux.vnet.ibm.com>
References: <20090727181401.GA14120@linux.vnet.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 09:21:59 +0200
Message-Id: <1251098519.7538.139.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-22 at 13:52 -0700, Paul E. McKenney wrote:
> 
> o       Rename variables and functions so that RCU-sched is an
>         underlying definition, along with RCU-bh and (when so
>         configured) RCU-preempt.  RCU then maps to either RCU-sched
>         or RCU-preempt, depending on configuration.

Nice, but we're not quite there yet it seems, since RCU-preempt isn't
available outside of TREE_PREEMPT_RCU afaiks.

That is, I'm still hoping for the day that generic code can do:

  rcu_preempt_read_lock();


  call_rcu_preempt(&my_rcu_thing);
  rcu_preempt_read_unlock();

And have it work like expected, this would, I think, remove much of the
need for SRCU.


The thing I've talked about earlier is an extension of this where you
can create multiple RCU domains along the lines of:

  struct rcu_preempt_domain my_domain;

  rcu_preempt_init(&my_domain);


and

  rcu_preempt_read_lock(&my_domain);

  call_rcu_preempt(&my_domain, &my_rcu_head);
  rcu_preempt_read_unlock(&my_domain);


Which would allow you to create smaller RCU domains for when you want
faster grace periods due to less interference of other rcu users.


Anyway, enough rambling, the patch-set does look very nice, and if time
permits I'll try and go through the preempt-tree-rcu thing.

Thanks
