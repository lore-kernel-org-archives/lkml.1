Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbXH0UbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbXH0UbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762254AbXH0UZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:25:07 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:44006 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761934AbXH0UZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:25:04 -0400
Date: Mon, 27 Aug 2007 16:25:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB: use have_arch_cmpxchg()
Message-ID: <20070827202501.GC5653@Krystal>
References: <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com> <20070822000323.GG29691@Krystal> <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com> <20070822002616.GA1400@Krystal> <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com> <20070822150248.GB8504@Krystal> <84144f020708220924y6d707d50md1c95eeb58d5ce7@mail.gmail.com> <20070827145627.GB18504@Krystal> <Pine.LNX.4.64.0708271240350.5056@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708271240350.5056@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:22:20 up 28 days, 20:41,  4 users,  load average: 0.03, 0.17, 0.24
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:
> 
> > Hrm, actually, I don't think such have_arch_cmpxchg() macro will be
> > required at all because of the small performance hit disabling
> > preemption will have on the slow and fast paths. Let's compare, for each
> > of the slow path and fast path, what locking looks like on architecture
> > with and without local cmpxchg:
> > 
> > What we actually do here is:
> > 
> > fast path:
> > with local_cmpxchg:
> >   preempt_disable()
> >   preempt_enable()
> > without local_cmpxchg:
> >   preempt_disable()
> >   local_irq_save
> >   local_irq_restore
> >   preempt_enable()
> >     (we therefore disable preemption _and_ disable interrupts for
> >     nothing)
> 
> Hmmm..... This is a performance issue for preempt kernels.
> 
> > slow path:
> > both with and without local_cmpxchg():
> >   preempt_disable()
> >   preempt_enable()
> 
> Here we potentially loose our per cpu structure since the process may be 
> rescheduled.
> 

Yes, what you do here is more precisely:

  preempt_disable()
  local_irq_save()
  preempt_enable_no_resched()
  ...
  local_irq_restore()
  preempt_check_resched()


> >   local_irq_save()
> >   local_irq_restore()
> > 
> > 
> > Therefore, we would add preempt disable/enable to the fast path of
> > architectures where local_cmpxchg is emulated with irqs off. But since
> > preempt disable/enable is just a check counter increment/decrement with
> > barrier() and thread flag check, I doubt it would hurt performances
> > enough to justify the added complexity of disabling interrupts for the
> > whole fast path in this case.
> 
> One additional cacheline referenced in the hot path. Ok the counter may be 
> hot as well if this is a preemptible kernel. Nevertheless a cause for 
> concern.
> 

If kernel is non preemptible, the macros preempt_*() are defined to
nothing. And as you say, on preemptible kernels, these variables (thread
flags and preempt count) are very likely to be in cache, since they are
in the thread info struct, but it should still be kept in mind.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
