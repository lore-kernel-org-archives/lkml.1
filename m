Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbYBVQyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbYBVQyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYBVQxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:53:55 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:30456 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYBVQxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:53:53 -0500
Date: Fri, 22 Feb 2008 08:53:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: akpm@linux-foundation.org, hpa@zytor.com,
       Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add default mode CONFIG_EDD_OFF=n, override with
 edd={on,off}
Message-Id: <20080222085307.e04af07f.randy.dunlap@oracle.com>
In-Reply-To: <20080222162252.GB32088@auslistsprd01.us.dell.com>
References: <20080222162252.GB32088@auslistsprd01.us.dell.com>
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

On Fri, 22 Feb 2008 10:22:52 -0600 Matt Domsch wrote:

>  Documentation/kernel-parameters.txt |    3 +--
>  arch/x86/boot/edd.c                 |   10 +++++++++-
>  drivers/firmware/Kconfig            |    9 +++++++++
>  3 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 9a5b665..3e6f0f5 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -625,8 +625,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  	eata=		[HW,SCSI]
>  
>  	edd=		[EDD]
> -			Format: {"of[f]" | "sk[ipmbr]"}
> -			See comment in arch/i386/boot/edd.S
> +			Format: {"off" | "on" | "sk[ipmbr]"}

Where is "sk" valid (parsed) as a value for "edd="?
I see "skip" or "skipmbr"....
or is that just a typo, should be "skip[mbr]"?


>  	eisa_irq_edge=	[PARISC,HW]
>  			See header of drivers/parisc/eisa.c.
> diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
> index 8721dc4..4191805 100644
> --- a/arch/x86/boot/edd.c
> +++ b/arch/x86/boot/edd.c
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
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 05f02a3..c28e33f 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
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

---
~Randy
