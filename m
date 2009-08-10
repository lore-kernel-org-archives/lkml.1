Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbZHJNMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbZHJNMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZHJNMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:12:35 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:32139 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754012AbZHJNMe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:12:34 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz1432R98dNzz1202hzz5a6ciz32i6bh203h223i222i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KO5WOI-03-SN3-01
Date: Mon, 10 Aug 2009 15:12:19 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86: clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
Message-ID: <20090810131219.GD21879@aftab>
References: <4A7D673A.1090401@gmail.com>
 <20090808152016.GB25374@liondog.tnic>
 <4A7E0797.7060504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A7E0797.7060504@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Aug 2009 13:12:18.0834 (UTC) FILETIME=[304C6720:01CA19BC]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Aug 08, 2009 at 08:17:43PM -0300, Kevin Winchester wrote:
> Due to an erratum with certain AMD Athlon 64 processors, the BIOS may
> need to force enable the LAHF_LM capability.  Unfortunately, in at
> least one case, the BIOS does this even for processors that do not
> support the functionality.
> 
> Add a specific check that will clear the feature bit for processors
> known not to support the LAHF/SAHF instructions.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
>  arch/x86/kernel/cpu/amd.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index e2485b0..7b52787 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -400,6 +400,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  		level = cpuid_eax(1);
>  		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
>  			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
> +
> +		/*
> +		 * Some BIOSes incorrectly set this feature, but only Revisions
> +		 * D (Extended Model = 1) and E (Extended Model = 2) actually
> +		 * support it.
> +		 */
> +		if (!(level & 0x00030000))
> +			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);

The LAHF/SAHF instructions are supported on all K8s from revision D
upwards. Revisions D start their CPU model numbering at 0x14 so your
check should rather be

	if (c->x86_model < 0x14)
		clear_cpu_cap(c, X86_FEATURE_LAHF_LM);

Please correct the comment above too for future reference.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

