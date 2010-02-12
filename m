Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0BLQtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 11:49:33 -0500
Received: from ms01.sssup.it ([193.205.80.99]:36320 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756930Ab0BLQtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 11:49:32 -0500
Subject: sched: Make the rt throtting disabled tunable valid globally
From: Dhaval Giani <dhaval@retis.sssup.it>
To: a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 17:49:29 +0100
Message-ID: <1265993369.1938.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On setting /proc/sys/kernel/sched_rt_runtime_us to -1, the intended
behavior is that rt-group throttling is disabled throughout. This
could be confirmed by trying to launch a real time task in a cgroup
which had zero rt runtime allotted to it.

This though was not happening when one tried to move a rt task into
a rt cgroup which had zero rt runtime. Ensure that this
tunable is honoured globally.

Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>

---
 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: master/kernel/sched.c
===================================================================
--- master.orig/kernel/sched.c
+++ master/kernel/sched.c
@@ -8542,7 +8542,8 @@ static int sched_rt_global_constraints(v
 int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 {
 	/* Don't accept realtime tasks when there is no way for them to run */
-	if (rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
+	if (rt_task(tsk) && rt_bandwidth_enabled() &&
+				tg->rt_bandwidth.rt_runtime == 0)
 		return 0;
 
 	return 1;


