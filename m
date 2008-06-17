Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbYFQX5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbYFQX5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbYFQX5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:57:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756705AbYFQX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:57:24 -0400
Date: Tue, 17 Jun 2008 16:55:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
In-Reply-To: <1213739834.3803.137.camel@johannes.berg>
Message-ID: <alpine.LFD.1.10.0806171648330.2907@woody.linux-foundation.org>
References: <1213739834.3803.137.camel@johannes.berg>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Johannes Berg wrote:
>
> This warning has started to trigger with mac80211 because it can, under
> some circumstances, use spin_lock_bh() protected sections within
> irq-disabled sections. Is that a bug?

Yes, it's a bug.

Why? Not because of the "spin_lock_bh()" itself, but because of the 
_unlock_, which does a "local_bh_enable_ip()", which in turn will check 
the whole "do_softirq()" if it was the last softirq_count.

And you must not do softirq's when hard-irq's were disabled!

So it should in theory be ok (but perhaps a bit odd) to do something like

	spin_lock_irq(&irq_lock);
	..do something..
	spin_lock_bh(&bh_lock);
	spin_unlock_irq(&irq_lock);
	.. do something else ..
	spin_unlock_bh(&bh_lock);

where the "spin_lock_bh()" itself is in an irq-locked context - as long as 
the "spin_unlock_bh()" is *not*.

See?

		Linus
