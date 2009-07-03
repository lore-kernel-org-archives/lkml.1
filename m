Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbZGCScs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbZGCScs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbZGCSch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:32:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:53639 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758948AbZGCScf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:32:35 -0400
Date: Fri, 3 Jul 2009 18:31:25 GMT
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
In-Reply-To: <20090703111033.6e9627de@infradead.org>
References: <20090703111033.6e9627de@infradead.org>
Subject: [tip:perfcounters/urgent] x86: atomic64: Optimize CMPXCHG8B sequences to not use the LOCK prefix
Message-ID: <tip-07aa81b2169a2cb5e62ad239fd8055ef484e4f79@git.kernel.org>
Git-Commit-ID: 07aa81b2169a2cb5e62ad239fd8055ef484e4f79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 18:31:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07aa81b2169a2cb5e62ad239fd8055ef484e4f79
Gitweb:     http://git.kernel.org/tip/07aa81b2169a2cb5e62ad239fd8055ef484e4f79
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 3 Jul 2009 20:15:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 20:24:00 +0200

x86: atomic64: Optimize CMPXCHG8B sequences to not use the LOCK prefix

Arjan noted that the CMPXCHG8B instruction has an implicit lock
prefix, so there's no need to add the prefix explicitly.

This gives us smaller code and smaller alternative-instructions
tables.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <20090703111033.6e9627de@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/atomic_32.h |    2 +-
 arch/x86/lib/atomic64_32.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index de89959..130f4ab 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -302,7 +302,7 @@ static inline u64 atomic64_read(atomic64_t *ptr)
 	asm volatile(
 		"mov %%ebx, %%eax\n\t"
 		"mov %%ecx, %%edx\n\t"
-		LOCK_PREFIX "cmpxchg8b %1\n"
+		"cmpxchg8b %1\n"
 			: "=&A" (res)
 			: "m" (*ptr)
 		);
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index d79f4ac..e4a6671 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -12,7 +12,7 @@ static noinline u64 cmpxchg8b(u64 *ptr, u64 old, u64 new)
 	u32 high = new >> 32;
 
 	asm volatile(
-		LOCK_PREFIX "cmpxchg8b %1\n"
+		"cmpxchg8b %1\n"
 		     : "+A" (old), "+m" (*ptr)
 		     :  "b" (low),  "c" (high)
 		     );
