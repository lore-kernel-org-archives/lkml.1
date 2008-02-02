Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbYBBAvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbYBBAvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYBBAvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:51:02 -0500
Received: from ns.suse.de ([195.135.220.2]:58394 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbYBBAvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:51:00 -0500
Date: Fri, 1 Feb 2008 16:49:16 -0800
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net,
       "Li, Shaohua" <shaohua.li@intel.com>, yanmin.zhang@intel.com
Subject: Re: [GIT PATCH] PCI patches for 2.6.24
Message-ID: <20080202004916.GA10071@suse.de>
References: <20080201231147.GA18174@suse.de> <20080201164206.d96c6ee0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201164206.d96c6ee0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 04:42:06PM -0800, Andrew Morton wrote:
> On Fri, 1 Feb 2008 15:11:47 -0800
> Greg KH <gregkh@suse.de> wrote:
> 
> >       PCI: PCIE ASPM support
> 
> drivers/built-in.o: In function `pci_scan_slot':
> drivers/pci/probe.c:1016: undefined reference to `pcie_aspm_init_link_state'
> drivers/built-in.o: In function `pci_stop_dev':
> drivers/pci/remove.c:36: undefined reference to `pcie_aspm_exit_link_state'
> drivers/built-in.o: In function `pci_set_power_state':
> drivers/pci/pci.c:524: undefined reference to `pcie_aspm_pm_state_change'
> make: *** [.tmp_vmlinux1] Error 1
> 
> http://userweb.kernel.org/~akpm/config-vmm.txt
> 
> 
> Needs this, I guess:
> 
> 
> --- a/drivers/pci/pcie/Kconfig~fix-gregkh-pci-pci-pcie-aspm-support
> +++ a/drivers/pci/pcie/Kconfig
> @@ -32,7 +32,7 @@ source "drivers/pci/pcie/aer/Kconfig"
>  #
>  config PCIEASPM
>  	bool "PCI Express ASPM support(Experimental)"
> -	depends on PCI && EXPERIMENTAL
> +	depends on PCI && EXPERIMENTAL && PCIEPORTBUS
>  	default y
>  	help
>  	  This enables PCI Express ASPM (Active State Power Management) and
> _

Oops, sorry, I'll add that to my queue for the next round.

> 
> Also, that ASPM patch unnecessarily adds a pile of macros:
> 
> +#ifdef CONFIG_PCIEASPM
> +extern void pcie_aspm_init_link_state(struct pci_dev *pdev);
> +extern void pcie_aspm_exit_link_state(struct pci_dev *pdev);
> +extern void pcie_aspm_pm_state_change(struct pci_dev *pdev);
> +extern void pci_disable_link_state(struct pci_dev *pdev, int state);
> +#else
> +#define pcie_aspm_init_link_state(pdev)                do {} while (0)
> +#define pcie_aspm_exit_link_state(pdev)                do {} while (0)
> +#define pcie_aspm_pm_state_change(pdev)                do {} while (0)
> +#define pci_disable_link_state(pdev, state)    do {} while (0)
> +#endif
> 
> Please don't do this.  
> 
> A static inline function is cleaner and provides typechecking.  It also
> provides an access to the caller's argument and can avoid unused-varaiable
> warnings.
> 
> The only reason to use a macro in this situation is if the caller's
> argument is for some reason not defined if !CONFIG_PCIEASPM.
> 
> Greg, please check for this in your reviewing - reject macros *by default*.
>  They are inferior.

Ick, missed that, again, my appologies.  In cleaning up pci.h I saw a
few places like this, I'll fix that next go-around also.

thanks,

greg k-h
