Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZD3TmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZD3TmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZD3TmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:42:05 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:42090 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbZD3TmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:42:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkGAKCY+UlMQW1W/2dsb2JhbACBUM82g38F
Date: Thu, 30 Apr 2009 15:41:58 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yuriy Lalym <ylalym@gmail.com>, Tejun Heo <tj@kernel.org>,
       ltt-dev@lists.casi.polymtl.ca,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430194158.GB12926@Krystal>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <20090430062140.GA9559@elte.hu> <20090430063306.GA27431@Krystal> <20090430065055.GA16277@elte.hu> <alpine.DEB.1.10.0904300926530.22262@qirst.com> <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904301009530.14178@qirst.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:08:18 up 61 days, 12:34,  2 users,  load average: 0.90, 0.83,
	0.79
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Thu, 30 Apr 2009, Mathieu Desnoyers wrote:
> 
> > > The 3 variants on x86 generate the same instructions. On other platforms
> > > they would need to be able to fallback in various way depending on the
> > > availability of instructions that are atomic vs. preempt or irqs.
> > >
> >
> > The problem here, as we did figure out a while ago with the atomic
> > slub we worked on a while ago, is that if we have the following code :
> >
> > local_irq_save
> > var++
> > var++
> > local_irq_restore
> >
> > that we would like to turn into irq-safe percpu variant with this
> > semantic :
> >
> > percpu_add_irqsafe(var)
> > percpu_add_irqsafe(var)
> >
> > We are generating two irq save/restore in the fallback, which will be
> > slow.
> >
> > However, we could do the following trick :
> >
> > percpu_irqsave(flags);
> > percpu_add_irq(var);
> > percpu_add_irq(var);
> > percpu_irqrestore(flags);
> 
> Hmmm.I do not remember any of those double ops in the patches that I did a
> while back for this. It does not make sense either because atomic per cpu
> ops are only atomic for a single instruction. You are trying to extend
> that so that multiple "atomic" instructions are now atomic.
> 

Hrm, not exactly. So I probably chose the naming of the primitives
poorly here if my idea seems unclear. Here is what I am trying to do :

On architectures with irq-safe percpu_add :
- No need to disable interrupts at all

On archs lacking such irq-safe percpu_add :
- disabling interrupts only once for a sequence of percpu counter operations.

I tried to come up with an example in vmstat where multiple percpu ops
would be required, but I figured out that the code needs to be changed
to support percpu ops correctly. However separating
percpu_irqsave/restore from percpu_add_return_irq lets us express
__inc_zone_state and inc_zone_state cleanly, which would be difficult
otherwise.

Let's assume we change the stat_threshold values in mm/vmstat.c so they
become power of 2 (so we don't care when the u8 overflow occurs so it
becomes a free running counter). This model does not support
"overstep" (yet).

Then assume :

        u8 stat_threshold_mask = pcp->stat_threshold - 1;

mm/vmstat.c :

void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
{
        ... assuming p references percpu "u8" counters ...
        u8 p_new;

        p_new = percpu_add_return_irq(p, 1);

        if (unlikely(!(p_new & pcp->stat_threshold_mask)))
                zone_page_state_add(pcp->stat_threshold, zone, item);
}


void inc_zone_state(struct zone *zone, enum zone_stat_item item)
{
        unsigned long flags;

        /*
         * Disabling interrupts _only_ on architectures lacking atomic
         * percpu_*_irq ops.
         */
        percpu_irqsave(flags);
        __inc_zone_state(zone, item);
        percpu_irqrestore(flags);
}

void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
{
        ... assuming p references percpu "u8" counters ...
        u8 p_new;

        p_new = percpu_sub_return_irq(p, 1);

        if (unlikely(!(p_new & pcp->stat_threshold_mask)))
                zone_page_state_add(-(pcp->stat_threshold), zone, item);
}

void dec_zone_state(struct zone *zone, enum zone_stat_item item)
{
        unsigned long flags;

        /*
         * Disabling interrupts _only_ on architectures lacking atomic
         * percpu_*_irq ops.
         */
        percpu_irqsave(flags);
        __dec_zone_state(zone, item);
        percpu_irqrestore(flags);
}

void __mod_zone_state(struct zone *zone, enum zone_stat_item item, long delta)
{
        ... assuming p references percpu "u8" counters ...

        u8 p_new;
        long overflow_delta;

        p_new = percpu_add_return_irq(p, delta);

        /*
         * We must count the number of threshold overflow generated by
         * "delta". I know, this looks rather odd.
         */
        overflow_delta = ((long)p_new & ~(long)pcp->stat_threshold_mask)
                         - (((long)p_new - delta)
                           & ~(long)pcp->stat_threshold_mask);

        if (unlikely(abs(overflow_delta) > pcp->stat_threshold_mask))
                zone_page_state_add(glob_delta, zone, item);
}

void mod_zone_state(struct zone *zone, enum zone_stat_item item, long delta)
{
        unsigned long flags;

        /*
         * Disabling interrupts _only_ on architectures lacking atomic
         * percpu_*_irq ops.
         */
        percpu_irqsave(flags);
        __mod_zone_state(zone, item, detlta);
        percpu_irqrestore(flags);
}

Note that all the fast-path would execute with preemption enabled if the
architecture supports irqsave percpu atomic ops.

So as we can see, if cpu ops are used on _different_ atomic counters,
then it may require multiple percpu ops in sequence. However, in the
vmstat case, given the version currently in mainline uses a sequence of
operations on the same variable, this requires re-engineering the
structure, because otherwise races with preemption would occur.

disclaimer : the code above has been written in a email client and may
not compile/work/etc etc.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
