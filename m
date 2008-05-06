Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYEFMCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYEFMCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYEFMC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:02:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYEFMC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:02:27 -0400
Date: Tue, 6 May 2008 14:01:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Please revert 709f744 (x86: bitops asm constraint fixes)
Message-ID: <20080506120155.GG32591@elte.hu>
References: <1209995129.5172.19.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1209995129.5172.19.camel@odie.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Simon Holm Thøgersen <odie@cs.aau.dk> wrote:

> [CC'ing all that commented on the patch on LKML]
> 
> 709f744 causes my computer to freeze during the start up of X and my 
> login manger (GDM). It gets to the point where it has shown the 
> default X mouse cursor logo (a big X / cross) and does not respond to 
> anything from that point on.
> 
> This worked fine before 709f744, and it works fine with ﻿709f744 
> reverted on top of Linus' current tree (f74d505). The revert had 
> conflicts, as far as I can tell due to white space changes. The diff I 
> ended up with is below.
> 
> It is 100% reproducible.

thanks Simon for tracking this down.

I've applied your revert (see the patch below), we'll do it unless the 
real bug is found and confirmed by you. What exact compiler version are 
you using to build the kernel?

Jan, any ideas what's wrong with your commit?

	Ingo

------------->
Subject: revert commit 709f744 ("x86: bitops asm constraint fixes")
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Date: Mon, 05 May 2008 15:45:28 +0200

709f744 causes my computer to freeze during the start up of X and my
login manger (GDM). It gets to the point where it has shown the default
X mouse cursor logo (a big X / cross) and does not respond to anything
from that point on.

This worked fine before 709f744, and it works fine with ﻿709f744
reverted on top of Linus' current tree (f74d505). The revert had
conflicts, as far as I can tell due to white space changes. The diff I
ended up with is below.

It is 100% reproducible.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/bitops.h |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

Index: linux-x86.q/include/asm-x86/bitops.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/bitops.h
+++ linux-x86.q/include/asm-x86/bitops.h
@@ -23,13 +23,10 @@
 #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
 /* Technically wrong, but this avoids compilation errors on some gcc
    versions. */
-#define ADDR "=m" (*(volatile long *)addr)
-#define BIT_ADDR "=m" (((volatile int *)addr)[nr >> 5])
+#define ADDR "=m" (*(volatile long *) addr)
 #else
 #define ADDR "+m" (*(volatile long *) addr)
-#define BIT_ADDR "+m" (((volatile int *)addr)[nr >> 5])
 #endif
-#define BASE_ADDR "m" (*(volatile int *)addr)
 
 /**
  * set_bit - Atomically set a bit in memory
@@ -77,7 +74,7 @@ static inline void __set_bit(int nr, vol
  */
 static inline void clear_bit(int nr, volatile void *addr)
 {
-	asm volatile(LOCK_PREFIX "btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm volatile(LOCK_PREFIX "btr %1,%0" : ADDR : "Ir" (nr));
 }
 
 /*
@@ -96,7 +93,7 @@ static inline void clear_bit_unlock(unsi
 
 static inline void __clear_bit(int nr, volatile void *addr)
 {
-	asm volatile("btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
 }
 
 /*
@@ -131,7 +128,7 @@ static inline void __clear_bit_unlock(un
  */
 static inline void __change_bit(int nr, volatile void *addr)
 {
-	asm volatile("btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
 }
 
 /**
@@ -145,7 +142,7 @@ static inline void __change_bit(int nr, 
  */
 static inline void change_bit(int nr, volatile void *addr)
 {
-	asm volatile(LOCK_PREFIX "btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm volatile(LOCK_PREFIX "btc %1,%0" : ADDR : "Ir" (nr));
 }
 
 /**
@@ -191,9 +188,10 @@ static inline int __test_and_set_bit(int
 {
 	int oldbit;
 
-	asm volatile("bts %2,%3\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+	asm("bts %2,%1\n\t"
+	    "sbb %0,%0"
+	    : "=r" (oldbit), ADDR
+	    : "Ir" (nr));
 	return oldbit;
 }
 
@@ -229,9 +227,10 @@ static inline int __test_and_clear_bit(i
 {
 	int oldbit;
 
-	asm volatile("btr %2,%3\n\t"
+	asm volatile("btr %2,%1\n\t"
 		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+		     : "=r" (oldbit), ADDR
+		     : "Ir" (nr));
 	return oldbit;
 }
 
@@ -240,9 +239,10 @@ static inline int __test_and_change_bit(
 {
 	int oldbit;
 
-	asm volatile("btc %2,%3\n\t"
+	asm volatile("btc %2,%1\n\t"
 		     "sbb %0,%0"
-		     : "=r" (oldbit), BIT_ADDR : "Ir" (nr), BASE_ADDR);
+		     : "=r" (oldbit), ADDR
+		     : "Ir" (nr) : "memory");
 
 	return oldbit;
 }
@@ -276,11 +276,10 @@ static inline int variable_test_bit(int 
 {
 	int oldbit;
 
-	asm volatile("bt %2,%3\n\t"
+	asm volatile("bt %2,%1\n\t"
 		     "sbb %0,%0"
 		     : "=r" (oldbit)
-		     : "m" (((volatile const int *)addr)[nr >> 5]),
-		       "Ir" (nr), BASE_ADDR);
+		     : "m" (*(unsigned long *)addr), "Ir" (nr));
 
 	return oldbit;
 }
@@ -397,8 +396,6 @@ static inline int fls(int x)
 }
 #endif /* __KERNEL__ */
 
-#undef BASE_ADDR
-#undef BIT_ADDR
 #undef ADDR
 
 static inline void set_bit_string(unsigned long *bitmap,
