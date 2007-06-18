Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbXFRHZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbXFRHZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758307AbXFRHZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:25:20 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:34403 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617AbXFRHZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:25:20 -0400
To: mingo@elte.hu
CC: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-reply-to: <20070618064343.GA31113@elte.hu> (message from Ingo Molnar on
	Mon, 18 Jun 2007 08:43:43 +0200)
Subject: Re: [BUG] long freezes on thinkpad t60
References: <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu> <20070524141059.GA19872@elte.hu> <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu> <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu>
Message-Id: <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 09:24:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > If this solves the problem on your box then i'll do a proper fix and 
> > > introduce a cpu_relax_memory_change(*addr) type of API to around 
> > > monitor/mwait. This patch boots fine on my T60 - but i never saw 
> > > your problem.
> > 
> > Yes, the patch does make the pauses go away.  In fact just the 
> > smp_mb() seems to suffice.
> 
> cool! Could you send me the smallest patch you tried that still made the 
> hangs go away?

My previous attempt was just commenting out parts of your patch.  But
maybe it's more logical to move the barrier to immediately after the
unlock.

With this patch I can't reproduce the problem, which may not mean very
much, since it was rather a "fragile" bug anyway.  But at least the
fix looks pretty harmless.

Thanks,
Miklos

Index: linux-2.6.22-rc4/kernel/sched.c
===================================================================
--- linux-2.6.22-rc4.orig/kernel/sched.c	2007-06-18 08:59:17.000000000 +0200
+++ linux-2.6.22-rc4/kernel/sched.c	2007-06-18 09:04:13.000000000 +0200
@@ -1168,6 +1168,11 @@ repeat:
 		/* If it's preempted, we yield.  It could be a while. */
 		preempted = !task_running(rq, p);
 		task_rq_unlock(rq, &flags);
+		/*
+		 * Without this barrier, wait_task_inactive() can starve
+		 * waiters of rq->lock (observed on Core2Duo)
+		 */
+		smp_mb();
 		cpu_relax();
 		if (preempted)
 			yield();
