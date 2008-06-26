Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYFZUzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYFZUzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYFZUy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:54:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:16822 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYFZUy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KpAt2Yw5TYqq9ewNHbOIGYo2imzIT8hYQO6JWWb3imD+myOC8x9gH3JTdiKsBqFQFZ
         zx+TvdtxE3cJT2oeZ6M1ghzjs882XkS0P4WkIlwnls4A11PLK3r/N/qo1LXK4WpSfluN
         5z/ozgkAOmPs1oPPMYTrgwW3N2+A38GwH3qa0=
Message-ID: <86802c440806261354y673a5521ie615feafae3b2bd8@mail.gmail.com>
Date: Thu, 26 Jun 2008 13:54:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH 2/2] Use FIRMWARE_MEMMAP on x86/E820
Cc: x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, gregkh@suse.de
In-Reply-To: <1214511542-28458-3-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214511542-28458-1-git-send-email-bwalle@suse.de>
	 <1214511542-28458-3-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 1:19 PM, Bernhard Walle <bwalle@suse.de> wrote:
> This patch uses the /sys/firmware/memmap interface provided in the last patch
> on the x86 architecture when E820 is used. The patch copies the E820
> memory map very early, and registers the E820 map afterwards via
> firmware_map_add_early().
>
>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  arch/x86/kernel/e820.c |   42 ++++++++++++++++++++++++++++++++++++------
>  include/asm-x86/e820.h |    2 ++
>  2 files changed, 38 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 1dcb665..e48eb10 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -19,6 +19,7 @@
>  #include <linux/mm.h>
>  #include <linux/pfn.h>
>  #include <linux/suspend.h>
> +#include <linux/firmware-map.h>
>
>  #include <asm/pgtable.h>
>  #include <asm/page.h>
> @@ -27,7 +28,22 @@
>  #include <asm/setup.h>
>  #include <asm/trampoline.h>
>
> +/*
> + * The e820 map is the map that gets modified e.g. with command line parameters
> + * and that is also registered with modifications in the kernel resource tree
> + * with the iomem_resource as parent.
> + *
> + * The e820_saved is directly saved after the BIOS-provided memory map is
> + * copied. It doesn't get modified afterwards. It's registered for the
> + * /sys/firmware/memmap interface.
> + *
> + * That memory map is not modified and is used as base for kexec. The kexec'd
> + * kernel should get the same memory map as the firmware provides. Then the
> + * user can e.g. boot the original kernel with mem=1G while still booting the
> + * next kernel with full memory.
> + */
>  struct e820map e820;
> +struct e820map e820_saved;
>
>  /* For PCI or other memory-mapped resources */
>  unsigned long pci_mem_start = 0xaeedbabe;
> @@ -1180,6 +1196,16 @@ void __init finish_e820_parsing(void)
>        }
>  }
>
> +static inline const char *e820_type_to_string(int e820_type)
> +{
> +       switch (e820_type) {
> +       case E820_RAM:  return "System RAM";
> +       case E820_ACPI: return "ACPI Tables";
> +       case E820_NVS:  return "ACPI Non-volatile Storage";
> +       default:        return "reserved";
> +       }
> +}
> +
>  /*
>  * Mark e820 reserved areas as busy for the resource manager.
>  */
> @@ -1190,12 +1216,7 @@ void __init e820_reserve_resources(void)
>
>        res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
>        for (i = 0; i < e820.nr_map; i++) {
> -               switch (e820.map[i].type) {
> -               case E820_RAM:  res->name = "System RAM"; break;
> -               case E820_ACPI: res->name = "ACPI Tables"; break;
> -               case E820_NVS:  res->name = "ACPI Non-volatile Storage"; break;
> -               default:        res->name = "reserved";
> -               }
> +               res->name = e820_type_to_string(e820.map[i].type);
>                res->start = e820.map[i].addr;
>                res->end = res->start + e820.map[i].size - 1;
>  #ifndef CONFIG_RESOURCES_64BIT
> @@ -1208,6 +1229,13 @@ void __init e820_reserve_resources(void)
>                insert_resource(&iomem_resource, res);
>                res++;
>        }
> +
> +       for (i = 0; i < e820_saved.nr_map; i++) {
> +               struct e820entry *entry = &e820_saved.map[i];
> +               firmware_map_add_early(entry->addr,
> +                       entry->addr + entry->size - 1,
> +                       e820_type_to_string(entry->type));
> +       }
>  }
>
>  char *__init default_machine_specific_memory_setup(void)
> @@ -1243,6 +1271,8 @@ char *__init default_machine_specific_memory_setup(void)
>                e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
>        }
>
> +       memcpy(&e820_saved, &e820, sizeof(struct e820map));
> +
>        /* In case someone cares... */
>        return who;
>  }
> diff --git a/include/asm-x86/e820.h b/include/asm-x86/e820.h
> index f622685..64ce6f8 100644
> --- a/include/asm-x86/e820.h
> +++ b/include/asm-x86/e820.h
> @@ -56,7 +56,9 @@ struct e820map {
>        struct e820entry map[E820_X_MAX];
>  };
>
> +/* see comment in arch/x86/kernel/e820.c */
>  extern struct e820map e820;
> +extern struct e820map e820_saved;
>
>  extern int e820_any_mapped(u64 start, u64 end, unsigned type);
>  extern int e820_all_mapped(u64 start, u64 end, unsigned type);
> --

looks good...

will produce one patch update early_reserve_e820_mpc_new or
early_reserve_e820 to update e820_saved too. that contained updated
mptable for second kernel without acpi support.

YH
