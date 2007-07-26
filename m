Return-Path: <linux-kernel-owner+w=401wt.eu-S936335AbXGZSfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936335AbXGZSfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934552AbXGZSf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:35:27 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:64418 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934413AbXGZSfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:35:24 -0400
Date: Thu, 26 Jul 2007 14:25:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ankita Garg <ankita@in.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       linux@bohmer.net, LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Message-ID: <20070726182510.GB10324@Krystal>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <1184615557.2698.3.camel@laptopd505.fenrus.org> <20070726072858.GC13061@in.ibm.com> <20070726133138.GA30559@Krystal> <y0mps2f1asz.fsf@ton.toronto.redhat.com> <20070726150226.GB1299@Krystal> <20070726162231.GB30643@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070726162231.GB30643@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:21:28 up 9 days, 12:55,  4 users,  load average: 0.87, 0.54, 0.62
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> On Thu, Jul 26, 2007 at 11:02:26AM -0400, Mathieu Desnoyers wrote:
> > [...]
> > > > The problem is also in _stp_print_flush, not *only* in relay code:
> > > > void _stp_print_flush (void)
> > > > ...
> > > >                 spin_lock(&_stp_print_lock);
> > > >                 spin_unlock(&_stp_print_lock);
> > > > 
> > > > Those will turn into mutexes with -rt.
> > > 
> > > Indeed,
> 
> (Though actually that bug was fixed some time ago.)
> 
> 
> > > plus systemtap-generated locking code uses rwlocks,
> > > local_irq_save/restore or preempt_disable, in various places.  Could
> > > someone point to a place that spells out what would be more
> > > appropriate way of ensuring atomicity while being compatible with -rt?
> > 
> > AFAIK, for your needs either:
> > [...]
> > - Use per-cpu data with preempt disabling/irq disabling
> 
> As in local_irq_save / preempt_disable?  Yes, already done.
> 
> > - Use the original "real" spin locks/rwlocks (raw_*).
> > [...]
> 
> It was unclear from the OLS paper whether the spin_lock_irq* family of
> functions also had to be moved to the raw forms.
> 

Yes, you have them to move them too:

linux/spinlock.h:
#ifdef CONFIG_PREEMPT_RT
# define _spin_lock(l)                  rt_spin_lock(l)
# define _spin_lock_nested(l, s)        rt_spin_lock_nested(l, s)
# define _spin_lock_bh(l)               rt_spin_lock(l)
# define _spin_lock_irq(l)              rt_spin_lock(l)
# define _spin_unlock(l)                rt_spin_unlock(l)
# define _spin_unlock_no_resched(l)     rt_spin_unlock(l)
# define _spin_unlock_bh(l)             rt_spin_unlock(l)
# define _spin_unlock_irq(l)            rt_spin_unlock(l)
# define _spin_unlock_irqrestore(l, f)  rt_spin_unlock(l)
..

And below, both spin_lock and spin_lock_irqsave use PICK_OP to turn into
their _spin_lock_* equivalent, which are both mapped to rt_spin_lock in
-rt.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
