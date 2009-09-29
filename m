Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZI2V5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZI2V5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZI2V5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:57:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751657AbZI2V5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:57:21 -0400
Date: Tue, 29 Sep 2009 14:56:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
In-Reply-To: <20090929232248.735bf4df@infradead.org>
Message-ID: <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <4AC060AE.1090401@gmail.com> <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com>
 <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Sep 2009, Arjan van de Ven wrote:
> 
> can't we use alternatives() for this, to patch cmpxchg64 in ?
> I mean.. it'll be commonly supported nowadays.. the fallback to it not
> being supported could be a bit slower by now...

Yes, we could. It would limit us to some fixed address format, probably

	cmpxchg8b (%esi)

or something. Use something like this as a starting point, perhaps?

NOTE! Totally untested! And you'd actually need to implement the 
"cmpxchg8b_emu" function that takes it's arguments in %eax:%edx, %ebx:%ecx 
and %esi and doesn't trash any other registers..

		Linus

---
 arch/x86/include/asm/cmpxchg_32.h |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 82ceb78..d16a486 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -312,19 +312,20 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
 
 extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
 
-#define cmpxchg64(ptr, o, n)						\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = (__typeof__(*(ptr)))__cmpxchg64((ptr),		\
-				(unsigned long long)(o),		\
-				(unsigned long long)(n));		\
-	else								\
-		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
-				(unsigned long long)(o),		\
-				(unsigned long long)(n));		\
-	__ret;								\
-})
+#define cmpxchg64(ptr, o, n)					\
+({								\
+	__typeof__(*(ptr)) __ret;				\
+	__typeof__(*(ptr)) __old = (o);				\
+	__typeof__(*(ptr)) __new = (n);				\
+	alternative_io(LOCK_PREFIX "cmpxchg8b (%%esi)",		\
+		       "call cmpxchg8b_emu",			\
+		       X86_FEATURE_CMPXCHG8B,			\
+		       "=A" (__ret),				\
+		       "m" (*(ptr)), "0" (__old),		\
+		       "b" ((unsigned int)__new),		\
+		       "c" ((unsigned int)(__new>>32)) );	\
+	__ret; })
+
 #define cmpxchg64_local(ptr, o, n)					\
 ({									\
 	__typeof__(*(ptr)) __ret;					\
