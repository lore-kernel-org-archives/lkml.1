Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbZACGCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbZACGCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 01:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZACGB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 01:01:59 -0500
Received: from ozlabs.org ([203.10.76.45]:38658 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZACGB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 01:01:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: git-pull request for tip/cpus4096
Date: Sat, 3 Jan 2009 16:31:46 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Chris Zankel <chris@zankel.net>,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com, Hirokazu Takata <takata@linux-m32r.org>,
       linux-m32r@ml.linux-m32r.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
References: <495E4837.8090600@sgi.com> <20090102180942.GB10072@elte.hu>
In-Reply-To: <20090102180942.GB10072@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901031631.47818.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 04:39:42 Ingo Molnar wrote:
> these architectures have no __fls() implementation ...
...
>  arch/cris           : 0
>  arch/frv            : 0
>  arch/h8300          : 0
>  arch/m32r           : 0
>  arch/m68k           : 0
>  arch/mn10300        : 0
>  arch/um             : 0
>  arch/xtensa         : 0

These are the non-linux-next archs.

I've already patched m68k (but it's in include/asm-m68k) and um doesn't
need it.  

Fixes are below, and pushed into my cpumask git tree.

Thanks,
Rusty.

commit 5ece5c5192d065c229da01e7b347c1d3877b59fa
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Jan 3 16:21:08 2009 +1030

    xtensa: define __fls
    
    Like fls, but can't be handed 0 and returns the bit number.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/asm-xtensa/bitops.h b/include/asm-xtensa/bitops.h
index 23261e8..6c39303 100644
--- a/include/asm-xtensa/bitops.h
+++ b/include/asm-xtensa/bitops.h
@@ -82,6 +82,16 @@ static inline int fls (unsigned int x)
 	return 32 - __cntlz(x);
 }
 
+/**
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	return 31 - __cntlz(word);
+}
 #else
 
 /* Use the generic implementation if we don't have the nsa/nsau instructions. */
@@ -90,6 +100,7 @@ static inline int fls (unsigned int x)
 # include <asm-generic/bitops/__ffs.h>
 # include <asm-generic/bitops/ffz.h>
 # include <asm-generic/bitops/fls.h>
+# include <asm-generic/bitops/__fls.h>
 
 #endif
 

commit 5c134dad43443aa9c9606eaf47c378a6b9c5c597
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Jan 3 16:19:03 2009 +1030

    mn10300: define __fls
    
    Like fls, but can't be handed 0 and returns the bit number.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/asm-mn10300/bitops.h b/include/asm-mn10300/bitops.h
index cc6d40c..0b610f4 100644
--- a/include/asm-mn10300/bitops.h
+++ b/include/asm-mn10300/bitops.h
@@ -196,6 +196,17 @@ int fls(int x)
 }
 
 /**
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	return __ilog2_u32(word);
+}
+
+/**
  * ffs - find first bit set
  * @x: the word to search
  *

commit 16a206260ee70f181de6a3672678545859589ef2
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Jan 3 16:16:54 2009 +1030

    m32r: define __fls
    
    Like fls, but can't be handed 0 and returns the bit number.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/asm-m32r/bitops.h b/include/asm-m32r/bitops.h
index 6dc9b81..aaddf0d 100644
--- a/include/asm-m32r/bitops.h
+++ b/include/asm-m32r/bitops.h
@@ -251,6 +251,7 @@ static __inline__ int test_and_change_bit(int nr, volatile void * addr)
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #ifdef __KERNEL__

commit 9ddabc2a29163e4b243d10c5e06fc5584073d7ad
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Jan 3 16:16:04 2009 +1030

    h8300: define __fls
    
    Like fls, but can't be handed 0 and returns the bit number.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/h8300/include/asm/bitops.h b/arch/h8300/include/asm/bitops.h
index cb18e3b..cb9ddf5 100644
--- a/arch/h8300/include/asm/bitops.h
+++ b/arch/h8300/include/asm/bitops.h
@@ -207,6 +207,7 @@ static __inline__ unsigned long __ffs(unsigned long word)
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #endif /* _H8300_BITOPS_H */

commit ee38e5140bafbf40e1bd25ab917ac8db54a27799
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Jan 3 16:14:05 2009 +1030

    frv: define __fls
    
    Like fls, but can't be handed 0 and returns the bit number.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/asm-frv/bitops.h b/include/asm-frv/bitops.h
index 39456ba..287f6f6 100644
--- a/include/asm-frv/bitops.h
+++ b/include/asm-frv/bitops.h
@@ -339,6 +339,19 @@ int __ffs(unsigned long x)
 	return 31 - bit;
 }
 
+/**
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	unsigned long bit;
+	asm("scan %1,gr0,%0" : "=r"(bit) : "r"(word));
+	return bit;
+}
+
 /*
  * special slimline version of fls() for calculating ilog2_u32()
  * - note: no protection against n == 0
