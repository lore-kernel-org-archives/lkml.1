Return-Path: <linux-kernel-owner+w=401wt.eu-S965529AbXDVIJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbXDVIJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965533AbXDVIJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:09:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965529AbXDVIJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:09:23 -0400
Date: Sun, 22 Apr 2007 01:09:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Fix potential overflow in perfctr reservation
Message-Id: <20070422010917.6427e7a2.akpm@linux-foundation.org>
In-Reply-To: <200704172359.l3HNxAMV024586@hera.kernel.org>
References: <200704172359.l3HNxAMV024586@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 23:59:10 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1714f9bfc92d6ee67e84127332a1fae27772acfe
> Commit:     1714f9bfc92d6ee67e84127332a1fae27772acfe
> Parent:     08269c6d38e003adb12f55c6d795daa89bdc1bae
> Author:     Andi Kleen <ak@suse.de>
> AuthorDate: Mon Apr 16 10:30:27 2007 +0200
> Committer:  Andi Kleen <andi@basil.nowhere.org>
> CommitDate: Mon Apr 16 10:30:27 2007 +0200
> 
>     [PATCH] x86: Fix potential overflow in perfctr reservation
>     
>     While reviewing this code again I found a potential overflow of the bitmap.
>     The p4 oprofile can theoretically set bits beyond the reservation bitmap for
>     specific configurations. Avoid that by sizing the bitmaps properly.
>     
>     Signed-off-by: Andi Kleen <ak@suse.de>
> ---
>  arch/i386/kernel/nmi.c   |    9 +++++----
>  arch/x86_64/kernel/nmi.c |   10 ++++++----
>  2 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
> index a98ba88..9f1e8c1 100644
> --- a/arch/i386/kernel/nmi.c
> +++ b/arch/i386/kernel/nmi.c
> @@ -41,16 +41,17 @@ int nmi_watchdog_enabled;
>   *   different subsystems this reservation system just tries to coordinate
>   *   things a little
>   */
> -static DEFINE_PER_CPU(unsigned long, perfctr_nmi_owner);
> -static DEFINE_PER_CPU(unsigned long, evntsel_nmi_owner[3]);
> -
> -static cpumask_t backtrace_mask = CPU_MASK_NONE;
>  
>  /* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
>   * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
>   */
>  #define NMI_MAX_COUNTER_BITS 66
> +#define NMI_MAX_COUNTER_LONGS BITS_TO_LONGS(NMI_MAX_COUNTER_BITS)
>  
> +static DEFINE_PER_CPU(unsigned long, perfctr_nmi_owner[NMI_MAX_COUNTER_LONGS]);
> +static DEFINE_PER_CPU(unsigned long, evntsel_nmi_owner[NMI_MAX_COUNTER_LONGS]);
> +
> +static cpumask_t backtrace_mask = CPU_MASK_NONE;
>  /* nmi_active:
>   * >0: the lapic NMI watchdog is active, but can be disabled
>   * <0: the lapic NMI watchdog has not been set up, and cannot

The created a warning storm:


arch/i386/kernel/nmi.c: In function 'avail_to_resrv_perfctr_nmi_bit':
arch/i386/kernel/nmi.c:129: warning: passing argument 2 of 'constant_test_bit' from incompatible pointer type
arch/i386/kernel/nmi.c:129: warning: passing argument 2 of 'variable_test_bit' from incompatible pointer type
arch/i386/kernel/nmi.c: In function 'avail_to_resrv_perfctr_nmi':
arch/i386/kernel/nmi.c:145: warning: passing argument 2 of 'constant_test_bit' from incompatible pointer type
arch/i386/kernel/nmi.c:145: warning: passing argument 2 of 'variable_test_bit' from incompatible pointer type
arch/i386/kernel/nmi.c: In function '__reserve_perfctr_nmi':
arch/i386/kernel/nmi.c:160: warning: passing argument 2 of 'test_and_set_bit' from incompatible pointer type
arch/i386/kernel/nmi.c: In function '__release_perfctr_nmi':
arch/i386/kernel/nmi.c:174: warning: passing argument 2 of 'clear_bit' from incompatible pointer type

diff -puN arch/i386/kernel/nmi.c~fix-x86-fix-potential-overflow-in-perfctr-reservation arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~fix-x86-fix-potential-overflow-in-perfctr-reservation
+++ a/arch/i386/kernel/nmi.c
@@ -126,7 +126,7 @@ int avail_to_resrv_perfctr_nmi_bit(unsig
 	int cpu;
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 	for_each_possible_cpu (cpu) {
-		if (test_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)))
+		if (test_bit(counter, per_cpu(perfctr_nmi_owner, cpu)))
 			return 0;
 	}
 	return 1;
@@ -142,7 +142,7 @@ int avail_to_resrv_perfctr_nmi(unsigned 
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
 	for_each_possible_cpu (cpu) {
-		if (test_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)))
+		if (test_bit(counter, per_cpu(perfctr_nmi_owner, cpu)))
 			return 0;
 	}
 	return 1;
@@ -157,7 +157,7 @@ static int __reserve_perfctr_nmi(int cpu
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	if (!test_and_set_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)))
+	if (!test_and_set_bit(counter, per_cpu(perfctr_nmi_owner, cpu)))
 		return 1;
 	return 0;
 }
@@ -171,7 +171,7 @@ static void __release_perfctr_nmi(int cp
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	clear_bit(counter, &per_cpu(perfctr_nmi_owner, cpu));
+	clear_bit(counter, per_cpu(perfctr_nmi_owner, cpu));
 }
 
 int reserve_perfctr_nmi(unsigned int msr)
_


I worry rather a lot about how well runtime tested this very late change
was, and whether it works correctly even with this fix applied.  Perhaps
we should jsut revert?

