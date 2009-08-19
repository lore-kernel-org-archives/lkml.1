Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbZHSOxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbZHSOxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZHSOxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:53:00 -0400
Received: from www.tglx.de ([62.245.132.106]:52084 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZHSOxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:53:00 -0400
Date: Wed, 19 Aug 2009 16:51:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 3/10] x86: introduce a set of platform feature flags
In-Reply-To: <43F901BD926A4E43B106BF17856F0755643EBDF5@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908191641120.3361@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F0755643EBDF5@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On Thu, 16 Jul 2009, Pan, Jacob jun wrote:

> >From 697d29ca621fffa63bc0bac022861f582d1905a6 Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Thu, 11 Jun 2009 09:37:26 -0700
> Subject: [PATCH] x86: introduce a set of platform feature flags
> 
> This patch introduces a set of x86 pc platform feature flags. the intention is
> to clean up setup code based on the availability of patform features.

Hmm, if it would be used to cleanup the setup code, fine. But as I can
see in the later patches it just adds lots of conditionals based on
that feature flags.
 
> +#ifndef _ASM_X86_PLATFORM_FEATURE_H
> +#define _ASM_X86_PLATFORM_FEATURE_H
> +
> +#ifndef __ASSEMBLY__
> +#include <linux/bitops.h>
> +#endif
> +#include <asm/required-features.h>

Why does this header require asm/required-features.h ?

> diff --git a/arch/x86/kernel/mkx86pcflags.pl b/arch/x86/kernel/mkx86pcflags.pl
> new file mode 100644
> index 0000000..19c13aa
> --- /dev/null
> +++ b/arch/x86/kernel/mkx86pcflags.pl
> @@ -0,0 +1,32 @@
> +#!/usr/bin/perl
> +#
> +# Generate the x86_platform_available_feature[] array from arch/x86/include/asm/platform_feature.h

  What's the purpose of this ? Creating an array of strings ?

> +static ssize_t
> +sysfs_show_available_platform_feature(struct sys_device *dev,
> +				struct sysdev_attribute *attr, char *buf)
> +{
> +	ssize_t count = 0;
> +	int i;
> +
> +	for (i = 0; i < 32*N_PLATFORM_CAPINTS; i++) {
> +		if (x86_platform_available_feature[i] != NULL) {
> +			count += snprintf(buf + count,
> +					max((ssize_t)PAGE_SIZE - count,
> +						(ssize_t)0), "%s ",
> +				x86_platform_available_feature[i]);
> +		}
> +	}

Is this really worth an extra sysfs machinery ?  IMO it's sufficient
to printk the hex value of the set feature bits once during boot.

> +/*
> + * Initialize a set of default feature flags based on subarch IDs
> + * Currently, only MRST platform has non-X86 PC standard feature set.
> + */
> +void platform_feature_init_default(void)
> +{
> +	int subarch_id = boot_params.hdr.hardware_subarch;
> +
> +	if ((subarch_id >= 0) && (subarch_id < N_X86_SUBARCHS)) {
> +		if (subarch_id == X86_SUBARCH_MRST) {
> +			setup_mrst_default_feature();
> +			return;
> +		}
> +	} else {
> +		printk(KERN_INFO "Use default X86 platform feature set\n");
> +	}
> +	/* platforms such as Moorestown and paravirt should be filtered out */
> +	if (platform_has(X86_PLATFORM_FEATURE_BIOS))
> +		x86_quirks->reserve_ebda_region = reserve_ebda_region;

I don't like that at all. We do not want tons of places where we init
parts of the setup depending on different platforms. platform setup
has to be done in a platform file and there we override quirks or
platform functions. Not on some random place.

Thanks,

	tglx
