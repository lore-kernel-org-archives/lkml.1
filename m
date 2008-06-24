Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYFXF5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYFXF5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYFXF5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:57:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbYFXF5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:57:04 -0400
Date: Tue, 24 Jun 2008 01:57:02 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net
Subject: [3/10 PATCH] inline wake_up_bit
In-Reply-To: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240156230.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline wake_up_bit. The function just pases arguments around.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/include/linux/wait.h
===================================================================
--- linux-2.6.26-rc7-devel.orig/include/linux/wait.h	2008-06-24 07:28:13.000000000 +0200
+++ linux-2.6.26-rc7-devel/include/linux/wait.h	2008-06-24 07:37:20.000000000 +0200
@@ -147,11 +147,32 @@
  void __wake_up_bit(wait_queue_head_t *, void *, int);
  int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
  int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
-void wake_up_bit(void *, int);
  int out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned);
  int out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned);
  wait_queue_head_t *bit_waitqueue(void *, int);

+/**
+ * wake_up_bit - wake up a waiter on a bit
+ * @word: the word being waited on, a kernel virtual address
+ * @bit: the bit of the word being waited on
+ *
+ * There is a standard hashed waitqueue table for generic use. This
+ * is the part of the hashtable's accessor API that wakes up waiters
+ * on a bit. For instance, if one were to have waiters on a bitflag,
+ * one would call wake_up_bit() after clearing the bit.
+ *
+ * In order for this to function properly, as it uses waitqueue_active()
+ * internally, some kind of memory barrier must be done prior to calling
+ * this. Typically, this will be smp_mb__after_clear_bit(), but in some
+ * cases where bitflags are manipulated non-atomically under a lock, one
+ * may need to use a less regular barrier, such fs/inode.c's smp_mb(),
+ * because spin_unlock() does not guarantee a memory barrier.
+ */
+static __always_inline void wake_up_bit(void *word, int bit)
+{
+	__wake_up_bit(bit_waitqueue(word, bit), word, bit);
+}
+
  #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
  #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
  #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
Index: linux-2.6.26-rc7-devel/kernel/wait.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/kernel/wait.c	2008-06-24 07:28:14.000000000 +0200
+++ linux-2.6.26-rc7-devel/kernel/wait.c	2008-06-24 07:37:20.000000000 +0200
@@ -219,29 +219,6 @@
  }
  EXPORT_SYMBOL(__wake_up_bit);

-/**
- * wake_up_bit - wake up a waiter on a bit
- * @word: the word being waited on, a kernel virtual address
- * @bit: the bit of the word being waited on
- *
- * There is a standard hashed waitqueue table for generic use. This
- * is the part of the hashtable's accessor API that wakes up waiters
- * on a bit. For instance, if one were to have waiters on a bitflag,
- * one would call wake_up_bit() after clearing the bit.
- *
- * In order for this to function properly, as it uses waitqueue_active()
- * internally, some kind of memory barrier must be done prior to calling
- * this. Typically, this will be smp_mb__after_clear_bit(), but in some
- * cases where bitflags are manipulated non-atomically under a lock, one
- * may need to use a less regular barrier, such fs/inode.c's smp_mb(),
- * because spin_unlock() does not guarantee a memory barrier.
- */
-void wake_up_bit(void *word, int bit)
-{
-	__wake_up_bit(bit_waitqueue(word, bit), word, bit);
-}
-EXPORT_SYMBOL(wake_up_bit);
-
  wait_queue_head_t *bit_waitqueue(void *word, int bit)
  {
  	const int shift = BITS_PER_LONG == 32 ? 5 : 6;

