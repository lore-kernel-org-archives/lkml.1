Return-Path: <linux-kernel-owner+w=401wt.eu-S946682AbXHMOWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946682AbXHMOWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965327AbXHMLXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:23:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939199AbXHMLXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:23:47 -0400
Date: Mon, 13 Aug 2007 07:23:34 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH 10/23] make atomic_read() and atomic_set() behavior consistent on ia64
Message-ID: <20070813112334.GJ24018@shell.boston.redhat.com>
References: <46C03885.7000109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C03885.7000109@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Use volatile consistently in atomic.h on ia64.
This will do weird things without Andreas Schwab's fix:
http://lkml.org/lkml/2007/8/10/410

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc3-orig/include/asm-ia64/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc3/include/asm-ia64/atomic.h	2007-08-13 05:38:27.000000000 -0400
@@ -19,19 +19,34 @@
 
 /*
  * On IA-64, counter must always be volatile to ensure that that the
- * memory accesses are ordered.
+ * memory accesses are ordered.  This must be enforced each time that
+ * counter is read or written.
  */
-typedef struct { volatile __s32 counter; } atomic_t;
-typedef struct { volatile __s64 counter; } atomic64_t;
+typedef struct { __s32 counter; } atomic_t;
+typedef struct { __s64 counter; } atomic64_t;
 
 #define ATOMIC_INIT(i)		((atomic_t) { (i) })
 #define ATOMIC64_INIT(i)	((atomic64_t) { (i) })
 
-#define atomic_read(v)		((v)->counter)
-#define atomic64_read(v)	((v)->counter)
+static inline __s32 atomic_read(atomic_t *v)
+{
+        return *(volatile __s32 *)&v->counter;
+}
+
+static inline void atomic_set(atomic_t *v, __s32 i)
+{
+        *(volatile __s32 *)&v->counter = i;
+}
 
-#define atomic_set(v,i)		(((v)->counter) = (i))
-#define atomic64_set(v,i)	(((v)->counter) = (i))
+static inline __s64 atomic64_read(atomic64_t *v)
+{
+        return *(volatile __s64 *)&v->counter;
+}
+
+static inline void atomic64_set(atomic64_t *v, __s64 i)
+{
+        *(volatile __s64 *)&v->counter = i;
+}
 
 static __inline__ int
 ia64_atomic_add (int i, atomic_t *v)
