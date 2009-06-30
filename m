Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbZF3HS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbZF3HS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZF3HSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:18:17 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:35468 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZF3HSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:18:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=REHP6ugK8PLu5MkUorw5CZlGxEYT4obFcXkoZoJJnxFGk7Qvx7hg5J7QnLLnVe515L
         9OI34lG/0qpH35mMDX5lhNYHiI6HCEAur+JSQudfr3Af/MUDR7SntDmFRUC6lmD8WH2/
         NDH7b9zQDSOcELh4MxnPV1nwBQ6iRgk5P6ViU=
MIME-Version: 1.0
In-Reply-To: <20090630064515.GG20289@redhat.com>
References: <20090630064515.GG20289@redhat.com>
Date: Tue, 30 Jun 2009 00:18:19 -0700
Message-ID: <86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com>
Subject: Re: [PATCH v4] enable x2APIC without interrupt remapping under KVM
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 11:45 PM, Gleb Natapov<gleb@redhat.com> wrote:
> KVM would like to provide x2APIC interface to a guest without emulating
> interrupt remapping device. The reason KVM prefers guest to use x2APIC
> is that x2APIC interface is better virtualizable and provides better
> performance than mmio xAPIC interface:
>
> - msr exits are faster than mmio (no page table walk, emulation)
> - no need to read back ICR to look at the busy bit
> - one 64 bit ICR write instead of two 32 bit writes
> - shared code with the Hyper-V paravirt interface
>
> Included patch changes x2APIC enabling logic to enable it even if IR
> initialization failed, but kernel runs under KVM and no apic id is
> greater than 255 (if there is one spec requires BIOS to move to x2apic
> mode before starting an OS).
>
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 8c7c042..351d55a 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -49,6 +49,7 @@
>  #include <asm/mtrr.h>
>  #include <asm/smp.h>
>  #include <asm/mce.h>
> +#include <asm/kvm_para.h>
>
>  unsigned int num_processors;
>
> @@ -1363,52 +1364,75 @@ void enable_x2apic(void)
>  }
>  #endif /* CONFIG_X86_X2APIC */
>
> -void __init enable_IR_x2apic(void)
> +int __init enable_IR(void)
>  {
>  #ifdef CONFIG_INTR_REMAP
>        int ret;
> -       unsigned long flags;
> -       struct IO_APIC_route_entry **ioapic_entries = NULL;
>
>        ret = dmar_table_init();
>        if (ret) {
>                pr_debug("dmar_table_init() failed with %d:\n", ret);
> -               goto ir_failed;
> +               return 0;
>        }
>
>        if (!intr_remapping_supported()) {
>                pr_debug("intr-remapping not supported\n");
> -               goto ir_failed;
> +               return 0;
>        }
>
> -
>        if (!x2apic_preenabled && skip_ioapic_setup) {
>                pr_info("Skipped enabling intr-remap because of skipping "
>                        "io-apic setup\n");
> -               return;
> +               return 0;
>        }
>
> +       if (enable_intr_remapping(x2apic_supported()))
> +               return 0;
> +
> +       pr_info("Enabled Interrupt-remapping\n");
> +
> +       return 1;
> +
> +#endif
> +       return 0;
> +}
> +
> +void __init enable_IR_x2apic(void)
> +{
> +       unsigned long flags;
> +       struct IO_APIC_route_entry **ioapic_entries = NULL;
> +       int ret, x2apic_enabled = 0;
> +
>        ioapic_entries = alloc_ioapic_entries();
>        if (!ioapic_entries) {
> -               pr_info("Allocate ioapic_entries failed: %d\n", ret);
> -               goto end;
> +                pr_info("Allocate ioapic_entries failed\n");
> +                goto out;
>        }
>
>        ret = save_IO_APIC_setup(ioapic_entries);
>        if (ret) {
>                pr_info("Saving IO-APIC state failed: %d\n", ret);
> -               goto end;
> +               goto out;
>        }
>
>        local_irq_save(flags);
> -       mask_IO_APIC_setup(ioapic_entries);
>        mask_8259A();
> +       mask_IO_APIC_setup(ioapic_entries);
>
> -       ret = enable_intr_remapping(x2apic_supported());
> -       if (ret)
> -               goto end_restore;
> +       ret = enable_IR();
> +       if (!ret) {
> +               /* IR is required if x2apic is enabled by BIOS even
> +                * when running in kvm since this indicates present
> +                * of APIC ID > 255 */
> +               if (x2apic_preenabled || !kvm_para_available())
> +                       goto nox2apic;
> +               else
> +                       /* without IR all CPUs can be addressed by IOAPIC/MSI
> +                        * only in physical mode */
> +                       x2apic_phys = 1;
> +       }

how about kexec second kernel in KVM ?

x2apic_preenabled will be set in second kernel.

YH
