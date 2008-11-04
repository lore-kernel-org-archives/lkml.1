Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbYKDJWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYKDJWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYKDJWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:22:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57633 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYKDJWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:22:38 -0500
Date: Tue, 4 Nov 2008 18:21:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 1/2] memcg: hierarchy, yet another one.
Message-Id: <20081104182155.f1b6cdbb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a toy for showing idea,
how do you think ?

[1/2] ... res counter part
[2/2] ... for memcg (mem+swap controller)

based on mem+swap controller + synchronized lru + some fixes(not posted)
I'm just wondering how to support hirerachy and not indend to improve this now.

[1/2] ... hierachical res_counter 
==
Hierarchy support for res_coutner.

This patch adds following interface to res_counter.
 - res_counter_init_hierarchy().
 - res_counter_charge_hierarchy().
 - res_counter_uncharge_hierarchy().
 - res_counter_check_under_limit_hierarchy().

By this, if res_counter is properly intialized, a charge to res_counter
will be charged up to the root of res_counter.

root res_counter has is res_counter->parent pointer to be NULL.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/res_counter.h |   13 ++++++++
 kernel/res_counter.c        |   65 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 77 insertions(+), 1 deletion(-)

Index: mmotm-2.6.28-rc2+/include/linux/res_counter.h
===================================================================
--- mmotm-2.6.28-rc2+.orig/include/linux/res_counter.h
+++ mmotm-2.6.28-rc2+/include/linux/res_counter.h
@@ -39,6 +39,10 @@ struct res_counter {
 	 */
 	unsigned long long failcnt;
 	/*
+         * The parent sharing resource.
+         */
+	struct res_counter *parent;
+	/*
 	 * the lock to protect all of the above.
 	 * the routines below consider this to be IRQ-safe
 	 */
@@ -88,6 +92,8 @@ enum {
  */
 
 void res_counter_init(struct res_counter *counter);
+void res_counter_init_hierarchy(struct res_counter *counter,
+				struct res_counter *parent);
 
 /*
  * charge - try to consume more resource.
@@ -105,6 +111,8 @@ int __must_check res_counter_charge_lock
 int __must_check res_counter_charge(struct res_counter *counter,
 		unsigned long val);
 
+int __must_check res_counter_charge_hierarchy(struct res_counter *counter,
+		      unsigned long val, struct res_counter **fail);
 /*
  * uncharge - tell that some portion of the resource is released
  *
@@ -118,6 +126,9 @@ int __must_check res_counter_charge(stru
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
 void res_counter_uncharge(struct res_counter *counter, unsigned long val);
 
+void res_counter_uncharge_hierarchy(struct res_counter *counter,
+		unsigned long val);
+
 static inline bool res_counter_limit_check_locked(struct res_counter *cnt)
 {
 	if (cnt->usage < cnt->limit)
@@ -126,6 +137,8 @@ static inline bool res_counter_limit_che
 	return false;
 }
 
+bool res_counter_check_under_limit_hierarchy(struct res_counter *cnt,
+					     struct res_counter **fail);
 /*
  * Helper function to detect if the cgroup is within it's limit or
  * not. It's currently called from cgroup_rss_prepare()
Index: mmotm-2.6.28-rc2+/kernel/res_counter.c
===================================================================
--- mmotm-2.6.28-rc2+.orig/kernel/res_counter.c
+++ mmotm-2.6.28-rc2+/kernel/res_counter.c
@@ -15,10 +15,17 @@
 #include <linux/uaccess.h>
 #include <linux/mm.h>
 
-void res_counter_init(struct res_counter *counter)
+void res_counter_init_hierarchy(struct res_counter *counter,
+				struct res_counter *parent)
 {
 	spin_lock_init(&counter->lock);
 	counter->limit = (unsigned long long)LLONG_MAX;
+	counter->parent = parent;
+}
+
+void res_counter_init(struct res_counter *counter)
+{
+	res_counter_init_hierarchy(counter, NULL);
 }
 
 int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
@@ -45,6 +52,7 @@ int res_counter_charge(struct res_counte
 	return ret;
 }
 
+
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
 {
 	if (WARN_ON(counter->usage < val))
@@ -62,6 +70,61 @@ void res_counter_uncharge(struct res_cou
 	spin_unlock_irqrestore(&counter->lock, flags);
 }
 
+/**
+ * res_counter_charge_hierarchy - hierarchical resource charging.
+ * @counter: an res_counter to be charged.
+ * @val: value to be charged.
+ * @fail: a pointer to *res_counter for returning where we failed.
+ *
+ * charge "val" to res_counter and all ancestors of it. If fails, a pointer
+ * to res_counter which failed to be charged is returned to "fail".
+ */
+int res_counter_charge_hierarchy(struct res_counter *counter,
+				 unsigned long val,
+				 struct res_counter **fail)
+{
+	struct res_counter *tmp, *undo;
+	int ret = 0;
+
+	for (tmp = counter; tmp != NULL; tmp = tmp->parent) {
+		ret = res_counter_charge(tmp, val);
+		if (ret)
+			break;
+	}
+	if (!ret)
+		return ret;
+
+	*fail = tmp;
+	for (undo = tmp, tmp = counter; tmp != undo; tmp = tmp->parent)
+		res_counter_uncharge(tmp, val);
+
+	return ret;
+}
+
+
+void res_counter_uncharge_hierarchy(struct res_counter *counter,
+				    unsigned long  val)
+{
+	struct res_counter *tmp;
+
+	for (tmp = counter; tmp != NULL; tmp = tmp->parent)
+		res_counter_uncharge(tmp, val);
+}
+
+bool res_counter_check_under_limit_hierarchy(struct res_counter *counter,
+					     struct res_counter **fail)
+{
+	struct res_counter *tmp;
+	for (tmp = counter; tmp != NULL; tmp = tmp->parent)
+		if (!res_counter_check_under_limit(tmp))
+			break;
+
+	if (!tmp)
+		return true;
+	*fail = tmp;
+	return false;
+}
+
 
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)

