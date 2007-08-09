Return-Path: <linux-kernel-owner+w=401wt.eu-S939856AbXHIOZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939856AbXHIOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964983AbXHIOZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:25:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936719AbXHIOZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:25:06 -0400
Date: Thu, 9 Aug 2007 10:24:30 -0400
From: Chris Snook <csnook@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: [PATCH 24/24] document volatile atomic_read() behavior
Message-ID: <20070809142430.GA19817@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Update atomic_ops.txt to reflect the newly consistent behavior of
atomic_read(), and to note that volatile (in declarations) is now
considered harmful.

Signed-off-by: Chris Snook <csnook@redhat.com>

--- linux-2.6.23-rc2-orig/Documentation/atomic_ops.txt	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.23-rc2/Documentation/atomic_ops.txt	2007-08-09 08:24:32.000000000 -0400
@@ -12,7 +12,7 @@
 C integer type will fail.  Something like the following should
 suffice:
 
-	typedef struct { volatile int counter; } atomic_t;
+	typedef struct { int counter; } atomic_t;
 
 	The first operations to implement for atomic_t's are the
 initializers and plain reads.
@@ -38,9 +38,17 @@
 
 Next, we have:
 
-	#define atomic_read(v)	((v)->counter)
+	#define atomic_read(v)	(*(volatile int *)&(v)->counter)
 
-which simply reads the current value of the counter.
+which reads the counter as though it were volatile.  This prevents the
+compiler from optimizing away repeated atomic_read() invocations without
+requiring a more expensive barrier().  Historically this has been
+accomplished by declaring the counter itself to be volatile, but the
+ambiguity of the C standard on the semantics of volatile make this practice
+vulnerable to overly creative interpretation by compilers.  Explicit
+casting in atomic_read() ensures consistent behavior across architectures
+and compilers.  Even with this convenience in atomic_read(), busy-waiters
+should call cpu_relax().
 
 Now, we move onto the actual atomic operation interfaces.
 
