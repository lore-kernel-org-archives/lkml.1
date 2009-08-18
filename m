Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbZHRG6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbZHRG6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 02:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZHRG6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 02:58:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:36075 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZHRG6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 02:58:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,401,1246863600"; 
   d="scan'208";a="542249797"
Subject: Re: [RFC][PATCH 5/7] PM: Asynchronous suspend and resume of PCI
	devices
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
In-Reply-To: <200908170220.18874.rjw@sisk.pl>
References: <200908122218.13975.rjw@sisk.pl>
	 <200908170215.21173.rjw@sisk.pl>  <200908170220.18874.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Tue, 18 Aug 2009 14:57:08 +0800
Message-Id: <1250578628.5351.64.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 08:20 +0800, Rafael J. Wysocki wrote:
> Set async_suspend for all PCI devices and PCIe port services.
> 
﻿Alan said that we can not break the resume order of the uhci/ehci host
controllers on some platforms.

For example,
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
Controller #2 (rev 02)
00:1a.7 must be resumed after 00:1a.0 and 00:1a.1

please refer to this thread:
http://marc.info/?l=linux-acpi&m=122996117918188&w=2

So I'm afraid we can not suspend/resume the PCI devices in parallel,
unless we add this off-tree dependency at the same time.

thanks,
rui
> ---
>  drivers/input/serio/i8042.c     |    2 ++
>  drivers/pci/pci.c               |    2 ++
>  drivers/pci/pcie/portdrv_core.c |    1 +
>  3 files changed, 5 insertions(+)
> 
> Index: linux-2.6/drivers/pci/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -1409,6 +1409,8 @@ void pci_pm_init(struct pci_dev *dev)
>  	} else {
>  		dev->pme_support = 0;
>  	}
> +
> +	device_enable_async_suspend(&dev->dev, true);
>  }
>  
>  /**
> Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
> +++ linux-2.6/drivers/pci/pcie/portdrv_core.c
> @@ -280,6 +280,7 @@ static void pcie_device_init(struct pci_
>  	dev_set_name(device, "%s:pcie%02x",
>  		 pci_name(parent), get_descriptor_id(port_type, service_type));
>  	device->parent = &parent->dev;
> +	device_enable_async_suspend(device, true);
>  }
>  
>  /**

