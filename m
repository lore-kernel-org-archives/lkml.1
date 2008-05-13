Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbYEMC2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbYEMC2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 22:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbYEMC2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 22:28:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56174 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbYEMC2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 22:28:44 -0400
Message-ID: <4828FC85.7020400@cn.fujitsu.com>
Date: Tue, 13 May 2008 10:27:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: limit the input of cpuset.sched_relax_domain_level
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allow the inputs to be [-1 ... SD_LV_MAX), and return -EINVAL
for inputs outside this range.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cpusets.txt |    2 +-
 kernel/cpuset.c           |    4 ++--
 kernel/sched.c            |    7 ++++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/cpusets.txt b/Documentation/cpusets.txt
index fb7b361..9066ce7 100644
--- a/Documentation/cpusets.txt
+++ b/Documentation/cpusets.txt
@@ -542,7 +542,7 @@ otherwise initial value -1 that indicates the cpuset has no request.
    2  : search cores in a package.
    3  : search cpus in a node [= system wide on non-NUMA system]
  ( 4  : search nodes in a chunk of node [on NUMA system] )
- ( 5~ : search system wide [on NUMA system])
+ ( 5  : search system wide [on NUMA system] )
 
 This file is per-cpuset and affect the sched domain where the cpuset
 belongs to.  Therefore if the flag 'sched_load_balance' of a cpuset
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 86ea9e3..c192213 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1033,8 +1033,8 @@ int current_cpuset_is_being_rebound(void)
 
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
-	if ((int)val < 0)
-		val = -1;
+	if (val < -1 || val >= SD_LV_MAX)
+		return -EINVAL;
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
diff --git a/kernel/sched.c b/kernel/sched.c
index 8841a91..24d499e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7219,7 +7219,12 @@ static int default_relax_domain_level = -1;
 
 static int __init setup_relax_domain_level(char *str)
 {
-	default_relax_domain_level = simple_strtoul(str, NULL, 0);
+	unsigned long val;
+
+	val = simple_strtoul(str, NULL, 0);
+	if (val < SD_LV_MAX)
+		default_relax_domain_level = val;
+
 	return 1;
 }
 __setup("relax_domain_level=", setup_relax_domain_level);
-- 
1.5.4.rc3
