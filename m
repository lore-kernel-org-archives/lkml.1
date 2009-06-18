Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbZFRPTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbZFRPTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZFRPTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:19:05 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:58373 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZFRPTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:19:03 -0400
Message-ID: <4A3A59DD.4070004@oracle.com>
Date: Thu, 18 Jun 2009 08:14:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       a.beregalov@gmail.com, lenb@kernel.org
Subject: Re: linux-next: Tree for June 17 (pci/slot)
References: <20090617155354.075c60ae.sfr@canb.auug.org.au> <4A39194B.2060200@oracle.com> <20090617163604.GT19977@parisc-linux.org> <20090617102901.6e39aac2@jbarnes-g45> <4A392B48.7060206@oracle.com> <20090617161001.734321be@jbarnes-g45> <20090618003808.GA29472@ldl.fc.hp.com> <20090618004612.GB29472@ldl.fc.hp.com> <20090618010357.GC29472@ldl.fc.hp.com>
In-Reply-To: <20090618010357.GC29472@ldl.fc.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A3A5AA0.022B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Alex Chiang <achiang@hp.com>:
>> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
>> index ba6af16..0be4efd 100644
>> --- a/drivers/pci/Makefile
>> +++ b/drivers/pci/Makefile
>> @@ -2,10 +2,11 @@
>>  # Makefile for the PCI bus specific drivers.
>>  #
>>  
>> -obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o slot.o \
>> -			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
>> +obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o \
>> +			pci-driver.o search.o rom.o setup-res.o \
>>  			irq.o
>>  obj-$(CONFIG_PROC_FS) += proc.o
>> +obj-$(CONFIG_SYSFS) += slot.o pci-sysfs.o
> 
> Sigh, this won't work because the PCI core blithely assumes we have
> sysfs:
> 
> drivers/built-in.o: In function `pci_bus_add_device':
> /kio/work/achiang/kernels/linux-2.6/drivers/pci/bus.c:89: undefined reference to `pci_create_sysfs_dev_files'
> drivers/built-in.o: In function `pci_stop_dev':
> /kio/work/achiang/kernels/linux-2.6/drivers/pci/remove.c:24: undefined reference to `pci_remove_sysfs_dev_files'
> 
> So, here is v3 that actually does build with !CONFIG_SYSFS. It
> touches a bit more now, but I believe it is still appropriate
> because neither pci_slot.ko nor any of the drivers in
> drivers/pci/hotplug/ are useful without sysfs.
> 
> From: Alex Chiang <achiang@hp.com>
> 
> PCI: drivers/pci/slot.c should depend on CONFIG_SYSFS
> 
> There is no way to interact with a physical PCI slot without
> sysfs, so encode the dependency and prevent this build error:
> 
> 	drivers/pci/slot.c: In function 'pci_hp_create_module_link':
> 	drivers/pci/slot.c:327: error: 'module_kset' undeclared
> 
> This patch _should_ make pci-sysfs.o depend on CONFIG_SYSFS too,
> but we cannot (yet) because the PCI core merrily assumes the
> existence of sysfs:
> 
> 	drivers/built-in.o: In function `pci_bus_add_device':
> 	drivers/pci/bus.c:89: undefined reference to `pci_create_sysfs_dev_files'
> 	drivers/built-in.o: In function `pci_stop_dev':
> 	drivers/pci/remove.c:24: undefined reference to `pci_remove_sysfs_dev_files'
> 
> So do the minimal bit for now and figure out how to untangle it
> later.
> 
> Cc: Len Brown <lenb@kernel.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> Fix-suggested-by: Matthew Wilcox <matthew@wil.cx>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 431f8b4..7ec7d88 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -266,6 +266,7 @@ config ACPI_DEBUG_FUNC_TRACE
>  
>  config ACPI_PCI_SLOT
>  	tristate "PCI slot detection driver"
> +	depends on SYSFS
>  	default n
>  	help
>  	  This driver creates entries in /sys/bus/pci/slots/ for all PCI
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index ba6af16..ed32f67 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -2,10 +2,11 @@
>  # Makefile for the PCI bus specific drivers.
>  #
>  
> -obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o slot.o \
> +obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o \
>  			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
>  			irq.o
>  obj-$(CONFIG_PROC_FS) += proc.o
> +obj-$(CONFIG_SYSFS) += slot.o
>  
>  # Build PCI Express stuff if needed
>  obj-$(CONFIG_PCIEPORTBUS) += pcie/
> diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
> index 9aa4fe1..522c360 100644
> --- a/drivers/pci/hotplug/Kconfig
> +++ b/drivers/pci/hotplug/Kconfig
> @@ -4,7 +4,7 @@
>  
>  menuconfig HOTPLUG_PCI
>  	tristate "Support for PCI Hotplug"
> -	depends on PCI && HOTPLUG
> +	depends on PCI && HOTPLUG && SYSFS
>  	---help---
>  	  Say Y here if you have a motherboard with a PCI Hotplug controller.
>  	  This allows you to add and remove PCI cards while the machine is


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
