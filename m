Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbYBKIad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbYBKIad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 03:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYBKIaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 03:30:25 -0500
Received: from www.tglx.de ([62.245.132.106]:54348 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbYBKIaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:30:24 -0500
Date: Mon, 11 Feb 2008 09:30:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] Only do century BCD conversion when we know the
 RTC is BCD
In-Reply-To: <20080209416.271135970@suse.de>
Message-ID: <alpine.LFD.1.00.0802110924050.12988@apollo.tec.linutronix.de>
References: <20080209416.271135970@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Andi Kleen wrote:

> 
> Minor logic fix. The century change was previously always BCD,
> even when the CMOS data would report itself not being BCD.

I checked that whole rtc / BCD logic again. We always set RTC_ALWAYS_BCD:

#ifndef RTC_PORT
#define RTC_PORT(x)    (0x70 + (x))
#define RTC_ALWAYS_BCD 1       /* RTC operates in BCD mode */
#endif

Nothing ever defines RTC_PORT and RTC_ALWAYS_BCD

So we can get rid of that stuff completely.

> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/kernel/rtc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/arch/x86/kernel/rtc.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/rtc.c
> +++ linux/arch/x86/kernel/rtc.c
> @@ -130,10 +130,10 @@ unsigned long mach_get_cmos_time(void)
>  		BCD_TO_BIN(day);
>  		BCD_TO_BIN(mon);
>  		BCD_TO_BIN(year);
> +		BCD_TO_BIN(century);

This should probably go here:

        if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
            acpi_gbl_FADT.century) {
--->
 	}

It does not matter much, because BCD_TO_BIN(0) is 0, but it makes a
lot of sense.

Thanks,

	tglx
