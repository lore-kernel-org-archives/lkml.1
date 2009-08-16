Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZHPUv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZHPUv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 16:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZHPUvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 16:51:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080AbZHPUvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 16:51:24 -0400
Date: Sun, 16 Aug 2009 22:51:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, AMD: Disable wrongly set
	X86_FEATURE_LAHF_LM CPUID bit
Message-ID: <20090816205113.GA3463@elte.hu>
References: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com> <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org> <20090816064132.GA16278@elte.hu> <4A8867B3.6020504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A8867B3.6020504@gmail.com>
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> Ingo Molnar wrote:
> > * tip-bot for Borislav Petkov <borislav.petkov@amd.com> wrote:
> > 
> >> Commit-ID:  c74cb13b94118ec89e48849806356b67caa5ff86
> >> Gitweb:     http://git.kernel.org/tip/c74cb13b94118ec89e48849806356b67caa5ff86
> >> Author:     Borislav Petkov <borislav.petkov@amd.com>
> >> AuthorDate: Fri, 14 Aug 2009 14:06:34 +0200
> >> Committer:  Ingo Molnar <mingo@elte.hu>
> >> CommitDate: Sat, 15 Aug 2009 18:43:59 +0200
> >>
> >> x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit
> >>
> >> fbd8b1819e80ac5a176d085fdddc3a34d1499318 turns off the bit for
> >> /proc/cpuinfo. However, a proper/full fix would be to additionally
> >> turn off the bit in the CPUID output so that future callers get
> >> correct CPU features info.
> >>
> >> Do that by basically reversing what the BIOS wrongfully does at boot.
> >>
> >> Tested-by: Kevin Winchester <kjwinchester@gmail.com>
> >> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> >> Cc: kjwinchester@gmail.com
> >> Cc: mikpe@it.uu.se
> >> Cc: brgerst@gmail.com
> >> LKML-Reference: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com>
> >> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >>
> >>
> >> ---
> >>  arch/x86/kernel/cpu/amd.c |   12 +++++++++++-
> >>  1 files changed, 11 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> >> index 63fddcd..0ee63dd 100644
> >> --- a/arch/x86/kernel/cpu/amd.c
> >> +++ b/arch/x86/kernel/cpu/amd.c
> >> @@ -404,9 +404,19 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
> >>  		/*
> >>  		 * Some BIOSes incorrectly force this feature, but only K8
> >>  		 * revision D (model = 0x14) and later actually support it.
> >> +		 * (AMD Erratum #110, docId: 25759).
> >>  		 */
> >> -		if (c->x86_model < 0x14)
> >> +		if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
> >> +			u64 val;
> >> +
> >>  			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
> >> +			if (!rdmsrl_amd_safe(0xc001100d, &val)) {
> >> +				val &= ~(1ULL << 32);
> >> +				wrmsr_amd_safe(0xc001100d, (u32) val,
> >> +							   (u32)(val >> 32));
> >> +			}
> >> +		}
> >> +
> >>  	}
> >>  	if (c->x86 == 0x10 || c->x86 == 0x11)
> >>  		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
> > 
> > -tip testing found this build bug caused by this patch:
> > 
> > arch/x86/kernel/cpu/amd.c: In function ‘init_amd’:
> > arch/x86/kernel/cpu/amd.c:417: error: implicit declaration of function ‘wrmsr_amd_safe’
> > 
> 
> I didn't see a notification that patch 1/2:
> 
>  x86, msr: Add a AMD wrmsr with exception handling
> 
> got applied before this patch.  That could be the cause of this failure.

it got applied in the correct order:

c74cb13: x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit
0ae84a7: x86, msr: Add a AMD wrmsr with exception handling
3ef12c3: x86: Fix UV BAU destination subnode id
64f1607: Linux 2.6.31-rc6

	Ingo
