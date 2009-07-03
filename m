Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbZGCSBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbZGCSBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZGCSBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:01:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36177 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZGCSBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:01:04 -0400
Date: Fri, 3 Jul 2009 20:00:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, arnd@arndb.de,
       fweisbec@gmail.com, dhowells@redhat.com, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/urgent] x86: atomic64: Fix unclean type use
	in atomic64_xchg()
Message-ID: <20090703180042.GA3405@elte.hu>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-199e23780a7e75c63a9e3d1108804e3af450ea3e@git.kernel.org> <alpine.LFD.2.01.0907031000590.3210@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907031000590.3210@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 3 Jul 2009, tip-bot for Ingo Molnar wrote:
> > 
> > Fix atomic64_xchg() to use __atomic64_read() instead.
> 
> Hmm. The whole __atomic64_read() thing should be dropped. Are 
> there any users? None of them should be valid, as Eric's numbers 
> showed. It's apparently better to start out with a random value 
> rather than actually trying to read it.

ah, yes.

We still have this use:

u64 atomic64_xchg(atomic64_t *ptr, u64 new_val)
{
        u64 old_val;

        do {
                old_val = __atomic64_read(ptr);
        } while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);

        return old_val;
}
EXPORT_SYMBOL(atomic64_xchg);

I'm testing the commit below which improves this loop and also 
removes __atomic64_read().

	Ingo

---------------->
>From 2f4f497dfb708daa52392db98b4bb3d6378be3d3 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 3 Jul 2009 19:56:36 +0200
Subject: [PATCH] x86: atomic64: Improve atomic64_xchg()

Remove the read-first logic from atomic64_xchg() and simplify
the loop.

This function was the last user of __atomic64_read() - remove it.

Also, change the 'real_val' assumption from the somewhat quirky
1ULL << 32 value to the (just as arbitrary, but simpler) value
of 0.

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
LKML-Reference: <tip-05118ab8859492ac9ddda0154cf90e37b0a4a0b0@git.kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/atomic_32.h |    9 ---------
 arch/x86/lib/atomic64_32.c       |   21 +++++++++++++++------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index aa045de..d7c8849 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -268,15 +268,6 @@ typedef struct {
 
 #define ATOMIC64_INIT(val)	{ (val) }
 
-/**
- * atomic64_read - read atomic64 variable
- * @ptr: pointer of type atomic64_t
- *
- * Atomically reads the value of @v.
- * Doesn't imply a read memory barrier.
- */
-#define __atomic64_read(ptr)		((ptr)->counter)
-
 extern u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val);
 
 /**
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index aab898c..0fac67b 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -31,14 +31,23 @@ EXPORT_SYMBOL(atomic64_cmpxchg);
  * Atomically xchgs the value of @ptr to @new_val and returns
  * the old value.
  */
-
 u64 atomic64_xchg(atomic64_t *ptr, u64 new_val)
 {
-	u64 old_val;
+	/*
+	 * Try first with a (possibly incorrect) assumption about
+	 * what we have there. We'll do two loops most likely,
+	 * but we'll get an ownership MESI transaction straight away
+	 * instead of a read transaction followed by a
+	 * flush-for-ownership transaction:
+	 */
+	u64 old_val, real_val = 0;
 
 	do {
-		old_val = __atomic64_read(ptr);
-	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+		old_val = real_val;
+
+		real_val = atomic64_cmpxchg(ptr, old_val, new_val);
+
+	} while (real_val != old_val);
 
 	return old_val;
 }
@@ -89,13 +98,13 @@ EXPORT_SYMBOL(atomic64_read);
 noinline u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
 {
 	/*
-	 * Try first with a (probably incorrect) assumption about
+	 * Try first with a (possibly incorrect) assumption about
 	 * what we have there. We'll do two loops most likely,
 	 * but we'll get an ownership MESI transaction straight away
 	 * instead of a read transaction followed by a
 	 * flush-for-ownership transaction:
 	 */
-	u64 old_val, new_val, real_val = 1ULL << 32;
+	u64 old_val, new_val, real_val = 0;
 
 	do {
 		old_val = real_val;
