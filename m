Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZFGUkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZFGUkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 16:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbZFGUjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 16:39:54 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:32949 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbZFGUjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 16:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Quo3PD3sdLLmoGS/cSnXppCUYChRc8KcBSfUeqUStN9BYdACpjQX7KQs5WQHP30d90
         Ww1jOnzzQmOcyfoX0v4OSzBqg+6e9H99zfxOZEPNbEnBV+l6G8ALheNzxcuINsh02nPV
         DKwpewRK3rAf2sPba4aVarvuY3SYezc2khoFo=
Date: Mon, 8 Jun 2009 00:39:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86, apic: Fix dummy apic read operation
	together with broken MP handling
Message-ID: <20090607203951.GF4547@lenovo>
References: <20090607124840.GD4547@lenovo> <tip-103428e57be323c3c5545db8ad12667099bc6005@git.kernel.org> <86802c440906071223w3116f452n7ccd028d52f11c77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440906071223w3116f452n7ccd028d52f11c77@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Sun, Jun 07, 2009 at 12:23:47PM -0700]
...
| > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
| > index d2e8de9..7c80007 100644
| > --- a/arch/x86/kernel/smpboot.c
| > +++ b/arch/x86/kernel/smpboot.c
| > @@ -992,10 +992,12 @@ static int __init smp_sanity_check(unsigned max_cpus)
| >         */
| >        if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
| >            !cpu_has_apic) {
| > -               printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
| > -                       boot_cpu_physical_apicid);
| > -               printk(KERN_ERR "... forcing use of dummy APIC emulation."
| > +               if (!disable_apic) {
| > +                       pr_err("BIOS bug, local APIC #%d not detected!...\n",
| > +                               boot_cpu_physical_apicid);
| > +                       pr_err("... forcing use of dummy APIC emulation."
| >                                "(tell your hw vendor)\n");
| > +               }
| 
| It seems we don't need this check here.
| when we have disable_apic, cpu_has_apic is cleared forcely.
| 
| YH
| 

No Yinghai, it's needed. The check is for !disable_apic
and if we really has a BIOS bug we should report about
it _only_ in case if it's a bios bug not apic being
disabled via boot line. I could be missing something
of course. Rechecking...

Ah, I remember the scenario I've kept in mind while
was cooking the patch.

1) MP apic entry is broken.
2) apic was disabled via boot option.
3) kernel compiled with smp support.

So we have the calls

init_apic_mappings
		(due to boot option)
		apic_disable()
	(due to broken MP)
	apic_version[new_apicid] = 0
smp_sanity_check
	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
	    !cpu_has_apic) {
Stop! So APIC_INTEGRATED returns false now regargless of what
really we have on HW level. Darn! Actually I was in idea
this if() should be true so SMP support will be turned _off_.

Yinghai, I think we need to set apic_version[boot_cpu_physical_apicid]
to 0xf0 in case if apic is disabled via cmdline option together with
broken MP. Thoughts?

To Ingo: this !disable_apic will be needed if Yinghai confirm
that my idea is right. Meanwhile -- it's just an always-true
cpu consuming operation. So should not be harming. But sorry
anyway -- was thinking about one way but reached another.

	-- Cyrill
