Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbYFRHCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbYFRHCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbYFRHB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:01:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbYFRHB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:01:56 -0400
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.10.0806171648330.2907@woody.linux-foundation.org>
References: <1213739834.3803.137.camel@johannes.berg>
	 <alpine.LFD.1.10.0806171648330.2907@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 09:01:54 +0200
Message-Id: <1213772514.16944.197.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-17 at 16:55 -0700, Linus Torvalds wrote:
> 
> On Tue, 17 Jun 2008, Johannes Berg wrote:
> >
> > This warning has started to trigger with mac80211 because it can, under
> > some circumstances, use spin_lock_bh() protected sections within
> > irq-disabled sections. Is that a bug?
> 
> Yes, it's a bug.
> 
> Why? Not because of the "spin_lock_bh()" itself, but because of the 
> _unlock_, which does a "local_bh_enable_ip()", which in turn will check 
> the whole "do_softirq()" if it was the last softirq_count.
> 
> And you must not do softirq's when hard-irq's were disabled!
> 
> So it should in theory be ok (but perhaps a bit odd) to do something like
> 
> 	spin_lock_irq(&irq_lock);
> 	..do something..
> 	spin_lock_bh(&bh_lock);
> 	spin_unlock_irq(&irq_lock);
> 	.. do something else ..
> 	spin_unlock_bh(&bh_lock);
> 
> where the "spin_lock_bh()" itself is in an irq-locked context - as long as 
> the "spin_unlock_bh()" is *not*.

I would suggest discouraging such madne^Wcreativity, its gains are
dubious at best and it doesn't make the locking any more obvious and
could be an indication of messy locking to begin with.

So I would like to see Johannes' other patch that allows all of us to
enjoy the warning he ran into ;-)

Peter

