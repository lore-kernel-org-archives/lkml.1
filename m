Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbYGPIyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbYGPIyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYGPIyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:54:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60693 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbYGPIya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:54:30 -0400
Message-ID: <487DB6DA.1030708@cn.fujitsu.com>
Date: Wed, 16 Jul 2008 16:52:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH] cpuset: avoid unnecessary sched domains rebuilding
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When changing 'sched_relax_domain_level', don't rebuild sched domains
if 'cpus' is empty or 'sched_load_balance' is not set.

Also make the comments of rebuild_sched_domains() more readable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/cpuset.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 798b3ab..70514e8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -500,11 +500,16 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
 /*
  * rebuild_sched_domains()
  *
- * If the flag 'sched_load_balance' of any cpuset with non-empty
- * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
- * which has that flag enabled, or if any cpuset with a non-empty
- * 'cpus' is removed, then call this routine to rebuild the
- * scheduler's dynamic sched domains.
+ * This routine will be called to rebuild the scheduler's dynamic
+ * sched domains:
+ * - if the flag 'sched_load_balance' of any cpuset with non-empty
+ *   'cpus' changes,
+ * - or if the 'cpus' allowed changes in any cpuset which has that
+ *   flag enabled,
+ * - or if the 'sched_relax_domain_level' of any cpuset which has
+ *   that flag enabled and with non-empty 'cpus' changes,
+ * - or if any cpuset with non-empty 'cpus' is removed,
+ * - or if a cpu gets offlined.
  *
  * This routine builds a partial partition of the systems CPUs
  * (the set of non-overlappping cpumask_t's in the array 'part'
@@ -1042,7 +1047,8 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
-		rebuild_sched_domains();
+		if (!cpus_empty(cs->cpus_allowed) && is_sched_load_balance(cs))
+			rebuild_sched_domains();
 	}
 
 	return 0;
-- 
1.5.4.rc3
