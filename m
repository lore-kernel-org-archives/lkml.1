Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbYIEM1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbYIEM1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYIEM0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:26:52 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:29831 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYIEM0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:26:52 -0400
Message-Id: <48C141C0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 05 Sep 2008 13:27:12 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] x86: ticket spin locks: factor out more common
	 code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>

---
 include/asm-x86/spinlock.h |   42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

--- linux-x86.orig/include/asm-x86/spinlock.h
+++ linux-x86/include/asm-x86/spinlock.h
@@ -54,19 +54,7 @@
  * much between them in performance though, especially as locks are out of line.
  */
 #if (NR_CPUS < 256)
-static inline int __ticket_spin_is_locked(raw_spinlock_t *lock)
-{
-	int tmp = ACCESS_ONCE(lock->slock);
-
-	return (((tmp >> 8) & 0xff) != (tmp & 0xff));
-}
-
-static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
-{
-	int tmp = ACCESS_ONCE(lock->slock);
-
-	return (((tmp >> 8) - tmp) & 0xff) > 1;
-}
+#define TICKET_SHIFT 8
 
 static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
 {
@@ -116,19 +104,7 @@ static __always_inline void __ticket_spi
 		     : "memory", "cc");
 }
 #else
-static inline int __ticket_spin_is_locked(raw_spinlock_t *lock)
-{
-	int tmp = ACCESS_ONCE(lock->slock);
-
-	return (((tmp >> 16) & 0xffff) != (tmp & 0xffff));
-}
-
-static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
-{
-	int tmp = ACCESS_ONCE(lock->slock);
-
-	return (((tmp >> 16) - tmp) & 0xffff) > 1;
-}
+#define TICKET_SHIFT 16
 
 static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
 {
@@ -182,6 +158,20 @@ static __always_inline void __ticket_spi
 }
 #endif
 
+static inline int __ticket_spin_is_locked(raw_spinlock_t *lock)
+{
+	int tmp = ACCESS_ONCE(lock->slock);
+
+	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & ((1 << TICKET_SHIFT) - 1));
+}
+
+static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
+{
+	int tmp = ACCESS_ONCE(lock->slock);
+
+	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
+}
+
 #ifdef CONFIG_PARAVIRT
 /*
  * Define virtualization-friendly old-style lock byte lock, for use in




