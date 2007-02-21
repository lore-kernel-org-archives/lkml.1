Return-Path: <linux-kernel-owner+w=401wt.eu-S1751084AbXBUBnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084AbXBUBnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXBUBkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:40:01 -0500
Received: from ns2.suse.de ([195.135.220.15]:34698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbXBUBjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:39:54 -0500
Date: Tue, 20 Feb 2007 17:38:32 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@suse.de>
Subject: [patch 17/21] Use different constraint for gcc < 4.1 in bitops.
Message-ID: <20070221013832.GR30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="use-different-constraint-for-gcc-4.1-in-bitops.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

Use different constraint for gcc < 4.1 in bitops.h

+m is really correct for a RMW instruction, but some older gccs
error out. I finally gave in and ifdefed it.

This fixes compilation errors with some compiler version.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-x86_64/bitops.h |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- linux-2.6.19.4.orig/include/asm-x86_64/bitops.h
+++ linux-2.6.19.4/include/asm-x86_64/bitops.h
@@ -7,7 +7,13 @@
 
 #include <asm/alternative.h>
 
-#define ADDR (*(volatile long *) addr)
+#if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
+/* Technically wrong, but this avoids compilation errors on some gcc
+   versions. */
+#define ADDR "=m" (*(volatile long *) addr)
+#else
+#define ADDR "+m" (*(volatile long *) addr)
+#endif
 
 /**
  * set_bit - Atomically set a bit in memory
@@ -23,7 +29,7 @@ static __inline__ void set_bit(int nr, v
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %1,%0"
-		:"+m" (ADDR)
+		:ADDR
 		:"dIr" (nr) : "memory");
 }
 
@@ -40,7 +46,7 @@ static __inline__ void __set_bit(int nr,
 {
 	__asm__ volatile(
 		"btsl %1,%0"
-		:"+m" (ADDR)
+		:ADDR
 		:"dIr" (nr) : "memory");
 }
 
@@ -58,7 +64,7 @@ static __inline__ void clear_bit(int nr,
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %1,%0"
-		:"+m" (ADDR)
+		:ADDR
 		:"dIr" (nr));
 }
 
@@ -66,7 +72,7 @@ static __inline__ void __clear_bit(int n
 {
 	__asm__ __volatile__(
 		"btrl %1,%0"
-		:"+m" (ADDR)
+		:ADDR
 		:"dIr" (nr));
 }
 
@@ -86,7 +92,7 @@ static __inline__ void __change_bit(int 
 {
 	__asm__ __volatile__(
 		"btcl %1,%0"
-		:"+m" (ADDR)
+		:ADDR
 		:"dIr" (nr));
 }
 
@@ -103,7 +109,7 @@ static __inline__ void change_bit(int nr
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %1,%0"
-		:"+m" (ADDR)
+		:ADDR
 		:"dIr" (nr));
 }
 
@@ -121,7 +127,7 @@ static __inline__ int test_and_set_bit(i
 
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),ADDR
 		:"dIr" (nr) : "memory");
 	return oldbit;
 }
@@ -141,7 +147,7 @@ static __inline__ int __test_and_set_bit
 
 	__asm__(
 		"btsl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),ADDR
 		:"dIr" (nr));
 	return oldbit;
 }
@@ -160,7 +166,7 @@ static __inline__ int test_and_clear_bit
 
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),ADDR
 		:"dIr" (nr) : "memory");
 	return oldbit;
 }
@@ -180,7 +186,7 @@ static __inline__ int __test_and_clear_b
 
 	__asm__(
 		"btrl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),ADDR
 		:"dIr" (nr));
 	return oldbit;
 }
@@ -192,7 +198,7 @@ static __inline__ int __test_and_change_
 
 	__asm__ __volatile__(
 		"btcl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),ADDR
 		:"dIr" (nr) : "memory");
 	return oldbit;
 }
@@ -211,7 +217,7 @@ static __inline__ int test_and_change_bi
 
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),ADDR
 		:"dIr" (nr) : "memory");
 	return oldbit;
 }
@@ -237,7 +243,7 @@ static __inline__ int variable_test_bit(
 	__asm__ __volatile__(
 		"btl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit)
-		:"m" (ADDR),"dIr" (nr));
+		:"m" (*(volatile long *)addr),"dIr" (nr));
 	return oldbit;
 }
 

--
