Return-Path: <linux-kernel-owner+w=401wt.eu-S934172AbYETVrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172AbYETVrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763149AbYETVrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:47:11 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56566 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768AbYETVrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:47:09 -0400
Message-ID: <48334766.1020701@keyaccess.nl>
Date: Tue, 20 May 2008 23:49:26 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Mikael Pettersson <mikpe@it.uu.se>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: Re: [X86] Add a boot parameter to force-enable PAT
References: <200805200409.m4K49Ybn024338@gelk.kernelslacker.org> <86802c440805192253s34b3acb2r63c657db86676792@mail.gmail.com> <20080520132306.GB4843@redhat.com> <18482.58121.130009.555407@harpo.it.uu.se> <20080520195846.GA29806@redhat.com>
In-Reply-To: <20080520195846.GA29806@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-05-08 21:58, Dave Jones wrote:

> diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
> index c2e1ce3..e22e809 100644
> --- a/arch/x86/kernel/cpu/addon_cpuid_features.c
> +++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
> @@ -50,9 +50,27 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
>  	}
>  }
>  
> +static int forcepat;
> +
> +static int __init x86_forcepat_setup(char *s)
> +{
> +	forcepat = 1;
> +	return 1;
> +}
> +__setup("enablepat", x86_forcepat_setup);

This should probably be called plain "pat" to mirror arch/x86/mm/pat.c 
"nopat" force off parameter. That by the way is an early_param which I 
guess this should then also be?

> +
> +
>  #ifdef CONFIG_X86_PAT
>  void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
>  {
> +	if (!test_cpu_cap(c, X86_FEATURE_PAT))
> +		return;

It seems you needn't test this, the !cpu_has_pat test in pat_init() will 
trigger and user knows best... :-)

> +
> +	if (forcepat == 1) {
> +		printk(KERN_INFO "Force enabling PAT\n");
> +		return;
> +	}
> +
>  	switch (c->x86_vendor) {
>  	case X86_VENDOR_AMD:
>  		if (c->x86 >= 0xf && c->x86 <= 0x11)

Rene.
