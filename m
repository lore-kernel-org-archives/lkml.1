Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZJAA6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZJAA6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZJAA6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:58:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249AbZJAA6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:58:11 -0400
Date: Wed, 30 Sep 2009 17:57:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <alpine.LFD.2.01.0909301738220.6996@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain>
References: <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain>
 <20090930170754.0886ff2e@infradead.org> <4AC37FE5.7020200@gmail.com> <alpine.LFD.2.01.0909300909460.6996@localhost.localdomain> <20090930185315.GA9716@elte.hu> <20090930220342.GA2118@elte.hu> <alpine.LFD.2.01.0909301738220.6996@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Sep 2009, Linus Torvalds wrote:
> 
> Pulled. I'd also like to see something that actually fails gracefully on 
> cmpxchg() of an unsupported size, though. The silent failure still annoys 
> me.

Oh, and we probably should try to avoid the 'alternates()' code when we 
can statically determine that cmpxchg8b is fine. We already have that 
CONFIG_x86_CMPXCHG64 (enabled by PAE support), and we could easily also 
enable it for some of the CPU cases.

[ If I recall correctly, cmpxchg8b support detection was something that 
  was totally messed up in WNT, and I have this memory of TMTA _not_ 
  claiming to support CX8 in the cpuid bits, but happily supporting the 
  instruction itself - because otherwise WNT would blue-screen on boot or 
  something silly like that.

  As a result, the patch below only adds CMPXCHG8B for the obvious Intel 
  CPU's, not for others. There was something really messy about cmpxchg8b 
  and clone CPU's, but I'm not 100% sure about the details, so take this 
  patch with a pinch of salt, and some thinking ]

If we avoid that asm-alternative thing when we can assume the instruction 
exists, we'll generate less support crud, and we'll avoid the whole issue 
with that extra 'nop' for padding instruction sizes etc.

			Linus

---
 arch/x86/Kconfig.cpu |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 527519b..f2824fb 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -400,7 +400,7 @@ config X86_TSC
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on X86_PAE || X86_64
+	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
@@ -412,6 +412,7 @@ config X86_MINIMUM_CPU_FAMILY
 	int
 	default "64" if X86_64
 	default "6" if X86_32 && X86_P6_NOP
+	default "5" if X86_32 && X86_CMPXCHG64
 	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
 	default "3"
 


