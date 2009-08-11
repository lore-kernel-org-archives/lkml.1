Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZHKOiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZHKOiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZHKOiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:38:12 -0400
Received: from aun.it.uu.se ([130.238.12.36]:59629 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbZHKOiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:38:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19073.33348.459260.456740@pilspetsen.it.uu.se>
Date: Tue, 11 Aug 2009 16:37:56 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
In-Reply-To: <4A80A5AD.2000209@gmail.com>
References: <4A7D673A.1090401@gmail.com>
	<20090808152016.GB25374@liondog.tnic>
	<4A7E0797.7060504@gmail.com>
	<20090810131219.GD21879@aftab>
	<4A80A5AD.2000209@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester writes:
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
 >  arch/x86/kernel/cpu/amd.c |    7 +++++++
 >  1 files changed, 7 insertions(+), 0 deletions(-)
 > 
 > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
 > index e2485b0..63fddcd 100644
 > --- a/arch/x86/kernel/cpu/amd.c
 > +++ b/arch/x86/kernel/cpu/amd.c
 > @@ -400,6 +400,13 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 >  		level = cpuid_eax(1);
 >  		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 >  			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 > +
 > +		/*
 > +		 * Some BIOSes incorrectly force this feature, but only K8
 > +		 * revision D (model = 0x14) and later actually support it.
 > +		 */
 > +		if (c->x86_model < 0x14)
 > +			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
 >  	}
 >  	if (c->x86 == 0x10 || c->x86 == 0x11)
 >  		set_cpu_cap(c, X86_FEATURE_REP_GOOD);

But this only fixes /proc/cpuinfo, right?

Since the BIOS apparently wrote some MSR to get LAHF_LM incorrectly
reported by CPUID, would it be possible to also correct that MSR so
that applications that execute CPUID get the correct feature flags?

/Mikael
