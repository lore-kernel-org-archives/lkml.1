Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbXFASvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbXFASvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762018AbXFASvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:51:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57209 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760792AbXFASvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:51:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.21 2/3] x86_64: EFI64 support
References: <20070501185945.237601000@em64tdvp.jf.intel.com>
	<20070501190110.958988000@em64tdvp.jf.intel.com>
Date: Fri, 01 Jun 2007 12:50:33 -0600
In-Reply-To: <20070501190110.958988000@em64tdvp.jf.intel.com> (Chandramouli
	Narayanan's message of "Tue, 01 May 2007 11:59:47 -0700")
Message-ID: <m13b1b1pc6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chandramouli Narayanan <mouli@linux.intel.com> writes:

> diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff
> linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/reboot.c
> linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/reboot.c
> --- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/reboot.c 2007-02-04
> 10:44:54.000000000 -0800
> +++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/reboot.c 2007-04-19
> 13:01:02.000000000 -0700
> @@ -7,6 +7,7 @@
>  #include <linux/ctype.h>
>  #include <linux/string.h>
>  #include <linux/pm.h>
> +#include <linux/efi.h>
>  #include <asm/io.h>
>  #include <asm/kdebug.h>
>  #include <asm/delay.h>
> @@ -116,9 +117,15 @@ void machine_emergency_restart(void)
>  {
>  	int i;
>  
> +	/* If EFI enabled, reset system through EFI protocol. */
> +	if (efi_enabled) {
> +		efi.reset_system(EFI_RESET_WARM, EFI_SUCCESS, 0, NULL);
> +		return;
> +	}
> +
>  	/* Tell the BIOS if we want cold or warm reboot */
>  	*((unsigned short *)__va(0x472)) = reboot_mode;
> -       
> +

Don't do this.

Instead add an architecture specific pointer that the EFI
initialization code can override.  That should be a lot less
intrusive and more maintainable.

>  	for (;;) {
>  		/* Could also try the reset bit in the Hammer NB */
>  		switch (reboot_type) { 
> diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff
> linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/setup.c
> linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/setup.c
> --- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/setup.c 2007-04-19
> 12:39:39.000000000 -0700
> +++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/setup.c 2007-04-19
> 13:01:02.000000000 -0700
> @@ -44,6 +44,7 @@
>  #include <linux/dmi.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/ctype.h>
> +#include <linux/efi.h>
>  
>  #include <asm/mtrr.h>
>  #include <asm/uaccess.h>
> @@ -69,6 +70,10 @@
>   * Machine setup..
>   */
>  
> +#ifdef CONFIG_EFI
> +int efi_enabled = 0;
> +EXPORT_SYMBOL(efi_enabled);
> +#endif

Please remove this variable.

I didn't see a single use where it appears to be actually needed.

Eric
