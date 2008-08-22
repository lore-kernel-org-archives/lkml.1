Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbYHVGRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYHVGRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYHVGQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:16:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:5904 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbYHVGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JRqjZheGPlAH+OYrY8oWbFQ4dAdOmbEPkEvnYVVX0COZnrnQH44uUDs/KtThmCfrLN
         K8i+BCREpcqsRGUAq15OTiHTrT7HQq9CLIe1MKRc2nytMB/OlCeyRDOWoT73yE43HrFa
         SiCUOcSN351dOTpy5Ymg9OmtMdk3n33XPRD28=
Message-ID: <86802c440808212316t1c89321fl717fa80d2013f155@mail.gmail.com>
Date: Thu, 21 Aug 2008 23:16:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Joshua Hoblitt" <josh@hoblitt.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
In-Reply-To: <20080822035024.GB30284@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080821233317.GE23377@hoblitt.com>
	 <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com>
	 <20080822002952.GG23377@hoblitt.com>
	 <20080822010014.GH23377@hoblitt.com>
	 <20080822011055.GI23377@hoblitt.com>
	 <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com>
	 <20080822021512.GJ23377@hoblitt.com>
	 <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com>
	 <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com>
	 <20080822035024.GB30284@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 8:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> or please try attached workaround patch. hope it works.
>>
>> Ingo,
>> if it works, we need to push it for 2.6.27
>
> i've tidied up your patch (see the commit below) and have queued it up
> in x86/urgent. It seems fairly safe and i guess we can push it to
> v2.6.27 if Joshua reports test success. Joshua, could you give it a go
> please?
>
>        Ingo
>
> -------------->
> From 38cc1c3df77c1bb739a4766788eb9fa49f16ffdf Mon Sep 17 00:00:00 2001
> From: Yinghai Lu <yhlu.kernel@gmail.com>
> Date: Thu, 21 Aug 2008 20:24:24 -0700
> Subject: [PATCH] x86: work around MTRR mask setting
>
> Joshua Hoblitt reported that only 3 GB of his 16 GB of RAM is
> usable. Booting with mtrr_show showed us the BIOS-initialized
> MTRR settings - which are all wrong.
>
> So the root cause is that the BIOS has not set the mask correctly:
>
>>               [    0.429971]  MSR00000200: 00000000d0000000
>>               [    0.433305]  MSR00000201: 0000000ff0000800
>> should be ==> [    0.433305]  MSR00000201: 0000003ff0000800
>>
>>               [    0.436638]  MSR00000202: 00000000e0000000
>>               [    0.439971]  MSR00000203: 0000000fe0000800
>> should be ==> [    0.439971]  MSR00000203: 0000003fe0000800
>>
>>               [    0.443304]  MSR00000204: 0000000000000006
>>               [    0.446637]  MSR00000205: 0000000c00000800
>> should be ==> [    0.446637]  MSR00000205: 0000003c00000800
>>
>>               [    0.449970]  MSR00000206: 0000000400000006
>>               [    0.453303]  MSR00000207: 0000000fe0000800
>> should be ==> [    0.453303]  MSR00000207: 0000003fe0000800
>>
>>               [    0.456636]  MSR00000208: 0000000420000006
>>               [    0.459970]  MSR00000209: 0000000ff0000800
>> should be ==> [    0.459970]  MSR00000209: 0000003ff0000800
>
> So detect this borkage and add the prefix 111.
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: <stable@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/mtrr/generic.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
> index 509bd3d..43102e0 100644
> --- a/arch/x86/kernel/cpu/mtrr/generic.c
> +++ b/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -379,6 +379,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
>                             unsigned long *size, mtrr_type *type)
>  {
>        unsigned int mask_lo, mask_hi, base_lo, base_hi;
> +       unsigned int tmp, hi;
>
>        rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
>        if ((mask_lo & 0x800) == 0) {
> @@ -392,8 +393,18 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
>        rdmsr(MTRRphysBase_MSR(reg), base_lo, base_hi);
>
>        /* Work out the shifted address mask. */
> -       mask_lo = size_or_mask | mask_hi << (32 - PAGE_SHIFT)
> -           | mask_lo >> PAGE_SHIFT;
> +       tmp = mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
> +       mask_lo = size_or_mask | tmp;
> +       /* Expand tmp with high bits to all 1s*/
> +       hi = fls(tmp);
> +       if (hi > 0) {
> +               tmp |= ~((1<<(hi - 1)) - 1);
> +
> +               if (tmp != mask_lo) {
> +                       WARN_ON("mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");

can you change WARN_ON to WARN_ON_ONCE ?

YH
