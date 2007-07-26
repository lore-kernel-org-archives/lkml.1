Return-Path: <linux-kernel-owner+w=401wt.eu-S1763710AbXGZPCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763710AbXGZPCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbXGZPCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:02:31 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:53885 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755719AbXGZPCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:02:30 -0400
Date: Thu, 26 Jul 2007 11:02:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ankita Garg <ankita@in.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       linux@bohmer.net, LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Message-ID: <20070726150226.GB1299@Krystal>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <1184615557.2698.3.camel@laptopd505.fenrus.org> <20070726072858.GC13061@in.ibm.com> <20070726133138.GA30559@Krystal> <y0mps2f1asz.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <y0mps2f1asz.fsf@ton.toronto.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:55:24 up 9 days,  9:29,  3 users,  load average: 0.01, 0.26, 0.32
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > [...]
> > The problem is also in _stp_print_flush, not *only* in relay code:
> > void _stp_print_flush (void)
> > ...
> >                 spin_lock(&_stp_print_lock);
> >                 ...
> >                 spin_unlock(&_stp_print_lock);
> > 
> > Those will turn into mutexes with -rt.
> 
> Indeed, plus systemtap-generated locking code uses rwlocks,
> local_irq_save/restore or preempt_disable, in various places.  Could
> someone point to a place that spells out what would be more
> appropriate way of ensuring atomicity while being compatible with -rt?
> 
> - FChE

AFAIK, for your needs either:
- Use atomic ops
- Use per-cpu data with preempt disabling/irq disabling
- Use the original "real" spin locks/rwlocks (raw_*).
- Don't play with timers or wakeups, since this kernel code uses the
  "standard" spin locks (sleepable in -rt).

You just don't want to sleep in the tracing code.

Make sure that the sub-buffer switch code respects that too: it is the
most tricky and yet less executed part of the tracing code, so it's easy
for bugs to slip there and yet be undetected for a while.

Since you will likely disable preemption, make sure your tracing code
executes in a deterministic time.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
