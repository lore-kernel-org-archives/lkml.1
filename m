Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbYHZXEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbYHZXEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 19:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYHZXEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 19:04:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:5485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYHZXEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 19:04:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,273,1217833200"; 
   d="scan'208";a="329396961"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Dave Airlie <airlied@gmail.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Tue, 26 Aug 2008 16:03:31 -0700
Subject: RE: [patch 3/4] x86: PAT Update validate_pat_support for intel CPUs
Thread-Topic: [patch 3/4] x86: PAT Update validate_pat_support for intel CPUs
Thread-Index: AckHSjRuvtUIM4T/Q0iDafM7SOC68wAXU7wg
Message-ID: <7E82351C108FA840AB1866AC776AEC460B68CC5F@orsmsx505.amr.corp.intel.com>
References: <20080820234550.923970000@intel.com>
	 <20080820234604.592277000@intel.com>
 <21d7e9970808260005g14ec71e9xfa584780498a86e7@mail.gmail.com>
In-Reply-To: <21d7e9970808260005g14ec71e9xfa584780498a86e7@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The problem here is both with MTRR entry of UC and even with
default MTRR being UC.

Default MTRR being UC for all reserved regions and drivers
wanting WC is very common situation and performance will be
affected when that ends up being UC access.
With pat disabled, drivers can set MTRR with WC in this case
and get the expected performance.

Yes. We can still allow WC mappings only for the RAM
regions and disable PAT WC for all the reserved regions. I will
take a look at that option and see how cleanly we can
enable pat only for set_memory_wc and disable PAT for
ioremap_wc and pci regions.

Thanks,
Venki



>-----Original Message-----
>From: Dave Airlie [mailto:airlied@gmail.com]
>Sent: Tuesday, August 26, 2008 12:06 AM
>To: Pallipadi, Venkatesh
>Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com;
>linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 3/4] x86: PAT Update validate_pat_support
>for intel CPUs
>
>On Thu, Aug 21, 2008 at 9:45 AM,
><venkatesh.pallipadi@intel.com> wrote:
>> Pentium III and Core Solo/Duo CPUs have an erratum
>> " Page with PAT set to WC while associated MTRR is UC may
>consolidate to UC "
>> which can result in WC setting in PAT to be ineffective. We
>will disable
>> PAT on such CPUs, so that we can continue to use MTRR WC setting.
>>
>
>IMHO this seems like a bit hammer with which to squash this nut.
>
>I really need PAT support for upcoming GPU stuff, esp where I have
>pages of RAM allocated into a
>GART and I want write-combined access to them. These pages will
>physically me under a write-back MTRR, with a WC PAT entry
>on the PTE mappings.
>
>Can we not just be smarter and fix this when we know we have a UC MTRR
>and a WC PAT mapping inside it?
>
>Dave.
>
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>
>> ---
>>  arch/x86/kernel/cpu/addon_cpuid_features.c |   17 +++++++++++++++--
>>  1 file changed, 15 insertions(+), 2 deletions(-)
>>
>> Index: tip/arch/x86/kernel/cpu/addon_cpuid_features.c
>> ===================================================================
>> --- tip.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
>2008-08-20 14:25:18.000000000 -0700
>> +++ tip/arch/x86/kernel/cpu/addon_cpuid_features.c
>2008-08-20 14:26:39.000000000 -0700
>> @@ -56,9 +56,22 @@ void __cpuinit validate_pat_support(stru
>>
>>        switch (c->x86_vendor) {
>>        case X86_VENDOR_INTEL:
>> -               if (c->x86 == 0xF || (c->x86 == 6 &&
>c->x86_model >= 15))
>> +               /*
>> +                * There is a known erratum on Pentium III
>and Core Solo
>> +                * and Core Duo CPUs.
>> +                * " Page with PAT set to WC while
>associated MTRR is UC
>> +                *   may consolidate to UC "
>> +                * Because of this erratum, it is better to
>stick with
>> +                * setting WC in MTRR rather than using PAT
>on these CPUs.
>> +                *
>> +                * Enable PAT WC only on P4, Core 2 or later CPUs.
>> +                */
>> +               if (c->x86 > 0x6 || (c->x86 == 6 &&
>c->x86_model >= 15))
>>                        return;
>> -               break;
>> +
>> +               pat_disable("PAT WC disabled due to known
>CPU erratum.");
>> +               return;
>> +
>>        case X86_VENDOR_AMD:
>>        case X86_VENDOR_CENTAUR:
>>        case X86_VENDOR_TRANSMETA:
>>
>> --
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
