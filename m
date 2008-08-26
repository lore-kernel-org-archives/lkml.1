Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYHZHGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYHZHGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 03:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYHZHFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 03:05:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:7582 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbYHZHFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 03:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WsKPcYkOXwMjRdSaBOe4+3ai3VmIo4kYOVFiYjf14A5t83y3h1sHQSEEJyJ3E2eTL8
         A8w214Jb2XyWnWf6c46NyDEZ3M+dnpXB5NYHlqCqxeJzA3/n5ycdDFRmsZDcDz2cn1K5
         ysQvuT7zpXAVtxS1H6hbvwORtlU0e3WUZvu+E=
Message-ID: <21d7e9970808260005g14ec71e9xfa584780498a86e7@mail.gmail.com>
Date: Tue, 26 Aug 2008 17:05:48 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: venkatesh.pallipadi@intel.com
Subject: Re: [patch 3/4] x86: PAT Update validate_pat_support for intel CPUs
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
In-Reply-To: <20080820234604.592277000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080820234550.923970000@intel.com>
	 <20080820234604.592277000@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 9:45 AM,  <venkatesh.pallipadi@intel.com> wrote:
> Pentium III and Core Solo/Duo CPUs have an erratum
> " Page with PAT set to WC while associated MTRR is UC may consolidate to UC "
> which can result in WC setting in PAT to be ineffective. We will disable
> PAT on such CPUs, so that we can continue to use MTRR WC setting.
>

IMHO this seems like a bit hammer with which to squash this nut.

I really need PAT support for upcoming GPU stuff, esp where I have
pages of RAM allocated into a
GART and I want write-combined access to them. These pages will
physically me under a write-back MTRR, with a WC PAT entry
on the PTE mappings.

Can we not just be smarter and fix this when we know we have a UC MTRR
and a WC PAT mapping inside it?

Dave.

> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
> ---
>  arch/x86/kernel/cpu/addon_cpuid_features.c |   17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> Index: tip/arch/x86/kernel/cpu/addon_cpuid_features.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/cpu/addon_cpuid_features.c 2008-08-20 14:25:18.000000000 -0700
> +++ tip/arch/x86/kernel/cpu/addon_cpuid_features.c      2008-08-20 14:26:39.000000000 -0700
> @@ -56,9 +56,22 @@ void __cpuinit validate_pat_support(stru
>
>        switch (c->x86_vendor) {
>        case X86_VENDOR_INTEL:
> -               if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
> +               /*
> +                * There is a known erratum on Pentium III and Core Solo
> +                * and Core Duo CPUs.
> +                * " Page with PAT set to WC while associated MTRR is UC
> +                *   may consolidate to UC "
> +                * Because of this erratum, it is better to stick with
> +                * setting WC in MTRR rather than using PAT on these CPUs.
> +                *
> +                * Enable PAT WC only on P4, Core 2 or later CPUs.
> +                */
> +               if (c->x86 > 0x6 || (c->x86 == 6 && c->x86_model >= 15))
>                        return;
> -               break;
> +
> +               pat_disable("PAT WC disabled due to known CPU erratum.");
> +               return;
> +
>        case X86_VENDOR_AMD:
>        case X86_VENDOR_CENTAUR:
>        case X86_VENDOR_TRANSMETA:
>
> --
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
