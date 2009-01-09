Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbZAIU6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbZAIU6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbZAIU5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:57:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39465 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbZAIU44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:56:56 -0500
Date: Fri, 9 Jan 2009 21:56:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090109205628.GA18871@elte.hu>
References: <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109204103.GA17212@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Note that meanwhile i also figured out why gcc got the inlining wrong 
> there: the 'int nr' combined with the '% BITS_PER_LONG' signed 
> arithmetics was too much for it to figure out at the inlining stage - it 
> generated IDIV instructions, etc. With forced inlining later 
> optimization stages managed to prove that the expression can be 
> simplified.
> 
> The second patch below that changes 'int nr' to 'unsigned nr' solves 
> that problem, without the need to mark the function __always_inline.

The patch below that changes all the 'int nr' arguments to 'unsigned int 
nr' in bitops.h and gives us a 0.3% size win (and all the right inlining 
behavior) on x86 defconfig:

    text	   data	    bss	    dec	    hex	filename
 6813470	1453188	 801096	9067754	 8a5cea	vmlinux.before
 6792602	1453188	 801096	9046886	 8a0b66	vmlinux.after

i checked other architectures and i can see many cases where the bitops 
'nr' parameter is defined as unsigned - maybe they noticed this.

This change makes some sense anyway as a cleanup: a negative 'nr' bitop 
argument does not make much sense IMO.

	Ingo

---
 arch/x86/include/asm/bitops.h |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

Index: linux/arch/x86/include/asm/bitops.h
===================================================================
--- linux.orig/arch/x86/include/asm/bitops.h
+++ linux/arch/x86/include/asm/bitops.h
@@ -75,7 +75,7 @@ static inline void set_bit(unsigned int 
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __set_bit(int nr, volatile unsigned long *addr)
+static inline void __set_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
@@ -90,7 +90,7 @@ static inline void __set_bit(int nr, vol
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static inline void clear_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -117,7 +117,7 @@ static inline void clear_bit_unlock(unsi
 	clear_bit(nr, addr);
 }
 
-static inline void __clear_bit(int nr, volatile unsigned long *addr)
+static inline void __clear_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
 }
@@ -152,7 +152,7 @@ static inline void __clear_bit_unlock(un
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile unsigned long *addr)
+static inline void __change_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
 }
@@ -166,7 +166,7 @@ static inline void __change_bit(int nr, 
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile unsigned long *addr)
+static inline void change_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "xorb %1,%0"
@@ -187,7 +187,7 @@ static inline void change_bit(int nr, vo
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_set_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -204,7 +204,7 @@ static inline int test_and_set_bit(int n
  *
  * This is the same as test_and_set_bit on x86.
  */
-static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+static inline int test_and_set_bit_lock(unsigned int nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -218,7 +218,7 @@ static inline int test_and_set_bit_lock(
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_set_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -237,7 +237,7 @@ static inline int __test_and_set_bit(int
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_clear_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -257,7 +257,7 @@ static inline int test_and_clear_bit(int
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_clear_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -269,7 +269,7 @@ static inline int __test_and_clear_bit(i
 }
 
 /* WARNING: non atomic and it can be reordered! */
-static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_change_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -289,7 +289,7 @@ static inline int __test_and_change_bit(
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_change_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -300,13 +300,14 @@ static inline int test_and_change_bit(in
 	return oldbit;
 }
 
-static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
+static inline int
+constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
 }
 
-static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
+static inline int variable_test_bit(unsigned int nr, volatile const unsigned long *addr)
 {
 	int oldbit;
 
@@ -324,7 +325,7 @@ static inline int variable_test_bit(int 
  * @nr: bit number to test
  * @addr: Address to start counting from
  */
-static int test_bit(int nr, const volatile unsigned long *addr);
+static int test_bit(unsigned int nr, const volatile unsigned long *addr);
 #endif
 
 #define test_bit(nr, addr)			\
