Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYGUTXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYGUTXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYGUTXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:23:04 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:43920 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbYGUTXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:23:02 -0400
Subject: Re: [git pull] scheduler updates for v2.6.27, phase #2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1216657892.2294.34.camel@dhcp32.mvista.com>
References: <20080721153804.GA26072@elte.hu>
	 <1216657892.2294.34.camel@dhcp32.mvista.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 21 Jul 2008 21:23:02 +0200
Message-Id: <1216668182.7257.80.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 09:31 -0700, Daniel Walker wrote:
> On Mon, 2008-07-21 at 17:38 +0200, Ingo Molnar wrote:
> > Linus,
> > 
> > Please pull the latest sched/for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched/for-linus
> > 
> > this includes the cpu_active_map changes (which cleans up scheduler and 
> > CPU hotplug interaction) and Peter's hrtick cleanup (which fixes the 
> > uvesafb regression) and assorted fixlets.
> 
> 
> I get this warning on powerpc builds (linus git as of a few days ago), 
> 
> /localuser/dwalker/linus/kernel/sched_rt.c: In function ‘do_balance_runtime’:
> /localuser/dwalker/linus/kernel/sched_rt.c:256: warning: comparison of distinct pointer types lacks a cast
> 
> I'm not exactly sure why .. Did this get fixed already?

Does this work for you?

---
shut up the type validation in asm-generic/div64.h:do_div()

its complaining diff isn't u64 - which is true, its s64. However we've
already checked its >0, so its safe. However we can't sanely cast since
do_div() is a macro.

Hence use an extra variable.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 47ceac9..3a1be03 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -253,11 +253,13 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 
 		diff = iter->rt_runtime - iter->rt_time;
 		if (diff > 0) {
-			do_div(diff, weight);
+			u64 gain = diff;
+
+			do_div(gain, weight);
 			if (rt_rq->rt_runtime + diff > rt_period)
-				diff = rt_period - rt_rq->rt_runtime;
-			iter->rt_runtime -= diff;
-			rt_rq->rt_runtime += diff;
+				gain = rt_period - rt_rq->rt_runtime;
+			iter->rt_runtime -= gain;
+			rt_rq->rt_runtime += gain;
 			more = 1;
 			if (rt_rq->rt_runtime == rt_period) {
 				spin_unlock(&iter->rt_runtime_lock);


