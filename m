Return-Path: <linux-kernel-owner+w=401wt.eu-S934550AbXHIG15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550AbXHIG15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbXHIG1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:27:48 -0400
Received: from colo.lackof.org ([198.49.126.79]:58237 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbXHIG1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:27:47 -0400
Date: Thu, 9 Aug 2007 00:27:31 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Kyle McMartin <kyle@mcmartin.ca>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [RFC][PATCH] uli526x: Add suspend and resume routines (updated)
Message-ID: <20070809062731.GC2259@colo.lackof.org>
References: <200708052114.01790.rjw@sisk.pl> <200708080024.28692.rjw@sisk.pl> <46B8F19D.6060406@garzik.org> <200708080056.41651.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708080056.41651.rjw@sisk.pl>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 12:56:41AM +0200, Rafael J. Wysocki wrote:
...
> > Apologies, I missed this.  I'll look to our new tulip maintainer to 
> > queue your resent patch, or at least ACK it...
> 
> OK
> 
> Below is the updated version.  It's functionally equivalent to the previous one.

ACK. Looks fine to me too. I don't have the HW to test it though.

cheers,
grant

> 
> Greetings,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add suspend/resume support to the uli526x network driver (tested on x86_64,
> with 'Ethernet controller: ALi Corporation M5263 Ethernet Controller, rev 40').
> 
> This patch is based on the suspend/resume code in the tg3 driver.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/net/tulip/uli526x.c |  109 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 103 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.23-rc2/drivers/net/tulip/uli526x.c
> ===================================================================
> --- linux-2.6.23-rc2.orig/drivers/net/tulip/uli526x.c
> +++ linux-2.6.23-rc2/drivers/net/tulip/uli526x.c
> @@ -1110,19 +1110,15 @@ static void uli526x_timer(unsigned long 
>  
>  
>  /*
> - *	Dynamic reset the ULI526X board
>   *	Stop ULI526X board
>   *	Free Tx/Rx allocated memory
> - *	Reset ULI526X board
> - *	Re-initialize ULI526X board
> + *	Init system variable
>   */
>  
> -static void uli526x_dynamic_reset(struct net_device *dev)
> +static void uli526x_reset_prepare(struct net_device *dev)
>  {
>  	struct uli526x_board_info *db = netdev_priv(dev);
>  
> -	ULI526X_DBUG(0, "uli526x_dynamic_reset()", 0);
> -
>  	/* Sopt MAC controller */
>  	db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);	/* Disable Tx/Rx */
>  	update_cr6(db->cr6_data, dev->base_addr);
> @@ -1141,6 +1137,22 @@ static void uli526x_dynamic_reset(struct
>  	db->link_failed = 1;
>  	db->init=1;
>  	db->wait_reset = 0;
> +}
> +
> +
> +/*
> + *	Dynamic reset the ULI526X board
> + *	Stop ULI526X board
> + *	Free Tx/Rx allocated memory
> + *	Reset ULI526X board
> + *	Re-initialize ULI526X board
> + */
> +
> +static void uli526x_dynamic_reset(struct net_device *dev)
> +{
> +	ULI526X_DBUG(0, "uli526x_dynamic_reset()", 0);
> +
> +	uli526x_reset_prepare(dev);
>  
>  	/* Re-initialize ULI526X board */
>  	uli526x_init(dev);
> @@ -1150,6 +1162,89 @@ static void uli526x_dynamic_reset(struct
>  }
>  
>  
> +#ifdef CONFIG_PM_SLEEP
> +
> +/*
> + *	Suspend the interface.
> + */
> +
> +static int uli526x_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct net_device *dev = pci_get_drvdata(pdev);
> +	pci_power_t power_state;
> +	int err;
> +
> +	ULI526X_DBUG(0, "uli526x_suspend", 0);
> +
> +	if (!(dev && netdev_priv(dev)))
> +		return 0;
> +
> +	pci_save_state(pdev);
> +
> +	if (!netif_running(dev))
> +		return 0;
> +
> +	netif_device_detach(dev);
> +	uli526x_reset_prepare(dev);
> +
> +	power_state = pci_choose_state(pdev, state);
> +	pci_enable_wake(pdev, power_state, 0);
> +	err = pci_set_power_state(pdev, power_state);
> +	if (err) {
> +		netif_device_attach(dev);
> +		/* Re-initialize ULI526X board */
> +		uli526x_init(dev);
> +		/* Restart upper layer interface */
> +		netif_wake_queue(dev);
> +	}
> +
> +	return err;
> +}
> +
> +/*
> + *	Resume the interface.
> + */
> +
> +static int uli526x_resume(struct pci_dev *pdev)
> +{
> +	struct net_device *dev = pci_get_drvdata(pdev);
> +	struct uli526x_board_info *db = netdev_priv(dev);
> +	int err;
> +
> +	ULI526X_DBUG(0, "uli526x_resume", 0);
> +
> +	if (!(dev && db))
> +		return 0;
> +
> +	pci_restore_state(pdev);
> +
> +	if (!netif_running(dev))
> +		return 0;
> +
> +	err = pci_set_power_state(pdev, PCI_D0);
> +	if (err) {
> +		printk(KERN_WARNING "%s: Could not put device into D0\n",
> +			dev->name);
> +		return err;
> +	}
> +
> +	netif_device_attach(dev);
> +	/* Re-initialize ULI526X board */
> +	uli526x_init(dev);
> +	/* Restart upper layer interface */
> +	netif_wake_queue(dev);
> +
> +	return 0;
> +}
> +
> +#else /* !CONFIG_PM_SLEEP */
> +
> +#define uli526x_suspend	NULL
> +#define uli526x_resume	NULL
> +
> +#endif /* !CONFIG_PM_SLEEP */
> +
> +
>  /*
>   *	free all allocated rx buffer
>   */
> @@ -1689,6 +1784,8 @@ static struct pci_driver uli526x_driver 
>  	.id_table	= uli526x_pci_tbl,
>  	.probe		= uli526x_init_one,
>  	.remove		= __devexit_p(uli526x_remove_one),
> +	.suspend	= uli526x_suspend,
> +	.resume		= uli526x_resume,
>  };
>  
>  MODULE_AUTHOR("Peer Chen, peer.chen@uli.com.tw");
