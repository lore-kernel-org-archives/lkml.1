Return-Path: <linux-kernel-owner+w=401wt.eu-S1752239AbZJAFbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbZJAFbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 01:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZJAFbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 01:31:04 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:47918 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZJAFbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 01:31:04 -0400
Message-ID: <4AC43E7E.1000600@gmail.com>
Date: Thu, 01 Oct 2009 07:30:38 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
References: <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <4AC37FE5.7020200@gmail.com> <alpine.LFD.2.01.0909300909460.6996@localhost.localdomain> <20090930185315.GA9716@elte.hu> <20090930220342.GA2118@elte.hu> <alpine.LFD.2.01.0909301738220.6996@localhost.localdomain> <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 01 Oct 2009 07:30:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Wed, 30 Sep 2009, Linus Torvalds wrote:
> Oh, and we probably should try to avoid the 'alternates()' code when we 
> can statically determine that cmpxchg8b is fine. We already have that 
> CONFIG_x86_CMPXCHG64 (enabled by PAE support), and we could easily also 
> enable it for some of the CPU cases.
> 

Agreed.

Please find following patch to conditionaly compile cmpxchg8b_emu.o and
EXPORT_SYMBOL(cmpxchg8b_emu).

This patch doesnt depend on yours.

Thanks

[PATCH] x86: Dont generate cmpxchg8b_emu if CONFIG_X86_CMPXCHG64=y

cmpxchg8b_emu helper wont be used if CONFIG_X86_CMPXCHG64=y

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 arch/x86/kernel/i386_ksyms_32.c |    2 ++
 arch/x86/lib/Makefile           |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index 1736c5a..9c3bd4a 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -15,8 +15,10 @@ EXPORT_SYMBOL(mcount);
  * the export, but dont use it from C code, it is used
  * by assembly code and is not using C calling convention!
  */
+#ifndef CONFIG_X86_CMPXCHG64
 extern void cmpxchg8b_emu(void);
 EXPORT_SYMBOL(cmpxchg8b_emu);
+#endif
 
 /* Networking helper routines. */
 EXPORT_SYMBOL(csum_partial_copy_generic);
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 3e549b8..c309b82 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -15,8 +15,10 @@ ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
-        lib-y += semaphore_32.o string_32.o cmpxchg8b_emu.o
-
+        lib-y += semaphore_32.o string_32.o
+ifeq ($(CONFIG_X86_CMPXCHG64),n)
+        lib-y += cmpxchg8b_emu.o
+endif
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
         obj-y += io_64.o iomap_copy_64.o
