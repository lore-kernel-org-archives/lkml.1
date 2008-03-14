Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYCNKG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYCNKG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 06:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYCNKGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 06:06:50 -0400
Received: from sacred.ru ([62.205.161.221]:42447 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYCNKGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 06:06:49 -0400
Message-ID: <47DA4AE8.4030207@openvz.org>
Date: Fri, 14 Mar 2008 12:52:40 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Memcgroup: implement failcounter reset
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 14 Mar 2008 12:52:39 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a very common requirement from people using the
resource accounting facilities (not only memcgroup but
also OpenVZ beancounters). They want to put the cgroup in
an initial state without re-creating it.

For example after re-configuring a group people want to
observe how this new configuration fits the group needs
without saving the previous failcnt value.

Merge two resets into one mem_cgroup_reset() function to
demonstrate how multiplexing work.

Besides, I have plans to move the files, that correspond to
res_counter to the res_counter.c file and somehow "import" 
them into controller. I don't know how to make it gracefully
yet, but merging resets of max_usage and failcnt in one 
function will be there for sure.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/res_counter.h |    8 ++++++++
 mm/memcontrol.c             |   14 +++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index df8085a..3c05d6d 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -141,4 +141,12 @@ static inline void res_counter_reset_max(struct res_counter *cnt)
 	spin_unlock_irqrestore(&cnt->lock, flags);
 }
 
+static inline void res_counter_reset_failcnt(struct res_counter *cnt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->failcnt = 0;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+}
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d3ec3e3..5852b23 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -868,12 +868,19 @@ static ssize_t mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 				mem_cgroup_write_strategy);
 }
 
-static int mem_cgroup_max_reset(struct cgroup *cont, unsigned int event)
+static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 {
 	struct mem_cgroup *mem;
 
 	mem = mem_cgroup_from_cont(cont);
-	res_counter_reset_max(&mem->res);
+	switch (event) {
+		case RES_MAX_USAGE:
+			res_counter_reset_max(&mem->res);
+			break;
+		case RES_FAILCNT:
+			res_counter_reset_failcnt(&mem->res);
+			break;
+	}
 	return 0;
 }
 
@@ -927,7 +934,7 @@ static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "max_usage_in_bytes",
 		.private = RES_MAX_USAGE,
-		.trigger = mem_cgroup_max_reset,
+		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
@@ -939,6 +946,7 @@ static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "failcnt",
 		.private = RES_FAILCNT,
+		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
-- 
1.5.3.4

