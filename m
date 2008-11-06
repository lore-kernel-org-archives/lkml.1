Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYKFBsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYKFBsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 20:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYKFBsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 20:48:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49777 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbYKFBsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 20:48:10 -0500
Message-ID: <49124C2C.9080300@cn.fujitsu.com>
Date: Thu, 06 Nov 2008 09:45:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: [PATCH] sched: fix a bug in sched domain degenerate
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1) on i386 with SCHED_SMT and SCHED_MC enabled
	# mount -t cgroup -o cpuset xxx /mnt
	# echo 0 > /mnt/cpuset.sched_load_balance
	# mkdir /mnt/0
	# echo 0 > /mnt/0/cpuset.cpus
	# dmesg
	CPU0 attaching sched-domain:
	 domain 0: span 0 level CPU
	  groups: 0

(2) on i386 with SCHED_MC enabled but SCHED_SMT disabled
	# same with (1)
	# dmesg
	CPU0 attaching NULL sched-domain.

The bug is some sched domains may be skipped unintentionally when
doing sched domain degenerating.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dee79ad..b13f45a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6875,15 +6875,17 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	struct sched_domain *tmp;
 
 	/* Remove the sched domains which do not contribute to scheduling. */
-	for (tmp = sd; tmp; tmp = tmp->parent) {
+	for (tmp = sd; tmp; ) {
 		struct sched_domain *parent = tmp->parent;
 		if (!parent)
 			break;
+
 		if (sd_parent_degenerate(tmp, parent)) {
 			tmp->parent = parent->parent;
 			if (parent->parent)
 				parent->parent->child = tmp;
-		}
+		} else
+			tmp = tmp->parent;
 	}
 
 	if (sd && sd_degenerate(sd)) {
-- 
1.5.4.rc3

