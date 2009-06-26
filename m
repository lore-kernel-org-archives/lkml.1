Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbZFZVWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbZFZVWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 17:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZFZVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 17:21:53 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:59253 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZFZVVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 17:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V93LbOqtDkYiim2rHIIBPJeI9t7ix7Ooh0TYrSRrdZ1a03Da85z1xuSbnHXFBKSK/n
         jwKyn1yLkb7W9aZJP77bpx4O4WH6yqphvGCghxzRGkiTBKElKsG2VQ0YZyCMlDSE45JP
         8EkqTrjxGfXXWWzBvfcghGZsrXG/MvNaiNTiY=
MIME-Version: 1.0
In-Reply-To: <43F901BD926A4E43B106BF17856F07556412B7E7@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07556412B7E7@orsmsx508.amr.corp.intel.com>
Date: Fri, 26 Jun 2009 14:21:54 -0700
Message-ID: <86802c440906261421g77fd0e50j7dfdbbdcc7c0b8eb@mail.gmail.com>
Subject: Re: [PATCH 8/9] x86/apic: match destination id with destination mode
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 5:15 PM, Pan, Jacob jun<jacob.jun.pan@intel.com> wrote:
> From 791a44040dde6670f90a729cf91ed302d84b875a Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Tue, 12 May 2009 10:51:08 -0700
> Subject: [PATCH] x86/apic: match destination id with destination mode
>
> current code assigns logical destination IDs regardless of destination modes, this is not a problem since we only use logical delivery so far. but it could be a problem with platforms only supports physical mode
>
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |   27 +++++++++++++++++++--------
>  1 files changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 4d0216f..c84dc3d 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1431,7 +1431,10 @@ int setup_ioapic_entry(int apic_id, int irq,
>        } else {
>                entry->delivery_mode = apic->irq_delivery_mode;
>                entry->dest_mode = apic->irq_dest_mode;
> -               entry->dest = destination;
> +               if (apic->irq_dest_mode)
> +                       entry->dest = destination;
> +               else    /* physical ID of BSP */
> +                       entry->dest = boot_cpu_id;
>                entry->vector = vector;
>        }
>
> @@ -1576,7 +1579,10 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
>         */
>        entry.dest_mode = apic->irq_dest_mode;
>        entry.mask = 0;                 /* don't mask IRQ for edge */
> -       entry.dest = apic->cpu_mask_to_apicid(apic->target_cpus());
> +       if (!apic->irq_dest_mode)
> +               entry.dest = boot_cpu_id;       /* physical apic id */
> +       else
> +               entry.dest = apic->cpu_mask_to_apicid(apic->target_cpus());
>        entry.delivery_mode = apic->irq_delivery_mode;
>        entry.polarity = 0;
>        entry.trigger = 0;
> @@ -2343,7 +2349,8 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
>        dest = set_desc_affinity(desc, mask);
>        if (dest != BAD_APICID) {
>                /* Only the high 8 bits are valid. */
> -               dest = SET_APIC_LOGICAL_ID(dest);
> +               if (apic->irq_dest_mode)
> +                       dest = SET_APIC_LOGICAL_ID(dest);
>                __target_IO_APIC_irq(irq, dest, cfg);
>                ret = 0;
>        }
> @@ -3273,9 +3280,11 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
>        err = assign_irq_vector(irq, cfg, apic->target_cpus());
>        if (err)
>                return err;
> -
> -       dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
> -
> +       if (apic->irq_dest_mode)
> +               dest = apic->cpu_mask_to_apicid_and(cfg->domain,
> +                                               apic->target_cpus());
> +       else
> +               dest = boot_cpu_id;
>        if (irq_remapped(irq)) {
>                struct irte irte;
>                int ir_index;
> @@ -3339,8 +3348,10 @@ static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
>        struct irq_cfg *cfg;
>        struct msi_msg msg;
>        unsigned int dest;
> -
> -       dest = set_desc_affinity(desc, mask);
> +       if (apic->irq_dest_mode)
> +               dest = set_desc_affinity(desc, mask);
> +       else
> +               dest = boot_cpu_id;
>        if (dest == BAD_APICID)
>                return -1;
>

for physical flat mode

apic->cpu_mask_to_apicid() is

static unsigned int physflat_cpu_mask_to_apicid(const struct cpumask *cpumask)
{
        int cpu;

        /*
         * We're using fixed IRQ delivery, can only return one phys APIC ID.
         * May as well be the first.
         */
        cpu = cpumask_first(cpumask);
        if ((unsigned)cpu < nr_cpu_ids)
                return per_cpu(x86_cpu_to_apicid, cpu);
        else
                return BAD_APICID;
}


so this patch will put all ioapic routing to boot_cpu_id what is that?
how can you assume that is is apic id.?
that is NOT apic id.

the patch is totally wrong.

Nacked-by: Yinghai Lu <yinghai@kernel.org>


YH
