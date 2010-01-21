Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274Ab0AUPet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0AUPet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894Ab0AUPes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:34:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43692 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0AUPer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:34:47 -0500
Subject: [PATCH] sched: Fix incorrect sanity check
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "heiko.carstens" <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 16:34:27 +0100
Message-ID: <1264088067.4283.1172.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We moved to migrate on wakeup, which means that sleeping tasks could
still be present on offline cpus. Amend the check to only test running
tasks.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -151,7 +151,7 @@ static inline void check_for_tasks(int c
 
 	write_lock_irq(&tasklist_lock);
 	for_each_process(p) {
-		if (task_cpu(p) == cpu &&
+		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
 		    (!cputime_eq(p->utime, cputime_zero) ||
 		     !cputime_eq(p->stime, cputime_zero)))
 			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d\


