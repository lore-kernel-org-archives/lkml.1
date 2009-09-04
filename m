Return-Path: <linux-kernel-owner+w=401wt.eu-S933633AbZIDKZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633AbZIDKZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933437AbZIDKZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:25:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:48603 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933389AbZIDKZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:25:40 -0400
Date: Fri, 4 Sep 2009 10:25:05 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090904092742.GA11014@elte.hu>
References: <20090904092742.GA11014@elte.hu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Fix dynamic power-balancing crash
Message-ID: <tip-d7ea17a76916e456fcc78e45142c66f7fb875e3d@git.kernel.org>
Git-Commit-ID: d7ea17a76916e456fcc78e45142c66f7fb875e3d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 10:25:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7ea17a76916e456fcc78e45142c66f7fb875e3d
Gitweb:     http://git.kernel.org/tip/d7ea17a76916e456fcc78e45142c66f7fb875e3d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 4 Sep 2009 11:49:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 11:52:52 +0200

sched: Fix dynamic power-balancing crash

This crash:

[ 1774.088275] divide error: 0000 [#1] SMP
[ 1774.100355] CPU 13
[ 1774.102498] Modules linked in:
[ 1774.105631] Pid: 30881, comm: hackbench Not tainted 2.6.31-rc8-tip-01308-g484d664-dirty #1629 X8DTN
[ 1774.114807] RIP: 0010:[<ffffffff81041c38>]  [<ffffffff81041c38>]
sched_balance_self+0x19b/0x2d4

Triggers because update_group_power() modifies the sd tree and does
temporary calculations there - not considering that other CPUs
could observe intermediate values, such as the zero initial value.

Calculate it in a temporary variable instead. (we need no memory
barrier as these are all statistical values anyway)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090904092742.GA11014@elte.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b537853..796baf7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3765,19 +3765,22 @@ static void update_group_power(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
+	unsigned long power;
 
 	if (!child) {
 		update_cpu_power(sd, cpu);
 		return;
 	}
 
-	sdg->cpu_power = 0;
+	power = 0;
 
 	group = child->groups;
 	do {
-		sdg->cpu_power += group->cpu_power;
+		power += group->cpu_power;
 		group = group->next;
 	} while (group != child->groups);
+
+	sdg->cpu_power = power;
 }
 
 /**
