Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZARSvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZARSvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZARSvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:51:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZARSvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:51:00 -0500
Date: Sun, 18 Jan 2009 19:50:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
Message-ID: <20090118185034.GA26908@elte.hu>
References: <1232287474.3130.19.camel@localhost.localdomain> <20090118172800.GB22624@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118172800.GB22624@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hm, i just noticed this detail:

commit 3521c5eef990515719614e212b26ea49e610d072
Author: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date:   Sat Jan 17 19:25:46 2009 +0530

    headers_check fix: x86, swab.h
    
    fix the following 'make headers_check' warnings:
    
      usr/include/asm/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
      usr/include/asm/swab.h:7: found __[us]{8,16,32,64} type without #include <linux/types.h>
      usr/include/asm/swab.h:10: leaks CONFIG_X86 to userspace where it is not valid
      usr/include/asm/swab.h:40: leaks CONFIG_X86 to userspace where it is not valid
    
    Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
index 306d417..613be68 100644
--- a/arch/x86/include/asm/swab.h
+++ b/arch/x86/include/asm/swab.h
@@ -1,12 +1,15 @@
 #ifndef _ASM_X86_SWAB_H
 #define _ASM_X86_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
+#ifdef __KERNEL__
 #include <linux/compiler.h>
+#endif /* __KERNEL__ */
 
 static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 #ifdef __i386__
+#ifdef __KERNEL__
 # ifdef CONFIG_X86_BSWAP
 	asm("bswap %0" : "=r" (val) : "0" (val));
 # else
@@ -16,7 +19,13 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 	    : "=q" (val)
 	    : "0" (val));
 # endif
-
+#else /* __KERNEL__ */
+	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
+	    "rorl $16,%0\n\t"	/* swap words		*/
+	    "xchgb %b0,%h0"	/* swap higher bytes	*/
+	    : "=q" (val)
+	    : "0" (val));
+#endif /* __KERNEL__ */
 #else /* __i386__ */
 	asm("bswapl %0"
 	    : "=r" (val)
@@ -37,6 +46,7 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 		__u64 u;
 	} v;
 	v.u = val;
+#ifdef __KERNEL__
 # ifdef CONFIG_X86_BSWAP
 	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
@@ -48,6 +58,13 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
 # endif
+#else /* __KERNEL__ */
+	v.s.a = __arch_swab32(v.s.a);
+	v.s.b = __arch_swab32(v.s.b);
+	asm("xchgl %0,%1"
+	    : "=r" (v.s.a), "=r" (v.s.b)
+	    : "0" (v.s.a), "1" (v.s.b));
+#endif /* __KERNEL__ */
 	return v.u;
 #else /* __i386__ */
 	asm("bswapq %0"


why does such a change introduce new code? It is duplicating existing code 
instead of cleaning it all up.

	Ingo
