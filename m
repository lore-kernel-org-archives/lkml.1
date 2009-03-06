Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbZCFQIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbZCFQIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZCFQIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:08:32 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:35997 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbZCFQIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:08:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=r21cbiM1qBlPqpEutEg03jdmus0k94Xh2A0agq9NPAIIEYOVkYI+bgDqKpbvMwr5E4
         fcbz+rC2ULpd331tNz+4jprrWcQZwN2UcOyhDjD/SFnE6EP+SzJBDU/9gnhVMgMhAhCj
         Zzc10I5van1Fbsr50OP7nKsx5H46+0RWb3nSc=
Date: Fri, 6 Mar 2009 19:08:34 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: linkage.h - guard assembler specifics by __ASSEMBLY__
Message-ID: <20090306160833.GB7420@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell reported
|
|Today's linux-next build (x86_64 allmodconfig) produced this warning:
|
|In file included from drivers/char/epca.c:49:
|drivers/char/digiFep1.h:7:1: warning: "GLOBAL" redefined
|In file included from include/linux/linkage.h:5,
|                 from include/linux/kernel.h:11,
|                 from arch/x86/include/asm/system.h:10,
|                 from arch/x86/include/asm/processor.h:17,
|                 from include/linux/prefetch.h:14,
|                 from include/linux/list.h:6,
|                 from include/linux/module.h:9,
|                 from drivers/char/epca.c:29:
|arch/x86/include/asm/linkage.h:55:1: warning: this is the location of the previous definition
|
|Probably introduced by commit 95695547a7db44b88a7ee36cf5df188de267e99e
|("x86: asm linkage - introduce GLOBAL macro") from the x86 tree.
|

Any assembler specific snippets being placed in headers
are to be protected by __ASSEMBLY__. Fixed.

Also move __ALIGN definition under the same protection as well.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Ingo, Stephen -- check it please (until I miss something)

 arch/x86/include/asm/linkage.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/linkage.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/linkage.h
+++ linux-2.6.git/arch/x86/include/asm/linkage.h
@@ -4,11 +4,6 @@
 #undef notrace
 #define notrace __attribute__((no_instrument_function))
 
-#ifdef CONFIG_X86_64
-#define __ALIGN .p2align 4,,15
-#define __ALIGN_STR ".p2align 4,,15"
-#endif
-
 #ifdef CONFIG_X86_32
 #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
 /*
@@ -50,16 +45,25 @@
 	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
 			      "g" (arg4), "g" (arg5), "g" (arg6))
 
-#endif
+#endif /* CONFIG_X86_32 */
+
+#ifdef __ASSEMBLY__
 
 #define GLOBAL(name)	\
 	.globl name;	\
 	name:
 
+#ifdef CONFIG_X86_64
+#define __ALIGN .p2align 4,,15
+#define __ALIGN_STR ".p2align 4,,15"
+#endif
+
 #ifdef CONFIG_X86_ALIGNMENT_16
 #define __ALIGN .align 16,0x90
 #define __ALIGN_STR ".align 16,0x90"
 #endif
 
+#endif /* __ASSEMBLY__ */
+
 #endif /* _ASM_X86_LINKAGE_H */
 
