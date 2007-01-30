Return-Path: <linux-kernel-owner+w=401wt.eu-S965321AbXA3GsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965321AbXA3GsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 01:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965361AbXA3GsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 01:48:05 -0500
Received: from fencepost.gnu.org ([199.232.76.164]:36786 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965321AbXA3GsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 01:48:02 -0500
Subject: [PATCH] Fix sparse annotation of spin unlock macros in one case
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Jan 2007 01:48:00 -0500
Message-Id: <1170139680.8587.7.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Roskin <proski@gnu.org>

SMP systems without preemption and spinlock debugging enabled use unlock
macros that don't tell sparse that the lock is being released.  Add
sparse annotations in this case.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 include/linux/spinlock.h |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 94b767d..d3b6397 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -228,15 +228,30 @@ do {								\
 # define read_unlock_irq(lock)		_read_unlock_irq(lock)
 # define write_unlock_irq(lock)		_write_unlock_irq(lock)
 #else
-# define spin_unlock(lock)		__raw_spin_unlock(&(lock)->raw_lock)
-# define read_unlock(lock)		__raw_read_unlock(&(lock)->raw_lock)
-# define write_unlock(lock)		__raw_write_unlock(&(lock)->raw_lock)
-# define spin_unlock_irq(lock) \
-    do { __raw_spin_unlock(&(lock)->raw_lock); local_irq_enable(); } while (0)
-# define read_unlock_irq(lock) \
-    do { __raw_read_unlock(&(lock)->raw_lock); local_irq_enable(); } while (0)
-# define write_unlock_irq(lock) \
-    do { __raw_write_unlock(&(lock)->raw_lock); local_irq_enable(); } while (0)
+# define spin_unlock(lock) \
+    do {__raw_spin_unlock(&(lock)->raw_lock); __release(lock); } while (0)
+# define read_unlock(lock) \
+    do {__raw_read_unlock(&(lock)->raw_lock); __release(lock); } while (0)
+# define write_unlock(lock) \
+    do {__raw_write_unlock(&(lock)->raw_lock); __release(lock); } while (0)
+# define spin_unlock_irq(lock)			\
+do {						\
+	__raw_spin_unlock(&(lock)->raw_lock);	\
+	local_irq_enable();			\
+	__release(lock);			\
+} while (0)
+# define read_unlock_irq(lock)			\
+do {						\
+	__raw_read_unlock(&(lock)->raw_lock);	\
+	local_irq_enable();			\
+	__release(lock);			\
+} while (0)
+# define write_unlock_irq(lock)			\
+do {						\
+	__raw_write_unlock(&(lock)->raw_lock);	\
+	local_irq_enable();			\
+	__release(lock);			\
+} while (0)
 #endif
 
 #define spin_unlock_irqrestore(lock, flags) \


-- 
Regards,
Pavel Roskin


