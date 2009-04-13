Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZDMOyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZDMOyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZDMOyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:54:09 -0400
Received: from mail.vyatta.com ([76.74.103.46]:41922 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZDMOyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:54:08 -0400
Date: Mon, 13 Apr 2009 07:54:00 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       davem@davemloft.net, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH 3/4] net: bridge: use device address list instead of
 dev_addr
Message-ID: <20090413075400.34604e72@nehalam>
In-Reply-To: <20090413084407.GD23734@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com>
	<20090413083729.GA23734@psychotron.englab.brq.redhat.com>
	<20090413084407.GD23734@psychotron.englab.brq.redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 10:44:08 +0200
Jiri Pirko <jpirko@redhat.com> wrote:

> This patch changes the handling of mac addresses of bridge port devices. Now
> it uses previously introduced list of device addresses. It allows the bridge to
> know more then one local mac address per port which is mandatory for the right
> work in some cases.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> ---
>  net/bridge/br_fdb.c     |  120 +++++++++++++++++++++++++++++++++--------------
>  net/bridge/br_if.c      |    2 +-
>  net/bridge/br_notify.c  |    2 +-
>  net/bridge/br_private.h |    4 +-
>  4 files changed, 89 insertions(+), 39 deletions(-)
> 
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index a48f5ef..6efc556 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -77,10 +77,45 @@ static inline void fdb_delete(struct net_bridge_fdb_entry *f)
>  	br_fdb_put(f);
>  }
>  
> -void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
> +/*
> + * Finds out if passed address is one of the addresses assigned to the device.
> + * Returns 1 on positive result
> + */
> +static inline int is_dev_addr(struct net_device *dev, unsigned char *addr)

Why not a general version in net_device.h or etherdevice.h?

static inline bool is_etherdev_addr(const struct net_device *dev, const unsigned char addr[ETH_ALEN])

> +{
> +	struct hw_addr *ha;
> +	int ret = 1;
> +
> +	netif_dev_addr_lock_bh(dev);
> +	for_each_dev_addr(dev, ha) {
User RCU

> +		ret = compare_ether_addr(addr, ha->addr);
> +		if (!ret)
> +			break;
> +	}
> +	netif_dev_addr_unlock_bh(dev);
> +	return !ret ? 1 : 0;
> +}
> +
> +static int another_port_has_addr(const struct net_bridge_port *p,
> +				 struct net_bridge_fdb_entry *f)
> +{
> +	struct net_bridge *br = p->br;
> +	struct net_bridge_port *op;
> +
> +	list_for_each_entry(op, &br->port_list, list) {
> +		if (op != p && is_dev_addr(op->dev, f->addr.addr)) {
> +			f->dst = op;
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}

Forwarding database is hot path, people sometimes run lots of devices
on single bridge, doesn't this scale worse?

> +void br_fdb_changeaddr(struct net_bridge_port *p, struct net_device *dev)
>  {
>  	struct net_bridge *br = p->br;
>  	int i;
> +	struct hw_addr *ha;
>  
>  	spin_lock_bh(&br->hash_lock);
>  
> @@ -92,26 +127,23 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
>  
>  			f = hlist_entry(h, struct net_bridge_fdb_entry, hlist);
>  			if (f->dst == p && f->is_local) {
> -				/* maybe another port has same hw addr? */
> -				struct net_bridge_port *op;
> -				list_for_each_entry(op, &br->port_list, list) {
> -					if (op != p &&
> -					    !compare_ether_addr(op->dev->dev_addr,
> -								f->addr.addr)) {
> -						f->dst = op;
> -						goto insert;
> -					}
> -				}
> -
> -				/* delete old one */
> -				fdb_delete(f);
> -				goto insert;
> +				/*
> +				 * maybe another port has same hw addr?,
> +				 * if not then delete it
> +				 */
> +				if (!another_port_has_addr(p, f))
> +					fdb_delete(f);
>  			}
>  		}
>  	}
> - insert:
> -	/* insert new address,  may fail if invalid address or dup. */
> -	fdb_insert(br, p, newaddr);
> +
> +	/* insert device addresses, may fail if invalid address. */
> +
> +	netif_dev_addr_lock_bh(dev);
> +	for_each_dev_addr(dev, ha) {
> +		fdb_insert(br, p, ha->addr);
> +	}
> +	netif_dev_addr_unlock_bh(dev);
>

You added another layer of locking on the already hot bridge
fast path.
