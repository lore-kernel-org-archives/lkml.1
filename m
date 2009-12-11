Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZLKDE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZLKDE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZLKDE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:04:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:5797 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZLKDE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:04:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,378,1257148800"; 
   d="scan'208";a="577684814"
Date: Fri, 11 Dec 2009 11:04:31 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, lenb@kernel.org
Subject: [PATCH 1/2]workqueue:introduce INIT_WORK_KEY()
Message-ID: <20091211030431.GA7772@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce INIT_WORK_KEY(). lockdep key is static in a function. If a function
uses INIT_WORK() to initialize works for different workqueue, the works will
share a lockdep key incorrectly and cause lockdep fase alarm sometimes.
Next patch will use the new API to solve one ACPI issue.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/workqueue.h |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux/include/linux/workqueue.h
===================================================================
--- linux.orig/include/linux/workqueue.h	2009-12-10 10:14:56.000000000 +0800
+++ linux/include/linux/workqueue.h	2009-12-10 10:39:30.000000000 +0800
@@ -99,15 +99,20 @@ struct execute_work {
  * to generate better code.
  */
 #ifdef CONFIG_LOCKDEP
-#define INIT_WORK(_work, _func)						\
+#define INIT_WORK_KEY(_work, _func, _key, _key_name) 			\
 	do {								\
-		static struct lock_class_key __key;			\
-									\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
-		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0);\
+		lockdep_init_map(&(_work)->lockdep_map, _key_name, 	\
+				&_key, 0);				\
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
+
+#define INIT_WORK(_work, _func)						\
+	do {								\
+		static struct lock_class_key __key;			\
+		INIT_WORK_KEY(_work, _func, __key, #_work);		\
+	} while (0)
 #else
 #define INIT_WORK(_work, _func)						\
 	do {								\
@@ -115,6 +120,9 @@ struct execute_work {
 		INIT_LIST_HEAD(&(_work)->entry);			\
 		PREPARE_WORK((_work), (_func));				\
 	} while (0)
+
+#define INIT_WORK_KEY(_work, _func, _key, _key_name) 			\
+	INIT_WORK(_work, _func)
 #endif
 
 #define INIT_DELAYED_WORK(_work, _func)				\
