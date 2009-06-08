Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbZFHPQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbZFHPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZFHPQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:16:49 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:60371 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZFHPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:16:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=cH2fPeIvXEbaZ+lr1Gy7rH0K1EBRRdT3ijyNQk9s2wkIAj2MEGg4ANHR9f8klh9JW4
         H3SeTrFrZZTr6us0Qnpl8GIYIXIZtf4g1AATMG72ohyzjGrmjto2zm2pEwtX6iDN5eKf
         ryImGANzNncYh95V+aHlCaY7mh4k96lpAKGwo=
Date: Mon, 8 Jun 2009 19:16:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86, apic: Fix dummy apic read operation
	together with broken MP handling
Message-ID: <20090608151646.GB5015@lenovo>
References: <20090607124840.GD4547@lenovo> <tip-103428e57be323c3c5545db8ad12667099bc6005@git.kernel.org> <86802c440906071223w3116f452n7ccd028d52f11c77@mail.gmail.com> <20090607203951.GF4547@lenovo> <86802c440906071559t7f2139c0s55fd15e8cd669cff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440906071559t7f2139c0s55fd15e8cd669cff@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Sun, Jun 07, 2009 at 03:59:28PM -0700]
| On Sun, Jun 7, 2009 at 1:39 PM, Cyrill Gorcunov<gorcunov@gmail.com> wrote:
| > [Yinghai Lu - Sun, Jun 07, 2009 at 12:23:47PM -0700]
| > ...
| > | > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
| > | > index d2e8de9..7c80007 100644
| > | > --- a/arch/x86/kernel/smpboot.c
| > | > +++ b/arch/x86/kernel/smpboot.c
| > | > @@ -992,10 +992,12 @@ static int __init smp_sanity_check(unsigned max_cpus)
| > | >         */
| > | >        if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
| > | >            !cpu_has_apic) {
| > | > -               printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
| > | > -                       boot_cpu_physical_apicid);
| > | > -               printk(KERN_ERR "... forcing use of dummy APIC emulation."
| > | > +               if (!disable_apic) {
| > | > +                       pr_err("BIOS bug, local APIC #%d not detected!...\n",
| > | > +                               boot_cpu_physical_apicid);
| > | > +                       pr_err("... forcing use of dummy APIC emulation."
| > | >                                "(tell your hw vendor)\n");
| > | > +               }
| > |
| > | It seems we don't need this check here.
| > | when we have disable_apic, cpu_has_apic is cleared forcely.
| > |
| > | YH
| > |
| >
| > No Yinghai, it's needed. The check is for !disable_apic
| > and if we really has a BIOS bug we should report about
| > it _only_ in case if it's a bios bug not apic being
| > disabled via boot line. I could be missing something
| > of course. Rechecking...
| >
| > Ah, I remember the scenario I've kept in mind while
| > was cooking the patch.
| >
| > 1) MP apic entry is broken.
| > 2) apic was disabled via boot option.
| > 3) kernel compiled with smp support.
| >
| > So we have the calls
| >
| > init_apic_mappings
| >                (due to boot option)
| >                apic_disable()
| >        (due to broken MP)
| >        apic_version[new_apicid] = 0
| > smp_sanity_check
| >        if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
| >            !cpu_has_apic) {
| > Stop! So APIC_INTEGRATED returns false now regargless of what
| > really we have on HW level. Darn! Actually I was in idea
| > this if() should be true so SMP support will be turned _off_.
| 
| in Ingo' case:
| before that check
|         /*
|          * If we couldn't find an SMP configuration at boot time,
|          * get out of here now!
|          */
|         if (!smp_found_config && !acpi_lapic) {
|                 preempt_enable();
|                 printk(KERN_NOTICE "SMP motherboard not detected.\n");
|                 disable_smp();
|                 if (APIC_init_uniprocessor())
|                         printk(KERN_NOTICE "Local APIC not detected."
|                                            " Using dummy APIC emulation.\n");
|                 return -1;
|         }
| 
| will get out earlier.
| 

Yeah, I've been just messed with the number of options.
We dont have smp_found_config set in this case.

| 
| 
| >
| > Yinghai, I think we need to set apic_version[boot_cpu_physical_apicid]
| > to 0xf0 in case if apic is disabled via cmdline option together with
| > broken MP. Thoughts?
| 
| should be other case:
| when MADT is right, but disablelapic is used.
| will get cpu_has_apic == 0, and we are not using dummy apic read/write.
| 
| so don't need to check
|         /*
|          * If we couldn't find a local APIC, then get out of here now!
|          */
|         if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
|             !cpu_has_apic) {
|                 if (!disable_apic) {
|                         pr_err("BIOS bug, local APIC #%d not detected!...\n",
|                                 boot_cpu_physical_apicid);
|                         pr_err("... forcing use of dummy APIC emulation."
|                                 "(tell your hw vendor)\n");
|                 }
|                 smpboot_clear_io_apic();
|                 arch_disable_smp_support();
|                 return -1;
|         }

Interesting scenario indeed. So we have the calls chain

start_kernel
  setup_arch
    setup_disableapic
    init_apic_mappings
kernel_init
  smp_prepare_cpus
    smp_sanity_check (have reached with disable_apic=1, !cpu_has_apic)
	...
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
	...

There we should disable smp support. I think we could
do this check in verify_local_APIC and return error code
and jump back to disable smp ops. We could not just remove
this check since cpu_has_apic could be cleared without
explicit apic disablement. Will cook a RFC for this case.

| 
| >
| > To Ingo: this !disable_apic will be needed if Yinghai confirm
| > that my idea is right. Meanwhile -- it's just an always-true
| > cpu consuming operation. So should not be harming. But sorry
| > anyway -- was thinking about one way but reached another.
| 
| YH
| 
	-- Cyrill
