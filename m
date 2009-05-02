Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZEBDKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZEBDKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 23:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZEBDK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 23:10:26 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:42027 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZEBDKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 23:10:24 -0400
Date: Fri, 1 May 2009 23:00:21 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090501211911.GA22134@Krystal>
Message-ID: <alpine.DEB.1.10.0905012257510.32364@qirst.com>
References: <20090430194158.GB12926@Krystal> <alpine.DEB.1.10.0904301559500.11923@qirst.com> <20090430211750.GA19933@Krystal> <alpine.DEB.1.10.0905010939090.18324@qirst.com> <20090501192142.GA18339@Krystal> <alpine.DEB.1.10.0905011527260.7795@qirst.com>
 <20090501202400.GA20280@Krystal> <alpine.DEB.1.10.0905011623450.16255@qirst.com> <20090501204355.GB20280@Krystal> <alpine.DEB.1.10.0905011640480.16255@qirst.com> <20090501211911.GA22134@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Mathieu Desnoyers wrote:

> Then, if I understand you correctly, you propose :
>
> void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
> {
>         ... assuming p references percpu "u8" counters ...
>         u8 p_new;
>
>         p_new = percpu_add_return(p, 1);
>
>         if (unlikely(!(p_new & pcp->stat_threshold_mask)))
>                 zone_page_state_add(pcp->stat_threshold, zone, item);
> }
>
> void inc_zone_state(struct zone *zone, enum zone_stat_item item)
> {
>         ... assuming p references percpu "u8" counters ...
>         u8 p_new;
>
>         p_new = percpu_add_return_irqsafe(p, 1);
>
>         if (unlikely(!(p_new & pcp->stat_threshold_mask)))
>                 zone_page_state_add(pcp->stat_threshold, zone, item);
> }
>
> (therefore opting for code duplication)
>
> Am I correct ?

Well __inc_zone_state is fine by itself. inc_zone_state will currently
disable irqs. But we can do it your way and duplicate the code.

> void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
> {
>         ... assuming p references percpu "u8" counters ...
>         u8 p_new;
>
>         p_new = __percpu_add_return_irqsafe(p, 1);
>
>         if (unlikely(!(p_new & pcp->stat_threshold_mask)))
>                 zone_page_state_add(pcp->stat_threshold, zone, item);
> }
>
> void inc_zone_state(struct zone *zone, enum zone_stat_item item)
> {
> 	unsigned long flags;
>
> 	percpu_local_irqsave(flags);
> 	__inc_zone_state(zone, item);
> 	percpu_local_irqrestore(flags);
> }
>
> Which is more compact and does not duplicate code.

This is almost like the current code. But lets avoid percpu_local_irqs
etc if we can.
