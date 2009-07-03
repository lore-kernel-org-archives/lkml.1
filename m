Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZGCIPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZGCIPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZGCIOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:14:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34439 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbZGCIOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:14:46 -0400
Date: Fri, 3 Jul 2009 10:14:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, htejun@gmail.com, jarkao2@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org, eric.dumazet@gmail.com
Subject: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090703081445.GG2902@jolsa.lab.eng.brq.redhat.com>
References: <20090703081219.GE2902@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703081219.GE2902@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding smp_mb__after_lock define to be used as a smp_mb call after
a lock.  

Making it nop for x86, since {read|write|spin}_lock() on x86 are 
full memory barriers.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>

---
 arch/x86/include/asm/spinlock.h |    3 +++
 include/linux/spinlock.h        |    5 +++++
 include/net/sock.h              |    5 ++++-
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index b7e5db8..39ecc5f 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -302,4 +302,7 @@ static inline void __raw_write_unlock(raw_rwlock_t *rw)
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
 
+/* The {read|write|spin}_lock() on x86 are full memory barriers. */
+#define smp_mb__after_lock() do { } while (0)
+
 #endif /* _ASM_X86_SPINLOCK_H */
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 252b245..ae053bd 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -132,6 +132,11 @@ do {								\
 #endif /*__raw_spin_is_contended*/
 #endif
 
+/* The lock does not imply full memory barrier. */
+#ifndef smp_mb__after_lock
+#define smp_mb__after_lock() smp_mb()
+#endif
+
 /**
  * spin_unlock_wait - wait until the spinlock gets unlocked
  * @lock: the spinlock in question.
diff --git a/include/net/sock.h b/include/net/sock.h
index 4eb8409..98afcd9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1271,6 +1271,9 @@ static inline int sk_has_allocations(const struct sock *sk)
  * in its cache, and so does the tp->rcv_nxt update on CPU2 side.  The CPU1
  * could then endup calling schedule and sleep forever if there are no more
  * data on the socket.
+ *
+ * The sk_has_helper is always called right after a call to read_lock, so we
+ * can use smp_mb__after_lock barrier.
  */
 static inline int sk_has_sleeper(struct sock *sk)
 {
@@ -1280,7 +1283,7 @@ static inline int sk_has_sleeper(struct sock *sk)
 	 *
 	 * This memory barrier is paired in the sock_poll_wait.
 	 */
-	smp_mb();
+	smp_mb__after_lock();
 	return sk->sk_sleep && waitqueue_active(sk->sk_sleep);
 }
 
