Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYIXIq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYIXIq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYIXIqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:46:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55208 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYIXIqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:46:20 -0400
Date: Wed, 24 Sep 2008 10:45:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Should irq_chip->mask disable percpu interrupts to all cpus,
	or just to this cpu?
Message-ID: <20080924084558.GD5576@elte.hu>
References: <48D94B64.3070004@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D94B64.3070004@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi,
> 
> I'm reworking Xen's interrupt handling to isolate it a bit from the 
> workings of the apic-based code, as Eric suggested a while back.
> 
> As I've mentioned before, Xen represents interrupts as event channels. 
> There are two major classes of event channels: per-cpu and, erm, not 
> percpu.  Per-cpu event channels are for things like timers and IPI 
> function calls which are inherently per-cpu; it's meaningless to 
> consider, for example, migrating them from cpu to cpu.  I guess 
> they're analogous to the the local apic vectors.
> 
> (Non-percpu event channels can be bound to a particular cpu, and 
> rebound at will; I'm not worried about them here.)
> 
> Previously I allocated an irq per percpu event channel per cpu.  This 
> was pretty wasteful, since I need about 5-6 of them per cpu, so the 
> number of interrupts increases quite quickly as cpus does.  There's no 
> deep problem with that, but it gets fairly ugly in /proc/interrupts, 
> and there's some tricky corners to manage in suspend/resume.
> 
> This time around I'm allocating a single irq for each percpu interrupt 
> source (so one for timers, one for IPI, etc), and mapping each per-cpu 
> event channel to each.  But I'm wondering what the correct behaviour 
> of irq_chip->mask/unmask should be in this case.  Each event channel 
> is individually maskable, so when ->mask gets called, I can either 
> mask all the event channels associated with that irq, or just the one 
> for this cpu.  The latter makes most sense for me, but I don't quite 
> understand the irq infrastructure enough to know if it will have bad 
> effects globally.
> 
> When I request the irq, I pass IRQF_PERCPU in the flags, but aside 
> from preventing migration, this only seems to have an effect on 
> __do_IRQ(), which looks like a legacy path anyway.  It seems to me 
> that by setting it that I'm giving the interrupt subsystem fair 
> warning that ->mask() is only going to disable the interrupt on this 
> cpu.
> 
> Are there any other ill-effects of sharing an irq across all cpus like 
> this?  I guess there's some risk of contention on the irq_desc lock.

You should be a pretty special case: both the producer and consumer of 
those IRQs. So if you change the semantics of ->mask()/->unmask() you'll 
only affect your own drivers: you might get irqs even after you 
disable_irq_nosync(). [but the genirq layer wont pass them down]

The genirq layer should be robust enough all across - as stray IRQs are 
commonplace on real hw anyway. Sometimes we have ->unmask() methods that 
opportunistically do not unmask the hw itself (but hope for an irq to 
not occur) - edge handlers for example. And you probably wont use 
disable_irq_nosync() anyway, you just want genirq to prevent irq handler 
self-reentry, right?

So i _think_ in theory with your scheme you should get enough 
concurrency and no arbitrary limitations/serialization/etc. - but you 
should check whether Miss Practice agrees with that ;)

	Ingo
