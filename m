Return-Path: <linux-kernel-owner+w=401wt.eu-S932909Ab0AFVql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab0AFVql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932872Ab0AFVqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:46:40 -0500
Received: from outbound-mail-133.bluehost.com ([67.222.39.23]:42211 "HELO
	outbound-mail-133.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756298Ab0AFVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:46:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SxKUTzwq8Iz9k/oyRtP5N1vk6hJDwuk0t9p7ODv9h0vPjvaEolID+f0i3c95cqfRbHA1Cpb+kbuGrfzYfJNR/SSN5xObzYA6K33Ic7EBx5yfRVXiQ6+rXlrDxdKvpaQ2;
Date: Wed, 6 Jan 2010 13:46:37 -0800
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
Subject: Re: [PATCH 1/12] PCI PM: Add function for checking PME status of
 devices
Message-ID: <20100106134637.7d016215@jbarnes-piketon>
In-Reply-To: <200912272059.06718.rjw@sisk.pl>
References: <200912272057.10443.rjw@sisk.pl>
	<200912272059.06718.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 20:59:06 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add function pci_check_pme_status() that will check the PME status
> bit of given device and clear it along with the PME enable bit.  It
> will be necessary for PCI run-time power management.
> 
> Based on a patch from Shaohua Li <shaohua.li@intel.com>
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci.c |   35 +++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.h |    1 +
>  2 files changed, 36 insertions(+)
> 
> Index: linux-2.6/drivers/pci/pci.h
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.h
> +++ linux-2.6/drivers/pci/pci.h
> @@ -49,6 +49,7 @@ struct pci_platform_pm_ops {
>  extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
>  extern void pci_update_current_state(struct pci_dev *dev,
> pci_power_t state); extern void pci_disable_enabled_device(struct
> pci_dev *dev); +extern bool pci_check_pme_status(struct pci_dev *dev);
>  extern void pci_pm_init(struct pci_dev *dev);
>  extern void platform_pci_wakeup_init(struct pci_dev *dev);
>  extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
> Index: linux-2.6/drivers/pci/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -1180,6 +1180,41 @@ int pci_set_pcie_reset_state(struct pci_
>  }
>  
>  /**
> + * pci_check_pme_status - Check if given device has generated PME.
> + * @dev: Device to check.
> + *
> + * Check the PME status of the device and if set, clear it and clear
> PME enable
> + * (if set).  Return 'true' if PME status and PME enable were both
> set or
> + * 'false' otherwise.
> + */
> +bool pci_check_pme_status(struct pci_dev *dev)
> +{
> +	int pmcsr_pos;
> +	u16 pmcsr;
> +	bool ret = false;
> +
> +	if (!dev->pm_cap)
> +		return false;
> +
> +	pmcsr_pos = dev->pm_cap + PCI_PM_CTRL;
> +	pci_read_config_word(dev, pmcsr_pos, &pmcsr);
> +	if (!(pmcsr & PCI_PM_CTRL_PME_STATUS))
> +		return false;
> +
> +	/* Clear PME status. */
> +	pmcsr |= PCI_PM_CTRL_PME_STATUS;
> +	if (pmcsr & PCI_PM_CTRL_PME_ENABLE) {
> +		/* Disable PME to avoid interrupt flood. */
> +		pmcsr &= ~PCI_PM_CTRL_PME_ENABLE;
> +		ret = true;
> +	}
> +
> +	pci_write_config_word(dev, pmcsr_pos, pmcsr);
> +
> +	return ret;
> +}
> +
> +/**
>   * pci_pme_capable - check the capability of PCI device to generate
> PME#
>   * @dev: PCI device to handle.
>   * @state: PCI state from which device will issue PME#.
> 
> 

Looks fine to me; would be especially nice if we could somehow
communicate that this function was ack'ing any outstanding PME event in
the function name too.

-- 
Jesse Barnes, Intel Open Source Technology Center
