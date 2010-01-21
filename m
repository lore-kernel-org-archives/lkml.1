Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662Ab0AUNwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab0AUNwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228Ab0AUNwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:52:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:46214 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab0AUNwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:52:16 -0500
Date: Thu, 21 Jan 2010 13:51:34 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, ming.m.lin@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1262612696.15495.15.camel@marge.simson.net>
References: <1262612696.15495.15.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix vmark regression on big machines
Message-ID: <tip-50b926e439620c469565e8be0f28be78f5fca1ce@git.kernel.org>
Git-Commit-ID: 50b926e439620c469565e8be0f28be78f5fca1ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:51:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50b926e439620c469565e8be0f28be78f5fca1ce
Gitweb:     http://git.kernel.org/tip/50b926e439620c469565e8be0f28be78f5fca1ce
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Mon, 4 Jan 2010 14:44:56 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:39:03 +0100

sched: Fix vmark regression on big machines

SD_PREFER_SIBLING is set at the CPU domain level if power saving isn't
enabled, leading to many cache misses on large machines as we traverse
looking for an idle shared cache to wake to.  Change the enabler of
select_idle_sibling() to SD_SHARE_PKG_RESOURCES, and enable same at the
sibling domain level.

Reported-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1262612696.15495.15.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/topology.h |    2 +-
 kernel/sched_fair.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 57e6357..5b81156 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,7 +99,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 42ac3c9..8fe7ee8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1508,7 +1508,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING)
+			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {
