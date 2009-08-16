Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbZHPGlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbZHPGlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 02:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZHPGlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 02:41:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbZHPGlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 02:41:44 -0400
Date: Sun, 16 Aug 2009 08:41:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       kjwinchester@gmail.com, tglx@linutronix.de, borislav.petkov@amd.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, AMD: Disable wrongly set
	X86_FEATURE_LAHF_LM CPUID bit
Message-ID: <20090816064132.GA16278@elte.hu>
References: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com> <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Borislav Petkov <borislav.petkov@amd.com> wrote:

> Commit-ID:  c74cb13b94118ec89e48849806356b67caa5ff86
> Gitweb:     http://git.kernel.org/tip/c74cb13b94118ec89e48849806356b67caa5ff86
> Author:     Borislav Petkov <borislav.petkov@amd.com>
> AuthorDate: Fri, 14 Aug 2009 14:06:34 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 15 Aug 2009 18:43:59 +0200
> 
> x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit
> 
> fbd8b1819e80ac5a176d085fdddc3a34d1499318 turns off the bit for
> /proc/cpuinfo. However, a proper/full fix would be to additionally
> turn off the bit in the CPUID output so that future callers get
> correct CPU features info.
> 
> Do that by basically reversing what the BIOS wrongfully does at boot.
> 
> Tested-by: Kevin Winchester <kjwinchester@gmail.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Cc: kjwinchester@gmail.com
> Cc: mikpe@it.uu.se
> Cc: brgerst@gmail.com
> LKML-Reference: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/cpu/amd.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 63fddcd..0ee63dd 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -404,9 +404,19 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  		/*
>  		 * Some BIOSes incorrectly force this feature, but only K8
>  		 * revision D (model = 0x14) and later actually support it.
> +		 * (AMD Erratum #110, docId: 25759).
>  		 */
> -		if (c->x86_model < 0x14)
> +		if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
> +			u64 val;
> +
>  			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
> +			if (!rdmsrl_amd_safe(0xc001100d, &val)) {
> +				val &= ~(1ULL << 32);
> +				wrmsr_amd_safe(0xc001100d, (u32) val,
> +							   (u32)(val >> 32));
> +			}
> +		}
> +
>  	}
>  	if (c->x86 == 0x10 || c->x86 == 0x11)
>  		set_cpu_cap(c, X86_FEATURE_REP_GOOD);

-tip testing found this build bug caused by this patch:

arch/x86/kernel/cpu/amd.c: In function ‘init_amd’:
arch/x86/kernel/cpu/amd.c:417: error: implicit declaration of function ‘wrmsr_amd_safe’

	Ingo
