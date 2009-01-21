Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZAUJ07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZAUJ07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZAUJ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:26:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40851 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZAUJ0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:26:48 -0500
Date: Wed, 21 Jan 2009 10:26:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, brgerst@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHSET linux-2.6-x86:core/percpu] x86: misc clean up and
	unify x86_32/64 code paths
Message-ID: <20090121092633.GA22506@elte.hu>
References: <1232527578-1960-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1232527578-1960-1-git-send-email-tj@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> This patchset contains the following 10 patches mostly unifying 32 and
> 64bit code paths.  0001 and 0007-0010 are from me and 0002-0006 are
> from Brian Gerst.
> 
>   0001-x86-update-canary-handling-during-switch.patch
>   0002-x86-clean-up-gdt_page-definition.patch
>   0003-x86-fix-percpu_write-with-64-bit-constants.patch
>   0004-x86-set-fs-to-__KERNEL_PERCPU-unconditionally-for.patch
>   0005-x86-merge-mmu_context.h.patch
>   0006-x86-merge-irq_regs.h.patch
>   0007-x86-uv-cleanup.patch
>   0008-x86-prepare-for-tlb-merge.patch
>   0009-x86-make-x86_32-use-tlb_64.c.patch
>   0010-x86-rename-tlb_64.c-to-tlb.c.patch
> 
> 0001-0002 clean up after previous percpu changes.  0003 improves
> percpu op slightly.  0004 simplifies x86_32 init path.  0005-0010
> unifies mmu_context.h, irq_regs.h and tlb.c, which not only simplifies
> the source code but also improves performance by applying
> optimizations implemented for either bitness to the other one while
> unifying.
> 
> The following git tree contains the above changes on top of
> core/percpu[1].  Please pull from it if there's no objection.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Pulled into tip/core/percpu, thanks Tejun.

Very nice stuff! The SMP TLB flush code unification is a gem - i never 
thought we'd get so far this quick ;-)

Note, i also merged the latest cpumask work into tip/core/percpu, to 
resolve tlb_32.c conflicts. I also moved tlb.c from arch/x86/kernel/ to 
arch/x86/mm/, where it really belongs conceptually.

-tip testing also stumbled upon a build error caused by the UV cleanups - 
see the fix below.

	Ingo

-------------->
>From 4ec71fa2d2c3f1040348f2604f4b8ccc833d1c2e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 21 Jan 2009 10:24:27 +0100
Subject: [PATCH] x86: uv cleanup, build fix
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Fix:

 arch/x86/mm/srat_64.c: In function ‘acpi_numa_processor_affinity_init’:
 arch/x86/mm/srat_64.c:141: error: implicit declaration of function ‘get_uv_system_type’
 arch/x86/mm/srat_64.c:141: error: ‘UV_X2APIC’ undeclared (first use in this function)
 arch/x86/mm/srat_64.c:141: error: (Each undeclared identifier is reported only once
 arch/x86/mm/srat_64.c:141: error: for each function it appears in.)

A couple of UV definitions were moved to asm/uv/uv.h, but srat_64.c did
not include that header. Add it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/srat_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 09737c8..15df1ba 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -21,6 +21,7 @@
 #include <asm/numa.h>
 #include <asm/e820.h>
 #include <asm/genapic.h>
+#include <asm/uv/uv.h>
 
 int acpi_numa __initdata;
 
