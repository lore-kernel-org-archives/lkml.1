Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZBHSDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZBHSDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZBHSDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:03:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbZBHSDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:03:41 -0500
Date: Sun, 8 Feb 2009 13:03:41 -0500
From: Kyle McMartin <kyle@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, mingo@redhat.com
Subject: x86: spinlocks: define dummy __raw_spin_is_contended
Message-ID: <20090208180341.GC11398@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Architectures other than mips and x86 are not using ticket
spinlocks. Therefore, the contention on the lock is meaningless,
since there is nobody known to be waiting on it (arguably /fairly/
unfair locks) Dummy it out to return 0 on other architectures.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/mips/include/asm/spinlock.h |    1 +
 arch/x86/include/asm/paravirt.h  |    1 +
 arch/x86/include/asm/spinlock.h  |    1 +
 include/linux/spinlock.h         |    5 +++++
 4 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/spinlock.h b/arch/mips/include/asm/spinlock.h
index 1a1f320..0884947 100644
--- a/arch/mips/include/asm/spinlock.h
+++ b/arch/mips/include/asm/spinlock.h
@@ -51,6 +51,7 @@ static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
 
 	return (((counters >> 14) - counters) & 0x1fff) > 1;
 }
+#define __raw_spin_is_contended	__raw_spin_is_contended
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index ba3e2ff..c09a141 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1402,6 +1402,7 @@ static inline int __raw_spin_is_contended(struct raw_spinlock *lock)
 {
 	return PVOP_CALL1(int, pv_lock_ops.spin_is_contended, lock);
 }
+#define __raw_spin_is_contended	__raw_spin_is_contended
 
 static __always_inline void __raw_spin_lock(struct raw_spinlock *lock)
 {
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index d17c919..8247e94 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -245,6 +245,7 @@ static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
 {
 	return __ticket_spin_is_contended(lock);
 }
+#define __raw_spin_is_contended	__raw_spin_is_contended
 
 static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index e0c0fcc..a0c66a2 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -124,7 +124,12 @@ do {								\
 #ifdef CONFIG_GENERIC_LOCKBREAK
 #define spin_is_contended(lock) ((lock)->break_lock)
 #else
+
+#ifdef __raw_spin_is_contended
 #define spin_is_contended(lock)	__raw_spin_is_contended(&(lock)->raw_lock)
+#else
+#define spin_is_contended(lock)	(((void)(lock), 0))
+#endif /*__raw_spin_is_contended*/
 #endif
 
 /**
-- 
1.6.0.6

