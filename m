Return-Path: <linux-kernel-owner+w=401wt.eu-S1765456AbYBUTyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765456AbYBUTyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYBUTyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:54:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:8948 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbYBUTyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:54:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cpk3cRPbFsYm/JJr7yCuzUWU0UCd4IlYBAoVvf9PZfQvsb7gaTeWAA38IcZdbGzvTL5yHPt8wiQCzJRN/bnzAaeKs6n1HRZeXai+Ryk+NIMFEUaRwJeoiGjIuI3v8t0NBZrSuAaYxUhum+GcO1jbseBiVf3YumXIdOjs9k4rQrA=
Message-ID: <86802c440802211154h28ef0170m59c42bdd8de76358@mail.gmail.com>
Date: Thu, 21 Feb 2008 11:54:00 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: Re: [PATCH] X86: don't print a warning when MTRR are blank and running in KVM
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1203605414-4958-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203605414-4958-1-git-send-email-joerg.roedel@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 6:50 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Inside a KVM virtual machine the MTRRs are usually blank. This confuses Linux
>  and causes a warning message at boot. This patch removes that warning message
>  when running Linux as a KVM guest.
>
>  Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>  ---
>   arch/x86/kernel/cpu/mtrr/main.c |    7 +++++--
>   1 files changed, 5 insertions(+), 2 deletions(-)
>
>  diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
>  index b6e136f..47e624c 100644
>  --- a/arch/x86/kernel/cpu/mtrr/main.c
>  +++ b/arch/x86/kernel/cpu/mtrr/main.c
>  @@ -43,6 +43,7 @@
>   #include <asm/uaccess.h>
>   #include <asm/processor.h>
>   #include <asm/msr.h>
>  +#include <asm/kvm_para.h>
>   #include "mtrr.h"
>
>   u32 num_var_ranges = 0;
>  @@ -687,12 +688,14 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
>         }
>
>         /* kvm/qemu doesn't have mtrr set right, don't trim them all */
>  -       if (!highest_pfn) {
>  +       if (!highest_pfn && !kvm_para_available()) {
>                 printk(KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
>                 WARN_ON(1);
>  -               return 0;
>         }
>
>  +       if (!highest_pfn)
>  +               return 0;
>  +
>         if (highest_pfn < end_pfn) {
>                 printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
>                         " all of memory, losing %luMB of RAM.\n",
>  --
>  1.5.3.7
>

Doest that WARN_ON(1) hurt?

or you may do some patch in qemu too.

so
        rdmsr(MTRRdefType_MSR, def, dummy);
        def &= 0xff;
        if (def != MTRR_TYPE_UNCACHABLE)
                return 0;

is happy out.

or set those MTRR entries in qemu...

YH
