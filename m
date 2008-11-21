Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbYKUXIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbYKUXIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 18:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbYKUXIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 18:08:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840AbYKUXIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 18:08:42 -0500
Date: Fri, 21 Nov 2008 15:08:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: youquan_song@linux.intel.com
Cc: linux-acpi@vger.kernel.org, venkatesh.pallipadi@intel.com,
       len.brown@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  ACPI: Check _PSS invalidation when BIOS report _PSS
 with  all 0x80000000
Message-Id: <20081121150839.58dbedfa.akpm@linux-foundation.org>
In-Reply-To: <3606.172.16.183.72.1227236916.squirrel@linux.intel.com>
References: <3606.172.16.183.72.1227236916.squirrel@linux.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 19:08:36 -0800 (PST)
youquan_song@linux.intel.com wrote:

> Subject: Check _PSS invalidation when BIOS report _PSS with 0x80000000
> 
> When cpu frequencey scaling disable,some BIOS report _PSS with all
> 0x80000000.
> If kernel treat this case as valid, the kernel will boot crash when load
> cpufreq govenors.
> 
> So in order to cover more buggy BIOSs, the patch just check _PSS core
> frequencey invalidtion.
> 

It's unclear how many machines this will affect, and what the effects
of not having the patch are upon those machines.  That is useful
information for people who are deciding whcih kernel versions this
patch should be merged into.

Do you think this fix is needed in 2.6.28?  2.6.27.x?  2.6.26.x?  etc?

> 
> --- linux-2.6-tip-orignal/drivers/acpi/processor_perflib.c	2008-11-20
> 12:25:05.000000000 -0500
> +++ linux-2.6-tip/drivers/acpi/processor_perflib.c	2008-11-20
> 12:23:57.000000000 -0500

Your email client is wordwrapping the text, btw.

> @@ -50,6 +50,7 @@
>  #define ACPI_PROCESSOR_CLASS		"processor"
>  #define ACPI_PROCESSOR_FILE_PERFORMANCE	"performance"
>  #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
> +#define ACPI_PROCESSOR_PSS_INVALID	0x80000000
>  ACPI_MODULE_NAME("processor_perflib");
> 
>  static DEFINE_MUTEX(performance_mutex);
> @@ -324,6 +325,14 @@
>  			kfree(pr->performance->states);
>  			goto end;
>  		}
> +
> +		if (px->core_frequency == ACPI_PROCESSOR_PSS_INVALID) {
> +			printk(KERN_ERR PREFIX
> +				    "P-states disabled in the BIOS\n");
> +			result = -EFAULT;
> +			kfree(pr->performance->states);
> +			goto end;
> +		}
>  	}
> 
>        end:

