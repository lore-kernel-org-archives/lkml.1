Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZJBRzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZJBRzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZJBRzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:55:03 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:37193 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751657AbZJBRzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:55:02 -0400
Date: Fri, 2 Oct 2009 13:49:28 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@elte.hu>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [this_cpu_xx V4 00/20] Introduce per cpu atomic operations and
 avoid per cpu address arithmetic
In-Reply-To: <20091002173246.GB4884@elte.hu>
Message-ID: <alpine.DEB.1.10.0910021340380.26189@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <4AC5C836.8000502@kernel.org> <20091002095455.GC21427@elte.hu> <alpine.DEB.1.10.0910021313270.26189@gentwo.org> <20091002173246.GB4884@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Ingo Molnar wrote:

> > Right. There will be a time period in which other arches will need to
> > add support for this_cpu_xx first.
>
> Size comparison should be only on architectures that support it (i.e.
> x86 right now). The generic fallbacks might be bloaty, no argument about
> that. ( => the more reason for any architecture to add optimizations for
> this_cpu_*() APIs. )

The fallbacks basically generate the same code (at least for the core
code) that was there before. F.e.

Before:

#define SNMP_INC_STATS(mib, field)     \
       do { \
               per_cpu_ptr(mib[!in_softirq()], get_cpu())->mibs[field]++; \
               put_cpu(); \
       } while (0)

After

#define SNMP_INC_STATS_USER(mib, field)        \
                       this_cpu_inc(mib[1]->mibs[field])



For the x86 case this means that we can use a simple atomic increment
with a segment prefix to do all the work.


The fallback case for arches not providing per cpu atomics is:

	preempt_disable();
	*__this_cpu_ptr(&mib[1]->mibs[field]) += 1;
	preempt_enable();

If the arch can optimize __this_cpu_ptr (and provides __my_cpu_offset)
because it has the per cpu offset of the local cpu in some priviledged
location then this is still going to be a win since we avoid
smp_processor_id() entirely and we also avoid the array lookup.

If the arch has no such mechanism then we fall back for this_cpu_ptr too:

#ifndef __my_cpu_offset
#define __my_cpu_offset per_cpu_offset(raw_smp_processor_id())
#endif

And then the result in terms of overhead is the same as before the
per_cpu_xx patches since get_cpu() does both a preempt_disable as well as
a smp_processor_id() call.



