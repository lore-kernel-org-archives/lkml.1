Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZAGFDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZAGFDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZAGFC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:02:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:54325 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZAGFC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:02:57 -0500
Subject: Re: powerpc: introduce asm/swab.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <1231303340.14860.61.camel@pasglop>
References: <200901070400.n0740Ore002063@hera.kernel.org>
	 <1231303340.14860.61.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Jan 2009 16:02:32 +1100
Message-Id: <1231304552.14860.72.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 15:42 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2009-01-07 at 04:00 +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=156ca2bbf6503a02d7d6829886ce381d572de66e
> > Commit:     156ca2bbf6503a02d7d6829886ce381d572de66e
> > Parent:     8cdd3a9261e8efe36aeb6c708edb76d7e2b5d13f
> > Author:     Harvey Harrison <harvey.harrison@gmail.com>
> > AuthorDate: Tue Jan 6 14:56:23 2009 -0800
> > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> > CommitDate: Tue Jan 6 18:10:27 2009 -0800
> > 
> >     powerpc: introduce asm/swab.h
> >     
> >     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Was this tested ? I see no arch maintainer signed-off here, it appears
> to at least break ppc32, and contains hunks that paulus says were
> explicitely nacked (removing of our ld_* macros) etc...
> 
> Linus, please revert.

More details:

include/linux/swab.h: In function ‘__fswab64’:
include/linux/swab.h:71: error: implicit declaration of function ‘___swab32’
make[1]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

I don't see any place where ___swab32() is defined (with 3 underscores).

Even if fixing that to use __swab32() instead, then it fails because
this is defined after it's used. I worked around it using fswab in
there instead.

This tentative patches fixes that too, but I haven't followed the whole
discussion closely, so I can't tell whether it's fully in the original
intend. In any case, it makes ppc32 build again (and probably others).

byteorder: Fix a couple of bugs in the new include/linux/swab.h

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

diff --git a/include/linux/swab.h b/include/linux/swab.h
index 9a2d33e..351c456 100644
--- a/include/linux/swab.h
+++ b/include/linux/swab.h
@@ -40,7 +40,7 @@
 /*
  * Implement the following as inlines, but define the interface using
  * macros to allow constant folding when possible:
- * ___swab16, ___swab32, ___swab64, ___swahw32, ___swahb32
+ * __swab16, __swab32, __swab64, __swahw32, __swahb32
  */
 
 static inline __attribute_const__ __u16 __fswab16(__u16 val)
@@ -68,7 +68,7 @@ static inline __attribute_const__ __u64 __fswab64(__u64 val)
 #elif defined(__SWAB_64_THRU_32__)
 	__u32 h = val >> 32;
 	__u32 l = val & ((1ULL << 32) - 1);
-	return (((__u64)___swab32(l)) << 32) | ((__u64)(___swab32(h)));
+	return (((__u64)__fswab32(l)) << 32) | ((__u64)(__fswab32(h)));
 #else
 	return ___constant_swab64(val);
 #endif


