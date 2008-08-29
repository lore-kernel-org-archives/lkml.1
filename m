Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYH2L6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYH2L6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbYH2L6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:58:10 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:14188 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYH2L6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:58:09 -0400
Message-Id: <48B800BC.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 12:59:24 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: reduce code duplication in tick spinlock code
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

--- linux-2.6.27-rc5/include/asm-x86/spinlock.h	2008-08-21 14:37:34.000000000 +0200
+++ 2.6.27-rc5-x86-spinlock-ticket-shift/include/asm-x86/spinlock.h	2008-08-19 12:43:22.000000000 +0200
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
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
 
 #ifdef CONFIG_PARAVIRT



