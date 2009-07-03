Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbZGCMpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbZGCMpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757757AbZGCMpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:45:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:59923 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757750AbZGCMpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:45:17 -0400
Date: Fri, 3 Jul 2009 12:43:42 GMT
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
Subject: [tip:perfcounters/urgent] x86: atomic64: Reduce size of functions
Message-ID: <tip-3ac805d2afd3fa4a07cb5bcf352fd7fa83f28935@git.kernel.org>
Git-Commit-ID: 3ac805d2afd3fa4a07cb5bcf352fd7fa83f28935
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 12:43:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ac805d2afd3fa4a07cb5bcf352fd7fa83f28935
Gitweb:     http://git.kernel.org/tip/3ac805d2afd3fa4a07cb5bcf352fd7fa83f28935
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 3 Jul 2009 12:51:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 13:26:43 +0200

x86: atomic64: Reduce size of functions

cmpxchg8b is a huge instruction in terms of register footprint,
we almost never want to inline it, not even within the same
code module.

GCC 4.3 still messes up for two functions, under-judging the
true cost of this instruction - so annotate two key functions
to reduce the bloat:

arch/x86/lib/atomic64_32.o:

   text	   data	    bss	    dec	    hex	filename
   1763	      0	      0	   1763	    6e3	atomic64_32.o.before
    435	      0	      0	    435	    1b3	atomic64_32.o.after

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
LKML-Reference: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/lib/atomic64_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index 6195962..a910238 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -4,7 +4,7 @@
 #include <asm/cmpxchg.h>
 #include <asm/atomic.h>
 
-static inline u64 cmpxchg8b(u64 *ptr, u64 old, u64 new)
+static noinline u64 cmpxchg8b(u64 *ptr, u64 old, u64 new)
 {
 	u32 low = new;
 	u32 high = new >> 32;
@@ -74,7 +74,7 @@ u64 atomic64_read(atomic64_t *ptr)
  *
  * Atomically adds @delta to @ptr and returns @delta + *@ptr
  */
-u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
+noinline u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
 {
 	/*
 	 * Try first with a (probably incorrect) assumption about
