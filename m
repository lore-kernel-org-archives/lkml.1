Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYKQRew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYKQRew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYKQRen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:34:43 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40015 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYKQRen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:34:43 -0500
X-BigFish: VPS-34(zz1432R62a3L98dR936eQ1805M8c8aizzzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KAHNHB-02-DQW-01
Date: Mon, 17 Nov 2008 18:33:59 +0100
From: Robert Richter <robert.richter@amd.com>
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
Message-ID: <20081117173359.GI1664@erda.amd.com>
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org> <491843C4.9090306@cosmosbay.com> <20081110154948.GW29626@one.firstfloor.org> <4919430C.6050502@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4919430C.6050502@cosmosbay.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Nov 2008 17:34:29.0503 (UTC) FILETIME=[BEA080F0:01C948DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.11.08 09:32:12, Eric Dumazet wrote:

[...]

> PATCH] oprofile: un-mask APIC before resetting counter in ppro_check_ctrs()

Is this the patch you all prefer? If so, I would like to send it
upstream.

-Robert

>
> While using oprofile on my HP BL460c G1, (two quad core intel E5450 CPU),
> I noticed that one CPU after the other could not get anymore NMI.
>
> After a while, all cores where blocked (ie not generating events for 
> oprofile)
> I tried all major linux versions and all where affected by this freeze.
>
> I found that we have to un-mask APIC *before* writing to MSR counter
> when we get event notification, because we use APIC_LVTPC in edge triggered 
> mode.
>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
> arch/x86/oprofile/op_model_ppro.c |   10 ++++++----
> 1 files changed, 6 insertions(+), 4 deletions(-)

> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> index 3f1b81a..8484528 100644
> --- a/arch/x86/oprofile/op_model_ppro.c
> +++ b/arch/x86/oprofile/op_model_ppro.c
> @@ -126,6 +126,12 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
>  	u64 val;
>  	int i;
>  
> +	/*
> +	 * We need to unmask the apic vector *before* writing reset_value
> +	 * to msr counter, because we use edge trigger
> +	 */
> +	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> +
>  	for (i = 0 ; i < num_counters; ++i) {
>  		if (!reset_value[i])
>  			continue;
> @@ -136,10 +142,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
>  		}
>  	}
>  
> -	/* Only P6 based Pentium M need to re-unmask the apic vector but it
> -	 * doesn't hurt other P6 variant */
> -	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> -
>  	/* We can't work out if we really handled an interrupt. We
>  	 * might have caught a *second* counter just after overflowing
>  	 * the interrupt for this counter then arrives


-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

