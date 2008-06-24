Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbYFXF7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbYFXF7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYFXF7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:59:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYFXF7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:59:14 -0400
Date: Tue, 24 Jun 2008 01:59:12 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net
Subject: [6/10 PATCH] inline default_wake_function
In-Reply-To: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240158380.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make autoremove_wake_function -> default_wake_function call inlined.

default_wake_function cannot be put as static inline into headers, because
reference to it is taken at some places.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/kernel/sched.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/kernel/sched.c	2008-06-24 07:37:31.000000000 +0200
+++ linux-2.6.26-rc7-devel/kernel/sched.c	2008-06-24 07:37:36.000000000 +0200
@@ -4268,13 +4268,23 @@

  #endif /* CONFIG_PREEMPT */

-int default_wake_function(wait_queue_t *curr, unsigned mode, int sync,
-			  void *key)
+__always_inline int default_wake_function(wait_queue_t *curr, unsigned mode,
+					  int sync, void *key)
  {
  	return try_to_wake_up(curr->private, mode, sync);
  }
  EXPORT_SYMBOL(default_wake_function);

+int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	int ret = default_wake_function(wait, mode, sync, key);
+
+	if (ret)
+		list_del_init(&wait->task_list);
+	return ret;
+}
+EXPORT_SYMBOL(autoremove_wake_function);
+
  /*
   * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
   * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
Index: linux-2.6.26-rc7-devel/kernel/wait.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/kernel/wait.c	2008-06-24 07:37:25.000000000 +0200
+++ linux-2.6.26-rc7-devel/kernel/wait.c	2008-06-24 07:37:36.000000000 +0200
@@ -127,16 +127,6 @@
  }
  EXPORT_SYMBOL(finish_wait);

-int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
-{
-	int ret = default_wake_function(wait, mode, sync, key);
-
-	if (ret)
-		list_del_init(&wait->task_list);
-	return ret;
-}
-EXPORT_SYMBOL(autoremove_wake_function);
-
  int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *arg)
  {
  	struct wait_bit_key *key = arg;
Index: linux-2.6.26-rc7-devel/include/linux/wait.h
===================================================================
--- linux-2.6.26-rc7-devel.orig/include/linux/wait.h	2008-06-24 07:37:31.000000000 +0200
+++ linux-2.6.26-rc7-devel/include/linux/wait.h	2008-06-24 07:37:36.000000000 +0200
@@ -63,7 +63,7 @@

  typedef struct __wait_queue wait_queue_t;
  typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int sync, void *key);
-int default_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
+__always_inline int default_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);

  struct __wait_queue {
  	unsigned int flags;

