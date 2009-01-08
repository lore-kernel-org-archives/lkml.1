Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZAHNtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZAHNtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 08:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZAHNs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 08:48:59 -0500
Received: from styx.suse.cz ([82.119.242.94]:33054 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755439AbZAHNs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 08:48:59 -0500
Date: Thu, 8 Jan 2009 14:48:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Subject: Re: Is 386 processor still supported?
In-Reply-To: <20090108132442.GB8015@localhost>
Message-ID: <alpine.LNX.1.10.0901081446040.5377@jikos.suse.cz>
References: <20090108120338.6b8b4567@zonk.pl> <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> <20090108132442.GB8015@localhost>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009, Cyrill Gorcunov wrote:

> Jiri I could be wrong but it seems __byte_spin_lock is implemented
> under CONFIG_PARAVIRT and now referred under #else  /* !CONFIG_PARAVIRT */
> At least I didn'y found additional implementaion in tree.
> Did I miss anything?

You're right, my bad. There is going to be some ifdef ugliness introduced 
by this unfortunately, but on the other hand it's pretty straightforward.



From: Jiri Kosina <jkosina@suse.cz>
Subject: x86: make spinlocks available on machines without xadd insn

Current kernel wouldn't compile on ancient x86 machines that don't support
xadd instruction, as ticket spinlocks implementation unconditionally uses
it.

On machines without CONFIG_X86_XADD, use old-style byte spinlock
implementation instead.

Reported-by: Adam Osuchowski <adwol@zonk.pl>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 

 arch/x86/include/asm/spinlock.h |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index d17c919..1331333 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -172,10 +172,10 @@ static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
 	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
 }
 
-#ifdef CONFIG_PARAVIRT
+#if defined(CONFIG_PARAVIRT) || !defined(CONFIG_X86_XADD)
 /*
  * Define virtualization-friendly old-style lock byte lock, for use in
- * pv_lock_ops if desired.
+ * pv_lock_ops or for machines not supporting xadd instruction.
  *
  * This differs from the pre-2.6.24 spinlock by always using xchgb
  * rather than decb to take the lock; this allows it to use a
@@ -235,30 +235,50 @@ static inline void __byte_spin_unlock(raw_spinlock_t *lock)
 	smp_wmb();
 	bl->lock = 0;
 }
-#else  /* !CONFIG_PARAVIRT */
+#else
 static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
 {
+#ifdef CONFIG_X86_XADD
 	return __ticket_spin_is_locked(lock);
+#else
+	return __byte_spin_is_locked(lock);
+#endif
 }
 
 static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
 {
+#ifdef CONFIG_X86_XADD
 	return __ticket_spin_is_contended(lock);
+#else
+	return __byte_spin_is_contended(lock);
+#endif
 }
 
 static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
+#ifdef CONFIG_X86_XADD
 	__ticket_spin_lock(lock);
+#else
+	__byte_spin_lock(lock);
+#endif
 }
 
 static __always_inline int __raw_spin_trylock(raw_spinlock_t *lock)
 {
+#ifdef CONFIG_X86_XADD
 	return __ticket_spin_trylock(lock);
+#else
+	return __byte_spin_trylock(lock);
+#endif
 }
 
 static __always_inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
+#ifdef CONFIG_X86_XADD
 	__ticket_spin_unlock(lock);
+#else
+	__byte_spin_unlock(lock);
+#endif
 }
 
 static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
@@ -267,7 +287,7 @@ static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
 	__raw_spin_lock(lock);
 }
 
-#endif	/* CONFIG_PARAVIRT */
+#endif
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
 {
