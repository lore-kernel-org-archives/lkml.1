Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120Ab0ADXkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0ADXkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096Ab0ADXkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:40:45 -0500
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:43323 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754076Ab0ADXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:40:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dayNFOxte+nPUTVC+sAE1C66hq9wukLmaFCPbNuN/C0ZVXRV5pQu4ihbpPHb8PT4c3Y3bzkoSqhTXWUDYg3yyAZex3+QWuJqDfJuNEnJbwiX9SZpXb4ZJwpI8rjZdty5;
Date: Mon, 4 Jan 2010 15:40:38 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [PATCH 2/12] PCI / PM: Propagate wake-up enable for PCIe
 devices too
Message-ID: <20100104154038.76a9eedf@jbarnes-piketon>
In-Reply-To: <200912272100.33117.rjw@sisk.pl>
References: <200912272057.10443.rjw@sisk.pl>
	<200912272100.33117.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 21:00:33 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Having read the PM part of the PCIe 2.0 specification more carefully
> I think that it was a mistake to restrict the wake-up enable
> propagation to non-PCIe devices, because if we do not request
> control of the root ports' PME registers via OSC, PCIe PME is
> supposed to be handled by the platform, just like the non-PCIe PME.
> Even if we do that, the wake-up propagation is done to allow the
> devices to wake up the system from sleep states which involves the
> platform anyway, so it won't hurt.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci-acpi.c |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> Index: linux-2.6/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-acpi.c
> +++ linux-2.6/drivers/pci/pci-acpi.c
> @@ -112,11 +112,7 @@ static bool acpi_pci_can_wakeup(struct p
>  static void acpi_pci_propagate_wakeup_enable(struct pci_bus *bus,
> bool enable) {
>  	while (bus->parent) {
> -		struct pci_dev *bridge = bus->self;
> -		int ret;
> -
> -		ret = acpi_pm_device_sleep_wake(&bridge->dev,
> enable);
> -		if (!ret || pci_is_pcie(bridge))
> +		if (!acpi_pm_device_sleep_wake(&bus->self->dev,
> enable)) return;
>  		bus = bus->parent;
>  	}
> @@ -131,9 +127,7 @@ static int acpi_pci_sleep_wake(struct pc
>  	if (acpi_pci_can_wakeup(dev))
>  		return acpi_pm_device_sleep_wake(&dev->dev, enable);
>  
> -	if (!pci_is_pcie(dev))
> -		acpi_pci_propagate_wakeup_enable(dev->bus, enable);
> -
> +	acpi_pci_propagate_wakeup_enable(dev->bus, enable);
>  	return 0;
>  }

Seems ok to try it out, but as usual with this sort of thing, the real
question is, "What does Windows do?", since wakeup enable ACPI support
for PCIe devices is likely broken unless Windows uses it.

-- 
Jesse Barnes, Intel Open Source Technology Center
