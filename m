Return-Path: <linux-kernel-owner+w=401wt.eu-S937063AbXHGWFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937063AbXHGWFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937727AbXHGVkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:40:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57010 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937720AbXHGVkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:40:40 -0400
Message-ID: <46B8E6D4.30405@garzik.org>
Date: Tue, 07 Aug 2007 17:40:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [RFC][PATCH] uli526x: Add suspend and resume routines
References: <200708052114.01790.rjw@sisk.pl>
In-Reply-To: <200708052114.01790.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> +static int uli526x_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct net_device *dev = pci_get_drvdata(pdev);
> +	int err = 0;
> +
> +	ULI526X_DBUG(0, "uli526x_suspend", 0);
> +
> +	if (dev && netdev_priv(dev)) {
> +		pci_power_t power_state;
> +
> +		pci_save_state(pdev);
> +
> +		if (!netif_running(dev))
> +			return 0;
> +
> +		netif_device_detach(dev);
> +		uli526x_reset_prepare(dev);
> +
> +		power_state = pci_choose_state(pdev, state);
> +		pci_enable_wake(pdev, power_state, 0);
> +		err = pci_set_power_state(pdev, power_state);
> +		if (err) {
> +			netif_device_attach(dev);
> +			/* Re-initialize ULI526X board */
> +			uli526x_init(dev);
> +			/* Restart upper layer interface */
> +			netif_wake_queue(dev);
> +		}
> +	}
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
> +
> +	ULI526X_DBUG(0, "uli526x_resume", 0);
> +
> +	if (dev && db) {
> +		int err;
> +
> +		pci_restore_state(pdev);
> +
> +		if (!netif_running(dev))
> +			return 0;
> +
> +		err = pci_set_power_state(pdev, PCI_D0);
> +		if (err) {
> +			printk(KERN_WARNING
> +				"%s: Could not put device into D0\n",
> +				dev->name);
> +			return err;
> +		}
> +
> +		netif_device_attach(dev);
> +		/* Re-initialize ULI526X board */
> +		uli526x_init(dev);
> +		/* Restart upper layer interface */
> +		netif_wake_queue(dev);
> +	}
> +	return 0;


Ugh -- please fix indentation.  This is not proper Linux code.

If you have the -vast majority- of code on an indented branch, as you 
have here, then you should either add an early 'return x;' or a goto, 
and unindent the main body of code.

I'll let our new tulip maintainer see what he thinks about the 
implementation.  Seems fairly sane to me, but should at least get an "it 
works" test.

	Jeff




