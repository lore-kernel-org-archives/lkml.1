Return-Path: <linux-kernel-owner+w=401wt.eu-S1765851AbYBOW7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765851AbYBOW7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764253AbYBOWwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:52:32 -0500
Received: from mailhost.somanetworks.com ([216.126.67.42]:45623 "EHLO
	mail.somanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934614AbYBOWwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:52:30 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2008 17:52:29 EST
Date: Fri, 15 Feb 2008 17:45:47 -0500 (EST)
From: Scott Murray <scottm@somanetworks.com>
X-X-Sender: scottm@rancor.yyz.somanetworks.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH 06/12] PCI Hotplug: make cpcihp driver use modern apis
In-Reply-To: <1203036010-27988-6-git-send-email-gregkh@suse.de>
Message-ID: <alpine.LFD.0.9999.0802151744330.3386@rancor.yyz.somanetworks.com>
References: <20080215003909.GA27981@kroah.com> <1203036010-27988-6-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Greg Kroah-Hartman wrote:

> This removes the depandancy of the cpcihp driver from the PCI_LEGACY
> config option by removing its usage of the pci_find_bus() function.
>
>
> Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> Cc: Scott Murray <scottm@somanetworks.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Sorry for the slow reply, this looks fine to me.

Signed-off-by: Scott Murray <scottm@somanetworks.com>

Scott

> ---
>  drivers/pci/hotplug/Kconfig          |    2 +-
>  drivers/pci/hotplug/cpcihp_generic.c |    8 +++++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
> index 2cdd832..17fb3d6 100644
> --- a/drivers/pci/hotplug/Kconfig
> +++ b/drivers/pci/hotplug/Kconfig
> @@ -119,7 +119,7 @@ config HOTPLUG_PCI_CPCI_ZT5550
>
>  config HOTPLUG_PCI_CPCI_GENERIC
>  	tristate "Generic port I/O CompactPCI Hotplug driver"
> -	depends on HOTPLUG_PCI_CPCI && X86 && PCI_LEGACY
> +	depends on HOTPLUG_PCI_CPCI && X86
>  	help
>  	  Say Y here if you have a CompactPCI system card that exposes the #ENUM
>  	  hotswap signal as a bit in a system register that can be read through
> diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
> index f3852a6..148fb46 100644
> --- a/drivers/pci/hotplug/cpcihp_generic.c
> +++ b/drivers/pci/hotplug/cpcihp_generic.c
> @@ -154,12 +154,18 @@ static int __init cpcihp_generic_init(void)
>  	if(!r)
>  		return -EBUSY;
>
> -	dev = pci_find_slot(bridge_busnr, PCI_DEVFN(bridge_slot, 0));
> +	bus = pci_find_bus(0, bridge_busnr);
> +	if (!bus) {
> +		err("Invalid bus number %d", bridge_busnr);
> +		return -EINVAL;
> +	}
> +	dev = pci_get_slot(bus, PCI_DEVFN(bridge_slot, 0));
>  	if(!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
>  		err("Invalid bridge device %s", bridge);
>  		return -EINVAL;
>  	}
>  	bus = dev->subordinate;
> +	pci_dev_put(dev);
>
>  	memset(&generic_hpc, 0, sizeof (struct cpci_hp_controller));
>  	generic_hpc_ops.query_enum = query_enum;
>

-- 
Scott Murray
SOMA Networks, Inc.
Toronto, Ontario
e-mail: scottm@somanetworks.com
