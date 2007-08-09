Return-Path: <linux-kernel-owner+w=401wt.eu-S940661AbXHIOR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940661AbXHIOR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938502AbXHIORL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:17:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935895AbXHIORJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:17:09 -0400
Date: Thu, 9 Aug 2007 10:16:36 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: [PATCH 21/24] make atomic_read() behave consistently on v850
Message-ID: <20070809141636.GA18860@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Make atomic_read() volatile on v850.  This ensures that busy-waiting
for an interrupt handler to change an atomic_t won't get compiled to an
infinite loop, consistent with SMP architectures.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc2-orig/include/asm-v850/atomic.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc2/include/asm-v850/atomic.h	2007-08-09 07:50:15.000000000 -0400
@@ -27,7 +27,11 @@ typedef struct { int counter; } atomic_t
 
 #ifdef __KERNEL__
 
-#define atomic_read(v)		((v)->counter)
+/*
+ * Casting to volatile here minimizes the need for barriers,
+ * without having to declare the type itself as volatile.
+ */
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v,i)		(((v)->counter) = (i))
 
 static inline int atomic_add_return (int i, volatile atomic_t *v)
