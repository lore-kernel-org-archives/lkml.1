Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbZLDU1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbZLDU1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbZLDU1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:27:06 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:32005 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbZLDU1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:27:05 -0500
Date: Fri, 4 Dec 2009 13:27:09 -0700
From: Alex Chiang <achiang@hp.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci: Make pci_dev struct point to NULL.
Message-ID: <20091204202709.GA32347@ldl.fc.hp.com>
References: <b9df5fa10912040835k3e23702o8700d2d8ad2349a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10912040835k3e23702o8700d2d8ad2349a4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rakib Mullick <rakib.mullick@gmail.com>:
>  pci: Make pci_dev struct point to NULL.
> 
> In function enable_device of acpiphp_glue.c, structure pci_dev
> doesn't point anything. Due to the check in line 975 we might
> end up being uninitialized. So make it point to NULL.
> 
> ---
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linus/drivers/pci/hotplug/acpiphp_glue.c	2009-12-03 21:30:57.000000000 +0600
> +++ rakib/drivers/pci/hotplug/acpiphp_glue.c	2009-12-03 23:53:44.000000000 +0600
> @@ -964,7 +964,7 @@ static int acpiphp_bus_trim(acpi_handle
>   */
>  static int __ref enable_device(struct acpiphp_slot *slot)
>  {
> -	struct pci_dev *dev;
> +	struct pci_dev *dev = NULL;
>  	struct pci_bus *bus = slot->bridge->pci_bus;
>  	struct list_head *l;
>  	struct acpiphp_func *func;

This is from Linus's latest tree:

 965 static int __ref enable_device(struct acpiphp_slot *slot)
 966 {
 967         struct pci_dev *dev;
 968         struct pci_bus *bus = slot->bridge->pci_bus;
 969         struct list_head *l;
 970         struct acpiphp_func *func;
 971         int retval = 0;
 972         int num, max, pass;
 973         acpi_status status;
 974 
 975         if (slot->flags & SLOT_ENABLED)
 976                 goto err_exit;
 977 
 978         /* sanity check: dev should be NULL when hot-plugged in */
 979         dev = pci_get_slot(bus, PCI_DEVFN(slot->device, 0));
 980         if (dev) {

I assume your line 975 is my line 980.

pci_get_slot() returns NULL if it doesn't find the devfn, so as
far as I can tell, there's no need to initialize dev to NULL.

Were you fixing a real bug with this patch? Did you actually get
the "pci_dev structure already exists.\n" error message?

Thanks,
/ac
