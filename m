Return-Path: <linux-kernel-owner+w=401wt.eu-S947188AbXHMOmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947188AbXHMOmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944357AbXHMLox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:44:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S944324AbXHMLov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:44:51 -0400
Date: Mon, 13 Aug 2007 07:44:38 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH 22/23] make atomic_read() and atomic_set() behavior consistent on x86_64
Message-ID: <20070813114438.GV24018@shell.boston.redhat.com>
References: <46C03885.7000109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C03885.7000109@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Use volatile consistently in atomic.h on x86_64.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc3-orig/include/asm-x86_64/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc3/include/asm-x86_64/atomic.h	2007-08-13 06:22:43.000000000 -0400
@@ -32,7 +32,10 @@ typedef struct { int counter; } atomic_t
  * 
  * Atomically reads the value of @v.
  */ 
-#define atomic_read(v)		((v)->counter)
+static __inline__ int atomic_read(atomic_t *v)
+{
+        return *(volatile int *)&v->counter;
+}
 
 /**
  * atomic_set - set atomic variable
@@ -41,7 +44,10 @@ typedef struct { int counter; } atomic_t
  * 
  * Atomically sets the value of @v to @i.
  */ 
-#define atomic_set(v,i)		(((v)->counter) = (i))
+static __inline__ void atomic_set(atomic_t *v, int i)
+{
+        *(volatile int *)&v->counter = i;
+}
 
 /**
  * atomic_add - add integer to atomic variable
@@ -206,7 +212,7 @@ static __inline__ int atomic_sub_return(
 
 /* An 64bit atomic type */
 
-typedef struct { volatile long counter; } atomic64_t;
+typedef struct { long counter; } atomic64_t;
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
@@ -217,7 +223,10 @@ typedef struct { volatile long counter; 
  * Atomically reads the value of @v.
  * Doesn't imply a read memory barrier.
  */
-#define atomic64_read(v)		((v)->counter)
+static __inline__ long atomic64_read(atomic64_t *v)
+{
+        return *(volatile long *)&v->counter;
+}
 
 /**
  * atomic64_set - set atomic64 variable
@@ -226,7 +235,10 @@ typedef struct { volatile long counter; 
  *
  * Atomically sets the value of @v to @i.
  */
-#define atomic64_set(v,i)		(((v)->counter) = (i))
+static __inline__ void atomic64_set(atomic64_t *v, long i)
+{
+        *(volatile long *)&v->counter = i;
+}
 
 /**
  * atomic64_add - add integer to atomic64 variable
