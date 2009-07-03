Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbZGCMqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbZGCMqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757785AbZGCMpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:45:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:59945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851AbZGCMpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:45:32 -0400
Date: Fri, 3 Jul 2009 12:44:06 GMT
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
Subject: [tip:perfcounters/urgent] x86: atomic64: Fix unclean type use in atomic64_xchg()
Message-ID: <tip-199e23780a7e75c63a9e3d1108804e3af450ea3e@git.kernel.org>
Git-Commit-ID: 199e23780a7e75c63a9e3d1108804e3af450ea3e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 12:44:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  199e23780a7e75c63a9e3d1108804e3af450ea3e
Gitweb:     http://git.kernel.org/tip/199e23780a7e75c63a9e3d1108804e3af450ea3e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 3 Jul 2009 13:02:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 13:26:46 +0200

x86: atomic64: Fix unclean type use in atomic64_xchg()

Linus noticed that atomic64_xchg() uses atomic_read(), which
happens to work because atomic_read() is a macro so the
.counter value gets u64-read on 32-bit too - but this is really
bogus and serious bugs are waiting to happen.

Fix atomic64_xchg() to use __atomic64_read() instead.

No code changed:

arch/x86/lib/atomic64_32.o:

   text	   data	    bss	    dec	    hex	filename
    435	      0	      0	    435	    1b3	atomic64_32.o.before
    435	      0	      0	    435	    1b3	atomic64_32.o.after

md5:
   bd8ab95e69c93518578bfaf0ea3be4d9  atomic64_32.o.before.asm
   bd8ab95e69c93518578bfaf0ea3be4d9  atomic64_32.o.after.asm

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
 arch/x86/lib/atomic64_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index a910238..fd28fd3 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -36,7 +36,7 @@ u64 atomic64_xchg(atomic64_t *ptr, u64 new_val)
 	u64 old_val;
 
 	do {
-		old_val = atomic_read(ptr);
+		old_val = __atomic64_read(ptr);
 	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
 
 	return old_val;
