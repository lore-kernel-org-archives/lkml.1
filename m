Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbZLFUqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbZLFUqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbZLFUqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:46:45 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:60040 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757722AbZLFUq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:46:27 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: airlied@redhat.com, Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 2/5] drm/ttm: Add ttm lock functionality.
Date: Sun,  6 Dec 2009 21:46:25 +0100
Message-Id: <1260132388-28414-3-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.3.2
In-Reply-To: <1260132388-28414-2-git-send-email-thellstrom@vmware.com>
References: <1260132388-28414-1-git-send-email-thellstrom@vmware.com>
 <1260132388-28414-2-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is intended to be used by ttm-aware drivers to
1) Block clients to inactive masters when
they try to validate buffers for GPU use.
2) Optionally block clients to the current master when
there is thrashing due to GPU memory shortage.

Used by the vmwgfx driver.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/ttm/Makefile   |    2 +-
 drivers/gpu/drm/ttm/ttm_lock.c |  311 ++++++++++++++++++++++++++++++++++++++++
 include/drm/ttm/ttm_lock.h     |  247 +++++++++++++++++++++++++++++++
 3 files changed, 559 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpu/drm/ttm/ttm_lock.c
 create mode 100644 include/drm/ttm/ttm_lock.h

diff --git a/drivers/gpu/drm/ttm/Makefile b/drivers/gpu/drm/ttm/Makefile
index a9cc9f8..4473549 100644
--- a/drivers/gpu/drm/ttm/Makefile
+++ b/drivers/gpu/drm/ttm/Makefile
@@ -4,6 +4,6 @@
 ccflags-y := -Iinclude/drm
 ttm-y := ttm_agp_backend.o ttm_memory.o ttm_tt.o ttm_bo.o \
 	ttm_bo_util.o ttm_bo_vm.o ttm_module.o ttm_global.o \
-	ttm_object.o
+	ttm_object.o ttm_lock.o
 
 obj-$(CONFIG_DRM_TTM) += ttm.o
diff --git a/drivers/gpu/drm/ttm/ttm_lock.c b/drivers/gpu/drm/ttm/ttm_lock.c
new file mode 100644
index 0000000..f619ebc
--- /dev/null
+++ b/drivers/gpu/drm/ttm/ttm_lock.c
@@ -0,0 +1,311 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2007-2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+ */
+
+#include "ttm/ttm_lock.h"
+#include "ttm/ttm_module.h"
+#include <asm/atomic.h>
+#include <linux/errno.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+
+#define TTM_WRITE_LOCK_PENDING    (1 << 0)
+#define TTM_VT_LOCK_PENDING       (1 << 1)
+#define TTM_SUSPEND_LOCK_PENDING  (1 << 2)
+#define TTM_VT_LOCK               (1 << 3)
+#define TTM_SUSPEND_LOCK          (1 << 4)
+
+void ttm_lock_init(struct ttm_lock *lock)
+{
+	spin_lock_init(&lock->lock);
+	init_waitqueue_head(&lock->queue);
+	lock->rw = 0;
+	lock->flags = 0;
+	lock->kill_takers = false;
+	lock->signal = SIGKILL;
+}
+EXPORT_SYMBOL(ttm_lock_init);
+
+void ttm_read_unlock(struct ttm_lock *lock)
+{
+	spin_lock(&lock->lock);
+	if (--lock->rw == 0)
+		wake_up_all(&lock->queue);
+	spin_unlock(&lock->lock);
+}
+EXPORT_SYMBOL(ttm_read_unlock);
+
+static bool __ttm_read_lock(struct ttm_lock *lock)
+{
+	bool locked = false;
+
+	spin_lock(&lock->lock);
+	if (unlikely(lock->kill_takers)) {
+		send_sig(lock->signal, current, 0);
+		spin_unlock(&lock->lock);
+		return false;
+	}
+	if (lock->rw >= 0 && lock->flags == 0) {
+		++lock->rw;
+		locked = true;
+	}
+	spin_unlock(&lock->lock);
+	return locked;
+}
+
+int ttm_read_lock(struct ttm_lock *lock, bool interruptible)
+{
+	int ret = 0;
+
+	if (interruptible)
+		ret = wait_event_interruptible(lock->queue,
+					       __ttm_read_lock(lock));
+	else
+		wait_event(lock->queue, __ttm_read_lock(lock));
+	return ret;
+}
+EXPORT_SYMBOL(ttm_read_lock);
+
+static bool __ttm_read_trylock(struct ttm_lock *lock, bool *locked)
+{
+	bool block = true;
+
+	*locked = false;
+
+	spin_lock(&lock->lock);
+	if (unlikely(lock->kill_takers)) {
+		send_sig(lock->signal, current, 0);
+		spin_unlock(&lock->lock);
+		return false;
+	}
+	if (lock->rw >= 0 && lock->flags == 0) {
+		++lock->rw;
+		block = false;
+		*locked = true;
+	} else if (lock->flags == 0) {
+		block = false;
+	}
+	spin_unlock(&lock->lock);
+
+	return !block;
+}
+
+int ttm_read_trylock(struct ttm_lock *lock, bool interruptible)
+{
+	int ret = 0;
+	bool locked;
+
+	if (interruptible)
+		ret = wait_event_interruptible
+			(lock->queue, __ttm_read_trylock(lock, &locked));
+	else
+		wait_event(lock->queue, __ttm_read_trylock(lock, &locked));
+
+	if (unlikely(ret != 0)) {
+		BUG_ON(locked);
+		return ret;
+	}
+
+	return (locked) ? 0 : -EBUSY;
+}
+
+void ttm_write_unlock(struct ttm_lock *lock)
+{
+	spin_lock(&lock->lock);
+	lock->rw = 0;
+	wake_up_all(&lock->queue);
+	spin_unlock(&lock->lock);
+}
+EXPORT_SYMBOL(ttm_write_unlock);
+
+static bool __ttm_write_lock(struct ttm_lock *lock)
+{
+	bool locked = false;
+
+	spin_lock(&lock->lock);
+	if (unlikely(lock->kill_takers)) {
+		send_sig(lock->signal, current, 0);
+		spin_unlock(&lock->lock);
+		return false;
+	}
+	if (lock->rw == 0 && ((lock->flags & ~TTM_WRITE_LOCK_PENDING) == 0)) {
+		lock->rw = -1;
+		lock->flags &= ~TTM_WRITE_LOCK_PENDING;
+		locked = true;
+	} else {
+		lock->flags |= TTM_WRITE_LOCK_PENDING;
+	}
+	spin_unlock(&lock->lock);
+	return locked;
+}
+
+int ttm_write_lock(struct ttm_lock *lock, bool interruptible)
+{
+	int ret = 0;
+
+	if (interruptible) {
+		ret = wait_event_interruptible(lock->queue,
+					       __ttm_write_lock(lock));
+		if (unlikely(ret != 0)) {
+			spin_lock(&lock->lock);
+			lock->flags &= ~TTM_WRITE_LOCK_PENDING;
+			wake_up_all(&lock->queue);
+			spin_unlock(&lock->lock);
+		}
+	} else
+		wait_event(lock->queue, __ttm_read_lock(lock));
+
+	return ret;
+}
+EXPORT_SYMBOL(ttm_write_lock);
+
+void ttm_write_lock_downgrade(struct ttm_lock *lock)
+{
+	spin_lock(&lock->lock);
+	lock->rw = 1;
+	wake_up_all(&lock->queue);
+	spin_unlock(&lock->lock);
+}
+
+static int __ttm_vt_unlock(struct ttm_lock *lock)
+{
+	int ret = 0;
+
+	spin_lock(&lock->lock);
+	if (unlikely(!(lock->flags & TTM_VT_LOCK)))
+		ret = -EINVAL;
+	lock->flags &= ~TTM_VT_LOCK;
+	wake_up_all(&lock->queue);
+	spin_unlock(&lock->lock);
+	printk(KERN_INFO TTM_PFX "vt unlock.\n");
+
+	return ret;
+}
+
+static void ttm_vt_lock_remove(struct ttm_base_object **p_base)
+{
+	struct ttm_base_object *base = *p_base;
+	struct ttm_lock *lock = container_of(base, struct ttm_lock, base);
+	int ret;
+
+	*p_base = NULL;
+	ret = __ttm_vt_unlock(lock);
+	BUG_ON(ret != 0);
+}
+
+static bool __ttm_vt_lock(struct ttm_lock *lock)
+{
+	bool locked = false;
+
+	spin_lock(&lock->lock);
+	if (lock->rw == 0) {
+		lock->flags &= ~TTM_VT_LOCK_PENDING;
+		lock->flags |= TTM_VT_LOCK;
+		locked = true;
+	} else {
+		lock->flags |= TTM_VT_LOCK_PENDING;
+	}
+	spin_unlock(&lock->lock);
+	return locked;
+}
+
+int ttm_vt_lock(struct ttm_lock *lock,
+		bool interruptible,
+		struct ttm_object_file *tfile)
+{
+	int ret = 0;
+
+	if (interruptible) {
+		ret = wait_event_interruptible(lock->queue,
+					       __ttm_vt_lock(lock));
+		if (unlikely(ret != 0)) {
+			spin_lock(&lock->lock);
+			lock->flags &= ~TTM_VT_LOCK_PENDING;
+			wake_up_all(&lock->queue);
+			spin_unlock(&lock->lock);
+			return ret;
+		}
+	} else
+		wait_event(lock->queue, __ttm_vt_lock(lock));
+
+	/*
+	 * Add a base-object, the destructor of which will
+	 * make sure the lock is released if the client dies
+	 * while holding it.
+	 */
+
+	ret = ttm_base_object_init(tfile, &lock->base, false,
+				   ttm_lock_type, &ttm_vt_lock_remove, NULL);
+	if (ret)
+		(void)__ttm_vt_unlock(lock);
+	else {
+		lock->vt_holder = tfile;
+		printk(KERN_INFO TTM_PFX "vt lock.\n");
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(ttm_vt_lock);
+
+int ttm_vt_unlock(struct ttm_lock *lock)
+{
+	return ttm_ref_object_base_unref(lock->vt_holder,
+					 lock->base.hash.key, TTM_REF_USAGE);
+}
+EXPORT_SYMBOL(ttm_vt_unlock);
+
+void ttm_suspend_unlock(struct ttm_lock *lock)
+{
+	spin_lock(&lock->lock);
+	lock->flags &= ~TTM_SUSPEND_LOCK;
+	wake_up_all(&lock->queue);
+	spin_unlock(&lock->lock);
+}
+
+static bool __ttm_suspend_lock(struct ttm_lock *lock)
+{
+	bool locked = false;
+
+	spin_lock(&lock->lock);
+	if (lock->rw == 0) {
+		lock->flags &= ~TTM_SUSPEND_LOCK_PENDING;
+		lock->flags |= TTM_SUSPEND_LOCK;
+		locked = true;
+	} else {
+		lock->flags |= TTM_SUSPEND_LOCK_PENDING;
+	}
+	spin_unlock(&lock->lock);
+	return locked;
+}
+
+void ttm_suspend_lock(struct ttm_lock *lock)
+{
+	wait_event(lock->queue, __ttm_suspend_lock(lock));
+}
diff --git a/include/drm/ttm/ttm_lock.h b/include/drm/ttm/ttm_lock.h
new file mode 100644
index 0000000..81ba0b0
--- /dev/null
+++ b/include/drm/ttm/ttm_lock.h
@@ -0,0 +1,247 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2007-2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+ */
+
+/** @file ttm_lock.h
+ * This file implements a simple replacement for the buffer manager use
+ * of the DRM heavyweight hardware lock.
+ * The lock is a read-write lock. Taking it in read mode and write mode
+ * is relatively fast, and intended for in-kernel use only.
+ *
+ * The vt mode is used only when there is a need to block all
+ * user-space processes from validating buffers.
+ * It's allowed to leave kernel space with the vt lock held.
+ * If a user-space process dies while having the vt-lock,
+ * it will be released during the file descriptor release. The vt lock
+ * excludes write lock and read lock.
+ *
+ * The suspend mode is used to lock out all TTM users when preparing for
+ * and executing suspend operations.
+ *
+ */
+
+#ifndef _TTM_LOCK_H_
+#define _TTM_LOCK_H_
+
+#include "ttm/ttm_object.h"
+#include <linux/wait.h>
+#include <asm/atomic.h>
+
+/**
+ * struct ttm_lock
+ *
+ * @base: ttm base object used solely to release the lock if the client
+ * holding the lock dies.
+ * @queue: Queue for processes waiting for lock change-of-status.
+ * @lock: Spinlock protecting some lock members.
+ * @rw: Read-write lock counter. Protected by @lock.
+ * @flags: Lock state. Protected by @lock.
+ * @kill_takers: Boolean whether to kill takers of the lock.
+ * @signal: Signal to send when kill_takers is true.
+ */
+
+struct ttm_lock {
+	struct ttm_base_object base;
+	wait_queue_head_t queue;
+	spinlock_t lock;
+	int32_t rw;
+	uint32_t flags;
+	bool kill_takers;
+	int signal;
+	struct ttm_object_file *vt_holder;
+};
+
+
+/**
+ * ttm_lock_init
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * Initializes the lock.
+ */
+extern void ttm_lock_init(struct ttm_lock *lock);
+
+/**
+ * ttm_read_unlock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ *
+ * Releases a read lock.
+ */
+extern void ttm_read_unlock(struct ttm_lock *lock);
+
+/**
+ * ttm_read_lock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * @interruptible: Interruptible sleeping while waiting for a lock.
+ *
+ * Takes the lock in read mode.
+ * Returns:
+ * -ERESTARTSYS If interrupted by a signal and interruptible is true.
+ */
+extern int ttm_read_lock(struct ttm_lock *lock, bool interruptible);
+
+/**
+ * ttm_read_trylock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * @interruptible: Interruptible sleeping while waiting for a lock.
+ *
+ * Tries to take the lock in read mode. If the lock is already held
+ * in write mode, the function will return -EBUSY. If the lock is held
+ * in vt or suspend mode, the function will sleep until these modes
+ * are unlocked.
+ *
+ * Returns:
+ * -EBUSY The lock was already held in write mode.
+ * -ERESTARTSYS If interrupted by a signal and interruptible is true.
+ */
+extern int ttm_read_trylock(struct ttm_lock *lock, bool interruptible);
+
+/**
+ * ttm_write_unlock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ *
+ * Releases a write lock.
+ */
+extern void ttm_write_unlock(struct ttm_lock *lock);
+
+/**
+ * ttm_write_lock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * @interruptible: Interruptible sleeping while waiting for a lock.
+ *
+ * Takes the lock in write mode.
+ * Returns:
+ * -ERESTARTSYS If interrupted by a signal and interruptible is true.
+ */
+extern int ttm_write_lock(struct ttm_lock *lock, bool interruptible);
+
+/**
+ * ttm_lock_downgrade
+ *
+ * @lock: Pointer to a struct ttm_lock
+ *
+ * Downgrades a write lock to a read lock.
+ */
+extern void ttm_lock_downgrade(struct ttm_lock *lock);
+
+/**
+ * ttm_suspend_lock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ *
+ * Takes the lock in suspend mode. Excludes read and write mode.
+ */
+extern void ttm_suspend_lock(struct ttm_lock *lock);
+
+/**
+ * ttm_suspend_unlock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ *
+ * Releases a suspend lock
+ */
+extern void ttm_suspend_unlock(struct ttm_lock *lock);
+
+/**
+ * ttm_vt_lock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * @interruptible: Interruptible sleeping while waiting for a lock.
+ * @tfile: Pointer to a struct ttm_object_file to register the lock with.
+ *
+ * Takes the lock in vt mode.
+ * Returns:
+ * -ERESTARTSYS If interrupted by a signal and interruptible is true.
+ * -ENOMEM: Out of memory when locking.
+ */
+extern int ttm_vt_lock(struct ttm_lock *lock, bool interruptible,
+		       struct ttm_object_file *tfile);
+
+/**
+ * ttm_vt_unlock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ *
+ * Releases a vt lock.
+ * Returns:
+ * -EINVAL If the lock was not held.
+ */
+extern int ttm_vt_unlock(struct ttm_lock *lock);
+
+/**
+ * ttm_write_unlock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ *
+ * Releases a write lock.
+ */
+extern void ttm_write_unlock(struct ttm_lock *lock);
+
+/**
+ * ttm_write_lock
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * @interruptible: Interruptible sleeping while waiting for a lock.
+ *
+ * Takes the lock in write mode.
+ * Returns:
+ * -ERESTARTSYS If interrupted by a signal and interruptible is true.
+ */
+extern int ttm_write_lock(struct ttm_lock *lock, bool interruptible);
+
+/**
+ * ttm_lock_set_kill
+ *
+ * @lock: Pointer to a struct ttm_lock
+ * @val: Boolean whether to kill processes taking the lock.
+ * @signal: Signal to send to the process taking the lock.
+ *
+ * The kill-when-taking-lock functionality is used to kill processes that keep
+ * on using the TTM functionality when its resources has been taken down, for
+ * example when the X server exits. A typical sequence would look like this:
+ * - X server takes lock in write mode.
+ * - ttm_lock_set_kill() is called with @val set to true.
+ * - As part of X server exit, TTM resources are taken down.
+ * - X server releases the lock on file release.
+ * - Another dri client wants to render, takes the lock and is killed.
+ *
+ */
+static inline void ttm_lock_set_kill(struct ttm_lock *lock, bool val,
+				     int signal)
+{
+	lock->kill_takers = val;
+	if (val)
+		lock->signal = signal;
+}
+
+#endif
-- 
1.5.3.2

