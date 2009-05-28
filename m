Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbZE1MSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbZE1MSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbZE1MSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:18:24 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58631 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935AbZE1MSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:18:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18974.32901.99290.162863@cargo.ozlabs.ibm.com>
Date: Thu, 28 May 2009 22:16:05 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] perf_counter: Fix race in attaching counters to
 tasks and exiting
In-Reply-To: <1243509170.6600.36.camel@laptop>
References: <18974.26663.618300.184845@cargo.ozlabs.ibm.com>
	<1243509170.6600.36.camel@laptop>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> The poor task will now have to wait for yet another RCU grace period,
> but yeah :-)

I moved the put_task_struct into put_ctx, inside the if, so the poor
task won't get impatient. :)

> Looks good, although lockdep will complain, the proper annotation would
> be spin_lock_nested_lock(&ctx->lock, &rq->lock), but since we don't have
> access to the rq here, we should change the second spin_lock, to:
> 
>   spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);

Ah OK, thanks.

> You jump into an rcu_read_lock() section there.

Oops.  I'll fix that.  I also need to use spin_[un]lock_irq in there.
New version coming.  Thanks for the review.

Paul.
