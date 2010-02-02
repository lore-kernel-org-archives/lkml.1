Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab0BBXiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 18:38:14 -0500
Received: from mail.vyatta.com ([76.74.103.46]:50991 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0BBXiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 18:38:10 -0500
Date: Tue, 2 Feb 2010 15:38:04 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Kevin Pedretti" <ktpedre@sandia.gov>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver
Message-ID: <20100202153804.6aa49835@nehalam>
In-Reply-To: <20100202205845.GE5246@hawkeye.sandia.gov>
References: <20100202205845.GE5246@hawkeye.sandia.gov>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010 13:58:45 -0700
"Kevin Pedretti" <ktpedre@sandia.gov> wrote:

> +
> +static const struct net_device_ops ss_netdev_ops = {
> +	.ndo_open		= ss_open,
> +	.ndo_start_xmit		= ss_tx,
> +	.ndo_set_mac_address	= eth_mac_addr,
> +};

You should have a validate_address as well.
> +
> +
> +static const struct header_ops ss_header_ops = {
> +	.create			= ss_header_create,
> +};
> +
> +
> +static void ss_ht_irq_update(struct pci_dev *dev, int irq,
> +			     struct ht_irq_msg *msg)
> +{
> +	seastar_setup_htb_bi(msg->address_lo);
> +}
> +
> +
> +static int __devinit ss_probe(struct pci_dev *pdev,
> +			      const struct pci_device_id *id)
> +{
> +	struct net_device *netdev;
> +	struct ss_priv *ssp;
> +	int i, irq, err = 0;
> +
> +	err = pci_enable_device(pdev);
> +	if (err != 0) {
> +		dev_err(&pdev->dev, "Could not enable PCI device.\n");
> +		return -ENODEV;
> +	}
> +
> +	netdev = alloc_etherdev(sizeof(*ssp));
> +	if (netdev == NULL) {
> +		dev_err(&pdev->dev, "Could not allocate ethernet device.\n");
> +		return -ENOMEM;
> +	}

You may want to use alloc_netdev() since this starts to look
like a non-ethernet device.
> +
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +
> +	strcpy(netdev->name, "ss");
> +	netdev->netdev_ops	= &ss_netdev_ops;
> +	netdev->header_ops	= &ss_header_ops;
> +	netdev->mtu		= 16000;
> +	netdev->flags		= IFF_NOARP;
> +
> +	/* Setup private state */
> +	ssp = netdev_priv(netdev);
> +	memset(ssp, 0, sizeof(*ssp));

memset is unnecessary, since alloc_netdev/alloc_etherdev zero that area
already.
-- 
