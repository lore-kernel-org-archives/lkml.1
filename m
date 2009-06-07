Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbZFGW7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbZFGW7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 18:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZFGW71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 18:59:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:63686 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZFGW70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 18:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q+jfYUx+Q32M1GTKYKtILJercwpzYZ6x3APRG8oZmAu/Bp0HxWF79IqvGa8rX2xSlE
         ksDohhFl0MYWxbOO4udntIFc6UrQl3gu0Olw1DiShwaYDADxSV3UaRjJzwwpkZb0U4hS
         q4Vtqt7tMpwpEHt22XN0zZuKdyPI7MVETrvXo=
MIME-Version: 1.0
In-Reply-To: <20090607203951.GF4547@lenovo>
References: <20090607124840.GD4547@lenovo>
	 <tip-103428e57be323c3c5545db8ad12667099bc6005@git.kernel.org>
	 <86802c440906071223w3116f452n7ccd028d52f11c77@mail.gmail.com>
	 <20090607203951.GF4547@lenovo>
Date: Sun, 7 Jun 2009 15:59:28 -0700
Message-ID: <86802c440906071559t7f2139c0s55fd15e8cd669cff@mail.gmail.com>
Subject: Re: [tip:irq/numa] x86, apic: Fix dummy apic read operation together 
	with broken MP handling
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 7, 2009 at 1:39 PM, Cyrill Gorcunov<gorcunov@gmail.com> wrote:
> [Yinghai Lu - Sun, Jun 07, 2009 at 12:23:47PM -0700]
> ...
> | > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> | > index d2e8de9..7c80007 100644
> | > --- a/arch/x86/kernel/smpboot.c
> | > +++ b/arch/x86/kernel/smpboot.c
> | > @@ -992,10 +992,12 @@ static int __init smp_sanity_check(unsigned max_cpus)
> | >         */
> | >        if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
> | >            !cpu_has_apic) {
> | > -               printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
> | > -                       boot_cpu_physical_apicid);
> | > -               printk(KERN_ERR "... forcing use of dummy APIC emulation."
> | > +               if (!disable_apic) {
> | > +                       pr_err("BIOS bug, local APIC #%d not detected!...\n",
> | > +                               boot_cpu_physical_apicid);
> | > +                       pr_err("... forcing use of dummy APIC emulation."
> | >                                "(tell your hw vendor)\n");
> | > +               }
> |
> | It seems we don't need this check here.
> | when we have disable_apic, cpu_has_apic is cleared forcely.
> |
> | YH
> |
>
> No Yinghai, it's needed. The check is for !disable_apic
> and if we really has a BIOS bug we should report about
> it _only_ in case if it's a bios bug not apic being
> disabled via boot line. I could be missing something
> of course. Rechecking...
>
> Ah, I remember the scenario I've kept in mind while
> was cooking the patch.
>
> 1) MP apic entry is broken.
> 2) apic was disabled via boot option.
> 3) kernel compiled with smp support.
>
> So we have the calls
>
> init_apic_mappings
>                (due to boot option)
>                apic_disable()
>        (due to broken MP)
>        apic_version[new_apicid] = 0
> smp_sanity_check
>        if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
>            !cpu_has_apic) {
> Stop! So APIC_INTEGRATED returns false now regargless of what
> really we have on HW level. Darn! Actually I was in idea
> this if() should be true so SMP support will be turned _off_.

in Ingo' case:
before that check
        /*
         * If we couldn't find an SMP configuration at boot time,
         * get out of here now!
         */
        if (!smp_found_config && !acpi_lapic) {
                preempt_enable();
                printk(KERN_NOTICE "SMP motherboard not detected.\n");
                disable_smp();
                if (APIC_init_uniprocessor())
                        printk(KERN_NOTICE "Local APIC not detected."
                                           " Using dummy APIC emulation.\n");
                return -1;
        }

will get out earlier.



>
> Yinghai, I think we need to set apic_version[boot_cpu_physical_apicid]
> to 0xf0 in case if apic is disabled via cmdline option together with
> broken MP. Thoughts?

should be other case:
when MADT is right, but disablelapic is used.
will get cpu_has_apic == 0, and we are not using dummy apic read/write.

so don't need to check
        /*
         * If we couldn't find a local APIC, then get out of here now!
         */
        if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
            !cpu_has_apic) {
                if (!disable_apic) {
                        pr_err("BIOS bug, local APIC #%d not detected!...\n",
                                boot_cpu_physical_apicid);
                        pr_err("... forcing use of dummy APIC emulation."
                                "(tell your hw vendor)\n");
                }
                smpboot_clear_io_apic();
                arch_disable_smp_support();
                return -1;
        }

>
> To Ingo: this !disable_apic will be needed if Yinghai confirm
> that my idea is right. Meanwhile -- it's just an always-true
> cpu consuming operation. So should not be harming. But sorry
> anyway -- was thinking about one way but reached another.

YH
