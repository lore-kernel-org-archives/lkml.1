Return-Path: <linux-kernel-owner+w=401wt.eu-S1764733AbXJXQsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764733AbXJXQsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760349AbXJXQ0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:26:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32784 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760333AbXJXQ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:26:44 -0400
Date: Wed, 24 Oct 2007 18:27:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Garzik <jeff@garzik.org>, lenb@kernel.org, mingo@redhat.com,
       hpa@zytor.com
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-acpi@vger.kernel.org
Subject: [2.6 patch] x86/kernel/acpi/processor.c: fix SMP=n warning
Message-ID: <20071024162713.GQ30533@stusta.de>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 06:36:33PM -0400, Jeff Garzik wrote:
> Fix !CONFIG_SMP warning:
> 
> arch/x86/kernel/acpi/processor.c: In function ‘arch_acpi_processor_init_pdc’:
> arch/x86/kernel/acpi/processor.c:65: warning: unused variable ‘cpu’
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
> Ideally this warning should be hidden inside a wrapper or somesuch, to
> camouflage the unneeded argument in !SMP case.
> 
> diff --git a/arch/x86/kernel/acpi/processor.c b/arch/x86/kernel/acpi/processor.c
> index 2ed0a4c..45e262a 100644
> --- a/arch/x86/kernel/acpi/processor.c
> +++ b/arch/x86/kernel/acpi/processor.c
> @@ -62,7 +62,9 @@ static void init_intel_pdc(struct acpi_processor *pr, struct cpuinfo_x86 *c)
>  /* Initialize _PDC data based on the CPU vendor */
>  void arch_acpi_processor_init_pdc(struct acpi_processor *pr)
>  {
> +#ifdef CONFIG_SMP
>  	unsigned int cpu = pr->id;
> +#endif
>...

The #ifdef is ugly.

What about the patch below instead?

cu
Adrian


<--  snip  -->



This patch fixes the following warning with CONFIG_SMP=n:

<--  snip  -->

...
arch/x86/kernel/acpi/processor.c: In function `arch_acpi_processor_init_pdc':
arch/x86/kernel/acpi/processor.c:65: warning: unused variable `cpu'
...

<--  snip  -->

Based on a patch by Jeff Garzik.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
96d83d412fb6530173110c872f1125ae21938a99 
diff --git a/arch/x86/kernel/acpi/processor.c b/arch/x86/kernel/acpi/processor.c
index 2ed0a4c..f63e5ff 100644
--- a/arch/x86/kernel/acpi/processor.c
+++ b/arch/x86/kernel/acpi/processor.c
@@ -62,8 +62,7 @@ static void init_intel_pdc(struct acpi_processor *pr, struct cpuinfo_x86 *c)
 /* Initialize _PDC data based on the CPU vendor */
 void arch_acpi_processor_init_pdc(struct acpi_processor *pr)
 {
-	unsigned int cpu = pr->id;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct cpuinfo_x86 *c = &cpu_data(pr->id);
 
 	pr->pdc = NULL;
 	if (c->x86_vendor == X86_VENDOR_INTEL)

