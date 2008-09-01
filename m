Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYIAQmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYIAQmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYIAQmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:42:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:39407 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbYIAQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:42:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gdvyC0l3bEncnNXS4nRm0H/JzGPkd8CWCZC6z+Fgr73UcE7cn0jVnQFC4DOxKtHvD8
         ga/PIVQsQEo5HxzSsCnrGbLCgxgc6O6Ks9lQAQxsg0WN3yRGQRjrLMMupWOwTeznyglU
         aElWM00LZYpdW89tcNGyDVNN0PSFs5e8E/F5k=
Message-ID: <86802c440809010942k7b789f09t920bbe8140dfea04@mail.gmail.com>
Date: Mon, 1 Sep 2008 09:42:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Krzysztof Helt" <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] x86: move mtrr cpu cap setting early in early_init_xxxx
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Krzysztof Helt" <krzysztof.h1@wp.pl>
In-Reply-To: <20080901181642.14bfb17f.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220242025-15113-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080901181642.14bfb17f.krzysztof.h1@poczta.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2008 at 9:16 AM, Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:
> On Sun, 31 Aug 2008 21:07:05 -0700
> Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> Krzysztof Helt <krzysztof.h1@wp.pl> found mtrr is not detected on k6-2
>>
>> root case:
>>       we move mtrr_bp_init early for mtrr trimming.
>> and in early_detect, only read cap from cpuid, so some cpu doesn't have
>> that bit in cpuid and need to set workaround bit will have problem.
>>
>> need to add early_init_xxxx to preset those bit before mtrr_bp_init
>> for those earlier cpus.
>>
>> this patch is for 2.6.27
>>
>> Reported-by: Krzysztof Helt <krzysztof.h1@wp.pl>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
>>
>> ---
>
> Your patch works only if the the fix below is applied.
>
> Otherwise, the caps set in the early_cpu_init are reset
> in the early_get_cap.
>
> Regards,
> Krzysztof
>
> ---
> From 808cfe180c1400594a01d6229239d4bf01ca4eea Mon Sep 17 00:00:00 2001
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> Date: Tue, 2 Sep 2008 17:29:51 +0200
> Subject: [PATCH] x86: delay early cpu initialization until cpuid is done
>
> Move early cpu initialization after cpu
> early get cap so the early cpu initialization
> can fix up cpu caps.
>
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
>  arch/x86/kernel/cpu/common.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index d3bc82f..f970cbf 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -335,11 +335,11 @@ static void __init early_cpu_detect(void)
>
>        get_cpu_vendor(c, 1);
>
> +       early_get_cap(c);
> +
>        if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
>            cpu_devs[c->x86_vendor]->c_early_init)
>                cpu_devs[c->x86_vendor]->c_early_init(c);
> -
> -       early_get_cap(c);
>  }
>
>  /*

thanks.

Ingo,
[PATCH] x86: delay early cpu initialization until cpuid is done
should be applied before
[PATCH] x86: move mtrr cpu cap setting early in early_init_xxxx

YH
