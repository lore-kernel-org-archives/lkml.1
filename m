Return-Path: <linux-kernel-owner+w=401wt.eu-S934799AbXFFU7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934799AbXFFU7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935289AbXFFU7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:59:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:57479 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935215AbXFFU7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:59:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="254025688"
Date: Wed, 6 Jun 2007 13:55:42 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Adam Belay <abelay@novell.com>, Len Brown <len.brown@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Shaohua Li <shaohua.li@intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH 7/8] cpuidle: add rating to the governors and pick the one with highest rating by default
Message-ID: <20070606205542.GG23906@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




Introduce a governor rating scheme to pick the right governor by default.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/include/linux/cpuidle.h
===================================================================
--- linux-2.6.22-rc-mm.orig/include/linux/cpuidle.h	2007-06-05 17:00:09.000000000 -0700
+++ linux-2.6.22-rc-mm/include/linux/cpuidle.h	2007-06-05 17:01:08.000000000 -0700
@@ -159,6 +159,7 @@
 struct cpuidle_governor {
 	char			name[CPUIDLE_NAME_LEN];
 	struct list_head 	governor_list;
+	unsigned int		rating;
 
 	int  (*init)		(struct cpuidle_device *dev);
 	void (*exit)		(struct cpuidle_device *dev);
Index: linux-2.6.22-rc-mm/drivers/cpuidle/governors/menu.c
===================================================================
--- linux-2.6.22-rc-mm.orig/drivers/cpuidle/governors/menu.c	2007-06-05 15:46:34.000000000 -0700
+++ linux-2.6.22-rc-mm/drivers/cpuidle/governors/menu.c	2007-06-05 17:04:32.000000000 -0700
@@ -153,6 +153,7 @@
 
 struct cpuidle_governor menu_governor = {
 	.name =		"menu",
+	.rating =	20,
 	.scan =		menu_scan_device,
 	.select =	menu_select,
 	.reflect =	menu_reflect,
Index: linux-2.6.22-rc-mm/drivers/cpuidle/governor.c
===================================================================
--- linux-2.6.22-rc-mm.orig/drivers/cpuidle/governor.c	2007-06-01 16:25:49.000000000 -0700
+++ linux-2.6.22-rc-mm/drivers/cpuidle/governor.c	2007-06-05 17:15:05.000000000 -0700
@@ -131,7 +131,8 @@
 	if (__cpuidle_find_governor(gov->name) == NULL) {
 		ret = 0;
 		list_add_tail(&gov->governor_list, &cpuidle_governors);
-		if (!cpuidle_curr_governor)
+		if (!cpuidle_curr_governor ||
+		    cpuidle_curr_governor->rating < gov->rating)
 			cpuidle_switch_governor(gov);
 	}
 	mutex_unlock(&cpuidle_lock);
@@ -142,6 +143,29 @@
 EXPORT_SYMBOL_GPL(cpuidle_register_governor);
 
 /**
+ * cpuidle_replace_governor - find a replacement governor
+ * @exclude_rating: the rating that will be skipped while looking for
+ * new governor.
+ */
+struct cpuidle_governor *cpuidle_replace_governor(int exclude_rating)
+{
+	struct cpuidle_governor *gov;
+	struct cpuidle_governor *ret_gov = NULL;
+	unsigned int max_rating = 0;
+
+	list_for_each_entry(gov, &cpuidle_governors, governor_list) {
+		if (gov->rating == exclude_rating)
+			continue;
+		if (gov->rating > max_rating) {
+			max_rating = gov->rating;
+			ret_gov = gov;
+		}
+	}
+
+	return ret_gov;
+}
+
+/**
  * cpuidle_unregister_governor - unregisters a governor
  * @gov: the governor
  */
@@ -151,8 +175,11 @@
 		return;
 
 	mutex_lock(&cpuidle_lock);
-	if (gov == cpuidle_curr_governor)
-		cpuidle_switch_governor(NULL);
+	if (gov == cpuidle_curr_governor) {
+		struct cpuidle_governor *new_gov;
+		new_gov = cpuidle_replace_governor(gov->rating);
+		cpuidle_switch_governor(new_gov);
+	}
 	list_del(&gov->governor_list);
 	mutex_unlock(&cpuidle_lock);
 }
Index: linux-2.6.22-rc-mm/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux-2.6.22-rc-mm.orig/drivers/cpuidle/governors/ladder.c	2007-06-01 16:25:49.000000000 -0700
+++ linux-2.6.22-rc-mm/drivers/cpuidle/governors/ladder.c	2007-06-05 17:03:37.000000000 -0700
@@ -199,6 +199,7 @@
 
 static struct cpuidle_governor ladder_governor = {
 	.name =		"ladder",
+	.rating =	10,
 	.init =		ladder_init_device,
 	.exit =		ladder_exit_device,
 	.scan =		ladder_scan_device,
