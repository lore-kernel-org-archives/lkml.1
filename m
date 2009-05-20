Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbZEUBJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbZEUBJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 21:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZEUBJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 21:09:40 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40828 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbZEUBJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 21:09:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18964.38744.198924.182451@cargo.ozlabs.ibm.com>
Date: Thu, 21 May 2009 09:50:48 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: dynamically allocate tasks'
 perf_counter_context struct
In-Reply-To: <1242831788.32543.1706.camel@laptop>
References: <18963.63352.489273.92145@cargo.ozlabs.ibm.com>
	<1242831788.32543.1706.camel@laptop>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> This seems to be the only site where we use ->perf_counter_mutex,
> couldn't we simply write this as:
> 
>  if (cmpxchg(&task->perf_counter_ctx, NULL, ctx) != NULL)
>    kfree(ctx);
> 
> and get rid of the mutex?

Yes, that should work, with an smp_wmb() before the cmpxchg.

> If, in find_get_context() we exclude PF_EXITING tasks under ctx->mutex,
> and ensure we take ctx->mutex in perf_counter_exit_task() we should be
> good.

It's the fact that we also call perf_counter_exit_task when doing an
exec of a setuid program that concerns me.  In that case the task
isn't exiting and its pid is still accessible, so it is quite possible
that some other task could be attaching counters to us.  Certainly
root could; I don't know whether we change uid before doing the
dumpable check or not, so it's possible a non-privileged process would
be refused.

Paul.
