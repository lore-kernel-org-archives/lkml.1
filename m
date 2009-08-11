Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZHKO4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZHKO4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZHKO4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:56:06 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:52774 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbZHKO4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ScKTly1C81ayJd6ciFBLADLTe2yKEBS7edirPQTjWCwVrklSbVHnUyOZzEWhBpEgJ/
         PTYAIpAWtpvz+NRbOGqE5yi1oRdPSP3had9n5EAzkXRNgWjadP8R7ijJ83EKsc81eKr1
         yjyRoA6GJHQCEHAmfw2mXhDgN14+S1V1avvz4=
MIME-Version: 1.0
In-Reply-To: <19073.33348.459260.456740@pilspetsen.it.uu.se>
References: <4A7D673A.1090401@gmail.com> <20090808152016.GB25374@liondog.tnic>
	 <4A7E0797.7060504@gmail.com> <20090810131219.GD21879@aftab>
	 <4A80A5AD.2000209@gmail.com>
	 <19073.33348.459260.456740@pilspetsen.it.uu.se>
Date: Tue, 11 Aug 2009 11:56:05 -0300
Message-ID: <d1af83620908110756h6c9782b5tbc03470f7d33153e@mail.gmail.com>
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
From: Kevin Winchester <kjwinchester@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/11 Mikael Pettersson <mikpe@it.uu.se>:
> Kevin Winchester writes:
>  > Due to an erratum with certain AMD Athlon 64 processors, the BIOS may
>  > need to force enable the LAHF_LM capability.  Unfortunately, in at
>  > least one case, the BIOS does this even for processors that do not
>  > support the functionality.
>  >
>  > Add a specific check that will clear the feature bit for processors
>  > known not to support the LAHF/SAHF instructions.
>  >
>  > Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
>  > ---
>  >  arch/x86/kernel/cpu/amd.c |    7 +++++++
>  >  1 files changed, 7 insertions(+), 0 deletions(-)
>  >
>  > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>  > index e2485b0..63fddcd 100644
>  > --- a/arch/x86/kernel/cpu/amd.c
>  > +++ b/arch/x86/kernel/cpu/amd.c
>  > @@ -400,6 +400,13 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  >              level = cpuid_eax(1);
>  >              if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
>  >                      set_cpu_cap(c, X86_FEATURE_REP_GOOD);
>  > +
>  > +            /*
>  > +             * Some BIOSes incorrectly force this feature, but only K8
>  > +             * revision D (model = 0x14) and later actually support it.
>  > +             */
>  > +            if (c->x86_model < 0x14)
>  > +                    clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
>  >      }
>  >      if (c->x86 == 0x10 || c->x86 == 0x11)
>  >              set_cpu_cap(c, X86_FEATURE_REP_GOOD);
>
> But this only fixes /proc/cpuinfo, right?
>
> Since the BIOS apparently wrote some MSR to get LAHF_LM incorrectly
> reported by CPUID, would it be possible to also correct that MSR so
> that applications that execute CPUID get the correct feature flags?
>

Yes, this does only fix /proc/cpuinfo.  The problem I was experiencing was
related to the 64-bit Adobe Flash plugin, which always uses the LAHF
instruction, regardless of the capabilities of the processor.  Gentoo has
a special additional browser plugin that will basically emulate the LAHF
instruction when it gets an illegal instruction signal, but that plugin is not
installed if /proc/cpuinfo indicates that LAHF is supported.

Thus this patch precisely fixes my problem.

Other options would be, as you mention, to correct the MSR value, or even
to have the kernel emulate the instruction (if that is possible).

I would be happy to implement any other solution instead if it would
help others,
while continuing to solve my problem - but this was the simplest answer I had.

-- 
Kevin Winchester
