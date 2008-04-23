Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYDWLWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYDWLWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbYDWLWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:22:04 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:41887 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbYDWLWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:22:02 -0400
X-SourceIP: 80.56.237.116
Subject: Re: [git pull] scheduler changes for v2.6.26
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Richard Jonsson <richie@coderworld.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1208946604.4803.9.camel@marge.simson.net>
References: <20080419181304.GB21353@elte.hu>
	 <200804192147.43719.elendil@planet.nl> <20080421123903.GE9554@elte.hu>
	 <200804211831.29976.elendil@planet.nl> <20080421194359.GD8770@elte.hu>
	 <1208854300.4695.7.camel@marge.simson.net>  <20080422085905.GA9939@elte.hu>
	 <1208867154.4873.4.camel@marge.simson.net>
	 <1208938303.4905.23.camel@marge.simson.net>
	 <1208946604.4803.9.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 13:21:55 +0200
Message-Id: <1208949715.7115.334.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 12:30 +0200, Mike Galbraith wrote:
> On Wed, 2008-04-23 at 10:11 +0200, Mike Galbraith wrote:
> 
> > I dug my old p3/500 out and hooked it up since I still can't get minicom
> > functional plugging P4->Q6600, but no joy.  Whatever the heck is going
> > wrong in sched-devel is so catastrophic that not one character hits the
> > console when it locks, and nmi_watchdog=1 does nada.
> 
> I built x86/latest to see if it locked, and while testing to see if
> minicom was really really working properly on p3/500, I created an
> explosion.  I see in the log that clockevents griped during boot, and
> when I later poked SysRq-W, box blew to pieces.

> [  604.923629] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> [  604.923629] IP: [<ffffffff802a93ac>] seq_printf+0x2e/0xa7

Sorry about that :-/

this should fix it:

---
Subject: sched: fix oops

sched_debug uses SEQ_printf to use printk when the seqfile 'm' is NULL.
Instead of doing that here too; choose to not output the weight tree
to cut back on output.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 89fa32b..353a481 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1643,8 +1643,10 @@ static void print_cfs_stats(struct seq_file *m, int cpu)
 	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
 		print_cfs_rq(m, cpu, cfs_rq);
 
-	seq_printf(m, "\nWeight tree:\n");
-	print_cfs_rq_tasks(m, &cpu_rq(cpu)->cfs, 1);
+	if (m) {
+		seq_printf(m, "\nWeight tree:\n");
+		print_cfs_rq_tasks(m, &cpu_rq(cpu)->cfs, 1);
+	}
 	rcu_read_unlock();
 }
 #endif


