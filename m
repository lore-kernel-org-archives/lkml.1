Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbZGCMpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbZGCMpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbZGCMos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:44:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:59875 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757564AbZGCMor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:44:47 -0400
Date: Fri, 3 Jul 2009 12:43:17 GMT
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
Subject: [tip:perfcounters/urgent] x86: atomic64: Improve cmpxchg8b()
Message-ID: <tip-69237f94e65d3d7f539f1adb98ef68685c595004@git.kernel.org>
Git-Commit-ID: 69237f94e65d3d7f539f1adb98ef68685c595004
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 12:43:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69237f94e65d3d7f539f1adb98ef68685c595004
Gitweb:     http://git.kernel.org/tip/69237f94e65d3d7f539f1adb98ef68685c595004
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Fri, 3 Jul 2009 13:26:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 13:26:41 +0200

x86: atomic64: Improve cmpxchg8b()

Rewrite cmpxchg8b() to not use %edi register but a generic "+m"
constraint, to increase compiler freedom in code generation and
possibly better code.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
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
 arch/x86/lib/atomic64_32.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index afa5d44..5fc1e2c 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -6,19 +6,14 @@
 
 static inline u64 cmpxchg8b(u64 *ptr, u64 old, u64 new)
 {
-	asm volatile(
-
-		LOCK_PREFIX "cmpxchg8b (%[ptr])\n"
-
-		     :		"=A" (old)
-
-		     : [ptr]	"D" (ptr),
-				"A" (old),
-				"b" (ll_low(new)),
-				"c" (ll_high(new))
-
-		     : "memory");
+	u32 low = new;
+	u32 high = new >> 32;
 
+	asm volatile(
+		LOCK_PREFIX "cmpxchg8b %1\n"
+		     : "+A" (old), "+m" (*ptr)
+		     :  "b" (low),  "c" (high)
+		     );
 	return old;
 }
 
