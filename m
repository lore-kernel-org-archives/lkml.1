Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYGIMmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYGIMmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYGIMmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:42:14 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:55770 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbYGIMmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:42:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8EANxMdEhMQWVt/2dsb2JhbACBWq4y
Date: Wed, 9 Jul 2008 08:42:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] stop_machine: simplify
Message-ID: <20080709124210.GA882@Krystal>
References: <200807081750.55536.rusty@rustcorp.com.au> <200807081756.47140.rusty@rustcorp.com.au> <20080708142703.GB8278@Krystal> <200807091211.39457.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200807091211.39457.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:31:37 up 34 days, 17:12,  3 users,  load average: 1.97, 2.45,
	2.34
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Wednesday 09 July 2008 00:27:03 Mathieu Desnoyers wrote:
> > Hi Rusty,
> >
> > * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > > stop_machine creates a kthread which creates kernel threads.  We can
> > > create those threads directly and simplify things a little.  Some care
> > > must be taken with CPU hotunplug, which has special needs, but that code
> > > seems more robust than it was in the past.
> > >
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > > ---
> > >  include/linux/stop_machine.h |   12 -
> > >  kernel/cpu.c                 |   13 -
> > >  kernel/stop_machine.c        |  299
> > > ++++++++++++++++++------------------------- 3 files changed, 135
> > > insertions(+), 189 deletions(-)
> > >
> > > diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
> > > --- a/include/linux/stop_machine.h
> > > +++ b/include/linux/stop_machine.h
> > > @@ -17,13 +17,12 @@
> > >   * @data: the data ptr for the @fn()
> > >   * @cpu: if @cpu == n, run @fn() on cpu n
> > >   *       if @cpu == NR_CPUS, run @fn() on any cpu
> > > - *       if @cpu == ALL_CPUS, run @fn() first on the calling cpu, and
> > > then - *       concurrently on all the other cpus
> > > + *       if @cpu == ALL_CPUS, run @fn() on every online CPU.
> > >   *
> >
> > I agree with this change if it makes things simpler. However, callers
> > must be aware of this important change :
> >
> > "run @fn() first on the calling cpu, and then concurrently on all the
> > other cpus" becomes "run @fn() on every online CPU".
> 
> OK.  Since that was never in mainline, I think you're the only one who needs 
> to be aware of the semantic change?
> 
> The new symmetric implementation breaks it; hope that isn't a showstopper for 
> you?
> 

Nope, that should be ok with something like :

...
                atomic_set(1, &stop_machine_first);
                wrote_text = 0;
                stop_machine_run(stop_machine_imv_update, (void *)imv,
                                        ALL_CPUS);
...

static int stop_machine_imv_update(void *imv_ptr)
{
        struct __imv *imv = imv_ptr;

        if (atomic_dec_and_test(&stop_machine_first)) {
                text_poke((void *)imv->imv, (void *)imv->var, imv->size);
                smp_wmb(); /* make sure other cpus see that this has run */
                wrote_text = 1;
        } else {
                while (!wrote_text)
                        smp_rmb();
                sync_core();
        }

        flush_icache_range(imv->imv, imv->imv + imv->size);

        return 0;
}

> > There were assumptions done in @fn() where a simple non atomic increment
> > was used on a static variable to detect that it was the first thread to
> > execute. It will have to be changed into an atomic inc/dec and test.
> > Given that the other threads have tasks to perform _after_ the first
> > thread has executed, they will have to busy-wait (spin) there waiting
> > for the first thread to finish its execution.
> 
> I assume you can't do that step then call stop_machine.
> 

Indeed, I can't, because I need to have all other CPUs busy looping with
interrupts disabled while I do the text_poke.

Mathieu


> Thanks,
> Rusty.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
