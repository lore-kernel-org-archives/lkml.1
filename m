Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbYFXF77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbYFXF77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYFXF7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:59:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbYFXF7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:59:48 -0400
Date: Tue, 24 Jun 2008 01:59:46 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net
Subject: [6/10 PATCH] inline autoremove_wake_function
In-Reply-To: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240159190.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make wake_bit_function -> autoremove_wake_function call inlined.

autoremove_wake_function cannot be put as static inline into headers, because
reference to it is taken at some places. So use "inline" keyword that will make
it both exported and inlinable in current file.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/kernel/sched.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/kernel/sched.c	2008-06-24 07:37:36.000000000 +0200
+++ linux-2.6.26-rc7-devel/kernel/sched.c	2008-06-24 07:37:42.000000000 +0200
@@ -4275,7 +4275,7 @@
  }
  EXPORT_SYMBOL(default_wake_function);

-int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
+__always_inline int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
  {
  	int ret = default_wake_function(wait, mode, sync, key);

@@ -4285,6 +4285,21 @@
  }
  EXPORT_SYMBOL(autoremove_wake_function);

+int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *arg)
+{
+	struct wait_bit_key *key = arg;
+	struct wait_bit_queue *wait_bit
+		= container_of(wait, struct wait_bit_queue, wait);
+
+	if (wait_bit->key.flags != key->flags ||
+			wait_bit->key.bit_nr != key->bit_nr ||
+			test_bit(key->bit_nr, key->flags))
+		return 0;
+	else
+		return autoremove_wake_function(wait, mode, sync, key);
+}
+EXPORT_SYMBOL(wake_bit_function);
+
  /*
   * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
   * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
Index: linux-2.6.26-rc7-devel/kernel/wait.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/kernel/wait.c	2008-06-24 07:37:36.000000000 +0200
+++ linux-2.6.26-rc7-devel/kernel/wait.c	2008-06-24 07:37:42.000000000 +0200
@@ -127,21 +127,6 @@
  }
  EXPORT_SYMBOL(finish_wait);

-int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *arg)
-{
-	struct wait_bit_key *key = arg;
-	struct wait_bit_queue *wait_bit
-		= container_of(wait, struct wait_bit_queue, wait);
-
-	if (wait_bit->key.flags != key->flags ||
-			wait_bit->key.bit_nr != key->bit_nr ||
-			test_bit(key->bit_nr, key->flags))
-		return 0;
-	else
-		return autoremove_wake_function(wait, mode, sync, key);
-}
-EXPORT_SYMBOL(wake_bit_function);
-
  /*
   * To allow interruptible waiting and asynchronous (i.e. nonblocking)
   * waiting, the actions of __wait_on_bit() and __wait_on_bit_lock() are
Index: linux-2.6.26-rc7-devel/include/linux/wait.h
===================================================================
--- linux-2.6.26-rc7-devel.orig/include/linux/wait.h	2008-06-24 07:37:36.000000000 +0200
+++ linux-2.6.26-rc7-devel/include/linux/wait.h	2008-06-24 07:37:42.000000000 +0200
@@ -527,7 +527,7 @@
  void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
  void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
  void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
-int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
+__always_inline int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
  int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);

  #define DEFINE_WAIT(name)						\

