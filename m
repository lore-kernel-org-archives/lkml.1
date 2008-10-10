Return-Path: <linux-kernel-owner+w=401wt.eu-S1751312AbYJJEiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbYJJEiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 00:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYJJEiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 00:38:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:10976 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYJJEiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 00:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rowsY8wcp9zh5uypPXMSlneBSOr1dpyDNePQZ12AdEm9T3/y/uOWV9iw+qBtpImyEr
         FAcduEXTWO7/Ok9v8nyQiXUhrJ4R3V2ruouT9Db0rNVAMsbs5JtjQUOjF/Fc/VFzAw82
         yCFl06frJdL+x9wmesFWCNx+qRYDVU8H4mYQM=
Message-ID: <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com>
Date: Fri, 10 Oct 2008 08:38:07 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Venki Pallipadi" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081010002203.GA23238@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010002203.GA23238@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 4:22 AM, Venki Pallipadi
<venkatesh.pallipadi@intel.com> wrote:
>
> Fix a typo in x86 apic.c CONFG_X86_64 -> CONFIG_X86_64.
> The intention looks like was to have divisor of 1 on x86_64 kernel.
>
> Also, for DIVISOR value of 1 to work, APIC_TDR_DIV should also change
> depending on divide by 1 or divide by 16 is used.
>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
> ---
>  arch/x86/kernel/apic.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> Index: tip/arch/x86/kernel/apic.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/apic.c     2008-10-09 17:12:39.000000000 -0700
> +++ tip/arch/x86/kernel/apic.c  2008-10-09 17:13:29.000000000 -0700
> @@ -332,10 +332,12 @@ int lapic_get_maxlvt(void)
>  */
>
>  /* Clock divisor */
> -#ifdef CONFG_X86_64
> +#ifdef CONFIG_X86_64
>  #define APIC_DIVISOR 1
> +#define APIC_TDR_DIV APIC_TDR_DIV_1
>  #else
>  #define APIC_DIVISOR 16
> +#define APIC_TDR_DIV APIC_TDR_DIV_16
>  #endif
>
>  /*
> @@ -369,7 +371,7 @@ static void __setup_APIC_LVTT(unsigned i
>        tmp_value = apic_read(APIC_TDCR);
>        apic_write(APIC_TDCR,
>                (tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
> -               APIC_TDR_DIV_16);
> +               APIC_TDR_DIV);
>
>        if (!oneshot)
>                apic_write(APIC_TMICT, clocks / APIC_DIVISOR);
>

Hi Venki,

you know I don't have code under my hands now to take a look on
(i'm in office now) -- but if I recall correctly it's not a typo :) By
writting (1) instead of (16) you make counter decrease faster by
16 times (if to compare with what we have now). So we could get
counter underflow before we've finish calibration. That is was the
original intension of this 16 divisor being used. Did you test this
patch?
