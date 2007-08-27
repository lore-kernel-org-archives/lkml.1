Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXH0Tne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXH0Tne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbXH0TnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:43:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36215 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759554AbXH0TnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:43:19 -0400
Date: Mon, 27 Aug 2007 12:43:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB: use have_arch_cmpxchg()
In-Reply-To: <20070827145627.GB18504@Krystal>
Message-ID: <Pine.LNX.4.64.0708271240350.5056@schroedinger.engr.sgi.com>
References: <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
 <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
 <20070822000323.GG29691@Krystal> <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com>
 <20070822002616.GA1400@Krystal> <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com>
 <20070822150248.GB8504@Krystal> <84144f020708220924y6d707d50md1c95eeb58d5ce7@mail.gmail.com>
 <20070827145627.GB18504@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:

> Hrm, actually, I don't think such have_arch_cmpxchg() macro will be
> required at all because of the small performance hit disabling
> preemption will have on the slow and fast paths. Let's compare, for each
> of the slow path and fast path, what locking looks like on architecture
> with and without local cmpxchg:
> 
> What we actually do here is:
> 
> fast path:
> with local_cmpxchg:
>   preempt_disable()
>   preempt_enable()
> without local_cmpxchg:
>   preempt_disable()
>   local_irq_save
>   local_irq_restore
>   preempt_enable()
>     (we therefore disable preemption _and_ disable interrupts for
>     nothing)

Hmmm..... This is a performance issue for preempt kernels.

> slow path:
> both with and without local_cmpxchg():
>   preempt_disable()
>   preempt_enable()

Here we potentially loose our per cpu structure since the process may be 
rescheduled.

>   local_irq_save()
>   local_irq_restore()
> 
> 
> Therefore, we would add preempt disable/enable to the fast path of
> architectures where local_cmpxchg is emulated with irqs off. But since
> preempt disable/enable is just a check counter increment/decrement with
> barrier() and thread flag check, I doubt it would hurt performances
> enough to justify the added complexity of disabling interrupts for the
> whole fast path in this case.

One additional cacheline referenced in the hot path. Ok the counter may be 
hot as well if this is a preemptible kernel. Nevertheless a cause for 
concern.

