Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYAUUco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYAUUco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYAUU2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:28:31 -0500
Received: from relay2.sgi.com ([192.48.171.30]:55905 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754585AbYAUU2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:28:23 -0500
Message-Id: <20080121202822.657079000@sgi.com>
References: <20080121202821.815918000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 12:28:27 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com
Subject: [PATCH 6/7] s390: Use generic percpu rc8-mm1-fixup with git-x86
Content-Disposition: inline; filename=s390_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change s390 percpu.h to use asm-generic/percpu.h

Based on 2.6.24-rc8-mm1 + latest (08/1/21) git-x86

Cc: schwidefsky@de.ibm.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
rc8-mm1-fixup:
  - rebased from 2.6.24-rc6-mm1 to 2.6.24-rc8-mm1
    (removed changes that are in the git-x86.patch)

V2->V3:

On Thu, 29 Nov 2007, Martin Schwidefsky wrote:

> On Wed, 2007-11-28 at 13:09 -0800, Christoph Lameter wrote:
> > s390 has a special way to determine the pointer to a per cpu area
> > plus there is a way to access the base of the per cpu area of the
> > currently executing processor.
> > 
> > Note: I had to do a minor change to ASM code. Please check that
> > this was done right.
> 
> Hi Christoph,
> 
> after fixing the trainwreck with Gregs kset changes I've got rc3-mm2
> compiled with your percpu patches. The new s390 percpu code works fine:
> 
> Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

---
 include/asm-s390/percpu.h |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

--- a/include/asm-s390/percpu.h
+++ b/include/asm-s390/percpu.h
@@ -13,40 +13,25 @@
  */
 #if defined(__s390x__) && defined(MODULE)
 
-#define __reloc_hide(var,offset) (*({			\
+#define SHIFT_PERCPU_PTR(ptr,offset) (({			\
 	extern int simple_identifier_##var(void);	\
 	unsigned long *__ptr;				\
-	asm ( "larl %0,per_cpu__"#var"@GOTENT"		\
-	    : "=a" (__ptr) : "X" (per_cpu__##var) );	\
-	(typeof(&per_cpu__##var))((*__ptr) + (offset));	}))
+	asm ( "larl %0, %1@GOTENT"		\
+	    : "=a" (__ptr) : "X" (ptr) );		\
+	(typeof(ptr))((*__ptr) + (offset));	}))
 
 #else
 
-#define __reloc_hide(var, offset) (*({				\
+#define SHIFT_PERCPU_PTR(ptr, offset) (({				\
 	extern int simple_identifier_##var(void);		\
 	unsigned long __ptr;					\
-	asm ( "" : "=a" (__ptr) : "0" (&per_cpu__##var) );	\
-	(typeof(&per_cpu__##var)) (__ptr + (offset)); }))
+	asm ( "" : "=a" (__ptr) : "0" (ptr) );			\
+	(typeof(ptr)) (__ptr + (offset)); }))
 
 #endif
 
-#ifdef CONFIG_SMP
+#define __my_cpu_offset S390_lowcore.percpu_offset
 
-extern unsigned long __per_cpu_offset[NR_CPUS];
-
-#define __get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
-#define __raw_get_cpu_var(var) __reloc_hide(var,S390_lowcore.percpu_offset)
-#define per_cpu(var,cpu) __reloc_hide(var,__per_cpu_offset[cpu])
-#define per_cpu_offset(x) (__per_cpu_offset[x])
-
-#else /* ! SMP */
-
-#define __get_cpu_var(var) __reloc_hide(var,0)
-#define __raw_get_cpu_var(var) __reloc_hide(var,0)
-#define per_cpu(var,cpu) __reloc_hide(var,0)
-
-#endif /* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
+#include <asm-generic/percpu.h>
 
 #endif /* __ARCH_S390_PERCPU__ */

-- 
