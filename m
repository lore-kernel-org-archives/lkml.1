Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbXCLWqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbXCLWqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbXCLWqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:46:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:14259 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXCLWqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:46:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,276,1170662400"; 
   d="scan'208"; a="211333286:sNHT24076990"
Message-ID: <45F5D854.5020100@intel.com>
Date: Mon, 12 Mar 2007 15:46:44 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       michael@ellerman.id.au
Subject: Re: [PATCH 2/2] pci: Repair pci_save/restore_state so we can restore
 one save many times.
References: <20070227103021.GA2250@kernel.dk>	<20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk>	<20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz>	<20070305084257.GA4464@mellanox.co.il>	<20070305101120.GA23032@elte.hu> <45ECFC5F.7000102@garzik.org>	<45ED0BBF.1050000@intel.com> <20070306090444.GA25409@elte.hu>	<45ED8A12.5040803@intel.com>	<m1ejo1elj6.fsf@ebiederm.dsl.xmission.com>	<45EEE8CF.1060803@intel.com> <45EEEC2C.5090609@intel.com>	<m1649cdfas.fsf@ebiederm.dsl.xmission.com>	<20070307185317.5601d452.akpm@linux-foundation.org>	<m1wt1s6x2p.fsf@ebiederm.dsl.xmission.com>	<45EFDD8C.3070702@garzik.org>	<m1abyn7iin.fsf@ebiederm.dsl.xmission.com>	<m1tzwv5wz9.fsf_-_@ebiederm.dsl.xmission.com>	<m1ps7j5wnq.fsf_-_@ebiederm.dsl.xmission.com> <m1lki75wlm.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1lki75wlm.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2007 22:46:46.0199 (UTC) FILETIME=[501B6C70:01C764F8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Because we do not reserve space for the pci-x and pci-e state in struct
> pci dev we need to dynamically allocate it.  However because we need
> to support restore being called multiple times after a single save
> it is never safe to free the buffers we have allocated to hold the
> state.
> 
> So this patch modifies the save routines to first check to see
> if we have already allocated a state buffer before allocating
> a new one.  Then the restore routines are modified to not free
> the state after restoring it.  Simple and it fixes some subtle
> error path handling bugs, that are hard to test for.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>


I tested this patch and the other 2 in this series:

[PATCH 0/2] Repair pci_restore_state when used with device resets
[PATCH 1/2] msi: Safer state caching.

against e1000 with suspend/resume functionality. Apart from a minor symmetry 
violation in e1000 for which I will send a patch later, these patches appear to 
work fine on my ich8 with 5 msi capable e1000 ports.

Feel free to add my Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

Cheers,

Auke



> ---
>  drivers/pci/pci.c   |   12 ++++++------
>  include/linux/pci.h |    5 -----
>  2 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 6fb78df..b292c9a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -551,7 +551,9 @@ static int pci_save_pcie_state(struct pci_dev *dev)
>  	if (pos <= 0)
>  		return 0;
>  
> -	save_state = kzalloc(sizeof(*save_state) + sizeof(u16) * 4, GFP_KERNEL);
> +	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
> +	if (!save_state)
> +		save_state = kzalloc(sizeof(*save_state) + sizeof(u16) * 4, GFP_KERNEL);
>  	if (!save_state) {
>  		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
>  		return -ENOMEM;
> @@ -582,8 +584,6 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
>  	pci_write_config_word(dev, pos + PCI_EXP_LNKCTL, cap[i++]);
>  	pci_write_config_word(dev, pos + PCI_EXP_SLTCTL, cap[i++]);
>  	pci_write_config_word(dev, pos + PCI_EXP_RTCTL, cap[i++]);
> -	pci_remove_saved_cap(save_state);
> -	kfree(save_state);
>  }
>  
>  
> @@ -597,7 +597,9 @@ static int pci_save_pcix_state(struct pci_dev *dev)
>  	if (pos <= 0)
>  		return 0;
>  
> -	save_state = kzalloc(sizeof(*save_state) + sizeof(u16), GFP_KERNEL);
> +	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
> +	if (!save_state)
> +		save_state = kzalloc(sizeof(*save_state) + sizeof(u16), GFP_KERNEL);
>  	if (!save_state) {
>  		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
>  		return -ENOMEM;
> @@ -622,8 +624,6 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
>  	cap = (u16 *)&save_state->data[0];
>  
>  	pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
> -	pci_remove_saved_cap(save_state);
> -	kfree(save_state);
>  }
>  
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 78417e4..481ea06 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -209,11 +209,6 @@ static inline void pci_add_saved_cap(struct pci_dev *pci_dev,
>  	hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
>  }
>  
> -static inline void pci_remove_saved_cap(struct pci_cap_saved_state *cap)
> -{
> -	hlist_del(&cap->next);
> -}
> -
>  /*
>   *  For PCI devices, the region numbers are assigned this way:
>   *
