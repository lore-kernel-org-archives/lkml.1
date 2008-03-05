Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbYCETRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbYCETRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbYCETRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:17:38 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21626 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbYCETRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:17:37 -0500
X-IronPort-AV: E=McAfee;i="5100,188,5245"; a="1119703"
Message-ID: <47CEF1CD.6040503@qualcomm.com>
Date: Wed, 05 Mar 2008 11:17:33 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Jackson <pj@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
References: <20080227222103.673194000@chello.nl>	 <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>	 <47C87084.3090208@qualcomm.com> <1204318980.6243.133.camel@lappy>	 <47C8771C.1070001@qualcomm.com> <1204545445.11412.6.camel@twins>	 <20080303113621.1dfdda87.pj@sgi.com> <1204567052.6241.4.camel@lappy>	 <20080303121033.c8c9651c.pj@sgi.com> <1204568316.8514.18.camel@twins>	 <20080304013534.4e51ae48.pj@sgi.com> <1204628762.6241.46.camel@lappy>	 <47CDA885.3000103@qualcomm.com>  <20080304191159.a02be58b.pj@sgi.com> <1204706272.6241.79.camel@lappy>
In-Reply-To: <1204706272.6241.79.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> How about we make this in-kernel boot set, that by default contains all
> IRQs, all unbounded kthreads and all of user-space.
I assumed that this exactly what we meant by the boot set all along :).

One thing I wanted to clarify that by all IRQs we literally mean all of them
even those that do not have handlers yet. /proc/irqN/smp_affinity for example
 is not available for the irqs are not active. In other words an IRQ must not
all of the sudden show up in the root set when something does request_irq() on
it.
This applies to other thing too.

>> How does all this interact with /proc/irq/N/smp_affinity?
> 
> Much the same way the cpuset cpus_allowed interacts with a task's
> cpus_allowed. That is, cs->cpus_allowed is a mask on top of the provided
> affinity.
> 
> If for some reason the cs->cpus_allowed changes in such a way that the
> user-specified mask becomes empty (irq->cpus_allowed & cs->cpus_allowed
> == 0), then print a message and set it to the full mask
> (irq->cpus_allowed = cs->cpus_allowed).
> 
> If for some reason the cs->cpus_allowed changes in such a way that the
> mask is physically impossible (set_irq_affinity(cs->cpus_allowed)
> fails), then print a message and move the IRQ to the parent set.

I think Paul missed my earlier reply where I pointed out that original patch
conflicted with /proc/irq/N/smp_affinity API. The solution is for
irq_set_affinity() to enforce cpus_allowed just like sched_setaffinity does
for the tasks.

Max
