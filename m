Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbZE2PiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbZE2PiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbZE2PiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:38:04 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35476 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757618AbZE2PiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:38:04 -0400
Date: Fri, 29 May 2009 11:37:48 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [my_cpu_ptr 1/5] Introduce my_cpu_ptr()
In-Reply-To: <200905291057.16286.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0905291023570.30695@gentwo.org>
References: <20090527180635.008102701@gentwo.org> <200905281316.01923.rusty@rustcorp.com.au> <alpine.DEB.1.10.0905281153280.22354@gentwo.org> <200905291057.16286.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009, Rusty Russell wrote:

> > Have not seen it but it would be a bit confusing since
> > we already have get_cpu* which must be paired with put_cpu*
> > because of the refcount taking (get_cpu_var and get_cpu).
> > get_cpu_ptr() would not have to be paired.
>
> To clarify, get_cpu_ptr() would be paired with put_cpu_ptr().  __get_cpu_ptr()
> would be the "raw" one:
>
> #define get_cpu_ptr(xx) per_cpu_ptr(xx, get_cpu())
> #define __get_cpu_ptr(xx) per_cpu_ptr(xx, smp_processor_id())

Hmmm.. That would be a major change in semantics. I tend to
think about these ops more as atomic like operations rather than preempt
sections. The operation to obtain a the current instance for a given
processor is an operation done in a given preemption context. The
get_cpu_ptr() approach establishes the preemption context during the same
operation.

That would mean use

	*get_cpu_ptr(per_cpu_ptr1)++
	*__get_cpu_ptr(per_cpu_ptr2)++
	put_cpu_ptr()

instead of

	preempt_disable()
	*__this_cpu_ptr(per_cpu_ptr1)++
	*__this_cpu_ptr(per_cpu_ptr2)++
	preempt_enable().


And for context in which we know that preemption is off

	*__get_cpu_ptr(per_cpu_ptr1)++
	*__get_cpu_ptr(per_cpu_ptr2)++

vs

	*__this_cpu_ptr(per_cpu_ptr2)++
	*__this_cpu_ptr(per_cpu_ptr2)++

So its the same

How would that look for atomic per cpu ops?

	get_cpu_ptr_inc(per_cpu_ptr1);
	__get_cpu_ptr_inc(per_cpu_ptr2)
	put_cpu_ptr()

vs.

	this_cpu_inc(per_cpu_ptr1)
	this_cpu_inc(per_cpu_ptr2)


and known preemption off context

	__get_cpu_ptr_inc(per_cpu_ptr1)
	__get_cpu_ptr_inc(per_cpu_ptr2)

vs
	__this_cpu_inc(percpu_ptr1)
	__this_cpu_inc(percpu_ptr2)

Same again

Seems to be added complexity to also push a change of preemption into
these operations. I'd rather keep the preempt status unchanged by these
operations in particular because some counters may need interrupt
protection on some platforms and not on others. We will likely need some
additional operations like

	this_cpu_inc_irqsafe( ....)

that will require an irq off / on on some platforms and be a simple
increment on others.



