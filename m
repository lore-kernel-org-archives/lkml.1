Return-Path: <linux-kernel-owner+w=401wt.eu-S1161489AbXDSKL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161489AbXDSKL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 06:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161490AbXDSKL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 06:11:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53264 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161489AbXDSKLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 06:11:55 -0400
Date: Thu, 19 Apr 2007 12:11:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Esben Nielsen <nielsen.esben@googlemail.com>
Cc: Christian Hesse <mail@earthworm.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy (was: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS])
Message-ID: <20070419101131.GB32274@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704181759.03559.mail@earthworm.de> <20070418164621.GA30744@elte.hu> <Pine.LNX.4.64.0704191117530.8557@frodo.shire>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704191117530.8557@frodo.shire>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Esben Nielsen <nielsen.esben@googlemail.com> wrote:

> >+	/*
> >+	 * Temporarily insert at the last position of the tree:
> >+	 */
> >+	p->fair_key = LLONG_MAX;
> >+	__enqueue_task_fair(rq, p);
> >	p->on_rq = 1;
> >+
> >+	/*
> >+	 * Update the key to the real value, so that when all other
> >+	 * tasks from before the rightmost position have executed,
> >+	 * this task is picked up again:
> >+	 */
> >+	p->fair_key = rq->fair_clock - p->wait_runtime + p->nice_offset;
> 
> I don't think it safe to change the key after inserting the element in 
> the tree. You end up with an unsorted tree giving where new entries 
> end up in wrong places "randomly".

yeah, indeed. I hoped that once this rightmost entry is removed (as soon 
as it gets scheduled next time) the tree goes back to a correct shape, 
but that's not the case - the left sub-tree and the right sub-tree is 
merged by the rbtree code with the assumption that the entry had a 
correct key.

> I think a better approach would be to keep track of the rightmost 
> entry, set the key to the rightmost's key +1 and then simply insert it 
> there.

yeah. I had that implemented at a stage but was trying to be too clever 
for my own good ;-)

	Ingo
