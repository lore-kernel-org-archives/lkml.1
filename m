Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbYFZUqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbYFZUqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYFZUqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:46:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbYFZUqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:46:03 -0400
Date: Thu, 26 Jun 2008 16:45:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       yhlu.kernel@gmail.com, gregkh@suse.de
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-ID: <20080626204511.GF3878@redhat.com>
References: <1214511542-28458-1-git-send-email-bwalle@suse.de> <1214511542-28458-2-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214511542-28458-2-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:19:01PM +0200, Bernhard Walle wrote:
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
> The purpose of the new interface is kexec: While /proc/iomem represents
> the *used* memory map (e.g. modified via kernel parameters like 'memmap'
> and 'mem'), the /sys/firmware/memmap tree represents the unmodified memory
> map provided via the firmware. So kexec can:
> 
>  - use the original memory map for rebooting,
>  - use the /proc/iomem for setting up the ELF core headers for kdump
>    case that should only represent the memory of the system.
> 
> The patch has been tested on i386 and x86_64.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  drivers/firmware/Kconfig     |    8 ++
>  drivers/firmware/Makefile    |    1 +
>  drivers/firmware/memmap.c    |  164 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/firmware-map.h |   84 +++++++++++++++++++++
>  4 files changed, 257 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/firmware/memmap.c
>  create mode 100644 include/linux/firmware-map.h

I think you also need to introduce some documentation about this new
sysfs interface. Looks like in Documentation/ABI/ somewhere. Greg
can tell more...

Thanks
Vivek
