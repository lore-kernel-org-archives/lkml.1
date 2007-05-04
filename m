Return-Path: <linux-kernel-owner+w=401wt.eu-S376145AbXEDVoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376145AbXEDVoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376156AbXEDVoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:44:24 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S376145AbXEDVoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:44:23 -0400
Date: Fri, 4 May 2007 14:44:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
Message-Id: <20070504144408.c041d8df.akpm@linux-foundation.org>
In-Reply-To: <1178314144.6094.7.camel@localhost.localdomain>
References: <1178314144.6094.7.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 14:29:04 -0700
john stultz <johnstul@us.ibm.com> wrote:

> One of the 2.6.21 regressions was Guilherme's problem seeing his box
> lock up when the system detected an unstable TSC and dropped back to
> using the HPET.
> 
> In digging deeper, we found the HPET is not actually incrementing on
> this system. And in fact, the reason why this issue just cropped up was
> because of Thomas's clocksource watchdog code was comparing the TSC to
> the HPET (which wasn't moving) and thought the TSC was broken.
> 
> Anyway, Guliherme checked for a BIOS update and did not find one, so
> I've added a DMI blacklist against his system so the HPET is not used.
> 
> Many thanks to Guilherme for the slow and laborious testing that finally
> narrowed down this issue.
> 

OK, I tagged that for -stable too.

> 
> diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
> index 17d7345..1ae27f3 100644
> --- a/arch/i386/kernel/hpet.c
> +++ b/arch/i386/kernel/hpet.c
> @@ -5,6 +5,7 @@
>  #include <linux/init.h>
>  #include <linux/sysdev.h>
>  #include <linux/pm.h>
> +#include <linux/dmi.h>
>  
>  #include <asm/hpet.h>
>  #include <asm/io.h>
> @@ -48,6 +49,31 @@ static int __init hpet_setup(char* str)
>  }
>  __setup("hpet=", hpet_setup);
>  
> +
> +/* DMI Blacklist for bad HPETs */
> +static int __init dmi_mark_hpet_broken(struct dmi_system_id *d)
> +{
> +	printk(KERN_NOTICE "%s detected: HPET does not function.\n",
> +		       d->ident);
> +	boot_hpet_disable = 1;
> +	return 0;
> +}
> +
> +/* List of systems that have known HPETproblems */
> +static struct dmi_system_id bad_hpet_dmi_table[] = {
> +	{
> +	 .callback = dmi_mark_hpet_broken,
> +	 .ident = "Dell OptiPlex 320",
> +	 .matches = {
> +		     DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 320"),
> +		     DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
> +		     DMI_MATCH(DMI_BOARD_NAME, "0UT237"),
> +		     },
> +	 },
> +	 {}
> +};
> +
> +
>  static inline int is_hpet_capable(void)
>  {
>  	return (!boot_hpet_disable && hpet_address);
> @@ -228,6 +254,8 @@ int __init hpet_enable(void)
>  	uint64_t hpet_freq;
>  	u64 tmp;
>  
> +	dmi_check_system(bad_hpet_dmi_table);
> +
>  	if (!is_hpet_capable())
>  		return 0;

The table can be __initdata, can't it?


--- a/arch/i386/kernel/hpet.c~blacklist-dell-optiplex-320-from-using-the-hpet-fix
+++ a/arch/i386/kernel/hpet.c
@@ -60,7 +60,7 @@ static int __init dmi_mark_hpet_broken(s
 }
 
 /* List of systems that have known HPETproblems */
-static struct dmi_system_id bad_hpet_dmi_table[] = {
+static struct dmi_system_id __initdata bad_hpet_dmi_table[] = {
 	{
 	 .callback = dmi_mark_hpet_broken,
 	 .ident = "Dell OptiPlex 320",
@@ -73,7 +73,6 @@ static struct dmi_system_id bad_hpet_dmi
 	 {}
 };
 
-
 static inline int is_hpet_capable(void)
 {
 	return (!boot_hpet_disable && hpet_address);
_

