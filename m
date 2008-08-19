Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYHSUUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYHSUUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYHSUUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:20:23 -0400
Received: from gw.goop.org ([64.81.55.164]:54400 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbYHSUUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:20:23 -0400
Message-ID: <48AB2AD8.8080108@goop.org>
Date: Tue, 19 Aug 2008 13:19:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH] x86/paravirt: add spin_lock_flags lock op
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful for a pv_lock_ops backend to know whether interrupts are
enabled or not in the context a spin_lock is being called.  This
allows it to enable interrupts while spinning, which could be
particularly helpful when spinning becomes blocking.

The default implementation just calls the normal spin_lock op,
ignoring the flags.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt-spinlocks.c |    6 ++++++
 include/asm-x86/paravirt.h           |    7 +++++++
 include/asm-x86/spinlock.h           |    9 +++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -7,12 +7,18 @@
 
 #include <asm/paravirt.h>
 
+static void default_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
+{
+	__raw_spin_lock(lock);
+}
+
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
 	.spin_is_locked = __ticket_spin_is_locked,
 	.spin_is_contended = __ticket_spin_is_contended,
 
 	.spin_lock = __ticket_spin_lock,
+	.spin_lock_flags = default_spin_lock_flags,
 	.spin_trylock = __ticket_spin_trylock,
 	.spin_unlock = __ticket_spin_unlock,
 #endif
===================================================================
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -328,6 +328,7 @@
 	int (*spin_is_locked)(struct raw_spinlock *lock);
 	int (*spin_is_contended)(struct raw_spinlock *lock);
 	void (*spin_lock)(struct raw_spinlock *lock);
+	void (*spin_lock_flags)(struct raw_spinlock *lock, unsigned long flags);
 	int (*spin_trylock)(struct raw_spinlock *lock);
 	void (*spin_unlock)(struct raw_spinlock *lock);
 };
@@ -1396,6 +1397,12 @@
 	PVOP_VCALL1(pv_lock_ops.spin_lock, lock);
 }
 
+static __always_inline void __raw_spin_lock_flags(struct raw_spinlock *lock,
+						  unsigned long flags)
+{
+	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
+}
+
 static __always_inline int __raw_spin_trylock(struct raw_spinlock *lock)
 {
 	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
===================================================================
--- a/include/asm-x86/spinlock.h
+++ b/include/asm-x86/spinlock.h
@@ -182,8 +182,6 @@
 }
 #endif
 
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
-
 #ifdef CONFIG_PARAVIRT
 /*
  * Define virtualization-friendly old-style lock byte lock, for use in
@@ -272,6 +270,13 @@
 {
 	__ticket_spin_unlock(lock);
 }
+
+static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
+						  unsigned long flags)
+{
+	__raw_spin_lock(lock);
+}
+
 #endif	/* CONFIG_PARAVIRT */
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)


