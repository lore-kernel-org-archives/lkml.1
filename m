Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZDWNc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZDWNc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZDWNcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:32:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:48641 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbZDWNcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:32:17 -0400
Date: Thu, 23 Apr 2009 15:32:11 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: npiggin@suse.de, paulmck@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atomic: Only take lock when the counter drops to zero on UP as well
Message-ID: <20090423133211.GT11220@bolzano.suse.de>
References: <20090411141754.45F7B16080@e179.suse.de> <20090417151405.3ca49c39.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417151405.3ca49c39.akpm@linux-foundation.org>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, Andrew Morton wrote:

> On Fri, 10 Apr 2009 18:13:57 +0200
> Jan Blunck <jblunck@suse.de> wrote:
> 
> > I think it is wrong to unconditionally take the lock before calling
> > atomic_dec_and_test() in _atomic_dec_and_lock(). This will deadlock in
> > situation where it is known that the counter will not reach zero (e.g. holding
> > another reference to the same object) but the lock is already taken.
> > 
> 
> It can't deadlock, because spin_lock() doesn't do anything on
> CONFIG_SMP=n.
> 
> You might get lockdep whines on CONFIG_SMP=n, but they'd be false
> positives because lockdep doesn't know that we generate additional code
> for SMP builds.

Sorry, you are right. spin_lock() isn't the problem here. _raw_spin_lock()
calls into __spin_lock_debug():

static void __spin_lock_debug(spinlock_t *lock)
{
        u64 i;
        u64 loops = loops_per_jiffy * HZ;
        int print_once = 1;

        for (;;) {
                for (i = 0; i < loops; i++) {
                        if (__raw_spin_trylock(&lock->raw_lock))
                                return;
                        __delay(1);
                }
                /* lockup suspected: */
                if (print_once) {
                        print_once = 0;
                        printk(KERN_EMERG "BUG: spinlock lockup on CPU#%d, "
                                        "%s/%d, %p\n",
                                raw_smp_processor_id(), current->comm,
                                task_pid_nr(current), lock);
                        dump_stack();
#ifdef CONFIG_SMP
                        trigger_all_cpu_backtrace();
#endif
                }
        }
}

This is an endless loop in this cases since the lock is already held and
therefore __raw_spin_trylock() never succeeds.

> > ---
> >  lib/dec_and_lock.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/dec_and_lock.c b/lib/dec_and_lock.c
> > index a65c314..e73822a 100644
> > --- a/lib/dec_and_lock.c
> > +++ b/lib/dec_and_lock.c
> > @@ -19,11 +19,10 @@
> >   */
> >  int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock)
> >  {
> > -#ifdef CONFIG_SMP
> >  	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
> >  	if (atomic_add_unless(atomic, -1, 1))
> >  		return 0;
> > -#endif
> > +
> >  	/* Otherwise do it the slow way */
> >  	spin_lock(lock);
> >  	if (atomic_dec_and_test(atomic))
> 
> The patch looks reasonable from a cleanup/consistency POV, but the
> analysis and changelog need a bit of help, methinks.
> 

Sorry, I'll come up with a more verbose description of the root cause of how
this locks up.

Cheers,
Jan
