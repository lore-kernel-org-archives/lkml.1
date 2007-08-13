Return-Path: <linux-kernel-owner+w=401wt.eu-S946838AbXHMObJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946838AbXHMObJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942054AbXHMLas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:30:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S944498AbXHMLao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:30:44 -0400
Date: Mon, 13 Aug 2007 07:29:33 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH 14/23] make atomic_read() and atomic_set() behavior consistent on mips
Message-ID: <20070813112933.GN24018@shell.boston.redhat.com>
References: <46C03885.7000109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C03885.7000109@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Use volatile consistently in atomic.h on mips.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc3-orig/include/asm-mips/atomic.h	2007-08-13 03:14:13.000000000 -0400
+++ linux-2.6.23-rc3/include/asm-mips/atomic.h	2007-08-13 05:52:14.000000000 -0400
@@ -20,7 +20,7 @@
 #include <asm/war.h>
 #include <asm/system.h>
 
-typedef struct { volatile int counter; } atomic_t;
+typedef struct { int counter; } atomic_t;
 
 #define ATOMIC_INIT(i)    { (i) }
 
@@ -30,7 +30,10 @@ typedef struct { volatile int counter; }
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		((v)->counter)
+static __inline__ int atomic_read(atomic_t *v)
+{
+        return *(volatile int *)&v->counter;
+}
 
 /*
  * atomic_set - set atomic variable
@@ -39,7 +42,10 @@ typedef struct { volatile int counter; }
  *
  * Atomically sets the value of @v to @i.
  */
-#define atomic_set(v,i)		((v)->counter = (i))
+static __inline__ void atomic_set(atomic_t *v, int i)
+{
+        *(volatile int *)&v->counter = i;
+}
 
 /*
  * atomic_add - add integer to atomic variable
@@ -404,7 +410,7 @@ static __inline__ int atomic_add_unless(
 
 #ifdef CONFIG_64BIT
 
-typedef struct { volatile long counter; } atomic64_t;
+typedef struct { long counter; } atomic64_t;
 
 #define ATOMIC64_INIT(i)    { (i) }
 
@@ -413,14 +419,20 @@ typedef struct { volatile long counter; 
  * @v: pointer of type atomic64_t
  *
  */
-#define atomic64_read(v)	((v)->counter)
+static __inline__ long atomic64_read(atomic64_t *v)
+{
+        return *(volatile long *)&v->counter;
+}
 
 /*
  * atomic64_set - set atomic variable
  * @v: pointer of type atomic64_t
  * @i: required value
  */
-#define atomic64_set(v,i)	((v)->counter = (i))
+static __inline__ void atomic64_set(atomic64_t *v, long i)
+{
+        *(volatile long *)&v->counter = i;
+}
 
 /*
  * atomic64_add - add integer to atomic variable
