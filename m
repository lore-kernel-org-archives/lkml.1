Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbYJUH32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbYJUH32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYJUH3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:29:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49156 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbYJUH3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:29:19 -0400
Date: Tue, 21 Oct 2008 09:28:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: benh@kernel.crashing.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: Bug in "genirq: record trigger type"
Message-ID: <20081021072857.GA333@elte.hu>
References: <200810202205.m9KM5une024759@hera.kernel.org> <1224570730.7654.242.camel@pasglop> <86802c440810210022i75d3c081r8fc979386cdda9ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810210022i75d3c081r8fc979386cdda9ce@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Mon, Oct 20, 2008 at 11:32 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Mon, 2008-10-20 at 22:05 +0000, Linux Kernel Mailing List wrote:
> >> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0c5d1eb77a8be917b638344a22afe1398236482b
> >> Commit:     0c5d1eb77a8be917b638344a22afe1398236482b
> >> Parent:     d6d5aeb661fc14655c417f3582ae7ec52985d2a8
> >> Author:     David Brownell <dbrownell@users.sourceforge.net>
> >> AuthorDate: Wed Oct 1 14:46:18 2008 -0700
> >> Committer:  Ingo Molnar <mingo@elte.hu>
> >> CommitDate: Thu Oct 2 10:24:09 2008 +0200
> >
> > This one is obviously broken and breaks booting on a whole bunch of
> > machines (including powermac's and thus my G5, it's never good when my
> > own machine breaks !).
> >
> > Nice to see 3 SOB's and one Ack and nobody caught the obvious bug :-)
> >
> >>       desc = irq_desc + irq;
> >> -     if (desc->chip->set_type) {
> >> -             spin_lock_irqsave(&desc->lock, flags);
> >> -             ret = desc->chip->set_type(irq, type);
> >> -             spin_unlock_irqrestore(&desc->lock, flags);
> >> -     }
> >> +     if (type == IRQ_TYPE_NONE)
> >> +             return 0;
> >> +
> >> +     spin_lock_irqsave(&desc->lock, flags);
> >> +     ret = __irq_set_trigger(desc, irq, flags);
> >                                             ^^^^ type maybe ?
> >
> >> +     spin_unlock_irqrestore(&desc->lock, flags);
> >>       return ret;
> >>  }
> >
> > I have to run so no patch until tomorrow unless somebody beats me to it.
> 
> there is patch about it, but somehow get lost.

should be all sorted now, the fix is below.

	Ingo

------------------>
>From aac4ddd11a8d0e402ddc3fbc75204cb64efa0aac Mon Sep 17 00:00:00 2001
From: Chris Friesen <cfriesen@nortel.com>
Date: Mon, 20 Oct 2008 12:41:58 -0600
Subject: [PATCH] genirq: fix set_irq_type() when recording trigger type

In set_irq_type() we want to pass the type rather than the current
interrupt state.

Signed-off-by: Chris Friesen <cfriesen@nortel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 4895fde..3de6ea3 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -127,7 +127,7 @@ int set_irq_type(unsigned int irq, unsigned int type)
 		return 0;
 
 	spin_lock_irqsave(&desc->lock, flags);
-	ret = __irq_set_trigger(desc, irq, flags);
+	ret = __irq_set_trigger(desc, irq, type);
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
