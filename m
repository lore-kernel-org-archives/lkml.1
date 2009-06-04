Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZFDAcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZFDAcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 20:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZFDAc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 20:32:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbZFDAcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 20:32:25 -0400
Date: Wed, 3 Jun 2009 17:32:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, slapin@ossfans.org,
       maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
       oliver.fendt@siemens.com, dbaryshkov@gmail.com
Subject: Re: [PATCH 03/10] net: add IEEE 802.15.4 socket family
 implementation
Message-Id: <20090603173214.6d3997f7.akpm@linux-foundation.org>
In-Reply-To: <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-2-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-3-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-4-git-send-email-dbaryshkov@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Jun 2009 18:54:44 +0400
Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:

> Add support for communication over IEEE 802.15.4 networks. This implementation
> is neither certified nor complete, but aims to that goal. This commit contains
> only the socket interface for communication over IEEE 802.15.4 networks.
> One can either send RAW datagrams or use SOCK_DGRAM to encapsulate data
> inside normal IEEE 802.15.4 packets.
> 
> Configuration interface, drivers and software MAC 802.15.4 implementation will
> follow.
> 
> Initial implementation was done by Maxim Gorbachyov, Maxim Osipov and Pavel
> Smolensky as a research project at Siemens AG. Later the stack was heavily
> reworked to better suit the linux networking model, and is now maitained
> as an open project partially sponsored by Siemens.
> 

Some drive-by nitpicking, and I saw a bug...

> ...
>
> +#define MAC_CB(skb)	((struct ieee802154_mac_cb *)(skb)->cb)

At present this macro can be passed a variable of any type at all.

It would be better to implement this as a (probably inlined) C
function, so the compiler can check that it was indeed passed a `struct
sk_buff *' (or whatever type it's supposed to be).

And regular C functions are typically in lower case..


I have a feeling that this unnecessary macro pattern is used in other
places in networking, and there's an argument that new code should copy
the old code.  It's not a terribly good argument, IMO - the defeating
of type-safety does rather suck.

> +#define MAC_CB_FLAG_TYPEMASK		((1 << 3) - 1)
> +
> +#define MAC_CB_FLAG_ACKREQ		(1 << 3)
> +#define MAC_CB_FLAG_SECEN		(1 << 4)
> +#define MAC_CB_FLAG_INTRAPAN		(1 << 5)
> +
> +#define MAC_CB_IS_ACKREQ(skb)		(MAC_CB(skb)->flags & MAC_CB_FLAG_ACKREQ)
> +#define MAC_CB_IS_SECEN(skb)		(MAC_CB(skb)->flags & MAC_CB_FLAG_SECEN)
> +#define MAC_CB_IS_INTRAPAN(skb)		(MAC_CB(skb)->flags & MAC_CB_FLAG_INTRAPAN)
> +#define MAC_CB_TYPE(skb)		(MAC_CB(skb)->flags & MAC_CB_FLAG_TYPEMASK)

These didn't need to be implemented as macros either.

> +#define IEEE802154_MAC_SCAN_ED		0
> +#define IEEE802154_MAC_SCAN_ACTIVE	1
> +#define IEEE802154_MAC_SCAN_PASSIVE	2
> +#define IEEE802154_MAC_SCAN_ORPHAN	3
> +
> +/*
> + * This should be located at net_device->ml_priv
> + */
> +struct ieee802154_mlme_ops {
> +	int (*assoc_req)(struct net_device *dev, struct ieee802154_addr *addr, u8 channel, u8 cap);
> +	int (*assoc_resp)(struct net_device *dev, struct ieee802154_addr *addr, u16 short_addr, u8 status);
> +	int (*disassoc_req)(struct net_device *dev, struct ieee802154_addr *addr, u8 reason);
> +	int (*start_req)(struct net_device *dev, struct ieee802154_addr *addr, u8 channel,
> +			     u8 bcn_ord, u8 sf_ord, u8 pan_coord, u8 blx,
> +			     u8 coord_realign);
> +	int (*scan_req)(struct net_device *dev, u8 type, u32 channels, u8 duration);
> +
> +	/*
> +	 * FIXME: these should become the part of PIB/MIB interface.
> +	 * However we still don't have IB interface of any kind
> +	 */
> +	u16 (*get_pan_id)(struct net_device *dev);
> +	u16 (*get_short_addr)(struct net_device *dev);
> +	u8 (*get_dsn)(struct net_device *dev);
> +	u8 (*get_bsn)(struct net_device *dev);
> +};
> +
> +#define IEEE802154_MLME_OPS(dev)	((struct ieee802154_mlme_ops *) dev->ml_priv)

Nor did this.

>
> ...
>
> +	int i; \
> +	pr_debug("file %s: function: %s: data: len %d:\n", __FILE__, __func__, len); \
> +	for (i = 0; i < len; i++) {\
> +		pr_debug("%02x: %02x\n", i, (data)[i]); \
> +	} \
> +}

Could perhaps use lib/hexdump.c

Will do weird things if passed a pointer whcih has type other than char*.

> +/*
> + * Utility function for families
> + */
> +struct net_device *ieee802154_get_dev(struct net *net, struct ieee802154_addr *addr)
> +{
> +	struct net_device *dev = NULL;
> +
> +	switch (addr->addr_type) {
> +	case IEEE802154_ADDR_LONG:
> +		rtnl_lock();
> +		dev = dev_getbyhwaddr(net, ARPHRD_IEEE802154, addr->hwaddr);
> +		if (dev)
> +			dev_hold(dev);
> +		rtnl_unlock();
> +		break;
> +	case IEEE802154_ADDR_SHORT:
> +		if (addr->pan_id != 0xffff && addr->short_addr != IEEE802154_ADDR_UNDEF && addr->short_addr != 0xffff) {
> +			struct net_device *tmp;
> +
> +			rtnl_lock();
> +
> +			for_each_netdev(net, tmp) {
> +				if (tmp->type == ARPHRD_IEEE802154) {
> +					if (IEEE802154_MLME_OPS(tmp)->get_pan_id(tmp) == addr->pan_id
> +					  && IEEE802154_MLME_OPS(tmp)->get_short_addr(tmp) == addr->short_addr) {

You must use very wide xterms :(

> +						dev = tmp;
> +						dev_hold(dev);
> +						break;
> +					}
> +				}
> +			}
> +
> +			rtnl_unlock();
> +		}
> +		break;
> +	default:
> +		pr_warning("Unsupported ieee802154 address type: %d\n", addr->addr_type);
> +		break;
> +	}
> +
> +	return dev;
> +}
> +
>
> ...
>
> +static int ieee802154_create(struct net *net, struct socket *sock, int protocol)
> +{
> +	struct sock *sk;
> +	int rc;
> +	struct proto *proto;
> +	const struct proto_ops *ops;
> +
> +	/* FIXME: init_net */
> +	if (net != &init_net)
> +		return -EAFNOSUPPORT;

yeah, I was going to ask about that.  What's the problem here?

> +	switch (sock->type) {
> +	case SOCK_RAW:
> +		proto = &ieee802154_raw_prot;
> +		ops = &ieee802154_raw_ops;
> +		break;
> +	case SOCK_DGRAM:
> +		proto = &ieee802154_dgram_prot;
> +		ops = &ieee802154_dgram_ops;
> +		break;
> +	default:
> +		rc = -ESOCKTNOSUPPORT;
> +		goto out;
> +	}
> +
> +	rc = -ENOMEM;
> +	sk = sk_alloc(net, PF_IEEE802154, GFP_KERNEL, proto);
> +	if (!sk)
> +		goto out;
> +	rc = 0;
> +
> +	sock->ops = ops;
> +
> +	sock_init_data(sock, sk);
> +	/* FIXME: sk->sk_destruct */

?

> +	sk->sk_family = PF_IEEE802154;
> +
> +	/* Checksums on by default */
> +	sock_set_flag(sk, SOCK_ZAPPED);
> +
> +	if (sk->sk_prot->hash)
> +		sk->sk_prot->hash(sk);
> +
> +	if (sk->sk_prot->init) {
> +		rc = sk->sk_prot->init(sk);
> +		if (rc)
> +			sk_common_release(sk);
> +	}
> +out:
> +	return rc;
> +}
> +
>
> ...
>
> +static void af_ieee802154_remove(void)

Could be __exit, althugh __exit doesn't do much (it used to be
implemented on UML and might still be).

> +{
> +	dev_remove_pack(&ieee802154_packet_type);
> +	sock_unregister(PF_IEEE802154);
> +	proto_unregister(&ieee802154_dgram_prot);
> +	proto_unregister(&ieee802154_raw_prot);
> +}
> +
> +module_init(af_ieee802154_init);
> +module_exit(af_ieee802154_remove);
>
> ...
>
> +static inline struct dgram_sock *dgram_sk(const struct sock *sk)
> +{
> +	return (struct dgram_sock *)sk;

Better to use container_of() - it's clearer and doesn't assume that
dgram_sock.sk is the first member.

> +}
>
> ...
>
> +static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
> +{
> +	struct sockaddr_ieee802154 *addr = (struct sockaddr_ieee802154 *)uaddr;

sigh, more casting.  Often these things can be done in ways which are
nicer to the C type system.

> +	struct dgram_sock *ro = dgram_sk(sk);
> +	int err = 0;
> +	struct net_device *dev;
> +
> +	ro->bound = 0;
> +
> +	if (len < sizeof(*addr))
> +		return -EINVAL;
> +
> +	if (addr->family != AF_IEEE802154)
> +		return -EINVAL;
> +
> +	lock_sock(sk);
> +
> +	dev = ieee802154_get_dev(sock_net(sk), &addr->addr);
> +	if (!dev) {
> +		err = -ENODEV;
> +		goto out;
> +	}
> +
> +	if (dev->type != ARPHRD_IEEE802154) {
> +		err = -ENODEV;
> +		goto out_put;
> +	}
> +
> +	memcpy(&ro->src_addr, &addr->addr, sizeof(struct ieee802154_addr));
> +
> +	ro->bound = 1;
> +out_put:
> +	dev_put(dev);
> +out:
> +	release_sock(sk);
> +
> +	return err;
> +}
> +
>
> ...
>
> +static int dgram_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
> +		       size_t size)
> +{
> +	struct net_device *dev;
> +	unsigned mtu;
> +	struct sk_buff *skb;
> +	struct dgram_sock *ro = dgram_sk(sk);
> +	int err;
> +
> +	if (msg->msg_flags & MSG_OOB) {
> +		pr_debug("msg->msg_flags = 0x%x\n", msg->msg_flags);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (!ro->bound)
> +		dev = dev_getfirstbyhwtype(sock_net(sk), ARPHRD_IEEE802154);
> +	else
> +		dev = ieee802154_get_dev(sock_net(sk), &ro->src_addr);
> +
> +	if (!dev) {
> +		pr_debug("no dev\n");
> +		return -ENXIO;
> +	}
> +	mtu = dev->mtu;
> +	pr_debug("name = %s, mtu = %u\n", dev->name, mtu);
> +
> +	skb = sock_alloc_send_skb(sk, LL_ALLOCATED_SPACE(dev) + size, msg->msg_flags & MSG_DONTWAIT,
> +				  &err);
> +	if (!skb) {
> +		dev_put(dev);
> +		return err;
> +	}
> +	skb_reserve(skb, LL_RESERVED_SPACE(dev));
> +
> +	skb_reset_network_header(skb);
> +
> +	MAC_CB(skb)->flags = IEEE802154_FC_TYPE_DATA | MAC_CB_FLAG_ACKREQ;
> +	MAC_CB(skb)->seq = IEEE802154_MLME_OPS(dev)->get_dsn(dev);
> +	err = dev_hard_header(skb, dev, ETH_P_IEEE802154, &ro->dst_addr, ro->bound ? &ro->src_addr : NULL, size);
> +	if (err < 0) {
> +		kfree_skb(skb);
> +		dev_put(dev);
> +		return err;
> +	}
> +
> +	skb_reset_mac_header(skb);
> +
> +	err = memcpy_fromiovec(skb_put(skb, size), msg->msg_iov, size);
> +	if (err < 0) {
> +		kfree_skb(skb);
> +		dev_put(dev);
> +		return err;
> +	}

It would be better to convert this function (and any similar
occurences) to the `goto foo;' unwinding approach.  The
multiple-return-statements-per-C-function is not a favoured approach. 
It leads to code duplication and it leads to bugs.

> +	if (size > mtu) {
> +		pr_debug("size = %u, mtu = %u\n", size, mtu);
> +		return -EINVAL;

See, a bug.

> +	}
> +
> +	skb->dev = dev;
> +	skb->sk  = sk;
> +	skb->protocol = htons(ETH_P_IEEE802154);
> +
> +	err = dev_queue_xmit(skb);
> +
> +	dev_put(dev);
> +
> +	if (err)
> +		return err;
> +
> +	return size;
> +}
> +
>
> ...
>
> +struct proto ieee802154_dgram_prot = {

I suspect this could/should be const.

> +	.name		= "IEEE-802.15.4-MAC",
> +	.owner		= THIS_MODULE,
> +	.obj_size	= sizeof(struct dgram_sock),
> +	.init		= dgram_init,
> +	.close		= dgram_close,
> +	.bind		= dgram_bind,
> +	.sendmsg	= dgram_sendmsg,
> +	.recvmsg	= dgram_recvmsg,
> +	.hash		= dgram_hash,
> +	.unhash		= dgram_unhash,
> +	.connect	= dgram_connect,
> +	.disconnect	= dgram_disconnect,
> +	.ioctl		= dgram_ioctl,
> +};
> +
>
> ...
>
> +struct proto ieee802154_raw_prot = {

const?

>
> ...
>

