Return-Path: <linux-kernel-owner+w=401wt.eu-S1763378AbZAQQBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763378AbZAQQBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZAQQBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:01:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55170 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbZAQQBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:01:40 -0500
Date: Sat, 17 Jan 2009 17:01:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>, Avi Kivity <avi@redhat.com>,
       Kevin Shanahan <kmshanah@ucwb.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fixes
Message-ID: <20090117160115.GA31601@elte.hu>
References: <1231964647.14825.59.camel@laptop> <20090116204049.f4d6ef1c.akpm@linux-foundation.org> <1232173776.7073.21.camel@marge.simson.net> <1232186054.6813.48.camel@marge.simson.net> <1232186877.14073.59.camel@laptop> <1232188484.6813.85.camel@marge.simson.net> <1232193617.14073.67.camel@laptop> <1232194752.6273.5.camel@marge.simson.net> <20090117044316.bda7d0bd.akpm@linux-foundation.org> <1232198574.16303.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232198574.16303.8.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Sat, 2009-01-17 at 04:43 -0800, Andrew Morton wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=12465 just popped up - another
> > scheduler regression.  It has been bisected.
> 
> Seems pretty clear.  I'd suggest reverting it.

We can revert it (and will revert it if no solution is found), but i'd 
also like to understand why it happens, because that kind of regression 
from this change is unexpected - we might be hiding some bug that could 
pop up under less debuggable circumstances, so we need to understand it 
while we have a chance.

Below is the commit in question. Avi, any ideas what makes KVM special 
here? Perhaps its use of "preempt notifiers" is causing a problem somehow?

	Ingo

-------------->
>From 14800984706bf6936bbec5187f736e928be5c218 Mon Sep 17 00:00:00 2001
From: Mike Galbraith <efault@gmx.de>
Date: Fri, 7 Nov 2008 15:26:50 +0100
Subject: [PATCH] sched: fine-tune SD_MC_INIT

Tune SD_MC_INIT the same way as SD_CPU_INIT:
unset SD_BALANCE_NEWIDLE, and set SD_WAKE_BALANCE.

This improves vmark by 5%:

vmark         132102 125968 125497 messages/sec    avg 127855.66    .984
vmark         139404 131719 131272 messages/sec    avg 134131.66   1.033

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

 # *DOCUMENTATION*
---
 include/linux/topology.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 34a7ee0..a8d8405 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -120,10 +120,10 @@ void arch_update_cpu_topology(void);
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
+				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
 				| BALANCE_FOR_MC_POWER,	\
 	.last_balance		= jiffies,		\
