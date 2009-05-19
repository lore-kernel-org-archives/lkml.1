Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZESW2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZESW2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZESW2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:28:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:15967 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZESW2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:28:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,217,1241420400"; 
   d="scan'208";a="458697796"
Date: Tue, 19 May 2009 15:27:45 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] PCI PM: Fix initialization and kexec breakage for some
 devices
Message-ID: <20090519152745.7b443a84@jbarnes-g45>
In-Reply-To: <200905172017.08207.rjw@sisk.pl>
References: <200905172017.08207.rjw@sisk.pl>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 May 2009 20:17:06 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Recent PCI PM changes introduced a bug that causes some devices to be
> mishandled after kexec and during early initialization.  The failure
> scenario in the kexec case is the following:
> 
> * Assume a PCI device is not power-manageable by the platform and has
>   PCI_PM_CTRL_NO_SOFT_RESET set in PMCSR.
> * The device is put into D3 before kexec (using the native PCI PM).
> * After kexec, pci_setup_device() sets the device's power state to
>   PCI_UNKNOWN.
> * pci_set_power_state(dev, PCI_D0) is called by the device's driver.
> * __pci_start_power_transition(dev, PCI_D0) is called and since the
>   device is not power-manageable by the platform, it causes
>   pci_update_current_state(dev, PCI_D0) to be called.  As a result
>   the device's current_state field is updated to PCI_D3, in
>   accordance with the contents of its PCI PM registers.
> * pci_raw_set_power_state() is called and it changes the device power
>   state to D0.  *However*, it should also call pci_restore_bars() to
>   reinitialize the device, but it doesn't, because the device's
>   current_state field has been modified earlier.
> 
> To prevent this from happening, modify
> pci_platform_power_transition() so that it doesn't use
> pci_update_current_state() to update the current_state field for
> devices that aren't power-manageable by the platform.  Instead, this
> field should be updated directly for devices that don't support the
> native PCI PM.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -557,7 +557,8 @@ static int pci_platform_power_transition
>  	} else {
>  		error = -ENODEV;
>  		/* Fall back to PCI_D0 if native PM is not supported
> */
> -		pci_update_current_state(dev, PCI_D0);
> +		if (!dev->pm_cap)
> +			dev->current_state = PCI_D0;
>  	}
>  
>  	return error;
> 

Applied to my for-linus branch, thanks Rafael.

-- 
Jesse Barnes, Intel Open Source Technology Center
