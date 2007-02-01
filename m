Return-Path: <linux-kernel-owner+w=401wt.eu-S1422700AbXBAJQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422700AbXBAJQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 04:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030520AbXBAJQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 04:16:13 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:64253 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030569AbXBAJQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 04:16:10 -0500
Date: Thu, 1 Feb 2007 01:15:55 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: i386 and x86-64 bitops function prototypes differ
Message-ID: <20070201091555.GA32377@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070126143555.GL11525@frankl.hpl.hp.com> <45BA3F42.3020006@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA3F42.3020006@zytor.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 26, 2007 at 09:49:54AM -0800, H. Peter Anvin wrote:
> >
> >I ran into compiler warnings with the perfmon code when I tried
> >using test() and __set_bit() on i386. 
> >
> >For some reason, the i386 bitops functions use unsigned long * for
> >the address whereas x86-64/ia64 use void *.
> >
> >I do not quite understand why such difference?
> >Is this just for historical reasons?
> >
> >Thanks.
> >
> 
> Arguably void * is the right thing for a littleendian architecture.  For 
> bigendian architectures it unfortunately matters what the chunk size is, 
> regardless of if the chunks are numbered in bigendian (reverse) or 
> littleendian (forward) order.
> 

I agree with you, but i386 is definitively little endian, so here is a patch
against 2.6.20-rc6-mm3 to make x86-64 and i386 have the same prototypes for
bit manipulation routines.

changelog:
	- change all bit manipulation inline routine to use void * as their
	  address argument instead of unsigned long *. Match x86-64

signed-off-by: stephane eranian <eranian@hpl.hp.com>

--- linux-2.6.20-rc6-mm3.orig/include/asm-i386/bitops.h	2007-01-31 09:24:21.000000000 -0800
+++ linux-2.6.20-rc6-mm3.base/include/asm-i386/bitops.h	2007-01-31 09:31:46.000000000 -0800
@@ -33,7 +33,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(int nr, volatile unsigned long * addr)
+static inline void set_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %1,%0"
@@ -50,7 +50,7 @@ static inline void set_bit(int nr, volat
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __set_bit(int nr, volatile unsigned long * addr)
+static inline void __set_bit(int nr, volatile void * addr)
 {
 	__asm__(
 		"btsl %1,%0"
@@ -68,7 +68,7 @@ static inline void __set_bit(int nr, vol
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile unsigned long * addr)
+static inline void clear_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %1,%0"
@@ -76,7 +76,7 @@ static inline void clear_bit(int nr, vol
 		:"Ir" (nr));
 }
 
-static inline void __clear_bit(int nr, volatile unsigned long * addr)
+static inline void __clear_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__(
 		"btrl %1,%0"
@@ -95,7 +95,7 @@ static inline void __clear_bit(int nr, v
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile unsigned long * addr)
+static inline void __change_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__(
 		"btcl %1,%0"
@@ -113,7 +113,7 @@ static inline void __change_bit(int nr, 
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile unsigned long * addr)
+static inline void change_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %1,%0"
@@ -130,7 +130,7 @@ static inline void change_bit(int nr, vo
  * It may be reordered on other architectures than x86.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile unsigned long * addr)
+static inline int test_and_set_bit(int nr, volatile void * addr)
 {
 	int oldbit;
 
@@ -150,7 +150,7 @@ static inline int test_and_set_bit(int n
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile unsigned long * addr)
+static inline int __test_and_set_bit(int nr, volatile void * addr)
 {
 	int oldbit;
 
@@ -170,7 +170,7 @@ static inline int __test_and_set_bit(int
  * It can be reorderdered on other architectures other than x86.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile unsigned long * addr)
+static inline int test_and_clear_bit(int nr, volatile void * addr)
 {
 	int oldbit;
 
@@ -190,7 +190,7 @@ static inline int test_and_clear_bit(int
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_clear_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -202,7 +202,7 @@ static inline int __test_and_clear_bit(i
 }
 
 /* WARNING: non atomic and it can be reordered! */
-static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_change_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -221,7 +221,7 @@ static inline int __test_and_change_bit(
  * This operation is atomic and cannot be reordered.  
  * It also implies a memory barrier.
  */
-static inline int test_and_change_bit(int nr, volatile unsigned long* addr)
+static inline int test_and_change_bit(int nr, volatile void * addr)
 {
 	int oldbit;
 
@@ -241,12 +241,12 @@ static inline int test_and_change_bit(in
 static int test_bit(int nr, const volatile void * addr);
 #endif
 
-static __always_inline int constant_test_bit(int nr, const volatile unsigned long *addr)
+static __always_inline int constant_test_bit(int nr, const volatile void * addr)
 {
-	return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
+	return ((1UL << (nr & 31)) & (((const volatile unsigned int *) addr)[nr >> 5])) != 0;
 }
 
-static inline int variable_test_bit(int nr, const volatile unsigned long * addr)
+static inline int variable_test_bit(int nr, const volatile void * addr)
 {
 	int oldbit;
 
