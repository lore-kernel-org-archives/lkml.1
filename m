Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZGCMCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZGCMCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZGCMCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:02:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbZGCMCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:02:07 -0400
Date: Fri, 3 Jul 2009 14:01:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Howells <dhowells@redhat.com>,
       akpm@linux-foundation.org, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: [patch] x86: atomic64_t: Improve atomic64_add_return()
Message-ID: <20090703120159.GB7161@elte.hu>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com> <alpine.LFD.2.01.0907021419560.3210@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907021419560.3210@localhost.localdomain>
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

> On Thu, 2 Jul 2009, Eric Dumazet wrote:
> > 
> > Using a fixed initial value (instead of __atomic64_read()) is even faster, 
> > it apparently permits cpu to use an appropriate bus transaction.
> 
> Yeah, I guess it does a "read-for-write-ownership" and allows the 
> thing to be done as a single cache transaction.
> 
> If we read it first, it will first get the cacheline for 
> shared-read, and then the cmpxchg8b will need to turn it from 
> shared to exclusive.
> 
> Of course, the _optimal_ situation would be if the cmpxchg8b 
> didn't actually do the write at all when the value matches (and 
> all cores could just keep it shared), but I guess that's not going 
> to happen.
> 
> Too bad there is no pure 8-byte read op. Using MMX has too many 
> downsides.
> 
> Btw, your numbers imply that for the atomic64_add_return(), we 
> really would be much better off not reading the original value at 
> all. Again, in that case, we really do want the 
> "read-for-write-ownership" cache transaction, not a read.

Something like the patch below?

Please review it carefully, as the perfcounter exposure to the 
conditional-arithmetics atomic64_t APIs is very low:

  earth4:~/tip> for N in $(git grep atomic64_ | grep perf_ |
    sed 's/(/ /g'); do echo $N; done | grep ^atomic64_ | sort | uniq -c | sort -n

      1 atomic64_add_negative
      1 atomic64_inc_return
      2 atomic64_xchg
      3 atomic64_cmpxchg
      3 atomic64_sub
      7 atomic64_t
     11 atomic64_add
     21 atomic64_set
     22 atomic64_read

So while i have tested it on a 32-bit box, it's only lightly tested 
(and possibly broken) due to the low exposure of the API.

Thanks,

	Ingo

----------------------->
Subject: x86: atomic64_t: Improve atomic64_add_return()
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Jul 03 12:39:07 CEST 2009

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
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: linux/arch/x86/lib/atomic64_32.c
===================================================================
--- linux.orig/arch/x86/lib/atomic64_32.c
+++ linux/arch/x86/lib/atomic64_32.c
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
