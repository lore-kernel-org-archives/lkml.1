Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYFYWoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYFYWoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYFYWoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:44:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbYFYWoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:44:22 -0400
Date: Wed, 25 Jun 2008 18:43:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-ID: <20080625224301.GE32344@redhat.com>
References: <1214423826-12628-1-git-send-email-bwalle@suse.de> <1214423826-12628-2-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214423826-12628-2-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 09:57:05PM +0200, Bernhard Walle wrote:
> This patch adds /sys/firmware/memmap interface that represents the BIOS
> (or Firmware) provided memory map. The tree looks like:
> 
>     /sys/firmware/memmap/0/start   (hex number)
>                            end     (hex number)
>                            type    (string)
>     ...                 /1/start
>                            end
>                            type
> 
> With the following shell snippet one can print the memory map in the same form
> the kernel prints itself when booting on x86 (the E820 map).
> 
>   --------- 8< --------------------------
>     #!/bin/sh
>     cd /sys/firmware/memmap
>     for dir in * ; do
>         start=$(cat $dir/start)
>         end=$(cat $dir/end)
>         type=$(cat $dir/type)
>         printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type"
>     done
>   --------- >8 --------------------------
> 
> That patch only provides the needed interface:
> 
>  1. The sysfs interface.
>  2. The structure and enumeration definition.
>  3. The function firmware_map_add() and firmware_map_add_early()
>     that should be called from architecture code (E820/EFI, for
>     example) to add the contents to the interface.
> 
> If the kernel is compiled without CONFIG_FIRMWARE_MEMMAP, the interface does
> nothing without cluttering the architecture-specific code with #ifdef's.
> 

Hi Bernhard,

Thanks for the patch. Couple of thoughts.

Do we really need another CONFIG option (CONFIG_FIRMWARE_MEMMAP)? To,
me this does not seem to be a big chunk of code at the same time I am
assuming that most of the people will use it (because of kexec). So
probably, it might not make lot of sense to put additional CONFIG option.

[..]
> +#include <linux/string.h>
> +#include <linux/firmware-map.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/bootmem.h>
> +
> +/*
> + * String representation of enum firmware_map_type from
> + * <linux/firmware-map.h>.
> + */
> +const char *type_to_string_map[] = {
> +	"RAM",				/* MAP_RAM */
> +	"Reserved",			/* MAP_RESERVED */
> +	"ACPI Tables",			/* MAP_ACPI */
> +	"Non-volatile Storage",		/* MAP_NVS */
> +};
> +

How about leaving the decision of memory type on arch dependent code? How
about letting arch code pass you an string while adding entry and that
string will contain the type of memory. The way request_resource() is
implemented. 

I think that would be easier and provide more flexibility to arch
dependent code. For example, I see so many additional memory types for
EFI code. It will be good to give EFI code flexibility that how does
he perceive a particular memory region and then let kexec-tools deal 
with various memory types.
 
Thanks
Vivek
