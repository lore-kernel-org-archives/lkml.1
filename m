Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYJ1JJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYJ1JJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYJ1JJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:09:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57341 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYJ1JI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:08:59 -0400
Date: Tue, 28 Oct 2008 10:08:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: trace: fix printk warning for u64
Message-ID: <20081028090846.GR15734@elte.hu>
References: <20081027174328.084649ab.sfr@canb.auug.org.au> <20081027095248.GA6969@elte.hu> <20081028001254.7cb224e9.sfr@canb.auug.org.au> <20081027220655.1d188e1d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027220655.1d188e1d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 28 Oct 2008 00:12:54 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Ingo,
> > 
> > On Mon, 27 Oct 2008 10:52:48 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > (btw., did the "unify u64 definitions across all platforms" project 
> > > get anywhere?)
> > 
> > I think (from a comment from DaveM) that it led into a real mess.
> 
> The problem is the large amount of arch-specific code which is 
> printing u64's with %lu because it "knows" that u64 is implemented 
> as ulong. They all need to be switched to %ll.
> 
> A better strategy to get all this done would be to convert the 
> offending architectures to `long long' individually.  Then when 
> that's all done, unifying the typedef is a trivial step.

so here's the patch below which achieves just that. 64-bit platforms 
using the old int-l64.h header will get build warnings which they can 
fix gradually.

There's no runtime failures expected, nor any non-warning build 
failures, correct? So lets just do this, hm?

	Ingo

---
 include/asm-generic/int-l64.h |   63 +---------------------------------------
 1 files changed, 2 insertions(+), 61 deletions(-)

diff --git a/include/asm-generic/int-l64.h b/include/asm-generic/int-l64.h
index 2af9b75..a152df9 100644
--- a/include/asm-generic/int-l64.h
+++ b/include/asm-generic/int-l64.h
@@ -1,71 +1,12 @@
 /*
  * asm-generic/int-l64.h
  *
- * Integer declarations for architectures which use "long"
- * for 64-bit types.
+ * migration helper, will go away soon.
  */
 
 #ifndef _ASM_GENERIC_INT_L64_H
 #define _ASM_GENERIC_INT_L64_H
 
-#ifndef __ASSEMBLY__
-/*
- * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
- * header files exported to user space
- */
-
-typedef __signed__ char __s8;
-typedef unsigned char __u8;
-
-typedef __signed__ short __s16;
-typedef unsigned short __u16;
-
-typedef __signed__ int __s32;
-typedef unsigned int __u32;
-
-typedef __signed__ long __s64;
-typedef unsigned long __u64;
-
-#endif /* __ASSEMBLY__ */
-
-#ifdef __KERNEL__
-
-#ifndef __ASSEMBLY__
-
-typedef signed char s8;
-typedef unsigned char u8;
-
-typedef signed short s16;
-typedef unsigned short u16;
-
-typedef signed int s32;
-typedef unsigned int u32;
-
-typedef signed long s64;
-typedef unsigned long u64;
-
-#define S8_C(x)  x
-#define U8_C(x)  x ## U
-#define S16_C(x) x
-#define U16_C(x) x ## U
-#define S32_C(x) x
-#define U32_C(x) x ## U
-#define S64_C(x) x ## L
-#define U64_C(x) x ## UL
-
-#else /* __ASSEMBLY__ */
-
-#define S8_C(x)  x
-#define U8_C(x)  x
-#define S16_C(x) x
-#define U16_C(x) x
-#define S32_C(x) x
-#define U32_C(x) x
-#define S64_C(x) x
-#define U64_C(x) x
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
+#include <asm-generic/int-ll64.h>
 
 #endif /* _ASM_GENERIC_INT_L64_H */
