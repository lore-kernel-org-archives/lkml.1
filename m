Return-Path: <linux-kernel-owner+w=401wt.eu-S1762359AbYB0XlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762359AbYB0XlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758924AbYB0XlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:41:00 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:63541 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387AbYB0Xk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:40:59 -0500
Date: Wed, 27 Feb 2008 15:40:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tim.gardner@canonical.com, Matt_Domsch@dell.com,
       hpa@zytor.com, rdunlap@xenotime.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: +
 edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch added
 to -mm tree
Message-Id: <20080227154034.ecc603cf.randy.dunlap@oracle.com>
In-Reply-To: <200802272321.m1RNLDrb003699@imap1.linux-foundation.org>
References: <200802272321.m1RNLDrb003699@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 15:21:13 -0800 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      edd: add default mode CONFIG_EDD_OFF=n, override with edd={on,off}
> has been added to the -mm tree.  Its filename is
>      edd-add-default-mode-config_edd_off=n-override-with-edd=onoff.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: edd: add default mode CONFIG_EDD_OFF=n, override with edd={on,off}
> From: Tim Gardner <tim.gardner@canonical.com>
> 
> Add a kernel parameter option to 'edd' to enable/disable BIOS Enhanced Disk
> Drive Services.  CONFIG_EDD_OFF disables EDD while still compiling EDD into
> the kernel.  Default behavior can be forced using 'edd=on' or 'edd=off' as
> a kernel parameter.
> 
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Documentation/kernel-parameters.txt |    3 +--
>  arch/x86/boot/edd.c                 |   10 +++++++++-
>  drivers/firmware/Kconfig            |    9 +++++++++
>  3 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff -puN Documentation/kernel-parameters.txt~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff Documentation/kernel-parameters.txt
> --- a/Documentation/kernel-parameters.txt~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff
> +++ a/Documentation/kernel-parameters.txt
> @@ -625,8 +625,7 @@ and is between 256 and 4096 characters. 
>  	eata=		[HW,SCSI]
>  
>  	edd=		[EDD]
> -			Format: {"of[f]" | "sk[ipmbr]"}
> -			See comment in arch/i386/boot/edd.S
> +			Format: {"off" | "on" | "sk[ipmbr]"}

I think that should be "skip[mbr]"...

>  
>  	eisa_irq_edge=	[PARISC,HW]
>  			See header of drivers/parisc/eisa.c.
> diff -puN arch/x86/boot/edd.c~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff arch/x86/boot/edd.c
> --- a/arch/x86/boot/edd.c~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff
> +++ a/arch/x86/boot/edd.c
> @@ -128,17 +128,25 @@ void query_edd(void)
>  {
>  	char eddarg[8];
>  	int do_mbr = 1;
> +#ifdef CONFIG_EDD_OFF
> +	int do_edd = 0;
> +#else
>  	int do_edd = 1;
> +#endif
>  	int be_quiet;
>  	int devno;
>  	struct edd_info ei, *edp;
>  	u32 *mbrptr;
>  
>  	if (cmdline_find_option("edd", eddarg, sizeof eddarg) > 0) {
> -		if (!strcmp(eddarg, "skipmbr") || !strcmp(eddarg, "skip"))
> +		if (!strcmp(eddarg, "skipmbr") || !strcmp(eddarg, "skip")) {
> +			do_edd = 1;
>  			do_mbr = 0;
> +		}
>  		else if (!strcmp(eddarg, "off"))
>  			do_edd = 0;
> +		else if (!strcmp(eddarg, "on"))
> +			do_edd = 1;
>  	}
>  
>  	be_quiet = cmdline_find_option_bool("quiet");
> diff -puN drivers/firmware/Kconfig~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff drivers/firmware/Kconfig
> --- a/drivers/firmware/Kconfig~edd-add-default-mode-config_edd_off=n-override-with-edd=onoff
> +++ a/drivers/firmware/Kconfig
> @@ -17,6 +17,15 @@ config EDD
>            obscure configurations. Most disk controller BIOS vendors do
>            not yet implement this feature.
>  
> +config EDD_OFF
> +	bool "Sets default behavior for EDD detection to off"
> +	depends on EDD
> +	default n
> +	help
> +	  Say Y if you want EDD disabled by default, even though it is compiled into the
> +	  kernel. Say N if you want EDD enabled by default. EDD can be dynamically set
> +	  using the kernel parameter 'edd={on|skipmbr|off}'.
> +
>  config EFI_VARS
>  	tristate "EFI Variable Support via sysfs"
>  	depends on EFI
> _

---
~Randy
