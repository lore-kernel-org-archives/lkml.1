Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZCFQQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZCFQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbZCFQQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:16:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:43029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbZCFQQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:16:23 -0500
Date: Fri, 6 Mar 2009 16:15:28 GMT
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, sfr@canb.auug.org.au, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, sfr@canb.auug.org.au,
       gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <20090306160833.GB7420@localhost>
References: <20090306160833.GB7420@localhost>
Subject: [tip:x86/asm] x86: linkage.h - guard assembler specifics by __ASSEMBLY__
Message-ID: <tip-7ab152470e8416ef2a44c800fdc157e2192f2974@git.kernel.org>
Git-Commit-ID: 7ab152470e8416ef2a44c800fdc157e2192f2974
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 16:15:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ab152470e8416ef2a44c800fdc157e2192f2974
Gitweb:     http://git.kernel.org/tip/7ab152470e8416ef2a44c800fdc157e2192f2974
Author:     "Cyrill Gorcunov" <gorcunov@gmail.com>
AuthorDate: Fri, 6 Mar 2009 19:08:34 +0300
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 17:14:12 +0100

x86: linkage.h - guard assembler specifics by __ASSEMBLY__

Stephen Rothwell reported:

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

Any assembler specific snippets being placed in headers
are to be protected by __ASSEMBLY__. Fixed.

Also move __ALIGN definition under the same protection as well.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090306160833.GB7420@localhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/linkage.h |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 9320e2a..a0d70b4 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
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
 
