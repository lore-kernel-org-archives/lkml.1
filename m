Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbXIJTXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbXIJTXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932813AbXIJTWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:22:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53900 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189AbXIJTWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:22:07 -0400
Message-Id: <20070910191648.715953031@arndb.de>
References: <20070910191324.847651727@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 21:13:26 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: [patch 2/3] futex_compat: simplify pointer magic
Content-Disposition: inline; filename=futex_compat_type.diff
X-Provags-ID: V01U2FsdGVkX1+/l4nhPIZaGTuhX85eGHICWdgbm9bLXi79DQg
 XdaJ8bTC2Y8HNdQu2Ta+YmOxCHfBbNdOi13YVf5HiEF1S4hG3S
 Qz5ldKK/0C6PyO431b68w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The futex_compat code currently mixes pointers to robust_list
and compat_robust_list for no apparent reason other than
requiring extra typecasts. It also uses an extra argument
to fetch_robust_entry() that is not useful but has caused
bugs to be introduced before.

Clean up the code to get rid of all this and make the compat
version look more like the native one.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/kernel/futex_compat.c
===================================================================
--- linux-2.6.orig/kernel/futex_compat.c
+++ linux-2.6/kernel/futex_compat.c
@@ -16,15 +16,17 @@
 /*
  * Fetch a robust-list pointer. Bit 0 signals PI futexes:
  */
-static inline int
-fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **entry,
-		   compat_uptr_t __user *head, int *pi)
+static inline int fetch_robust_entry(struct compat_robust_list __user **entry,
+				     compat_uptr_t __user *head,
+				     unsigned int *pi)
 {
-	if (get_user(*uentry, head))
+	compat_uptr_t uentry;
+
+	if (get_user(uentry, head))
 		return -EFAULT;
 
-	*entry = compat_ptr((*uentry) & ~1);
-	*pi = (unsigned int)(*uentry) & 1;
+	*entry = compat_ptr((uentry) & ~1);
+	*pi = (unsigned int)(uentry) & 1;
 
 	return 0;
 }
@@ -38,16 +40,16 @@ fetch_robust_entry(compat_uptr_t *uentry
 void compat_exit_robust_list(struct task_struct *curr)
 {
 	struct compat_robust_list_head __user *head = curr->compat_robust_list;
-	struct robust_list __user *entry, *pending;
+	struct compat_robust_list __user *entry, *pending;
 	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
-	compat_uptr_t uentry, upending;
+
 	compat_long_t futex_offset;
 
 	/*
 	 * Fetch the list head (which was registered earlier, via
 	 * sys_set_robust_list()):
 	 */
-	if (fetch_robust_entry(&uentry, &entry, &head->list.next, &pi))
+	if (fetch_robust_entry(&entry, &head->list.next, &pi))
 		return;
 	/*
 	 * Fetch the relative futex offset:
@@ -58,13 +60,12 @@ void compat_exit_robust_list(struct task
 	 * Fetch any possibly pending lock-add first, and handle it
 	 * if it exists:
 	 */
-	if (fetch_robust_entry(&upending, &pending,
-			       &head->list_op_pending, &pip))
+	if (fetch_robust_entry(&pending, &head->list_op_pending, &pip))
 		return;
 	if (pending)
 		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
 
-	while (entry != (struct robust_list __user *) &head->list) {
+	while (entry != &head->list) {
 		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
@@ -73,12 +74,10 @@ void compat_exit_robust_list(struct task
 			if (handle_futex_death((void __user *)entry + futex_offset,
 						curr, pi))
 				return;
-
 		/*
 		 * Fetch the next entry in the list:
 		 */
-		if (fetch_robust_entry(&uentry, &entry,
-				       (compat_uptr_t __user *)&entry->next, &pi))
+		if (fetch_robust_entry(&entry, &entry->next, &pi))
 			return;
 		/*
 		 * Avoid excessively long or circular lists:

-- 

