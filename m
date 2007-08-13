Return-Path: <linux-kernel-owner+w=401wt.eu-S1750726AbXHMOID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750726AbXHMOID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943779AbXHMLGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:06:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965398AbXHMLGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:06:51 -0400
Date: Mon, 13 Aug 2007 07:06:39 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH 2/23] make atomic_read() and atomic_set() behavior consistent on alpha
Message-ID: <20070813110639.GB24018@shell.boston.redhat.com>
References: <46C03885.7000109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C03885.7000109@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Use volatile consistently in atomic.h on alpha.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc3-orig/include/asm-alpha/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc3/include/asm-alpha/atomic.h	2007-08-13 05:00:36.000000000 -0400
@@ -14,21 +14,35 @@
 
 
 /*
- * Counter is volatile to make sure gcc doesn't try to be clever
- * and move things around on us. We need to use _exactly_ the address
- * the user gave us, not some alias that contains the same information.
+ * Make sure gcc doesn't try to be clever and move things around
+ * on us. We need to use _exactly_ the address the user gave us,
+ * not some alias that contains the same information.
  */
-typedef struct { volatile int counter; } atomic_t;
-typedef struct { volatile long counter; } atomic64_t;
+typedef struct { int counter; } atomic_t;
+typedef struct { long counter; } atomic64_t;
 
 #define ATOMIC_INIT(i)		( (atomic_t) { (i) } )
 #define ATOMIC64_INIT(i)	( (atomic64_t) { (i) } )
 
-#define atomic_read(v)		((v)->counter + 0)
-#define atomic64_read(v)	((v)->counter + 0)
+static __inline__ int atomic_read(atomic_t *v)
+{
+	return *(volatile int *)&v->counter + 0;
+}
+
+static __inline__ long atomic64_read(atomic64_t *v)
+{
+	return *(volatile long *)&v->counter + 0;
+}
 
-#define atomic_set(v,i)		((v)->counter = (i))
-#define atomic64_set(v,i)	((v)->counter = (i))
+static __inline__ void atomic_set(atomic_t *v, int i)
+{
+	*(volatile int *)&v->counter = i;
+}
+
+static __inline__ void atomic64_set(atomic64_t *v, long i)
+{
+	*(volatile long *)&v->counter = i;
+}
 
 /*
  * To get proper branch prediction for the main line, we must branch
