Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZDMO5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZDMO5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZDMO4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:56:47 -0400
Received: from mail.vyatta.com ([76.74.103.46]:42075 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbZDMO4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:56:45 -0400
Date: Mon, 13 Apr 2009 07:56:38 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       davem@davemloft.net, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH 4/4] net: bonding: add slave device addresses in mode
 alb
Message-ID: <20090413075638.61839874@nehalam>
In-Reply-To: <20090413084614.GE23734@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com>
	<20090413083729.GA23734@psychotron.englab.brq.redhat.com>
	<20090413084614.GE23734@psychotron.englab.brq.redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 10:46:15 +0200
Jiri Pirko <jpirko@redhat.com> wrote:

> When in mode alb, add all device addresses which belong to an enslaved slave
> device to the bond device. This ensures that all mac addresses will be
> treated as local and bonding in this mode will work fine in bridge.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> ---
>  drivers/net/bonding/bond_main.c |   30 +++++++++++++++++++++++++++++-
>  1 files changed, 29 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 99610f3..47795c7 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1385,6 +1385,11 @@ static void bond_setup_by_slave(struct net_device *bond_dev,
>  	bond->setup_by_slave = 1;
>  }
>  
> +static inline int should_copy_dev_addrs(struct bonding *bond)
> +{
> +	return bond->params.mode == BOND_MODE_ALB ? 1 : 0;
> +}

static inline bool should_copy_dev_addrs(const struct bonding *bond)
{
	return (bond->params.mode == BOND_MODE_ALB);
}

Three things are wrong with your style here:
   1. Needless use of tri-graph operator, just return the result
   2. Use const for test_foo() type functions
   3. Use bool to make it clearer what the result is.

>  /* enslave device <slave> to bond device <master> */
>  int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
>  {
> @@ -1510,6 +1515,13 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
>  	 */
>  	new_slave->original_flags = slave_dev->flags;
>  
> +	if (should_copy_dev_addrs(bond)) {
> +		res = dev_addr_add_multiple(bond_dev, slave_dev);
> +		if (res)
> +			goto err_free;
> +		dev_mac_address_changed(bond_dev);

The notifier (dev_mac_address_changed) should be part of dev_addr_add

