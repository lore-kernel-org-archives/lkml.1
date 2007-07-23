Return-Path: <linux-kernel-owner+w=401wt.eu-S1763937AbXGWQGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763937AbXGWQGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760200AbXGWQEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:04:41 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:48708 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763077AbXGWQEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:04:40 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2007 21:35:58 +0530
Message-Id: <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[6/8] i386: bitops: Don't mark memory as clobbered unnecessarily

The goal is to let gcc generate good, beautiful, optimized code.

But test_and_set_bit, test_and_clear_bit, __test_and_change_bit,
and test_and_change_bit unnecessarily mark all of memory as clobbered,
thereby preventing gcc from doing perfectly valid optimizations.

The case of __test_and_change_bit() is particularly surprising, given
that it's a variant where we don't make any guarantees at all.

Even for the other three cases, the (only) instruction that accesses
shared memory is btsl/btrl/btcl and requires locking and atomicity.
But we handle that properly already by the use of the lock prefix.
Also, "=m" is already specified in the output operands of the asm
for the passed bit-string pointer, so the gcc optimizer knows what
to do and what not to do anyway.

So there's no point clobbering all of memory in these functions.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>

---

 include/asm-i386/bitops.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
index 0f5634b..f37b8a2 100644
--- a/include/asm-i386/bitops.h
+++ b/include/asm-i386/bitops.h
@@ -164,7 +164,7 @@ static inline int test_and_set_bit(int nr, unsigned long *addr)
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"=m" (*addr)
-		:"r" (nr) : "memory");
+		:"r" (nr));
 	return oldbit;
 }
 
@@ -208,7 +208,7 @@ static inline int test_and_clear_bit(int nr, unsigned long *addr)
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"=m" (*addr)
-		:"r" (nr) : "memory");
+		:"r" (nr));
 	return oldbit;
 }
 
@@ -254,7 +254,7 @@ static inline int __test_and_change_bit(int nr, unsigned long *addr)
 	__asm__ __volatile__(
 		"btcl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"=m" (*addr)
-		:"r" (nr) : "memory");
+		:"r" (nr));
 	return oldbit;
 }
 
@@ -275,7 +275,7 @@ static inline int test_and_change_bit(int nr, unsigned long *addr)
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"=m" (*addr)
-		:"r" (nr) : "memory");
+		:"r" (nr));
 	return oldbit;
 }
 
