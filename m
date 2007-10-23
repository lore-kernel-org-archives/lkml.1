Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbXJWQTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbXJWQTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXJWQTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:19:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:3377 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbXJWQTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:19:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,318,1188802800"; 
   d="scan'208";a="355986547"
Message-ID: <471E1ECD.80002@intel.com>
Date: Tue, 23 Oct 2007 09:18:21 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Adam Jackson <ajax@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
References: <11931515302013-git-send-email-ajax@redhat.com>
In-Reply-To: <11931515302013-git-send-email-ajax@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2007 16:18:42.0308 (UTC) FILETIME=[60C55C40:01C81590]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Jackson wrote:
> When the EEPROM gets corrupted, you can fix it with ethtool, but only if
> the module loads and creates a network device.  But, without this option,
> if the EEPROM is corrupted, the driver will not create a network device.
> 
> Signed-off-by: Adam Jackson <ajax@redhat.com>


NAK

wrong list, not sent to me, and while for e100 I was OK with this patch, for e1000
it really does not make sense to 'just allow' a bad checksum - if your eeprom is
randomly messed up then you cannot just fix it like this anyway.

Auke



> ---
>  drivers/net/e1000/e1000_main.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
> index f1ce348..b308c32 100644
> --- a/drivers/net/e1000/e1000_main.c
> +++ b/drivers/net/e1000/e1000_main.c
> @@ -255,6 +255,10 @@ static int debug = NETIF_MSG_DRV | NETIF_MSG_PROBE;
>  module_param(debug, int, 0);
>  MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
>  
> +static int eeprom_bad_csum_allow = 0;
> +module_param(eeprom_bad_csum_allow, int, 0);
> +MODULE_PARM_DESC(eeprom_bad_csum_allow, "Allow bad eeprom checksums");
> +
>  /**
>   * e1000_init_module - Driver Registration Routine
>   *
> @@ -1012,7 +1016,8 @@ e1000_probe(struct pci_dev *pdev,
>  
>  	if (e1000_validate_eeprom_checksum(&adapter->hw) < 0) {
>  		DPRINTK(PROBE, ERR, "The EEPROM Checksum Is Not Valid\n");
> -		goto err_eeprom;
> +		if (!eeprom_bad_csum_allow)
> +			goto err_eeprom;
>  	}
>  
>  	/* copy the MAC address out of the EEPROM */
> @@ -1024,7 +1029,8 @@ e1000_probe(struct pci_dev *pdev,
>  
>  	if (!is_valid_ether_addr(netdev->perm_addr)) {
>  		DPRINTK(PROBE, ERR, "Invalid MAC Address\n");
> -		goto err_eeprom;
> +		if (!eeprom_bad_csum_allow)
> +			goto err_eeprom;
>  	}
>  
>  	e1000_get_bus_info(&adapter->hw);
