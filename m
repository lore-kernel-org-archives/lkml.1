Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYDNNa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYDNNa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYDNNat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:30:49 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:18449 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYDNNat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:30:49 -0400
Message-Id: <480378CC.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 14 Apr 2008 14:31:24 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [RFC] x86: bitops asm constraint fixes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 27.03.08 09:41 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> Please revert it for the time being, I've got a better version (i.e. 
>> without extra dead code being generated) that I intended to submit 
>> once I know whether the other issues pointed out in the description on 
>> the original patch also should be adjusted. Of course, that could also 
>> be done incrementally, but I would think overhauling the whole file at 
>> once wouldn't be a bad thing...
>
>since it appears to cause no problems in x86.git (it passed a lot of 
>testing already) i'd prefer to keep it (so that we can see any other 
>side-effects of touching this code) - could you send your improvements 
>as a delta against x86.git/latest? [or is there any outright bug caused 
>by your changes that necessiates a revert?]

(Sorry, need to resend, previous version was lacking a refresh.)

For those bitops that don't have a memory clobber, make the asm
constraints more precise. It still remains questionable whether the
inconsistencies in the use of memory clobbers shouldn't be addressed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- x86.git/include/asm-x86/bitops.h
+++ x86.git/include/asm-x86/bitops.h
@@ -20,16 +20,20 @@
  * bit 0 is the LSB of addr; bit 32 is the LSB of (addr+1).
  */
 
+struct __bits { int _[1UL << (32 - 3 - sizeof(int))]; };
+
 #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
 /* Technically wrong, but this avoids compilation errors on some gcc
    versions. */
-#define ADDR "=m" (*(volatile long *)addr)
-#define BIT_ADDR "=m" (((volatile int *)addr)[nr >> 5])
+#define ADDR "=m" (*(volatile long *) addr)
+#define BIT_ADDR "=m" (((volatile int *) addr)[nr >> 5])
+#define FULL_ADDR "=m" (*(volatile struct __bits *) addr)
 #else
 #define ADDR "+m" (*(volatile long *) addr)
-#define BIT_ADDR "+m" (((volatile int *)addr)[nr >> 5])
+#define BIT_ADDR "+m" (((volatile int *) addr)[nr >> 5])
+#define FULL_ADDR "+m" (*(volatile struct __bits *) addr)
 #endif
-#define BASE_ADDR "m" (*(volatile int *)addr)
+#define BASE_ADDR "m" (*(volatile int *) addr)
 
 /**
  * set_bit - Atomically set a bit in memory
@@ -62,7 +68,10 @@ static inline void set_bit(int nr, volat
  */
 static inline void __set_bit(int nr, volatile void *addr)
 {
-	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
+	if (__builtin_constant_p(nr))
+		asm volatile("bts %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	else
+		asm volatile("bts %1,%0" : FULL_ADDR : "r" (nr));
 }
 
 /**
@@ -77,7 +87,11 @@ static inline void __set_bit(int nr, vol
  */
 static inline void clear_bit(int nr, volatile void *addr)
 {
-	asm volatile(LOCK_PREFIX "btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	if (__builtin_constant_p(nr))
+		asm volatile(LOCK_PREFIX "btr %1,%2"
+			     : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	else
+		asm volatile(LOCK_PREFIX "btr %1,%0" : FULL_ADDR : "r" (nr));
 }
 
 /*
@@ -96,7 +110,10 @@ static inline void clear_bit_unlock(unsi
 
 static inline void __clear_bit(int nr, volatile void *addr)
 {
-	asm volatile("btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	if (__builtin_constant_p(nr))
+		asm volatile("btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	else
+		asm volatile("btr %1,%0" : FULL_ADDR : "r" (nr));
 }
 
 /*
@@ -131,7 +148,10 @@ static inline void __clear_bit_unlock(un
  */
 static inline void __change_bit(int nr, volatile void *addr)
 {
-	asm volatile("btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	if (__builtin_constant_p(nr))
+		asm volatile("btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	else
+		asm volatile("btc %1,%0" : FULL_ADDR : "r" (nr));
 }
 
 /**
@@ -145,7 +165,11 @@ static inline void __change_bit(int nr, 
  */
 static inline void change_bit(int nr, volatile void *addr)
 {
-	asm volatile(LOCK_PREFIX "btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	if (__builtin_constant_p(nr))
+		asm volatile(LOCK_PREFIX "btc %1,%2"
+			     : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	else
+		asm volatile(LOCK_PREFIX "btc %1,%0" : FULL_ADDR : "r" (nr));
 }
 
 /**
@@ -191,9 +217,15 @@ static inline int __test_and_set_bit(int
 {
 	int oldbit;
 
-	asm volatile("bts %2,%3\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	if (__builtin_constant_p(nr))
+		asm volatile("bts %2,%3\n\t"
+			     "sbb %0,%0"
+			     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	else
+		asm volatile("bts %2,%1\n\t"
+			     "sbb %0,%0"
+			     : "=r" (oldbit), FULL_ADDR : "r" (nr));
+
 	return oldbit;
 }
 
@@ -229,9 +262,15 @@ static inline int __test_and_clear_bit(i
 {
 	int oldbit;
 
-	asm volatile("btr %2,%3\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	if (__builtin_constant_p(nr))
+		asm volatile("btr %2,%3\n\t"
+			     "sbb %0,%0"
+			     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	else
+		asm volatile("btr %2,%1\n\t"
+			     "sbb %0,%0"
+			     : "=r" (oldbit), FULL_ADDR : "r" (nr));
+
 	return oldbit;
 }
 
@@ -240,9 +279,14 @@ static inline int __test_and_change_bit(
 {
 	int oldbit;
 
-	asm volatile("btc %2,%3\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	if (__builtin_constant_p(nr))
+		asm volatile("btc %2,%3\n\t"
+			     "sbb %0,%0"
+			     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	else
+		asm volatile("btc %2,%1\n\t"
+			     "sbb %0,%0"
+			     : "=r" (oldbit), FULL_ADDR : "r" (nr));
 
 	return oldbit;
 }
@@ -276,11 +321,10 @@ static inline int variable_test_bit(int 
 {
 	int oldbit;
 
-	asm volatile("bt %2,%3\n\t"
+	asm volatile("bt %2,%1\n\t"
 		     "sbb %0,%0"
 		     : "=r" (oldbit)
-		     : "m" (((volatile const int *)addr)[nr >> 5]),
-		       "Ir" (nr), BASE_ADDR);
+		     : "m" (*(volatile struct __bits *) addr), "Ir" (nr));
 
 	return oldbit;
 }
@@ -398,6 +431,7 @@ static int test_bit(int nr, const volati
 #endif /* __KERNEL__ */
 
 #undef BASE_ADDR
+#undef FULL_ADDR
 #undef BIT_ADDR
 #undef ADDR
 


