Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbZBMXsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbZBMXsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 18:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZBMXs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 18:48:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZBMXs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 18:48:29 -0500
Subject: Re: [patch] generic-ipi: remove kmalloc, cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <200902140746.45320.rusty@rustcorp.com.au>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <1234433770.23438.210.camel@twins> <1234440554.23438.264.camel@twins>
	 <200902140746.45320.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 00:48:05 +0100
Message-Id: <1234568885.4831.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 07:46 +1030, Rusty Russell wrote:
> On Thursday 12 February 2009 22:39:14 Peter Zijlstra wrote:
> > So it put in unconditionally, how about this?
> > 
> > 
> > --
> > Subject: generic-smp: remove single ipi fallback for smp_call_function_many()
> > 
> > In preparation of removing the kmalloc() calls from the generic-ipi code
> > get rid of the single ipi fallback for smp_call_function_many().
> > 
> > Because we cannot get around carrying the cpumask in the data -- imagine
> > 2 such calls with different but overlapping masks -- put in a full mask.
> 
> OK, if you really want this, please just change it to:
> 	unsigned long cpumask_bits[BITS_TO_LONGS(CONFIG_NR_CPUS)];
> 
> The 'struct cpumask' will be undefined soon when CONFIG_CPUMASK_OFFSTACK=y,
> which will prevent assignment and declaration on stack.
> 
> I'd be fascinated to see perf numbers once you kill the kmalloc.  Because
> this patch will add num_possible_cpus * NR_CPUS/8 bytes to the kernel which
> is something we're trying to avoid unless necessary.

You're free to make it a pointer and do node affine allocations from an
init section of choice and add a hotplug handler.

But I'm not quite sure how perf is affected by size overhead on
ridiculous configs.

