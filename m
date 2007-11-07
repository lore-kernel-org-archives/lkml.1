Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXKGRON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXKGRON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbXKGRN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:13:58 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41670 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbXKGRN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:13:56 -0500
Message-ID: <4731F235.9030408@linux.vnet.ibm.com>
Date: Wed, 07 Nov 2007 22:43:25 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, trenn@suse.de, mhoffman@lightlink.com,
       lenb@kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32 - ACPI functions broken
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org> <4730DF4B.6090905@linux.vnet.ibm.com> <200711071329.49726.jdelvare@suse.de>
In-Reply-To: <200711071329.49726.jdelvare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Kamalesh,
> 
> Le mardi 06 novembre 2007, Kamalesh Babulal a écrit :
>> Hi Andrew,
>>
>> The kernel build fails, on powerpc while compiling the kernel with allyesconfig option
>>
>> drivers/hwmon/w83627hf.c:1631: error: implicit declaration of function ‘acpi_check_resource_conflict’
>> make[2]: *** [drivers/hwmon/w83627hf.o] Error 1
>> make[1]: *** [drivers/hwmon] Error 2
>> make: *** [drivers] Error 2
>>   CC      fs/xfs/xfs_error.o
>> drivers/hwmon/w83627hf.c:1631: error: implicit declaration of function ‘acpi_check_resource_conflict’
>> make[2]: *** [drivers/hwmon/w83627hf.o] Error 1
>> make[1]: *** [drivers/hwmon] Error 2
>> make: *** [drivers] Error 2
>> drivers/i2c/busses/i2c-ali1535.c:163: error: implicit declaration of function ‘acpi_check_region’
>> make[3]: *** [drivers/i2c/busses/i2c-ali1535.o] Error 1
>> make[2]: *** [drivers/i2c/busses] Error 2
>> make[1]: *** [drivers/i2c] Error 2
>> drivers/hwmon/dme1737.c:2231: error: implicit declaration of function ‘acpi_check_resource_conflict’
>> make[2]: *** [drivers/hwmon/dme1737.o] Error 1
>> make[1]: *** [drivers/hwmon] Error 2
>> make: *** [drivers] Error 2
> 
> Odd. Thanks for reporting.
> 
>> The patches check-for-acpi-resource-conflicts-in-hwmon-drivers and 
>> check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch, causes this build failure.
>> The declaration of the functions are under ifdef CONFIG_ACPI.
> 
> There's an #else after that, and the functions are defined as inlines
> doing nothing in the non-ACPI case. The code looks OK to me, but I can
> reproduce the problem on x86_64 with CONFIG_ACPI=n.
> 
> Aha, I see it now, there are nested #ifdef CONFIG_ACPI in acpi.h,
> so the inner one is a no-op (and its #else counterpart is never
> evaluated.) That's pretty confusing, I'll send a patch fixing this.
> 
> In the meantime, here's a quick fix so that you can go on testing
> the mm snapshot. Apply this at the top of the series:
> 
> Fix the <linux/acpi.h> breakage for CONFIG_ACPI=n.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> ---
>  include/linux/acpi.h |   23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> --- linux-2.6.24-rc1.orig/include/linux/acpi.h	2007-11-07 12:45:47.000000000 +0100
> +++ linux-2.6.24-rc1/include/linux/acpi.h	2007-11-07 13:23:06.000000000 +0100
> @@ -26,6 +26,7 @@
>  #define _LINUX_ACPI_H
> 
> 
> +#include <linux/ioport.h>
>  #ifdef	CONFIG_ACPI
> 
>  #ifndef _LINUX
> @@ -134,17 +135,6 @@ int acpi_check_mem_region(resource_size_
> 
>  #define acpi_mp_config	0
> 
> -static inline int acpi_check_resource_conflict(struct resource *res)
> -{ return 0; }
> -
> -static inline int acpi_check_region(resource_size_t start, resource_size_t n,
> -				    const char *name)
> -{ return 0; }
> -
> -static inline int acpi_check_mem_region(resource_size_t start,
> -					resource_size_t n, const char *name)
> -{ return 0; }
> -
>  #endif 	/* !CONFIG_ACPI */
> 
>  int acpi_register_gsi (u32 gsi, int triggering, int polarity);
> @@ -239,5 +229,16 @@ static inline int acpi_boot_table_init(v
>  	return 0;
>  }
> 
> +static inline int acpi_check_resource_conflict(struct resource *res)
> +{ return 0; }
> +
> +static inline int acpi_check_region(resource_size_t start, resource_size_t n,
> +				    const char *name)
> +{ return 0; }
> +
> +static inline int acpi_check_mem_region(resource_size_t start,
> +					resource_size_t n, const char *name)
> +{ return 0; }
> +
>  #endif	/* CONFIG_ACPI */
>  #endif	/*_LINUX_ACPI_H*/
> 
> 
Hi Jean,

Thanks for the quick fix.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
