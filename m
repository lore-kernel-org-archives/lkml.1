Return-Path: <linux-kernel-owner+w=401wt.eu-S1030575AbXBOUCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030575AbXBOUCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030579AbXBOUCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:02:49 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:55113 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030575AbXBOUCs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:02:48 -0500
Date: Thu, 15 Feb 2007 15:02:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] local_t : powerpc extension - use long for powerpc32
Message-ID: <20070215200245.GF31359@Krystal>
References: <117122149548-git-send-email-mathieu.desnoyers@polymtl.ca> <11712214961955-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214225653.345aad29.akpm@linux-foundation.org> <20070215072024.GA9137@Krystal> <27EC3349-5FD8-47BD-B909-E1180B86AF40@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <27EC3349-5FD8-47BD-B909-E1180B86AF40@kernel.crashing.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 14:51:22 up 13 days,  9:59,  8 users,  load average: 1.23, 2.06, 1.77
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Kumar Gala (galak@kernel.crashing.org) wrote:
> is there a reason this isn't local_add_return(long a, local_t *l) on  
> ppc32?
> 
> (same comment for other functions)
> 
> - k

no, except that we use the code is taken from atomic.h and used an
int parameter. However, due to the semantics of local_t, we should
manipulate longs instead of ints, even if they are the same size on a
given architecture (ppc32 and mips32 are affectec by this).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-powerpc/local.h
+++ b/include/asm-powerpc/local.h
@@ -21,9 +21,9 @@ typedef struct
 
 #ifndef __powerpc64__
 
-static __inline__ int local_add_return(int a, local_t *l)
+static __inline__ long local_add_return(long a, local_t *l)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__(
 "1:	lwarx	%0,0,%2		# local_add_return\n\
@@ -40,9 +40,9 @@ static __inline__ int local_add_return(int a, local_t *l)
 
 #define local_add_negative(a, l)	(local_add_return((a), (l)) < 0)
 
-static __inline__ int local_sub_return(int a, local_t *l)
+static __inline__ long local_sub_return(long a, local_t *l)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__(
 "1:	lwarx	%0,0,%2		# local_sub_return\n\
@@ -57,9 +57,9 @@ static __inline__ int local_sub_return(int a, local_t *l)
 	return t;
 }
 
-static __inline__ int local_inc_return(local_t *l)
+static __inline__ long local_inc_return(local_t *l)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__(
 "1:	lwarx	%0,0,%1		# local_inc_return\n\
@@ -84,9 +84,9 @@ static __inline__ int local_inc_return(local_t *l)
  */
 #define local_inc_and_test(l) (local_inc_return(l) == 0)
 
-static __inline__ int local_dec_return(local_t *l)
+static __inline__ long local_dec_return(local_t *l)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__(
 "1:	lwarx	%0,0,%1		# local_dec_return\n\
@@ -114,9 +114,9 @@ static __inline__ int local_dec_return(local_t *l)
  * Atomically adds @a to @l, so long as it was not @u.
  * Returns non-zero if @l was not @u, and zero otherwise.
  */
-static __inline__ int local_add_unless(local_t *l, int a, int u)
+static __inline__ int local_add_unless(local_t *l, long a, long u)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__ (
 "1:	lwarx	%0,0,%1		# local_add_unless\n\
@@ -144,9 +144,9 @@ static __inline__ int local_add_unless(local_t *l, int a, int u)
  * Atomically test *l and decrement if it is greater than 0.
  * The function returns the old value of *l minus 1.
  */
-static __inline__ int local_dec_if_positive(local_t *l)
+static __inline__ long local_dec_if_positive(local_t *l)
 {
-	int t;
+	long t;
 
 	__asm__ __volatile__(
 "1:	lwarx	%0,0,%1		# local_dec_if_positive\n\
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
