Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0CDQeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:34:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab0CDQeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:34:22 -0500
Date: Fri, 5 Mar 2010 03:34:18 +1100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] cpuset,mm: use rwlock to protect task->mempolicy
 and mems_allowed
Message-ID: <20100304163417.GS8653@laptop>
References: <4B8E3F77.6070201@cn.fujitsu.com>
 <20100304033017.GN8653@laptop>
 <1267714704.25158.199.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267714704.25158.199.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 03:58:24PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-03-04 at 14:30 +1100, Nick Piggin wrote:
> > 
> > Thanks for working on this. However, rwlocks are pretty nasty to use
> > when you have short critical sections and hot read-side (they're twice
> > as heavy as even spinlocks in that case). 
> 
> Should we add a checkpatch.pl warning for them? 

Yes I think it could be useful.

Most people agree rwlock is *almost* always the wrong thing to do. Or at
least, they can easily be used wrongly because they seem like a great
idea for read-mostly data.

> 
> There really rarely is a good case for using rwlock_t, for as you say
> they're a pain and often more expensive than a spinlock_t, and if
> possible RCU has the best performance.

Yep. Not to mention they starve writers (and don't FIFO like spinlocks).

Between normal spinlocks, RCU, percpu, and seqlocks, there's not much
room for rwlocks. Even tasklist lock should be RCUable if the effort is
put into it.

