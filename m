Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYCQTAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYCQTAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYCQTAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:00:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:50356 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbYCQTAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:00:44 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] thermal: fix Kconfig dependencies
Date: Mon, 17 Mar 2008 14:59:10 -0400
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
References: <20080317095845.GA6500@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0803170953210.3020@woody.linux-foundation.org> <20080317184339.GA3754@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20080317184339.GA3754@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171459.10656.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Heiko Carstens wrote:
> On Mon, Mar 17, 2008 at 09:55:13AM -0700, Linus Torvalds wrote:
> > On Mon, 17 Mar 2008, Heiko Carstens wrote:
> > > 
> > > Change the select to a depends on to fix this. Should work as well.
> > 
> > Nope, that doesn't work. ACPI_THERMAL will select THERMAL, so now you have 
> > THERMAL selected without HWMON.
> 
> Oh, missed that. Sorry.
>  
> > As a minimal fix, you'd at least need to make ACPI_THERMAL depend on 
> > THERMAL too.

Although the "select" that started this thread was certainly erroneous,
this doesn't look right either.

THERMAL should not depend on or select HWMON.
Instead, part of its code that is there for
the benefit of HWMON should depend on HWMON.

Based on Jean's last message, that code should
probably get its own sub-config option, CONFIG_THERMAL_HWMON
that is default N for the benefit of old libraries.

Similarly, ACPI_THERMAL should not depend on THERMAL,
instead the code that registers with THERMAL should
simply depend on if THERMAL is selected or not.

Also, the "default y" should go.

I'll tinker with this a bit after lunch.

thanks,
-Len


> Updated patch:
> 
> Subject: [PATCH] thermal: fix Kconfig dependencies
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> git commit 3152fb9f11cdd2fd8688c2c5cb805e5c09b53dd9
> "thermal: fix generic thermal I/F for hwmon" adds a select HWMON
> to THERMAL. This causes HWMON to be selected regardless of its
> other dependencies. In this case depends on HAS_IOMEM gets ignored
> which causes this build error on s390:
> 
> drivers/hwmon/w83627hf.c: In function 'superio_outb':
> drivers/hwmon/w83627hf.c:117: error: implicit declaration of function 'outb'
> 
> Change the select to a depends on. In addition change the select THERMAL
> from ACPI_THERMAL to a depends on THERMAL. Otherwise THERMAL
> could be selected by ACPI_THERMAL without HWMON being selected.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
>  drivers/acpi/Kconfig    |    3 +--
>  drivers/thermal/Kconfig |    2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/thermal/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/thermal/Kconfig
> +++ linux-2.6/drivers/thermal/Kconfig
> @@ -4,7 +4,7 @@
>  
>  menuconfig THERMAL
>  	bool "Generic Thermal sysfs driver"
> -	select HWMON
> +	depends on HWMON
>  	default y
>  	help
>  	  Generic Thermal Sysfs driver offers a generic mechanism for
> Index: linux-2.6/drivers/acpi/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/Kconfig
> +++ linux-2.6/drivers/acpi/Kconfig
> @@ -187,8 +187,7 @@ config ACPI_HOTPLUG_CPU
>  
>  config ACPI_THERMAL
>  	tristate "Thermal Zone"
> -	depends on ACPI_PROCESSOR
> -	select THERMAL
> +	depends on ACPI_PROCESSOR && THERMAL
>  	default y
>  	help
>  	  This driver adds support for ACPI thermal zones.  Most mobile and
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


