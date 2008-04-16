Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYDPSKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYDPSKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYDPSKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:10:35 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50714 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYDPSKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:10:34 -0400
Date: Wed, 16 Apr 2008 12:10:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Oliver Neukum <oliver@neukum.org>, Ingo Oeser <ioe-lkml@rameria.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080416181017.GS9191@parisc-linux.org>
References: <4803AD91.5020001@firstfloor.org> <200804161807.25582.ioe-lkml@rameria.de> <20080416161652.GK9191@parisc-linux.org> <200804161831.10510.oliver@neukum.org> <20080416095026.658bdd21@laptopd505.fenrus.org> <20080416165811.GO9191@parisc-linux.org> <20080416100849.01a742aa@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416100849.01a742aa@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, here's the first version that even compiles.  It's not completed --
a few functions need to be written, and I certainly haven't tried
to convert anything to use it.  Also, documentation would be good.
But it's useful for people to take pot-shots at the API and suggest
other things that are worth debugging checks.

One thing I want to add is a 'check if we can free this kcounter'.
ie are there any outstanding resources claimed.  And I'm not checking
for a double-release of a resource yet (trivial to add, but I need to
grab lunch).

commit 4496d41a540897039138a7d67dbef51f96dd0b09
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Wed Apr 16 14:04:28 2008 -0400

    kcounters

diff --git a/include/linux/kcounter.h b/include/linux/kcounter.h
new file mode 100644
index 0000000..35f83ed
--- /dev/null
+++ b/include/linux/kcounter.h
@@ -0,0 +1,58 @@
+#ifndef __LINUX_KCOUNTER_H
+#define __LINUX_KCOUNTER_H
+/*
+ * include/linux/kcounter.h
+ *
+ * Copyright (c) 2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * Distributed under the terms of the GNU GPL, version 2
+ *
+ * kcounters model a situation where you have a certain number of resources
+ * and tasks must sleep to acquire a resource if there are none available.
+ * New resources may be added or existing ones removed.
+ */
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+#ifdef CONFIG_DEBUG_KCOUNTER
+typedef struct { struct kcounter_owner *owner; } kcounter_cookie_t;
+#else
+typedef struct { } kcounter_cookie_t;
+#endif
+
+struct kcounter {
+	spinlock_t		lock;
+	unsigned int		count;
+	struct list_head	wait_list;
+#ifdef CONFIG_DEBUG_KCOUNTER
+	unsigned int		size;
+	struct kcounter_owner	*owners;
+#endif
+};
+
+extern void kcounter_init(struct kcounter *kc, unsigned int count);
+
+extern int __must_check kcounter_claim(struct kcounter *, kcounter_cookie_t *);
+extern int __must_check kcounter_claim_interruptible(struct kcounter *,
+				kcounter_cookie_t *);
+extern int __must_check kcounter_claim_timeout(struct kcounter *,
+				kcounter_cookie_t *, long jiffies);
+extern int __must_check kcounter_claim_interruptible_timeout(struct kcounter *,
+				kcounter_cookie_t *, long jiffies);
+extern int __must_check kcounter_try_claim(struct kcounter *kc,
+				kcounter_cookie_t *);
+extern int __must_check kcounter_has_free_resources(struct kcounter *kc);
+extern void kcounter_release(struct kcounter *, kcounter_cookie_t *);
+
+#ifdef CONFIG_DEBUG_KCOUNTER
+extern void kcounter_add_resource(struct kcounter *kc);
+extern int __must_check kcounter_remove_resource(struct kcounter *kc);
+#else
+#define kcounter_add_resource(kc)	kcounter_release(kc, NULL)
+#define kcounter_remove_resource(kc)	kcounter_claim(kc, NULL)
+#endif
+extern void kcounter_add_all_resources(struct kcounter *kc);
+
+#endif
diff --git a/kernel/kcounter.c b/kernel/kcounter.c
new file mode 100644
index 0000000..d290edc
--- /dev/null
+++ b/kernel/kcounter.c
@@ -0,0 +1,272 @@
+/*
+ * kernel/kcounter.c
+ *
+ * Copyright (c) 2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * Distributed under the terms of the GNU GPL, version 2
+ */
+
+#include <linux/kcounter.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#ifdef CONFIG_DEBUG_KCOUNTER
+static void kcounter_debug_init(struct kcounter *, unsigned int count);
+static void kcounter_debug_claim(struct kcounter *, kcounter_cookie_t *);
+static void kcounter_debug_release(struct kcounter *, kcounter_cookie_t *);
+#else
+#define kcounter_debug_init(kc, count)		do { } while (0)
+#define kcounter_debug_claim(kc, resource)	do { } while (0)
+#define kcounter_debug_release(kc, resource)	do { } while (0)
+#endif
+
+static noinline int __kc_claim(struct kcounter *kc);
+static noinline int __kc_claim_interruptible(struct kcounter *kc);
+static noinline int __kc_claim_timeout(struct kcounter *kc, long jiffies);
+static noinline int __kc_claim_interruptible_timeout(struct kcounter *kc, long jiffies);
+static noinline void __kc_release(struct kcounter *kc);
+
+void kcounter_init(struct kcounter *kc, unsigned int count)
+{
+	spin_lock_init(&kc->lock);
+	kc->count = count;
+	INIT_LIST_HEAD(&kc->wait_list);
+	kcounter_debug_init(kc, count);
+}
+EXPORT_SYMBOL(kcounter_init);
+
+int kcounter_claim(struct kcounter *kc, kcounter_cookie_t *resource)
+{
+	unsigned long flags;
+	int result = 0;
+
+	might_sleep();
+	spin_lock_irqsave(&kc->lock, flags);
+	if (kc->count > 0)
+		kc->count--;
+	else
+		result = __kc_claim(kc);
+	if (!result)
+		kcounter_debug_claim(kc, resource);
+	spin_unlock_irqrestore(&kc->lock, flags);
+
+	return result;
+}
+EXPORT_SYMBOL(kcounter_claim);
+
+int kcounter_claim_interruptible(struct kcounter *kc, kcounter_cookie_t *resource)
+{
+	unsigned long flags;
+	int result = 0;
+
+	might_sleep();
+	spin_lock_irqsave(&kc->lock, flags);
+	if (kc->count > 0)
+		kc->count--;
+	else
+		result = __kc_claim_interruptible(kc);
+	if (!result)
+		kcounter_debug_claim(kc, resource);
+	spin_unlock_irqrestore(&kc->lock, flags);
+
+	return result;
+}
+EXPORT_SYMBOL(kcounter_claim_interruptible);
+
+int kcounter_claim_timeout(struct kcounter *kc, kcounter_cookie_t *resource, long jiffies)
+{
+	unsigned long flags;
+	int result = 0;
+
+	might_sleep();
+	spin_lock_irqsave(&kc->lock, flags);
+	if (kc->count > 0)
+		kc->count--;
+	else
+		result = __kc_claim_timeout(kc, jiffies);
+	if (!result)
+		kcounter_debug_claim(kc, resource);
+	spin_unlock_irqrestore(&kc->lock, flags);
+
+	return result;
+}
+EXPORT_SYMBOL(kcounter_claim_timeout);
+
+int kcounter_claim_interruptible_timeout(struct kcounter *kc, kcounter_cookie_t *resource, long jiffies)
+{
+	unsigned long flags;
+	int result = 0;
+
+	might_sleep();
+	spin_lock_irqsave(&kc->lock, flags);
+	if (kc->count > 0)
+		kc->count--;
+	else
+		result = __kc_claim_interruptible_timeout(kc, jiffies);
+	if (!result)
+		kcounter_debug_claim(kc, resource);
+	spin_unlock_irqrestore(&kc->lock, flags);
+
+	return result;
+}
+EXPORT_SYMBOL(kcounter_claim_interruptible_timeout);
+
+void kcounter_release(struct kcounter *kc, kcounter_cookie_t *resource)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&kc->lock, flags);
+	kcounter_debug_release(kc, resource);
+	if (list_empty(&kc->wait_list))
+		kc->count++;
+	else
+		__kc_release(kc);
+	spin_unlock_irqrestore(&kc->lock, flags);
+}
+
+/* Functions for the contended case */
+
+struct kcounter_waiter {
+	struct list_head list;
+	struct task_struct *task;
+	int up;
+};
+
+/*
+ * Because this function is inlined, the 'state' parameter will be
+ * constant, and thus optimised away by the compiler.  Likewise the
+ * 'timeout' parameter for the cases without timeouts.
+ */
+static inline int __sched __kc_claim_common(struct kcounter *kc,
+						long state, long timeout)
+{
+	struct task_struct *task = current;
+	struct kcounter_waiter waiter;
+
+	list_add_tail(&waiter.list, &kc->wait_list);
+	waiter.task = task;
+	waiter.up = 0;
+
+	for (;;) {
+		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
+			goto interrupted;
+		if (state == TASK_KILLABLE && fatal_signal_pending(task))
+			goto interrupted;
+		if (timeout == 0)
+			goto timed_out;
+		__set_task_state(task, state);
+		spin_unlock_irq(&kc->lock);
+		timeout = schedule_timeout(timeout);
+		spin_lock_irq(&kc->lock);
+		if (waiter.up)
+			return 0;
+	}
+
+ timed_out:
+	list_del(&waiter.list);
+	return -ETIME;
+
+ interrupted:
+	list_del(&waiter.list);
+	return -EINTR;
+}
+
+static noinline int __sched __kc_claim(struct kcounter *kc)
+{
+	return __kc_claim_common(kc, TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT);
+}
+
+static noinline int __sched __kc_claim_interruptible(struct kcounter *kc)
+{
+	return __kc_claim_common(kc, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
+}
+
+static noinline int __sched __kc_claim_timeout(struct kcounter *kc,
+							long jiffies)
+{
+	return __kc_claim_common(kc, TASK_KILLABLE, jiffies);
+}
+
+static noinline int __sched __kc_claim_interruptible_timeout(
+					struct kcounter *kc, long jiffies)
+{
+	return __kc_claim_common(kc, TASK_INTERRUPTIBLE, jiffies);
+}
+
+static noinline void __sched __kc_release(struct kcounter *kc)
+{
+	struct kcounter_waiter *waiter = list_first_entry(&kc->wait_list,
+						struct kcounter_waiter, list);
+	list_del(&waiter->list);
+	waiter->up = 1;
+	wake_up_process(waiter->task);
+}
+
+#ifdef CONFIG_DEBUG_KCOUNTER
+
+#include <linux/debug_locks.h>
+#include <linux/sched.h>
+
+struct kcounter_owner {
+	struct kcounter_owner	*next;
+	struct thread_info	*thread;
+	const char		*name;
+	void			*magic;
+};
+
+static void kcounter_init_owner(struct kcounter_owner *owner)
+{
+	owner->next = NULL;
+	owner->thread = NULL;
+	owner->name = NULL;
+	owner->magic = owner;
+}
+
+static void kcounter_debug_init(struct kcounter *kc, unsigned int count)
+{
+	int i;
+	struct kcounter_owner *owner, **ptr;
+	kc->size = count;
+	ptr = &kc->owners;
+	for (i = 0; i < count; i++) {
+		owner = kmalloc(sizeof(*owner), GFP_KERNEL | __GFP_NOFAIL);
+		kcounter_init_owner(owner);
+		*ptr = owner;
+		ptr = &owner->next;
+	}
+}
+
+void kcounter_debug_claim(struct kcounter *kc, kcounter_cookie_t *resource)
+{
+	struct kcounter_owner *owner;
+
+	for (owner = kc->owners; owner != NULL; owner = owner->next) {
+		if (owner->thread)
+			continue;
+		owner->thread = task_thread_info(current);
+		resource->owner = owner;
+	}
+
+	/*
+	 * No free slots found, but we were going to return success.
+	 * This is an internal bug in the kcounter implementation.
+	 */
+	BUG();
+}
+
+void kcounter_debug_release(struct kcounter *kc, kcounter_cookie_t *resource)
+{
+	struct kcounter_owner *owner;
+
+	for (owner = kc->owners; owner != NULL; owner = owner->next) {
+		if (owner != resource->owner)
+			continue;
+		owner->thread = NULL;
+		return;
+	}
+
+	/* The resource doesn't belong to this kcounter */
+	DEBUG_LOCKS_WARN_ON(1);
+}
+#endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0796c1a..926293d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -265,6 +265,13 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
+config DEBUG_KCOUNTER
+	bool "Kcounter debugging: basic checks"
+	depends on DEBUG_KERNEL
+	help
+	  Enabling this option allows the kernel to detect some basic
+	  misuses of the kcounter feature.
+
 config DEBUG_SEMAPHORE
 	bool "Semaphore debugging"
 	depends on DEBUG_KERNEL

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
