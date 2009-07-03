Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbZGCMo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbZGCMo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbZGCMop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:44:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:59871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbZGCMoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:44:44 -0400
Date: Fri, 3 Jul 2009 12:43:05 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
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
Subject: [tip:perfcounters/urgent] x86: atomic64: Improve atomic64_read()
Message-ID: <tip-aacf682fd8c66b57383c407eecd9d4a28264ee91@git.kernel.org>
Git-Commit-ID: aacf682fd8c66b57383c407eecd9d4a28264ee91
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 12:43:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aacf682fd8c66b57383c407eecd9d4a28264ee91
Gitweb:     http://git.kernel.org/tip/aacf682fd8c66b57383c407eecd9d4a28264ee91
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Fri, 3 Jul 2009 12:14:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 13:26:40 +0200

x86: atomic64: Improve atomic64_read()

Linus noticed that the 32-bit version of atomic64_read() was
being overly complex with re-reading the value and doing a
retry loop over that.

Instead we can just rely on cmpxchg8b returning either the new
value or returning the current value.

We can use any 'old' value, which will be faster as it can be
loaded via immediates. Using some value that is not equal to
the real value in memory the instruction gets faster.

This also has the advantage that the CPU could avoid dirtying
the cacheline.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
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
 arch/x86/lib/atomic64_32.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index d21e725..afa5d44 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -67,13 +67,9 @@ void atomic64_set(atomic64_t *ptr, u64 new_val)
  */
 u64 atomic64_read(atomic64_t *ptr)
 {
-	u64 curr_val;
+	u64 old = 1LL << 32;
 
-	do {
-		curr_val = __atomic64_read(ptr);
-	} while (atomic64_cmpxchg(ptr, curr_val, curr_val) != curr_val);
-
-	return curr_val;
+	return cmpxchg8b(&ptr->counter, old, old);
 }
 
 /**
