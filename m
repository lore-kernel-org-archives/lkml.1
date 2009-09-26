Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZIZRfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZIZRfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 13:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZIZRfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 13:35:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55619 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZIZRfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 13:35:32 -0400
Date: Sat, 26 Sep 2009 19:35:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] x86: Fix hwpoison code related build failure on 32-bit
	NUMAQ
Message-ID: <20090926173522.GA22723@elte.hu>
References: <20090916125116.GA12751@basil.fritz.box> <20090926141352.GA26117@elte.hu> <20090926151740.GN30185@one.firstfloor.org> <alpine.LFD.2.01.0909260930410.3303@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909260930410.3303@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 26 Sep 2009, Andi Kleen wrote:
> > 
> > Thanks for the report. The issue comes from NODES_SHIFT=4
> > 
> > I think I tested the NUMA case, but perhaps not with full NODES_SHIFT.
> > 
> > The easy fix would be to limit NODES_SHIFT to 3 for 32bit (8 nodes max). Do you
> > have any problems with that? I doubt there are any >8 nodes NUMAQs left.
> > (last time I heard the last machine at IBM was down to < 4)
> 
> No, just say "we don't support HWPOISON on 32-bit NUMA". 
> 
> Maybe simply using something like this.
> 
> TOTALLY UNTESTED!
> 
> 		Linus
> ---
>  arch/x86/Kconfig |    6 ++++++
>  mm/Kconfig       |    4 +++-
>  2 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 9369879..be1bb44 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -432,6 +432,12 @@ config X86_NUMAQ
>  	  of Flat Logical.  You will need a new lynxer.elf file to flash your
>  	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
>  
> +config X86_SUPPORTS_MEMORY_FAILURE
> +	bool
> +	depends on !X86_NUMAQ
> +	select ARCH_SUPPORTS_MEMORY_FAILURE
> +	default y

Thanks Linus, this patch fixed the NUMAQ build problem.

Meanwhile i also found another similar build problem: sparsemem alone 
triggers the build bug on 32-bit as well:

 CONFIG_ARCH_SPARSEMEM_ENABLE=y
 CONFIG_SPARSEMEM_MANUAL=y
 CONFIG_SPARSEMEM=y
 CONFIG_SPARSEMEM_STATIC=y

So i added that to the X86_SUPPORTS_MEMORY_FAILURE rules as well - with 
that it works fine. (and this validates the concept of your patch as we 
keep excluding a new kernel feature in a well-documented way instead of 
narrowing existing hardware support with much less clear dependencies.)

I've attached the updated patch and will keep testing it a bit more 
(there might be more corner cases). If it goes fine i can send it to you 
via x86/urgent later today so that it gets into -rc1.

Can i add your signoff?

	Ingo


------------------->
>From 5e4000b6808ffca466f41c01442527f9fe4305bd Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Sep 2009 09:35:07 -0700
Subject: [PATCH] x86: Fix hwpoison code related build failure on 32-bit NUMAQ

This build failure triggers:

 In file included from include/linux/suspend.h:8,
                 from arch/x86/kernel/asm-offsets_32.c:11,
                 from arch/x86/kernel/asm-offsets.c:2:
 include/linux/mm.h:503:2: error: #error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS

Because due to the hwpoison page flag we ran out of page
flags on 32-bit.

Dont turn on hwpoison on 32-bit NUMA (it's rare in any
case).

Also clean up the Kconfig dependencies in the generic MM
code by introducing ARCH_SUPPORTS_MEMORY_FAILURE.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    6 ++++++
 mm/Kconfig       |    4 +++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9369879..ef95406 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -432,6 +432,12 @@ config X86_NUMAQ
 	  of Flat Logical.  You will need a new lynxer.elf file to flash your
 	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
 
+config X86_SUPPORTS_MEMORY_FAILURE
+	bool
+	depends on (!X86_NUMAQ && !(X86_32 && SPARSEMEM))
+	select ARCH_SUPPORTS_MEMORY_FAILURE
+	default y
+
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
 	depends on X86_32 && PCI && X86_MPPARSE && PCI_GODIRECT
diff --git a/mm/Kconfig b/mm/Kconfig
index 2477607..edd300a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -244,10 +244,12 @@ config DEFAULT_MMAP_MIN_ADDR
 	  This value can be changed after boot using the
 	  /proc/sys/vm/mmap_min_addr tunable.
 
+config ARCH_SUPPORTS_MEMORY_FAILURE
+	bool
 
 config MEMORY_FAILURE
 	depends on MMU
-	depends on X86_MCE
+	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
 	help
 	  Enables code to recover from some memory failures on systems
