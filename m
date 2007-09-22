Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbXIVTFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbXIVTFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 15:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbXIVTFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 15:05:42 -0400
Received: from www.osadl.org ([213.239.205.134]:42305 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750772AbXIVTFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 15:05:41 -0400
Subject: Re: [PATCH] [19/50] Experimental: detect if SVM is disabled by BIOS
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070921223218.22A8D13DCD@wotan.suse.de>
References: <200709221231.836138000@suse.de>
	 <20070921223218.22A8D13DCD@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 21:05:39 +0200
Message-Id: <1190487939.4035.92.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-22 at 00:32 +0200, Andi Kleen wrote:
> Also allow to set svm lock.

Please use two separate patches. The detection and cpuinfo display is
not related to set svm lock.

> TBD double check, documentation, i386 support

Yes, documentation would be useful. See below.

> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86_64/kernel/setup.c    |   25 +++++++++++++++++++++++--
>  include/asm-i386/cpufeature.h |    1 +
>  include/asm-i386/msr-index.h  |    3 +++
>  3 files changed, 27 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86_64/kernel/setup.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/setup.c
> +++ linux/arch/x86_64/kernel/setup.c
> @@ -565,7 +565,7 @@ static void __cpuinit early_init_amd(str
>  
>  static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  {
> -	unsigned level;
> +	unsigned level, flags, dummy;
>  
>  #ifdef CONFIG_SMP
>  	unsigned long value;
> @@ -634,7 +634,28 @@ static void __cpuinit init_amd(struct cp
>  	/* Family 10 doesn't support C states in MWAIT so don't use it */
>  	if (c->x86 == 0x10 && !force_mwait)
>  		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
> +
> +	if (c->x86 >= 0xf && c->x86 <= 0x11 &&
> +	    !rdmsr_safe(MSR_VM_CR, &flags, &dummy) &&
> +	    (flags & 0x18))
> +		set_bit(X86_FEATURE_VIRT_DISABLED, &c->x86_capability);

Why the check for 0x18 ???? And please can we use understandable
constants for this.

bit 3 (SVM_LOCK) controls only the writeability of bit 4 (SVME_DISABLE),
which controls whether SVM is allowed to be enabled or not. 

bit 3	bit 4
0	0	SVM can be enabled in EFER, SVME_DISABLE is writeable
1	0	SVM can be enabled in EFER, SVME_DISABLE is not writeable
0	1	SVM can not be enabled in EFER, SVME_DISABLE is writeable
1	1	SVM can not be enabled in EFER, SVME_DISABLE is not writeable

So SVM is disabled, when bit 4 is set.

> +}
> +
> +static int enable_svm_lock(char *s)
> +{
> +	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
> +		boot_cpu_data.x86 >= 0xf && boot_cpu_data.x86 <= 0x11) {
> +		unsigned a,b;
> +		if (rdmsr_safe(MSR_VM_CR, &a, &b))
> +			return 0;
> +		a |= (1 << 3);	/* set SVM lock */

SVM_LOCK is read only according to data sheet. You can set bit 4
(SVME_DISABLE) to prevent KVM or what else using that feature.

	tglx




