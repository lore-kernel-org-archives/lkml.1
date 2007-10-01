Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbXJAV7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbXJAV7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbXJAV7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:59:10 -0400
Received: from www.tglx.de ([62.245.132.106]:36501 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXJAV7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:59:09 -0400
Date: Mon, 1 Oct 2007 23:58:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: Arjan van de Ven <arjan@infradead.org>, David Bahi <dbahi@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
In-Reply-To: <200710012341.53169.ak@suse.de>
Message-ID: <alpine.LFD.0.9999.0710012349160.20478@localhost.localdomain>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <20071001125626.32eb6d0b@laptopd505.fenrus.org> <alpine.LFD.0.9999.0710012207270.20478@localhost.localdomain> <200710012341.53169.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Andi Kleen wrote:
> 
> > IRQ_NOBALANCING is not preventing cpu unplug. It moves the affinity to the
> > next CPU, but the check in NMI watchdog for CPU == 0 would not longer
> > work.
> 
> That cannot happen right now because cpu_disable() on both i386/x86-64
> reject CPU #0. So just setting IRQ_NOBALANCING is sufficient and both
> do that already. I was wrong earlier in being concerned about this.
> 
> >  int tick_do_broadcast(cpumask_t mask)
> > @@ -137,6 +147,7 @@ int tick_do_broadcast(cpumask_t mask)
> >  		cpu_clear(cpu, mask);
> >  		td = &per_cpu(tick_cpu_device, cpu);
> >  		td->evtdev->event_handler(td->evtdev);
> > +		tick_broadcast_account(cpu);
> 
> That would not handle the case with a single CPU running only
> irq  0 but not broadcasting I think.

Hmm. The only situation where this can happen is when you add
"nolapic_timer" to the command line on a single CPU system. We do not
register the lapic "dummy" clock event device then.

> I believe 
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/fix-watchdog
> is the correct fix

Yup, I completely missed the fact, that we reject CPU#0 unplugging, so
your fix seems indeed to be more correct and simpler.

OTOH, the accounting hook would allow us to remove the IRQ#0 -> CPU#0
restriction. Not sure whether it's worth the trouble.

     tglx
