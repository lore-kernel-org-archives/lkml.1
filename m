Return-Path: <linux-kernel-owner+w=401wt.eu-S1761119AbXJaWqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761119AbXJaWqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760212AbXJaWmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:42:33 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51404 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294AbXJaWm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:42:26 -0400
Message-Id: <20071031224214.491468014@polymtl.ca>
References: <20071031223710.099558229@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 18:37:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Lameter <clameter@sgi.com>, tony.luck@intel.com,
       Keith Owens <kaos@ocs.com.au>
Subject: [patch 13/28] Add cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64
Content-Disposition: inline; filename=add-cmpxchg-local-to-ia64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 22:42:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the primitives cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64. They
use cmpxchg_acq as underlying macro, just like the already existing ia64
cmpxchg().

Changelog:

ia64 cmpxchg_local coding style fix
Quoting Keith Owens:

As a matter of coding style, I prefer

#define cmpxchg_local   cmpxchg
#define cmpxchg64_local cmpxchg64

Which makes it absolutely clear that they are the same code.  With your
patch, humans have to do a string compare of two defines to see if they
are the same.

Note cmpxchg is *not* a performance win vs interrupt disable / enable on IA64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Christoph Lameter <clameter@sgi.com>
CC: tony.luck@intel.com
CC: Keith Owens <kaos@ocs.com.au>
---
 include/asm-ia64/intrinsics.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/asm-ia64/intrinsics.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-ia64/intrinsics.h	2007-10-31 18:06:31.000000000 -0400
+++ linux-2.6-lttng/include/asm-ia64/intrinsics.h	2007-10-31 18:09:18.000000000 -0400
@@ -153,11 +153,17 @@ extern long ia64_cmpxchg_called_with_bad
 	(__typeof__(old)) _r_;								\
 })
 
-#define cmpxchg_acq(ptr,o,n)	ia64_cmpxchg(acq, (ptr), (o), (n), sizeof(*(ptr)))
-#define cmpxchg_rel(ptr,o,n)	ia64_cmpxchg(rel, (ptr), (o), (n), sizeof(*(ptr)))
+#define cmpxchg_acq(ptr, o, n)	\
+	ia64_cmpxchg(acq, (ptr), (o), (n), sizeof(*(ptr)))
+#define cmpxchg_rel(ptr, o, n)	\
+	ia64_cmpxchg(rel, (ptr), (o), (n), sizeof(*(ptr)))
 
 /* for compatibility with other platforms: */
-#define cmpxchg(ptr,o,n)	cmpxchg_acq(ptr,o,n)
+#define cmpxchg(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
+#define cmpxchg64(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
+
+#define cmpxchg_local		cmpxchg
+#define cmpxchg64_local		cmpxchg64
 
 #ifdef CONFIG_IA64_DEBUG_CMPXCHG
 # define CMPXCHG_BUGCHECK_DECL	int _cmpxchg_bugcheck_count = 128;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
