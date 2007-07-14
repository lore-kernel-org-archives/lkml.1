Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbXGNTas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbXGNTas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762325AbXGNTaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:30:30 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:47081 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762228AbXGNTa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:30:29 -0400
Date: Sat, 14 Jul 2007 15:30:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, prasanna@in.ibm.com, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [patch 1/8] Kprobes - do not use kprobes mutex in arch code
Message-ID: <20070714193026.GL6975@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012411.262873138@polymtl.ca> <20070714104914.GB7358@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714104914.GB7358@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:27:03 up 7 days,  9:32,  2 users,  load average: 0.13, 0.19, 0.21
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Fri, Jul 13, 2007 at 09:21:34PM -0400, Mathieu Desnoyers wrote:
> > Remove the kprobes mutex from kprobes.h, since it does not belong there. Also
> > remove all use of this mutex in the architecture specific code, replacing it by
> > a proper mutex lock/unlock in the architecture agnostic code.
> 
> This is not very nice for avr32/sparc64 which have a noop arch_remove_kprobe
> and now need to take a mutex to do nothing.  Maybe you can find a nice
> way to avoid that?
> 
> Except for this issue making kprobes_mutex static to kprobes.c sounds like
> a good improvement.
> 

While we are here:

The whole check_safety() in kprobes.c seems awkward.. freezing processes
is probably costly, and the check:

if (p != current && p->state == TASK_RUNNING && p->pid != 0) {

Adds restrictions about where a probe can be safely put.. the idle
thread becomes a restriction.

I suggest disabling preemption in the int3 handler, just before
single-stepping, then reenabling it in the breakpoint handler executed
right after the single-step. A synchronize_sched() could then replace
the whole check_safety() and would never fail. The side-effect would be
to disable preemption in the single-step, it's no big deal.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
