Return-Path: <linux-kernel-owner+w=401wt.eu-S1762762AbZEAVTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762762AbZEAVTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbZEAVTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:19:14 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:47317 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbZEAVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:19:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAPv++klMQW1W/2dsb2JhbACBUM1Vg30F
Date: Fri, 1 May 2009 17:19:11 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <cl@linux.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090501211911.GA22134@Krystal>
References: <20090430194158.GB12926@Krystal> <alpine.DEB.1.10.0904301559500.11923@qirst.com> <20090430211750.GA19933@Krystal> <alpine.DEB.1.10.0905010939090.18324@qirst.com> <20090501192142.GA18339@Krystal> <alpine.DEB.1.10.0905011527260.7795@qirst.com> <20090501202400.GA20280@Krystal> <alpine.DEB.1.10.0905011623450.16255@qirst.com> <20090501204355.GB20280@Krystal> <alpine.DEB.1.10.0905011640480.16255@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905011640480.16255@qirst.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:03:47 up 62 days, 17:30,  2 users,  load average: 0.40, 0.45,
	0.45
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Fri, 1 May 2009, Mathieu Desnoyers wrote:
> 
> > Then do you have a better idea on how to deal with
> > __inc_zone_state/inc_zone_state without duplicating the code and without
> > adding useless local_irq_save/restore on x86 ?
> 
> We are already using __inc_zone_state to avoid local_irq_save/restore.
> 

Then, if I understand you correctly, you propose :

void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
{
        ... assuming p references percpu "u8" counters ...
        u8 p_new;

        p_new = percpu_add_return(p, 1);

        if (unlikely(!(p_new & pcp->stat_threshold_mask)))
                zone_page_state_add(pcp->stat_threshold, zone, item);
}

void inc_zone_state(struct zone *zone, enum zone_stat_item item)
{
        ... assuming p references percpu "u8" counters ...
        u8 p_new;

        p_new = percpu_add_return_irqsafe(p, 1);

        if (unlikely(!(p_new & pcp->stat_threshold_mask)))
                zone_page_state_add(pcp->stat_threshold, zone, item);
}

(therefore opting for code duplication)

Am I correct ?

It can indeed by argued to be more straightforward than adding irq
disabling primitives which behave differently depending on the
architecture. And it certainly makes sense as long as duplicated
functions are small enough and as long as we never touch more than one
counter in the same function.

A compromise would be to include the appropriate irq disabling or
preempt disabling in the "standard version" of these functions, but
create underscore prefixed versions which would need
percpu_local_irqsave and friends to be done separately. Therefore, the
standard usage would be easy to deal with and review, and it would still
allow using the underscore-prefixed version when code would otherwise
have to be duplicated or when multiple counters must be updated at once.

And the rule would be simple enough :

- percpu_add_return_irqsafe is safe wrt interrupts.

- _always_ disable interrupts or use percpu_local_irqsave/restore
  around __percpu_add_return_irqsafe().

For the example above, this would let us write :

void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
{
        ... assuming p references percpu "u8" counters ...
        u8 p_new;

        p_new = __percpu_add_return_irqsafe(p, 1);

        if (unlikely(!(p_new & pcp->stat_threshold_mask)))
                zone_page_state_add(pcp->stat_threshold, zone, item);
}

void inc_zone_state(struct zone *zone, enum zone_stat_item item)
{
	unsigned long flags;

	percpu_local_irqsave(flags);
	__inc_zone_state(zone, item);
	percpu_local_irqrestore(flags);
}

Which is more compact and does not duplicate code.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
