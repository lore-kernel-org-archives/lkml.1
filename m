Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbYE2TSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbYE2TSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYE2TS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:18:28 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11189 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYE2TS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:18:27 -0400
Message-ID: <11839164.1212088657472.JavaMail.oracle@acsmt302.oracle.com>
Date: Thu, 29 May 2008 14:17:37 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: jkosina@suse.cz, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH linux-next] serio: add ifdef for i8042 build fix
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <20080529184606.GA17728@anvil.corenet.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <20080529182556.2994310a.sfr@canb.auug.org.au> <20080529094454.3605aa5c.randy.dunlap@oracle.com> <20080529095633.8893b4ec.randy.dunlap@oracle.com> <20080529184606.GA17728@anvil.corenet.prv>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Original Message ---
> Hi Randy,
> 
> On Thu, May 29, 2008 at 09:56:33AM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Restrict variable usage by bounding it with ifdef/endif CONFIG_PNP.
> > 
> > linux-next-20080529/drivers/input/serio/i8042-x86ia64io.h:590: error: 'i8042_nopnp' undeclared (first use in this function)
> > 
> 
> Thank you for the report. I'd rahther changed it as in the
> patch below.
> What do you think?

It builds.  Other than that, it doesn't matter much to me.

> If everyone agrees then I will fold it in Jiri's original patch
> to keep the trees bisectable.

Yes, very desirable.

> 
> -- 
> Dmitry
> 
> diff --git a/drivers/input/serio/i8042-x86ia64io.h
> b/drivers/input/serio/i8042-x86ia64io.h
> index 709c9d9..2289e3a 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -63,7 +63,7 @@ static inline void i8042_write_command(int
> val)
>  	outb(val, I8042_COMMAND_REG);
>  }
>  
> -#if defined(__i386__) || defined(__x86_64__)
> +#ifdef CONFIG_X86
>  
>  #include <linux/dmi.h>
>  
> @@ -287,6 +287,7 @@ static struct dmi_system_id __initdata
> i8042_dmi_nomux_table[] = {
>  	{ }
>  };
>  
> +#ifdef CONFIG_PNP
>  static struct dmi_system_id __initdata i8042_dmi_nopnp_table[]
> = {
>  	{
>  		.ident = "Intel MBO Desktop D845PESV",
> @@ -297,13 +298,8 @@ static struct dmi_system_id __initdata
> i8042_dmi_nopnp_table[] = {
>  	},
>  	{ }
>  };
> -
>  #endif
>  
> -#ifdef CONFIG_X86
> -
> -#include <linux/dmi.h>
> -
>  /*
>   * Some Wistron based laptops need us to explicitly enable
> the 'Dritek
>   * keyboard extension' to make their extra keys start generating
> scancodes.
> @@ -351,7 +347,6 @@ static struct dmi_system_id __initdata
> i8042_dmi_dritek_table[] = {
>  
>  #endif /* CONFIG_X86 */
>  
> -
>  #ifdef CONFIG_PNP
>  #include <linux/pnp.h>
>  
> @@ -461,6 +456,11 @@ static int __init i8042_pnp_init(void)
>  	int pnp_data_busted = 0;
>  	int err;
>  
> +#ifdef CONFIG_X86
> +	if (dmi_check_system(i8042_dmi_nopnp_table))
> +		i8042_nopnp = 1;
> +#endif
> +
>  	if (i8042_nopnp) {
>  		printk(KERN_INFO "i8042: PNP detection disabled\n");
>  		return 0;
> @@ -578,10 +578,6 @@ static int __init i8042_platform_init(void)
>  	i8042_kbd_irq = I8042_MAP_IRQ(1);
>  	i8042_aux_irq = I8042_MAP_IRQ(12);
>  
> -#if defined(__i386__) || defined(__x86_64__)
> -	if (dmi_check_system(i8042_dmi_nopnp_table))
> -		i8042_nopnp = 1;
> -#endif
>  	retval = i8042_pnp_init();
>  	if (retval)
>  		return retval;
> @@ -590,15 +586,13 @@ static int __init i8042_platform_init(void)
>          i8042_reset = 1;
>  #endif
>  
> -#if defined(__i386__) || defined(__x86_64__)
> +#ifdef CONFIG_X86
>  	if (dmi_check_system(i8042_dmi_noloop_table))
>  		i8042_noloop = 1;
>  
>  	if (dmi_check_system(i8042_dmi_nomux_table))
>  		i8042_nomux = 1;
> -#endif
>  
> -#ifdef CONFIG_X86
>  	if (dmi_check_system(i8042_dmi_dritek_table))
>  		i8042_dritek = 1;
>  #endif /* CONFIG_X86 */

