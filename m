Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZGCMod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZGCMod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbZGCMoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:44:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:59828 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562AbZGCMoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:44:12 -0400
Date: Fri, 3 Jul 2009 12:43:29 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, eric.dumazet@gmail.com,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
       arnd@arndb.de, dhowells@redhat.com, fweisbec@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       arnd@arndb.de, fweisbec@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
Subject: [tip:perfcounters/urgent] x86: atomic64: Improve atomic64_add_return()
Message-ID: <tip-824975ef190e7dcb77718d1cc2cb53769b16d918@git.kernel.org>
Git-Commit-ID: 824975ef190e7dcb77718d1cc2cb53769b16d918
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 12:43:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  824975ef190e7dcb77718d1cc2cb53769b16d918
Gitweb:     http://git.kernel.org/tip/824975ef190e7dcb77718d1cc2cb53769b16d918
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 3 Jul 2009 12:39:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 13:26:42 +0200

x86: atomic64: Improve atomic64_add_return()

Linus noted (based on Eric Dumazet's numbers) that we would
probably be better off not trying an atomic_read() in
atomic64_add_return() but intead intentionally let the first
cmpxchg8b fail - to get a cache-friendly 'give me ownership
of this cacheline' transaction. That can then be followed
by the real cmpxchg8b which sets the value local to the CPU.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/lib/atomic64_32.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index 5fc1e2c..6195962 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -76,13 +76,22 @@ u64 atomic64_read(atomic64_t *ptr)
  */
 u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
 {
-	u64 old_val, new_val;
+	/*
+	 * Try first with a (probably incorrect) assumption about
+	 * what we have there. We'll do two loops most likely,
+	 * but we'll get an ownership MESI transaction straight away
+	 * instead of a read transaction followed by a
+	 * flush-for-ownership transaction:
+	 */
+	u64 old_val, new_val, real_val = 1ULL << 32;
 
 	do {
-		old_val = atomic_read(ptr);
+		old_val = real_val;
 		new_val = old_val + delta;
 
-	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+		real_val = atomic64_cmpxchg(ptr, old_val, new_val);
+
+	} while (real_val != old_val);
 
 	return new_val;
 }
