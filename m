Return-Path: <linux-kernel-owner+w=401wt.eu-S1764063AbXGWQHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764063AbXGWQHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763361AbXGWQEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:04:46 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:48715 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763295AbXGWQEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:04:45 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2007 21:36:03 +0530
Message-Id: <20070723160603.22137.16516.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH 7/8] i386: bitops: Kill needless usage of __asm__ __volatile__
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[7/8] i386: bitops: Kill needless usage of __asm__ __volatile__

Another oddity I noticed in this file. The semantics of __volatile__
when used to qualify inline __asm__ are that the compiler will not
(1) elid, or, (2) reorder, or, (3) intersperse, our inline asm with
the rest of the generated code.

However, we do not want these guarantees in the unlocked variants of the
bitops functions. Also, note that test_bit() is *always* an unlocked
operation on i386 -- the i386 instruction set disallows the use of the LOCK
prefix with the "btl" instruction anyway, and the CPU will throw an invalid
opcode exception otherwise. Hence, every caller of variable_test_bit() must
have all the required locking implemented at a higher-level anyway and this
operation would necessarily be guarantee-less.

So let's remove the __volatile__ qualification of the inline asm in the
variable_test_bit() function also -- and let's give the compiler a chance
to optimize / combine multiple bitops, if possible.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>

---

 include/asm-i386/bitops.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
index f37b8a2..4f1fda5 100644
--- a/include/asm-i386/bitops.h
+++ b/include/asm-i386/bitops.h
@@ -96,7 +96,7 @@ static inline void clear_bit(int nr, unsigned long *addr)
  */
 static inline void __clear_bit(int nr, unsigned long *addr)
 {
-	__asm__ __volatile__(
+	__asm__(
 		"btrl %1,%0"
 		:"=m" (*addr)
 		:"r" (nr));
@@ -123,7 +123,7 @@ static inline void __clear_bit(int nr, unsigned long *addr)
  */
 static inline void __change_bit(int nr, unsigned long *addr)
 {
-	__asm__ __volatile__(
+	__asm__(
 		"btcl %1,%0"
 		:"=m" (*addr)
 		:"r" (nr));
@@ -251,7 +251,7 @@ static inline int __test_and_change_bit(int nr, unsigned long *addr)
 {
 	int oldbit;
 
-	__asm__ __volatile__(
+	__asm__(
 		"btcl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"=m" (*addr)
 		:"r" (nr));
@@ -297,7 +297,7 @@ static inline int variable_test_bit(int nr, const unsigned long *addr)
 {
 	int oldbit;
 
-	__asm__ __volatile__(
+	__asm__(
 		"btl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit)
 		:"m" (*addr),"r" (nr));
