Return-Path: <linux-kernel-owner+w=401wt.eu-S933961AbXCFGks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933961AbXCFGks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 01:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933967AbXCFGks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 01:40:48 -0500
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:46668 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933961AbXCFGkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 01:40:47 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sched: fix idle at tick
Date: Tue, 6 Mar 2007 17:25:36 +1100
User-Agent: KMail/1.9.5
Cc: "J.A. =?iso-8859-1?q?Magall=F3n?=" <jamagallon@ono.com>,
       linux-kernel@vger.kernel.org
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070305232058.6eeeb254@werewolf-wl> <20070305151120.e5eab328.akpm@linux-foundation.org>
In-Reply-To: <20070305151120.e5eab328.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061725.37365.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 10:11, Andrew Morton wrote:
> On Mon, 5 Mar 2007 23:20:58 +0100
>
> "J.A. Magall__n" <jamagallon@ono.com> wrote:
> > On Fri, 2 Mar 2007 03:00:26 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > Temporarily at
> > >
> > >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > >
> > > Will appear later at
> > >
> > >  
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc
> > >2/2.6.21-rc2-mm1/
> >
> > I'm also noticing very bad behaviour wrt scheduling, I think. When I
> > launch my parallel cpu burning code, the system _really_ stalls, the
> > mouse in X11 is not jerky, it is _stuck_ for a couple or three seconds...
> >
> > The only diffrecence is that, trying to solve nVidia driver problems, I
> > disabled BKL preemption:
> >
> > werewolf:/usr/src/linux# grep PREEMPT .config
> > # CONFIG_PREEMPT_RCU is not set
> > # CONFIG_PREEMPT_NONE is not set
> > # CONFIG_PREEMPT_VOLUNTARY is not set
> > CONFIG_PREEMPT=y
> > # CONFIG_PREEMPT_BKL is not set
>
> Do you think that is a problem which is introduced by -rc1-mm1?
>
> It'd be good if you can capture the `top' output while this is happening -
> it could be the longstanding problem where an app's sleep/run pattern
> permits it to get a lot of dynamic priority boosting, even though it is
> CPU-intensive.

Haven't tried -mm in a while... but this could be more than a little hairy..

Call me crazy but I think the following might just be responsible...

---
Fix reverse idle at tick logic.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc2-mm1-base/kernel/sched.c
===================================================================
--- linux-2.6.21-rc2-mm1-base.orig/kernel/sched.c	2007-03-06 17:19:17.000000000 +1100
+++ linux-2.6.21-rc2-mm1-base/kernel/sched.c	2007-03-06 17:20:40.000000000 +1100
@@ -3444,7 +3444,7 @@ void scheduler_tick(void)
 
 	update_cpu_clock(p, rq, now);
 
-	if (idle_at_tick)
+	if (!idle_at_tick)
 		task_running_tick(rq, p);
 #ifdef CONFIG_SMP
 	update_load(rq);

-- 
-ck
