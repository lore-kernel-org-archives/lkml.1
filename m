Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYDJPBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYDJPBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758829AbYDJPAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:00:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821AbYDJPAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:00:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/5] FRV: Don't make smp_{r, w,
	}mb() interpolate MEMBAR when CONFIG_SMP=n
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 10 Apr 2008 16:00:41 +0100
Message-ID: <20080410150040.30046.47747.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080410150020.30046.84293.stgit@warthog.procyon.org.uk>
References: <20080410150020.30046.84293.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Don't make smp_{r,w,}mb() interpolate a MEMBAR instruction when CONFIG_SMP=n as
SMP memory barries on UP systems should interpolate a compiler barrier only.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-frv/system.h |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/include/asm-frv/system.h b/include/asm-frv/system.h
index 2c57f47..30a67a9 100644
--- a/include/asm-frv/system.h
+++ b/include/asm-frv/system.h
@@ -179,14 +179,23 @@ do {							\
 #define mb()			asm volatile ("membar" : : :"memory")
 #define rmb()			asm volatile ("membar" : : :"memory")
 #define wmb()			asm volatile ("membar" : : :"memory")
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
+#define read_barrier_depends()	barrier()
 
-#define smp_mb()		mb()
-#define smp_rmb()		rmb()
-#define smp_wmb()		wmb()
-
-#define read_barrier_depends()		do {} while(0)
+#ifdef CONFIG_SMP
+#define smp_mb()			mb()
+#define smp_rmb()			rmb()
+#define smp_wmb()			wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
+#define set_mb(var, value) \
+	do { xchg(&var, (value)); } while (0)
+#else
+#define smp_mb()			barrier()
+#define smp_rmb()			barrier()
+#define smp_wmb()			barrier()
+#define smp_read_barrier_depends()	do {} while(0)
+#define set_mb(var, value) \
+	do { var = (value); barrier(); } while (0)
+#endif
 
 #define HARD_RESET_NOW()			\
 do {						\

