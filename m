Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbXK0W5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbXK0W5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXK0W5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:57:31 -0500
Received: from gw.goop.org ([64.81.55.164]:33156 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbXK0W5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:57:30 -0500
Message-ID: <474CA0DA.3010005@goop.org>
Date: Tue, 27 Nov 2007 14:57:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Tobias Powalowski <t.powa@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Zachary Amsden <zach@vmware.com>
Subject: [PATCH] x86/paravirt: revert exports to restore old behaviour
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subdividing the paravirt_ops structure caused a regression in certain
non-GPL modules which try to use mmu_ops and cpu_ops.  This restores
the old behaviour, and makes it consistent with the
non-CONFIG_PARAVIRT case.

Tobias Powalowski <t.powa@gmx.de> reports:
> commit to .24 tree:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=93b1eab3d29e7ea32ee583de3362da84db06ded8
>
> introduces:
> +EXPORT_SYMBOL_GPL(pv_mmu_ops);
> +EXPORT_SYMBOL_GPL(pv_cpu_ops);
>
> pv_cpu_ops is for nvidia
> pv_mmu_ops' is for amd(ati)
>
> which will break 32bit systems with paravirt enabled and trying to compile
> the binary graphic drivers from amd(ati) and nvidia.

Takashi Iwai <tiwai@suse.de> adds:
> I took at this problem (as I have an nvidia card on one of my
> workstations), and found out that the following suffer from
> EXPORT_SYMBOL_GPL changes:
> 
> * local_disable_irq(), local_irq_save*(), etc.
> * MSR-related macros like rdmsr(), wrmsr(), read_cr0(), etc.
>   wbinvd(), too.
> * pmd_val(), pgd_val(), etc are all involved with pv_mm_ops.
>   pmd_large() and pmd_bad() is also indirectly involved.
>   __flush_tlb() and friends suffer, too.

Christoph Hellwig objects to this patch on the grounds that modules
shouldn't be using these operations anyway.  I don't think this is a
particularly good reason to reject the patch, for several reasons:

1. These operations are still available to modules when not using
   CONFIG_PARAVIRT, since they are implicitly exported as inline
   functions via the kernel headers.  Exporting the same functionality as
   GPL-only symbols just adds a gratuitious difference between
   CONFIG_PARAVIRT and non-CONFIG_PARAVIRT configurations.  If we really
   think these operations are not for module use (or non-GPL module use),
   then we should solve the problem in a general way.

2. It's a regression from previous kernels, which would work these
   modules even with CONFIG_PARAVIRT enabled.

3. The operations in question seem pretty reasonable for modules to
   use.  The control registers/MSRs can be accessed directly anyway, so there's
   no benefit in preventing modules from using standard interfaces.  And it seems
   reasonable to allow a graphics driver to create its own mappings if it wants.

Therefore, I think this patch should go in for 2.6.24.  If people
really think that these operations should not be available to modules,
then we can address that separately.

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: Tobias Powalowski <t.powa@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Zachary Amsden <zach@vmware.com>

---
 arch/x86/kernel/paravirt_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -r 0328c71b880c arch/x86/kernel/paravirt_32.c
--- a/arch/x86/kernel/paravirt_32.c	Tue Nov 27 11:21:09 2007 -0800
+++ b/arch/x86/kernel/paravirt_32.c	Tue Nov 27 11:21:16 2007 -0800
@@ -465,8 +465,8 @@ struct pv_mmu_ops pv_mmu_ops = {
 };
 
 EXPORT_SYMBOL_GPL(pv_time_ops);
-EXPORT_SYMBOL_GPL(pv_cpu_ops);
-EXPORT_SYMBOL_GPL(pv_mmu_ops);
+EXPORT_SYMBOL    (pv_cpu_ops);
+EXPORT_SYMBOL    (pv_mmu_ops);
 EXPORT_SYMBOL_GPL(pv_apic_ops);
 EXPORT_SYMBOL_GPL(pv_info);
 EXPORT_SYMBOL    (pv_irq_ops);

