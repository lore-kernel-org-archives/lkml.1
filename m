Return-Path: <linux-kernel-owner+w=401wt.eu-S936735AbXHGWPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936735AbXHGWPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXHGWPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:15:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35127 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbXHGWPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:15:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC][PATCH] uli526x: Add suspend and resume routines
Date: Wed, 8 Aug 2007 00:24:28 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@mcmartin.ca>
References: <200708052114.01790.rjw@sisk.pl> <46B8E6D4.30405@garzik.org>
In-Reply-To: <46B8E6D4.30405@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708080024.28692.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 7 August 2007 23:40, Jeff Garzik wrote:
> Rafael J. Wysocki wrote:
> > +static int uli526x_suspend(struct pci_dev *pdev, pm_message_t state)
> > +{
> > +	struct net_device *dev = pci_get_drvdata(pdev);
> > +	int err = 0;
> > +
> > +	ULI526X_DBUG(0, "uli526x_suspend", 0);
> > +
> > +	if (dev && netdev_priv(dev)) {
> > +		pci_power_t power_state;
> > +
> > +		pci_save_state(pdev);
> > +
> > +		if (!netif_running(dev))
> > +			return 0;
> > +
> > +		netif_device_detach(dev);
> > +		uli526x_reset_prepare(dev);
> > +
> > +		power_state = pci_choose_state(pdev, state);
> > +		pci_enable_wake(pdev, power_state, 0);
> > +		err = pci_set_power_state(pdev, power_state);
> > +		if (err) {
> > +			netif_device_attach(dev);
> > +			/* Re-initialize ULI526X board */
> > +			uli526x_init(dev);
> > +			/* Restart upper layer interface */
> > +			netif_wake_queue(dev);
> > +		}
> > +	}
> > +	return err;
> > +}
> > +
> > +/*
> > + *	Resume the interface.
> > + */
> > +
> > +static int uli526x_resume(struct pci_dev *pdev)
> > +{
> > +	struct net_device *dev = pci_get_drvdata(pdev);
> > +	struct uli526x_board_info *db = netdev_priv(dev);
> > +
> > +	ULI526X_DBUG(0, "uli526x_resume", 0);
> > +
> > +	if (dev && db) {
> > +		int err;
> > +
> > +		pci_restore_state(pdev);
> > +
> > +		if (!netif_running(dev))
> > +			return 0;
> > +
> > +		err = pci_set_power_state(pdev, PCI_D0);
> > +		if (err) {
> > +			printk(KERN_WARNING
> > +				"%s: Could not put device into D0\n",
> > +				dev->name);
> > +			return err;
> > +		}
> > +
> > +		netif_device_attach(dev);
> > +		/* Re-initialize ULI526X board */
> > +		uli526x_init(dev);
> > +		/* Restart upper layer interface */
> > +		netif_wake_queue(dev);
> > +	}
> > +	return 0;
> 
> 
> Ugh -- please fix indentation.  This is not proper Linux code.
> 
> If you have the -vast majority- of code on an indented branch, as you 
> have here, then you should either add an early 'return x;' or a goto, 
> and unindent the main body of code.

OK, I will.

> I'll let our new tulip maintainer see what he thinks about the 
> implementation.  Seems fairly sane to me, but should at least get an "it 
> works" test.

It has been tested, as stated in the changelog, and works (on my test system).

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
