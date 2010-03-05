Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0CEJl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:41:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab0CEJlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:41:25 -0500
Subject: Re: [PATCH] perf_event: Fix oops triggered by cpu offline/online
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100305060654.GE27606@brick.ozlabs.ibm.com>
References: <20100305060654.GE27606@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 10:41:23 +0100
Message-ID: <1267782083.16716.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 17:06 +1100, Paul Mackerras wrote:
> Anton Blanchard found that he could reliably make the kernel hit a
> BUG_ON in the slab allocator by taking a cpu offline and then online
> while a system-wide perf record session was running.
> 
> The reason is that when the cpu comes up, we completely reinitialize
> the ctx field of the struct perf_cpu_context for the cpu.  If there is
> a system-wide perf record session running, then there will be a struct
> perf_event that has a reference to the context, so its refcount will
> be 2.  (The perf_event has been removed from the context's group_entry
> and event_entry lists by perf_event_exit_cpu(), but that doesn't
> remove the perf_event's reference to the context and doesn't decrement
> the context's refcount.)
> 
> When the cpu comes up, perf_event_init_cpu() gets called, and it calls
> __perf_event_init_context() on the cpu's context.  That resets the
> refcount to 1.  Then when the perf record session finishes and the
> perf_event is closed, the refcount gets decremented to 0 and the
> context gets kfreed after an RCU grace period.  Since the context
> wasn't kmalloced -- it's part of a per-cpu variable -- bad things
> happen.
> 
> In fact we don't need to completely reinitialize the context when the
> cpu comes up.  It's sufficient to initialize the context once at boot,
> but we need to do it for all possible cpus.
> 
> This moves the context initialization to happen at boot time.  With
> this, we don't trash the refcount and the context never gets kfreed,
> and we don't hit the BUG_ON.
> 
> Reported-by: Anton Blanchard <anton@samba.org>
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> Tested-by: Anton Blanchard <anton@samba.org>

Very nice catch!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

