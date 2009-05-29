Return-Path: <linux-kernel-owner+w=401wt.eu-S1762513AbZE2RUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762513AbZE2RUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbZE2RTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:19:55 -0400
Received: from complete.lackof.org ([198.49.126.79]:55324 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbZE2RTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:19:54 -0400
Date: Fri, 29 May 2009 11:19:56 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       marc.c.dionne@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: use fixed-up device class when configuring device
Message-ID: <20090529171956.GE28355@lackof.org>
References: <1243441505-5477-1-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243441505-5477-1-git-send-email-yu.zhao@intel.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 12:25:05AM +0800, Yu Zhao wrote:
> The device class may be changed after the early fixup. Need to
> re-read the class value from pci_dev when configuring the device.
> Otherwise some devices such as JMicron SATA controller won't work.

I looked at pci_setup_device() and was thinking pci_fixup_device()
should be called before pci_cfg_space_size() and thus avoid having
to setup local "class" variable twice. pci_cfg_space_size() only
seems to care if the device is a PCI_CLASS_BRIDGE_HOST (or not).

But dev->class has to be set up in any case and the current order
makes more sense to me.

Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> Tested-by: Marc Dionne <marc.c.dionne@gmail.com>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> ---
>  drivers/pci/probe.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index e3c3e08..f1ae247 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -745,6 +745,8 @@ int pci_setup_device(struct pci_dev *dev)
>  
>  	/* Early fixups, before probing the BARs */
>  	pci_fixup_device(pci_fixup_early, dev);
> +	/* device class may be changed after fixup */
> +	class = dev->class >> 8;
>  
>  	switch (dev->hdr_type) {		    /* header type */
>  	case PCI_HEADER_TYPE_NORMAL:		    /* standard header */
> -- 
> 1.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
