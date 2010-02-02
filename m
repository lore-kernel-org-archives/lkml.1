Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0BBVml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:42:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45913
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756631Ab0BBVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:42:38 -0500
Date: Tue, 02 Feb 2010 13:42:51 -0800 (PST)
Message-Id: <20100202.134251.15604523.davem@davemloft.net>
To: ktpedre@sandia.gov
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100202205845.GE5246@hawkeye.sandia.gov>
References: <20100202205845.GE5246@hawkeye.sandia.gov>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kevin Pedretti" <ktpedre@sandia.gov>
Date: Tue, 2 Feb 2010 13:58:45 -0700

> +void seastar_setup_htb_bi(uint32_t idr)

Please use the in-kernel sized types "u32", "u16", etc.
instead of "uint32_t" et al.

> +extern void
> +seastar_ip_tx_cmd(
> +	struct ss_priv		*ssp,
> +	uint16_t		nid,
> +	uint16_t		length,
> +	uint64_t		address,
> +	uint16_t		pending_index
> +);
> +
> +
> +void
> +seastar_setup_htb_bi(
> +	uint32_t		idr
> +);
> +
> +
> +extern int
> +seastar_hw_init(
> +	struct ss_priv		*ssp
> +);

Please fix the formatting of these function declarations,
something like:

extern void seastar_ip_tx_cmd(struct ss_priv *ssp,
			      uint16_t nid,
			      uint16_t length,
			      uint64_t address,
			      uint16_t pending_index);

extern void seastar_setup_htb_bi(uint32_t idr);

extern int seastar_hw_init(struct ss_priv *ssp);

And again use "u16" instead of "uint16_t" etc.

There are many bad code formatting cases like this in your
driver, lease fix them all up.

> +static int ss_open(struct net_device *netdev)
> +{
> +	struct ss_priv *ssp = netdev_priv(netdev);
> +	int i;
> +
> +	netif_start_queue(netdev);
> +
> +	for (i = 0; i < NUM_SKBS; i++) {
> +		ssp->skb_table_phys[i] = 0;
> +		ssp->skb_table_virt[i] = 0;
> +		refill_skb(netdev, i);
> +	}
> +
> +	return 0;
> +}

You shouldn't call netif_start_queue() until you are completely
done initializing the chip.  Packets can start being transmitted
to the driver the exact moment that function returns.

> +static int eth2ss(struct ss_priv *ssp, struct sk_buff *skb)
 ...
> +static int ss2eth(struct sk_buff *skb)

This device can only transmit IPv4 packets and can only receive IPv4
packets?

> +#ifdef CONFIG_PM
> +static int ss_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	return -ENOSYS;
> +}
> +
> +
> +static int ss_resume(struct pci_dev *pdev)
> +{
> +	return -ENOSYS;
> +}
> +#endif

If you don't support suspend and resume, simply leave the
method pointers unassigned, there is no need to provide
NOP routines like this.
