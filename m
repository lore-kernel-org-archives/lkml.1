Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbZK0Lzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbZK0Lzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZK0Lzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:55:35 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63624 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZK0LzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:55:19 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH RFC v1 2/3] res_counter: implement thresholds
Date: Fri, 27 Nov 2009 13:55:03 +0200
Message-Id: <8524ba285f6dd59cda939c28da523f344cdab3da.1259321503.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259321503.git.kirill@shutemov.name>
References: <cover.1259255307.git.kirill@shutemov.name>
 <bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259321503.git.kirill@shutemov.name>
In-Reply-To: <cover.1259321503.git.kirill@shutemov.name>
References: <cover.1259321503.git.kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows to setup two thresholds: one above current usage and one
below. Callback threshold_notifier() will be called if a threshold is
crossed.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 include/linux/res_counter.h |   44 +++++++++++++++++++++++++++++++++++++++++++
 kernel/res_counter.c        |    4 +++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index fcb9884..bca99a5 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -9,6 +9,10 @@
  *
  * Author: Pavel Emelianov <xemul@openvz.org>
  *
+ * Thresholds support
+ * Copyright (C) 2009 Nokia Corporation
+ * Author: Kirill A. Shutemov
+ *
  * See Documentation/cgroups/resource_counter.txt for more
  * info about what this counter is.
  */
@@ -42,6 +46,13 @@ struct res_counter {
 	 * the number of unsuccessful attempts to consume the resource
 	 */
 	unsigned long long failcnt;
+
+	unsigned long long threshold_above;
+	unsigned long long threshold_below;
+	void (*threshold_notifier)(struct res_counter *counter,
+			unsigned long long usage,
+			unsigned long long threshold);
+
 	/*
 	 * the lock to protect all of the above.
 	 * the routines below consider this to be IRQ-safe
@@ -145,6 +156,20 @@ static inline bool res_counter_soft_limit_check_locked(struct res_counter *cnt)
 	return false;
 }
 
+static inline void res_counter_threshold_notify_locked(struct res_counter *cnt)
+{
+	if (cnt->usage >= cnt->threshold_above) {
+		cnt->threshold_notifier(cnt, cnt->usage, cnt->threshold_above);
+		return;
+	}
+
+	if (cnt->usage < cnt->threshold_below) {
+		cnt->threshold_notifier(cnt, cnt->usage, cnt->threshold_below);
+		return;
+	}
+}
+
+
 /**
  * Get the difference between the usage and the soft limit
  * @cnt: The counter
@@ -238,4 +263,23 @@ res_counter_set_soft_limit(struct res_counter *cnt,
 	return 0;
 }
 
+static inline int
+res_counter_set_thresholds(struct res_counter *cnt,
+		unsigned long long threshold_above,
+		unsigned long long threshold_below)
+{
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	spin_lock_irqsave(&cnt->lock, flags);
+	if ((cnt->usage < threshold_above) &&
+			(cnt->usage >= threshold_below)) {
+		cnt->threshold_above = threshold_above;
+		cnt->threshold_below = threshold_below;
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&cnt->lock, flags);
+	return ret;
+}
+
 #endif
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index bcdabf3..646c29c 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -20,6 +20,8 @@ void res_counter_init(struct res_counter *counter, struct res_counter *parent)
 	spin_lock_init(&counter->lock);
 	counter->limit = RESOURCE_MAX;
 	counter->soft_limit = RESOURCE_MAX;
+	counter->threshold_above = RESOURCE_MAX;
+	counter->threshold_below = 0ULL;
 	counter->parent = parent;
 }
 
@@ -33,6 +35,7 @@ int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
 	counter->usage += val;
 	if (counter->usage > counter->max_usage)
 		counter->max_usage = counter->usage;
+	res_counter_threshold_notify_locked(counter);
 	return 0;
 }
 
@@ -73,6 +76,7 @@ void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
 		val = counter->usage;
 
 	counter->usage -= val;
+	res_counter_threshold_notify_locked(counter);
 }
 
 void res_counter_uncharge(struct res_counter *counter, unsigned long val)
-- 
1.6.5.3

