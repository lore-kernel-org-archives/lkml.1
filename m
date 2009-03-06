Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZCFURT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZCFURT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbZCFURI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:17:08 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:31779 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZCFURH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:17:07 -0500
Subject: Re: [PATCH] PCIe: AER: during disable, check subordinate before
 walking
From: Andrew Patterson <andrew.patterson@hp.com>
To: Alex Chiang <achiang@hp.com>
Cc: jbarnes@virtuousgeek.org, matthew@wil.cx,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090306022840.GC30103@ldl.fc.hp.com>
References: <20090306022840.GC30103@ldl.fc.hp.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 13:17:05 -0700
Message-Id: <1236370625.1168.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 19:28 -0700, Alex Chiang wrote: 
> Commit 47a8b0cc (Enable PCIe AER only after checking firmware
> support) wants to walk the PCI bus in the remove path to disable
> AER, and calls pci_walk_bus for downstream bridges.
> 
> Unfortunately, in the remove path, we remove devices and bridges
> in a depth-first manner, starting with the furthest downstream
> bridge and working our way backwards.
> 
> The furthest downstream bridges will not have a dev->subordinate,
> and we hit a NULL deref in pci_walk_bus.
> 
> Check for dev->subordinate first before attempting to walk the
> PCI hierarchy below us.
> 

Looks good.

Acked-by: Andrew Patterson <andrew.patterson@hp.com>

> Cc: Andrew Patterson <andrew.patterson@hp.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> Willy, this is .29 material, please push to Linus, thanks.
> 
> ---
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index aebb5f6..677d680 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -133,6 +133,9 @@ static void set_downstream_devices_error_reporting(struct pci_dev *dev,
>  						   bool enable)
>  {
>  	set_device_error_reporting(dev, &enable);
> +
> +	if (!dev->subordinate)
> +		return;
>  	pci_walk_bus(dev->subordinate, set_device_error_reporting, &enable);
>  }
>  

-- 
Andrew Patterson
Hewlett-Packard Company

