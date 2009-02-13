Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbZBMXkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbZBMXkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 18:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZBMXkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 18:40:00 -0500
Received: from ozlabs.org ([203.10.76.45]:55060 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbZBMXj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 18:39:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch] generic-ipi: remove kmalloc, cleanup
Date: Sat, 14 Feb 2009 07:46:44 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       "rt-users" <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <1234433770.23438.210.camel@twins> <1234440554.23438.264.camel@twins>
In-Reply-To: <1234440554.23438.264.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140746.45320.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 February 2009 22:39:14 Peter Zijlstra wrote:
> So it put in unconditionally, how about this?
> 
> 
> --
> Subject: generic-smp: remove single ipi fallback for smp_call_function_many()
> 
> In preparation of removing the kmalloc() calls from the generic-ipi code
> get rid of the single ipi fallback for smp_call_function_many().
> 
> Because we cannot get around carrying the cpumask in the data -- imagine
> 2 such calls with different but overlapping masks -- put in a full mask.

OK, if you really want this, please just change it to:
	unsigned long cpumask_bits[BITS_TO_LONGS(CONFIG_NR_CPUS)];

The 'struct cpumask' will be undefined soon when CONFIG_CPUMASK_OFFSTACK=y,
which will prevent assignment and declaration on stack.

I'd be fascinated to see perf numbers once you kill the kmalloc.  Because
this patch will add num_possible_cpus * NR_CPUS/8 bytes to the kernel which
is something we're trying to avoid unless necessary.

Thanks,
Rusty.
