Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYIHPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYIHPGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYIHPGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:06:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:44938 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYIHPGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:06:12 -0400
Subject: Re: [RFC 07/13] sched: Reduce stack size requirements in
 kernel/sched.c
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <48C53C91.70604@sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
	 <20080906235037.880702000@polaris-admin.engr.sgi.com>
	 <1220783087.8687.73.camel@twins.programming.kicks-ass.net>
	 <48C53C91.70604@sgi.com>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 17:05:35 +0200
Message-Id: <1220886335.12278.31.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 07:54 -0700, Mike Travis wrote:
> Peter Zijlstra wrote:

> > get_online_cpus() can sleep, but you just disabled preemption with those
> > get_cpumask_var() horribles!
> > 
> > Couldn't be arsed to look through the rest, but I really hate this
> > cpumask_ptr() stuff that relies on disabling preemption.
> > 
> > NAK
> 
> Yeah, I really agree as well.  But I wanted to start playing with using
> cpumask_t pointers in some fairly straight forward manner.  Linus's and
> Ingo's suggestion to just bite the bullet and redefine the cpumask_t 
> would force a lot of changes to be made, but perhaps that's really the
> way to go.

I much prefer that approach!

> As to obtaining temp cpumask_t's (both early and late), perhaps a pool of
> them would be better?  I believe it could be done similar to alloc_bootmem
> (but much simpler), and I don't think there's enough nesting to require a
> very large pool.  (4 was the largest depth I could find in io_apic.c.)  Of
> course, with preemption enabled then other problems arise...
> 
> One other really big use was for the "allbutself" cpumask in the send_IPI
> functions.  I think here, preemption is ok because the ownership of the
> cpumask temp is very short lived.

The thing is, you add serialization requirements (be it preempt_disable,
or a lock for some preemptable form) to code that didn't had any for a
case that hardly anyone will ever encounter in real life - I mean,
really, who has 4096 cpus?

Stuffing the cpumap_t in an already existing structure that has suitable
serialization requirements is of course the preferred situation, but
lacking that a dynamic cpumap_t is best, since it keeps the references
local, and thus doesn't add requirements to the existing code.

You could also consider adding 1 cpumap_t to task_struct and use that as
temporary scratch pad - but seeing you needed at least 4 that might not
be a feasible solution either.

