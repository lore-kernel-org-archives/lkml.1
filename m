Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbXJaNTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbXJaNTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbXJaNTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:19:40 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:37858 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755176AbXJaNTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:19:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAN8dKEdMQWvU/2dsb2JhbACBWg
Date: Wed, 31 Oct 2007 09:19:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, matthew@wil.cx,
       linux-arch@vger.kernel.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 04/28] Add cmpxchg64 and cmpxchg64_local to mips
Message-ID: <20071031131935.GA26625@Krystal>
References: <20071030191557.947156623@polymtl.ca> <20071030192102.677087409@polymtl.ca> <20071031124831.GA3982@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071031124831.GA3982@linux-mips.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:18:35 up 93 days, 13:37,  3 users,  load average: 0.89, 0.56, 0.48
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ralf Baechle (ralf@linux-mips.org) wrote:
> This implementation means cmpxchg64_local will also silently take 32-bit
> arguments without making noises at compile time.  I think it should.
> 

Something along those lines ? I've fixed the other architectures too.


Add cmpxchg64 and cmpxchg64_local to mips

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: ralf@linux-mips.org
CC linux-mips@linux-mips.org
---
 include/asm-mips/cmpxchg.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6-lttng/include/asm-mips/cmpxchg.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-mips/cmpxchg.h	2007-10-31 09:14:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-mips/cmpxchg.h	2007-10-31 09:15:35.000000000 -0400
@@ -104,4 +104,21 @@ extern void __cmpxchg_called_with_bad_po
 #define cmpxchg(ptr, old, new)		__cmpxchg(ptr, old, new, smp_llsc_mb())
 #define cmpxchg_local(ptr, old, new)	__cmpxchg(ptr, old, new, )
 
+#define cmpxchg64(ptr,o,n)						\
+  ({									\
+  	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+  	cmpxchg((ptr),(o),(n));						\
+  })
+
+#ifdef CONFIG_64BIT
+#define cmpxchg64_local(ptr,o,n)					\
+  ({									\
+  	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+  	cmpxchg_local((ptr),(o),(n));					\
+  })
+#else
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg64_local(ptr,o,n)	__cmpxchg64_local_generic((ptr),(o),(n))
+#endif
+
 #endif /* __ASM_CMPXCHG_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
