Return-Path: <linux-kernel-owner+w=401wt.eu-S1161443AbXECIHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161443AbXECIHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161791AbXECIHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:07:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43870 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161443AbXECIHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:07:13 -0400
Date: Thu, 3 May 2007 10:07:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v7
Message-ID: <20070503080706.GA18427@elte.hu>
References: <200704300820.49078.a1426z@gawab.com> <20070503074552.GA14960@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503074552.GA14960@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > [...] but there are still some nice issues.
> > 
> > Try running 3 chew.c's, then renicing one to -10, starves others for 
> > some seconds while switching prio-level.  Now renice it back to 10, 
> > it starves for up to 45sec.
> 
> ok - to make sure i understood you correctly: does this starvation 
> only occur right when you renice it (when switching prio levels), and 
> it gets rectified quickly once they get over a few reschedules?

meanwhile i managed to reproduce it by following the exact steps you 
described, and i've fixed the bug in my tree. Can you confirm that the 
patch below fixes it for you too?

	Ingo

----------------->
From: Ingo Molnar <mingo@elte.hu>
Subject: [patch] sched, cfs: fix starvation upon nice level switching

Al Boldi reported the following bug: when switching a CPU-intense task's 
nice levels they can get unfairly starved right after the priority level 
switching. The bug was that when changing the load_weight the 
->wait_runtime value did not get rescaled. So clear wait_runtime when 
switching nice levels.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -575,6 +580,7 @@ static void set_load_weight(struct task_
 {
 	p->load_shift = get_load_shift(p);
 	p->load_weight = 1 << p->load_shift;
+	p->wait_runtime = 0;
 }
 
 static inline void
