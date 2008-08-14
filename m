Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYHNWXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYHNWXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYHNWXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:23:21 -0400
Received: from mail.vyatta.com ([216.93.170.194]:44354 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbYHNWXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:23:21 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.579
Date: Thu, 14 Aug 2008 15:23:18 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Stephen Hemminger <stephen.hemminger@vyatta.com>
Subject: Re: [PATCH 2/3] Adapt the sky2 driver to the reworked PCI PM
Message-ID: <20080814152318.625f8609@extreme>
In-Reply-To: <200808142338.18361.rjw@sisk.pl>
References: <200808142335.56644.rjw@sisk.pl>
	<200808142338.18361.rjw@sisk.pl>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 23:38:17 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Adapt the sky2 driver to the reworked PCI PM
> 
> * Use device_set_wakeup_enable() and friends as needed
> * Remove an open-coded reference to the standard PCI PM registers
> * Use pci_prepare_to_sleep() and pci_back_from_sleep() in the
>   ->suspend() and ->resume() callbacks
> * Use the observation that it is sufficient to call pci_enable_wake()
>   once, unless it fails
> 
> Tested on Asus M3A32-MVP (Yukon-2 EC Ultra rev 3).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/net/sky2.c |   34 ++++++++++------------------------
>  1 file changed, 10 insertions(+), 24 deletions(-)
> 
> Index: linux-2.6/drivers/net/sky2.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/sky2.c
> +++ linux-2.6/drivers/net/sky2.c
> @@ -3035,7 +3035,8 @@ static int sky2_set_wol(struct net_devic
>  	struct sky2_port *sky2 = netdev_priv(dev);
>  	struct sky2_hw *hw = sky2->hw;
>  
> -	if (wol->wolopts & ~sky2_wol_supported(sky2->hw))
> +	if ((wol->wolopts & ~sky2_wol_supported(sky2->hw))
> +	    || !device_can_wakeup(&hw->pdev->dev))
>  		return -EOPNOTSUPP;
>  

There was a regression in earlier releases caused because some BIOS's
are wrong, and device can wakeup.
