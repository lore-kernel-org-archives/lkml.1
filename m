Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYBWFme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYBWFme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 00:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYBWFmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 00:42:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:43308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbYBWFmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 00:42:24 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] [BUILD_FAILURE] 2.6.25-rc2-mm1 - Build Failure at acpi_os
Date: Sat, 23 Feb 2008 00:41:23 -0500
User-Agent: KMail/1.9.5
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Nish Aravamudan <nish.aravamudan@gmail.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080222185648.GA6843@uranus.ravnborg.org> <20080222112504.04e6b6a9.randy.dunlap@oracle.com>
In-Reply-To: <20080222112504.04e6b6a9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802230041.24272.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

works for me!

applied.

thanks,
-len

ps.  CONFIG_ACPI_CUSTOM_DSDT's only use is to guard the use of
CONFIG_ACPI_CUSTOM_DSDT_FILE:

#ifdef CONFIG_ACPI_CUSTOM_DSDT
#include CONFIG_ACPI_CUSTOM_DSDT_FILE
#endif

we could get rid of it if cpp could so something like

#if (CONFIG_ACPI_CUSTOM_DSDT_FILE != "")
#include CONFIG_ACPI_CUSTOM_DSDT_FILE
#endif

but it doesn't look like cpp has a concept of strings in expressions.

On Friday 22 February 2008 14:25, Randy Dunlap wrote:
> Let's see what the ACPI people think about this change.
> 
> Thanks, Sam.
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make ACPI_CUSTOM_DSDT boolean config symbol a hidden and derived
> value, based on the value of ACPI_CUSTOM_DSDT_FILE (string).
> Only the latter is presented to the user as a config option.
> 
> This fixes problems with "make randconfig" setting ACPI_CUSTOM_DSDT
> but leaving ACPI_CUSTOM_DSDT_FILE empty/blank.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/acpi/Kconfig |   19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> --- linux-2.6.25-rc2-git5.orig/drivers/acpi/Kconfig
> +++ linux-2.6.25-rc2-git5/drivers/acpi/Kconfig
> @@ -283,24 +283,23 @@ config ACPI_TOSHIBA
>  	  If you have a legacy free Toshiba laptop (such as the Libretto L1
>  	  series), say Y.
>  
> -config ACPI_CUSTOM_DSDT
> -	bool "Include Custom DSDT"
> +config ACPI_CUSTOM_DSDT_FILE
> +	string "Custom DSDT Table file to include"
> +	default ""
>  	depends on !STANDALONE
> -	default n 
>  	help
>  	  This option supports a custom DSDT by linking it into the kernel.
>  	  See Documentation/acpi/dsdt-override.txt
>  
> -	  If unsure, say N.
> -
> -config ACPI_CUSTOM_DSDT_FILE
> -	string "Custom DSDT Table file to include"
> -	depends on ACPI_CUSTOM_DSDT
> -	default ""
> -	help
>  	  Enter the full path name to the file which includes the AmlCode
>  	  declaration.
>  
> +	  If unsure, don't enter a file name.
> +
> +config ACPI_CUSTOM_DSDT
> +	bool
> +	default ACPI_CUSTOM_DSDT_FILE != ""
> +
>  config ACPI_CUSTOM_DSDT_INITRD
>  	bool "Read Custom DSDT from initramfs"
>  	depends on BLK_DEV_INITRD
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
