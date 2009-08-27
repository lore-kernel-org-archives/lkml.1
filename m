Return-Path: <linux-kernel-owner+w=401wt.eu-S1751356AbZH0OnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbZH0OnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZH0OnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:43:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:39531 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbZH0OnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:43:22 -0400
Date: Thu, 27 Aug 2009 14:43:05 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/clock] init: Move sched_clock_init after late_time_init
Message-ID: <tip-fa84e9eecfff478df2d00e94deb3fc40fe4634ad@git.kernel.org>
Git-Commit-ID: fa84e9eecfff478df2d00e94deb3fc40fe4634ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 27 Aug 2009 14:43:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa84e9eecfff478df2d00e94deb3fc40fe4634ad
Gitweb:     http://git.kernel.org/tip/fa84e9eecfff478df2d00e94deb3fc40fe4634ad
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 21 Aug 2009 22:01:12 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Aug 2009 16:38:18 +0200

init: Move sched_clock_init after late_time_init

Some architectures initialize clocks and timers in late_time_init and
x86 wants to do the same to avoid FIXMAP hackery for calibrating the
TSC. That would result in undefined sched_clock readout and wreckaged
printk timestamps again. We probably have those already on archs which
do all their time/clock setup in late_time_init.

There is no harm to move that after late_time_init except that a few
more boot timestamps are stale. The scheduler is not active at that
point so no real wreckage is expected.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: linux-arch@vger.kernel.org


---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 11f4f14..0ec75ce 100644
--- a/init/main.c
+++ b/init/main.c
@@ -631,7 +631,6 @@ asmlinkage void __init start_kernel(void)
 	softirq_init();
 	timekeeping_init();
 	time_init();
-	sched_clock_init();
 	profile_init();
 	if (!irqs_disabled())
 		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
@@ -682,6 +681,7 @@ asmlinkage void __init start_kernel(void)
 	numa_policy_init();
 	if (late_time_init)
 		late_time_init();
+	sched_clock_init();
 	calibrate_delay();
 	pidmap_init();
 	anon_vma_init();
