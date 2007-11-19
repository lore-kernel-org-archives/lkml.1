Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbXKSRzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbXKSRzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 12:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbXKSRyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 12:54:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:40663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbXKSRyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:54:50 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] [RFC] Expose _SUN in /proc/acpi/processor/<...>/info
Date: Mon, 19 Nov 2007 12:54:33 -0500
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel@vger.kernel.org
References: <20071019193844.GL8122@ldl.fc.hp.com> <20071030235057.GD3127@ldl.fc.hp.com>
In-Reply-To: <20071030235057.GD3127@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711191254.33682.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 19:50, Alex Chiang wrote:
> Hello,
> 
> I'm looking for comments on the following patch that exposes _SUN
> on processor objects in /proc/acpi/processor/<...>/info. 
> 
> This didn't get many comments on the linux-acpi list, so I'm
> sending to a wider distribution.
> 
> I notice that acpiphp exposes _SUN for (hotpluggable) PCI slots
> in /sys/bus/pci/slots/N/, where N is the value of _SUN. I'm not
> so sure we want to go *exactly* in the same direction for CPUs,
> because:
> 
>   - x86 systems might not implement _SUN for processors
>   - ia64 systems that implement ACPI 2.x do not have unique
>     values for _SUN across the entire system
> 
> Nonetheless, even non-unique values of _SUN are still helpful for
> userspace to figure out which physical socket a CPU might be in,
> especially when combined with information from /proc/cpuinfo.
> 
> Thoughts?

We've not allowed new features in /proc/acpi
since we started removing /proc/acpi.
ie. we don't want to update the API, we want to delete it.

If this is a useful thing for user-space to know, then you need
to figure out a generic way to present it -- likely under
/sys/devices/system/cpu/

Andrew, please remove acpi-expose-_sun-in-proc-acpi-processor-info.patch
from the mm series.

thanks,
-Len


>  
> From: Alex Chiang <achiang@hp.com>
> 
> On platforms that provide _SUN for the processor object, higher
> level software can consume the data to learn physical topology
> information, so let's expose it.
> 
> Platforms that do not implement _SUN will see <not supported>.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
>  drivers/acpi/processor_core.c |   11 +++++++++++
>  include/acpi/processor.h      |    1 +
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index 235a51e..86cb41a 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -302,6 +302,11 @@ static int acpi_processor_info_seq_show(struct seq_file *seq, void *offset)
>  		   pr->flags.throttling ? "yes" : "no",
>  		   pr->flags.limit ? "yes" : "no");
>  
> +	if (pr->sun == -1)
> +		seq_printf(seq, "slot user number:        <not supported>\n");
> +	else
> +		seq_printf(seq, "slot user number:        %d\n", (int)pr->sun);
> +
>        end:
>  	return 0;
>  }
> @@ -590,6 +595,12 @@ static int acpi_processor_get_info(struct acpi_processor *pr, unsigned has_uid)
>  	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Processor [%d:%d]\n", pr->id,
>  			  pr->acpi_id));
>  
> +	status = acpi_evaluate_object(pr->handle, "_SUN", NULL, &buffer);
> +	if (ACPI_FAILURE(status))
> +		object.integer.value = -1;
> +
> +	pr->sun = object.integer.value;
> +
>  	if (!object.processor.pblk_address)
>  		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No PBLK (NULL address)\n"));
>  	else if (object.processor.pblk_length != 6)
> diff --git a/include/acpi/processor.h b/include/acpi/processor.h
> index 26d79f6..81792c6 100644
> --- a/include/acpi/processor.h
> +++ b/include/acpi/processor.h
> @@ -210,6 +210,7 @@ struct acpi_processor {
>  	u32 acpi_id;
>  	u32 id;
>  	u32 pblk;
> +	acpi_native_int sun;
>  	int performance_platform_limit;
>  	int throttling_platform_limit;
>  	/* 0 - states 0..n-th state available */
