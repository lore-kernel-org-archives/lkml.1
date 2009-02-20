Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZBTPlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZBTPlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZBTPlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:41:13 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42929 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZBTPlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:41:12 -0500
Date: Fri, 20 Feb 2009 07:41:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090220154109.GB6960@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu> <1235139492.29813.53.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235139492.29813.53.camel@penberg-laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 04:18:12PM +0200, Pekka Enberg wrote:
> On Fri, 2009-02-20 at 15:01 +0100, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > ah, indeed:
> > > 
> > >         list_del_rcu(&va->list);
> > > 
> > > i suspect it could be hit big time in a workload that opens 
> > > more than 512 files, as expand_files() uses a 
> > > vmalloc()+vfree() pair in that case.
> > 
> > hm, perhaps it's not a problem after all. The freeing is done 
> > via rcu, and list_del_rcu() leaves the forward pointer intact.
> > 
> > So how did it happen that the entry got kfree()d before the loop 
> > was done? We are in a spinlocked section so the CPU should not 
> > have entered rcu processing.
> 
> RCU. Lets CC Paul.
> 
> Looking at it, Documentation/RCU/checklist.txt states that:
> 
> 7.      If the updater uses call_rcu(), then the corresponding readers
>         must use rcu_read_lock() and rcu_read_unlock().
> 
> which we don't do for this loop. I fail to see how it could be a
> kmemcheck false positive, so it's probably a real bug.

And checklist.txt rule #7 is even more important in preemptable kernels,
especially if CONFIG_PREEMPT_RT.

							Thanx, Paul
