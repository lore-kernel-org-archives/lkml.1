Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZGCMqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZGCMqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757856AbZGCMpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:45:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:59950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730AbZGCMpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:45:34 -0400
Date: Fri, 3 Jul 2009 12:44:18 GMT
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
Message-ID: <tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org>
Git-Commit-ID: 9103cab145a93cef13378632b332a824758a2f6f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 12:44:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9103cab145a93cef13378632b332a824758a2f6f
Gitweb:     http://git.kernel.org/tip/9103cab145a93cef13378632b332a824758a2f6f
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Fri, 3 Jul 2009 13:23:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 13:26:48 +0200

x86: atomic64: Improve atomic64_read()

Optimize atomic64_read() as a special open-coded
cmpxchg8b variant. This generates nicer code:

arch/x86/lib/atomic64_32.o:

   text	   data	    bss	    dec	    hex	filename
    435	      0	      0	    435	    1b3	atomic64_32.o.before
    431	      0	      0	    431	    1af	atomic64_32.o.after

md5:
   bd8ab95e69c93518578bfaf0ea3be4d9  atomic64_32.o.before.asm
   2bdfd4bd1f6b7b61b7fc127aef90ce3b  atomic64_32.o.after.asm

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
 arch/x86/lib/atomic64_32.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index fd28fd3..079ac8e 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -62,9 +62,17 @@ void atomic64_set(atomic64_t *ptr, u64 new_val)
  */
 u64 atomic64_read(atomic64_t *ptr)
 {
-	u64 old = 1LL << 32;
+	u64 res;
 
-	return cmpxchg8b(&ptr->counter, old, old);
+	asm volatile(
+		"mov %%ebx, %%eax\n\t"
+		"mov %%ecx, %%edx\n\t"
+		LOCK_PREFIX "cmpxchg8b %1\n"
+			: "=A" (res)
+			: "m" (*ptr)
+		);
+
+	return res;
 }
 
 /**
