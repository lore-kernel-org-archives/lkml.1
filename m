Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYCKPCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYCKPCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYCKPCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:02:16 -0400
Received: from sacred.ru ([62.205.161.221]:53038 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbYCKPCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:02:15 -0400
Message-ID: <47D69D72.5040304@openvz.org>
Date: Tue, 11 Mar 2008 17:55:46 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add the max_usage member on the res_counter
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 11 Mar 2008 17:55:43 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field is the maximal value of the usage one since the counter
creation (or since the latest reset).

To reset this to the usage value simply write anything to the
appropriate cgroup file.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

---

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 8cb1ecd..df8085a 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -25,6 +25,10 @@ struct res_counter {
 	 */
 	unsigned long long usage;
 	/*
+	 * the maximal value of the usage from the counter creation
+	 */
+	unsigned long long max_usage;
+	/*
 	 * the limit that usage cannot exceed
 	 */
 	unsigned long long limit;
@@ -67,6 +71,7 @@ ssize_t res_counter_write(struct res_counter *counter, int member,
 
 enum {
 	RES_USAGE,
+	RES_MAX_USAGE,
 	RES_LIMIT,
 	RES_FAILCNT,
 };
@@ -127,4 +132,13 @@ static inline bool res_counter_check_under_limit(struct res_counter *cnt)
 	return ret;
 }
 
+static inline void res_counter_reset_max(struct res_counter *cnt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	cnt->max_usage = cnt->usage;
+	spin_unlock_irqrestore(&cnt->lock, flags);
+}
+
 #endif
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 791ff2b..f1f20c2 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -27,6 +27,8 @@ int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
 	}
 
 	counter->usage += val;
+	if (counter->usage > counter->max_usage)
+		counter->max_usage = counter->usage;
 	return 0;
 }
 
@@ -65,6 +67,8 @@ res_counter_member(struct res_counter *counter, int member)
 	switch (member) {
 	case RES_USAGE:
 		return &counter->usage;
+	case RES_MAX_USAGE:
+		return &counter->max_usage;
 	case RES_LIMIT:
 		return &counter->limit;
 	case RES_FAILCNT:
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eb681a6..c27141d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -868,6 +868,17 @@ static ssize_t mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 				mem_cgroup_write_strategy);
 }
 
+static ssize_t mem_cgroup_max_reset(struct cgroup *cont, struct cftype *cft,
+				struct file *file, const char __user *userbuf,
+				size_t nbytes, loff_t *ppos)
+{
+	struct mem_cgroup *mem;
+
+	mem = mem_cgroup_from_cont(cont);
+	res_counter_reset_max(&mem->res);
+	return nbytes;
+}
+
 static ssize_t mem_force_empty_write(struct cgroup *cont,
 				struct cftype *cft, struct file *file,
 				const char __user *userbuf,
@@ -923,6 +934,12 @@ static struct cftype mem_cgroup_files[] = {
 		.read_u64 = mem_cgroup_read,
 	},
 	{
+		.name = "max_usage_in_bytes",
+		.private = RES_MAX_USAGE,
+		.write = mem_cgroup_max_reset,
+		.read_u64 = mem_cgroup_read,
+	},
+	{
 		.name = "limit_in_bytes",
 		.private = RES_LIMIT,
 		.write = mem_cgroup_write,
