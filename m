Return-Path: <linux-kernel-owner+w=401wt.eu-S1031140AbXDSG2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031140AbXDSG2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031153AbXDSG2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:28:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48633 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031140AbXDSG2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:28:48 -0400
Date: Thu, 19 Apr 2007 08:28:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy
Message-ID: <20070419062832.GD18894@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418221609.GA17347@elte.hu> <200704190112.52838.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704190112.52838.mail@earthworm.de>
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


* Christian Hesse <mail@earthworm.de> wrote:

> I now got some error message from my system:
> 
> http://www.eworm.de/tmp/cfs-suspend.jpg

ah, this pinpoints a bug: for performance reasons pick_next_task() 
assumes that the runqueue is not empty - which is true for schedule(), 
but not in migrate_dead_tasks(). Does the patch below fix the crash for 
you?

	Ingo

---
 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4425,6 +4425,8 @@ static void migrate_dead_tasks(unsigned 
 	struct task_struct *next;
 
 	for (;;) {
+		if (!rq->nr_running)
+			break;
 		next = pick_next_task(rq, rq->curr);
 		if (!next)
 			break;
