Return-Path: <linux-kernel-owner+w=401wt.eu-S1161292AbXDXF6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161292AbXDXF6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161637AbXDXF6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:58:04 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1562 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161292AbXDXF6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:58:01 -0400
Date: Tue, 24 Apr 2007 15:57:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: Re: [PATCH 22/25] xen: xen-netfront: use skb.cb for storing private data
Message-ID: <20070424055731.GA30018@gondor.apana.org.au>
References: <20070423215638.563901986@goop.org> <20070423215713.550883195@goop.org> <20070424014528.GA27789@gondor.apana.org.au> <462D88EF.9030007@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462D88EF.9030007@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 09:34:55PM -0700, Jeremy Fitzhardinge wrote:
> 
> Could you give netfront an overall review as well?  I know you're
> already pretty familiar with it, but if you could cast a fresh eye over
> it, that would be helpful.

Sure thing.  I'll look over it soon.

Actually there is one thing I'd like to see changed first up: I noticed
that you've stripped out the checksum hack which is in the main Xen tree.
We actually have the code in net-2.6.22 (which is also in mm) that lets
you use CHECKSUM_PARTIAL on received packets without having to do that
hack.

Here's the patch that I've been testing so far.  It's against the Xen
source, but should be easy to adapt to your version as well.

I just thought about this again, and in fact we need this change for
correctness as well as performance.  Because not setting ip_summed
to CHECKSUM_PARTIAL in netfront is not going to stop netback from
sending CHECKSUM_PARTIAL packets to us.  If these packets are then
routed/bridged back to netback, they'll have the wrong checksum.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff -ur linux-2.6.20.noarch/drivers/xen/core/skbuff.c linux-2.6.20.i686/drivers/xen/core/skbuff.c
--- linux-2.6.20.noarch/drivers/xen/core/skbuff.c	2007-04-03 15:26:15.000000000 +1000
+++ linux-2.6.20.i686/drivers/xen/core/skbuff.c	2007-03-30 21:06:20.000000000 +1000
@@ -9,6 +9,10 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/init.h>
+#include <linux/if_ether.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <net/ip.h>
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/hypervisor.h>
@@ -78,6 +82,37 @@
 	return skb;
 }
 
+int skb_checksum_setup(struct sk_buff *skb)
+{
+	if (skb->protocol != htons(ETH_P_IP))
+		goto out;
+	skb->h.raw = (unsigned char *)skb->nh.iph + 4*skb->nh.iph->ihl;
+	if (skb->h.raw >= skb->tail)
+		goto out;
+	switch (skb->nh.iph->protocol) {
+	case IPPROTO_TCP:
+		skb->csum_offset = offsetof(struct tcphdr, check);
+		break;
+	case IPPROTO_UDP:
+		skb->csum_offset = offsetof(struct udphdr, check);
+		break;
+	default:
+		if (net_ratelimit())
+			printk(KERN_ERR "Attempting to checksum a non-"
+			       "TCP/UDP packet, dropping a protocol"
+			       " %d packet", skb->nh.iph->protocol);
+		goto out;
+	}
+	if ((skb->h.raw + skb->csum_offset + 2) > skb->tail)
+		goto out;
+	skb->ip_summed = CHECKSUM_PARTIAL;
+
+	return 0;
+out:
+	return -EPROTO;
+}
+EXPORT_SYMBOL(skb_checksum_setup);
+
 static void skbuff_ctor(void *buf, struct kmem_cache *cachep, unsigned long unused)
 {
 	int order = 0;
diff -ur linux-2.6.20.noarch/drivers/xen/netback/loopback.c linux-2.6.20.i686/drivers/xen/netback/loopback.c
--- linux-2.6.20.noarch/drivers/xen/netback/loopback.c	2007-04-03 15:26:15.000000000 +1000
+++ linux-2.6.20.i686/drivers/xen/netback/loopback.c	2007-03-30 21:01:02.000000000 +1000
@@ -149,16 +149,6 @@
 	np->stats.rx_bytes += skb->len;
 	np->stats.rx_packets++;
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		/* Defer checksum calculation. */
-		skb->proto_csum_blank = 1;
-		/* Must be a local packet: assert its integrity. */
-		skb->proto_data_valid = 1;
-	}
-
-	skb->ip_summed = skb->proto_data_valid ?
-		CHECKSUM_UNNECESSARY : CHECKSUM_NONE;
-
 	skb->pkt_type = PACKET_HOST; /* overridden by eth_type_trans() */
 	skb->protocol = eth_type_trans(skb, dev);
 	skb->dev      = dev;
diff -ur linux-2.6.20.noarch/drivers/xen/netback/netback.c linux-2.6.20.i686/drivers/xen/netback/netback.c
--- linux-2.6.20.noarch/drivers/xen/netback/netback.c	2007-04-03 15:26:15.000000000 +1000
+++ linux-2.6.20.i686/drivers/xen/netback/netback.c	2007-03-31 21:07:48.000000000 +1000
@@ -293,7 +293,6 @@
 		/* Copy only the header fields we use in this driver. */
 		nskb->dev = skb->dev;
 		nskb->ip_summed = skb->ip_summed;
-		nskb->proto_data_valid = skb->proto_data_valid;
 		dev_kfree_skb(skb);
 		skb = nskb;
 	}
@@ -666,9 +665,11 @@
 		id = meta[npo.meta_cons].id;
 		flags = nr_frags ? NETRXF_more_data : 0;
 
-		if (skb->ip_summed == CHECKSUM_PARTIAL) /* local packet? */
+		if (skb->ip_summed == CHECKSUM_PARTIAL)
+			/* local packet? */
 			flags |= NETRXF_csum_blank | NETRXF_data_validated;
-		else if (skb->proto_data_valid) /* remote but checksummed? */
+		else if (skb->ip_summed == CHECKSUM_UNNECESSARY)
+			/* remote but checksummed? */
 			flags |= NETRXF_data_validated;
 
 		if (meta[npo.meta_cons].copy)
@@ -1303,23 +1304,19 @@
 			netif_idx_release(pending_idx);
 		}
 
-		/*
-		 * Old frontends do not assert data_validated but we
-		 * can infer it from csum_blank so test both flags.
-		 */
-		if (txp->flags & (NETTXF_data_validated|NETTXF_csum_blank)) {
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			skb->proto_data_valid = 1;
-		} else {
-			skb->ip_summed = CHECKSUM_NONE;
-			skb->proto_data_valid = 0;
-		}
-		skb->proto_csum_blank = !!(txp->flags & NETTXF_csum_blank);
-
 		netbk_fill_frags(skb);
 
 		skb->dev      = netif->dev;
 		skb->protocol = eth_type_trans(skb, skb->dev);
+		skb->nh.raw   = skb->data;
+
+		if (txp->flags & NETTXF_csum_blank) {
+			if (skb_checksum_setup(skb)) {
+				kfree_skb(skb);
+				continue;
+			}
+		} else if (txp->flags & NETTXF_data_validated)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 		netif->stats.rx_bytes += skb->len;
 		netif->stats.rx_packets++;
diff -ur linux-2.6.20.noarch/drivers/xen/netfront/netfront.c linux-2.6.20.i686/drivers/xen/netfront/netfront.c
--- linux-2.6.20.noarch/drivers/xen/netfront/netfront.c	2007-04-03 15:26:15.000000000 +1000
+++ linux-2.6.20.i686/drivers/xen/netfront/netfront.c	2007-03-31 21:07:43.000000000 +1000
@@ -925,12 +925,12 @@
 	tx->flags = 0;
 	extra = NULL;
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL) /* local packet? */
+	if (skb->ip_summed == CHECKSUM_PARTIAL)
+		/* local packet? */
 		tx->flags |= NETTXF_csum_blank | NETTXF_data_validated;
-#ifdef CONFIG_XEN
-	if (skb->proto_data_valid) /* remote but checksummed? */
+	else if (skb->ip_summed == CHECKSUM_UNNECESSARY)
+		/* remote but checksummed? */
 		tx->flags |= NETTXF_data_validated;
-#endif
 
 #ifdef HAVE_TSO
 	if (skb_is_gso(skb)) {
@@ -1351,20 +1351,10 @@
 		skb->truesize += skb->data_len - (RX_COPY_THRESHOLD - len);
 		skb->len += skb->data_len;
 
-		/*
-		 * Old backends do not assert data_validated but we
-		 * can infer it from csum_blank so test both flags.
-		 */
-		if (rx->flags & (NETRXF_data_validated|NETRXF_csum_blank))
+		if (rx->flags & NETRXF_csum_blank)
+			skb->ip_summed = CHECKSUM_PARTIAL;
+		else if (rx->flags & NETRXF_data_validated)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-		else
-			skb->ip_summed = CHECKSUM_NONE;
-#ifdef CONFIG_XEN
-		skb->proto_data_valid = (skb->ip_summed != CHECKSUM_NONE);
-		skb->proto_csum_blank = !!(rx->flags & NETRXF_csum_blank);
-#endif
-		np->stats.rx_packets++;
-		np->stats.rx_bytes += skb->len;
 
 		__skb_queue_tail(&rxq, skb);
 
@@ -1404,6 +1394,19 @@
 
 		/* Ethernet work: Delayed to here as it peeks the header. */
 		skb->protocol = eth_type_trans(skb, dev);
+		skb->nh.raw = skb->data;
+
+		if (skb->ip_summed == CHECKSUM_PARTIAL) {
+			if (skb_checksum_setup(skb)) {
+				work_done--;
+				kfree_skb(skb);
+				np->stats.rx_errors++;
+				continue;
+			}
+		}
+
+		np->stats.rx_packets++;
+		np->stats.rx_bytes += skb->len;
 
 		/* Pass it up. */
 		netif_receive_skb(skb);
diff -ur linux-2.6.20.noarch/include/linux/skbuff.h linux-2.6.20.i686/include/linux/skbuff.h
--- linux-2.6.20.noarch/include/linux/skbuff.h	2007-04-03 15:26:15.000000000 +1000
+++ linux-2.6.20.i686/include/linux/skbuff.h	2007-03-30 21:01:02.000000000 +1000
@@ -202,8 +202,6 @@
  *	@local_df: allow local fragmentation
  *	@cloned: Head may be cloned (check refcnt to be sure)
  *	@nohdr: Payload reference only, must not modify header
- *	@proto_data_valid: Protocol data validated since arriving at localhost
- *	@proto_csum_blank: Protocol csum must be added before leaving localhost
  *	@pkt_type: Packet class
  *	@fclone: skbuff clone status
  *	@ip_summed: Driver fed us an IP checksum
@@ -286,13 +284,7 @@
 				nfctinfo:3;
 	__u8			pkt_type:3,
 				fclone:2,
-#ifndef CONFIG_XEN
 				ipvs_property:1;
-#else
-				ipvs_property:1,
-				proto_data_valid:1,
-				proto_csum_blank:1;
-#endif
 	__be16			protocol;
 
 	void			(*destructor)(struct sk_buff *skb);
@@ -1345,6 +1337,8 @@
 
 extern struct sk_buff *skb_segment(struct sk_buff *skb, int features);
 
+extern int skb_checksum_setup(struct sk_buff *skb);
+
 static inline void *skb_header_pointer(const struct sk_buff *skb, int offset,
 				       int len, void *buffer)
 {
diff -ur linux-2.6.20.noarch/net/core/dev.c linux-2.6.20.i686/net/core/dev.c
--- linux-2.6.20.noarch/net/core/dev.c	2007-04-03 15:26:15.000000000 +1000
+++ linux-2.6.20.i686/net/core/dev.c	2007-04-03 15:26:04.000000000 +1000
@@ -117,12 +117,6 @@
 #include <linux/err.h>
 #include <linux/ctype.h>
 
-#ifdef CONFIG_XEN
-#include <net/ip.h>
-#include <linux/tcp.h>
-#include <linux/udp.h>
-#endif
-
 /*
  *	The list of packet types we will receive (as opposed to discard)
  *	and the routines to invoke.
@@ -1398,43 +1392,6 @@
 	}						\
 }
 
-#ifdef CONFIG_XEN
-inline int skb_checksum_setup(struct sk_buff *skb)
-{
-	if (skb->proto_csum_blank) {
-		if (skb->protocol != htons(ETH_P_IP))
-			goto out;
-		skb->h.raw = (unsigned char *)skb->nh.iph + 4*skb->nh.iph->ihl;
-		if (skb->h.raw >= skb->tail)
-			goto out;
-		switch (skb->nh.iph->protocol) {
-		case IPPROTO_TCP:
-			skb->csum = offsetof(struct tcphdr, check);
-			break;
-		case IPPROTO_UDP:
-			skb->csum = offsetof(struct udphdr, check);
-			break;
-		default:
-			if (net_ratelimit())
-				printk(KERN_ERR "Attempting to checksum a non-"
-				       "TCP/UDP packet, dropping a protocol"
-				       " %d packet", skb->nh.iph->protocol);
-			goto out;
-		}
-		if ((skb->h.raw + skb->csum + 2) > skb->tail)
-			goto out;
-		skb->ip_summed = CHECKSUM_PARTIAL;
-		skb->proto_csum_blank = 0;
-	}
-	return 0;
-out:
-	return -EPROTO;
-}
-#else
-inline int skb_checksum_setup(struct sk_buff *skb) { return 0; }
-#endif
-
-
 /**
  *	dev_queue_xmit - transmit a buffer
  *	@skb: buffer to transmit
@@ -1467,12 +1424,6 @@
 	struct Qdisc *q;
 	int rc = -ENOMEM;
 
- 	/* If a checksum-deferred packet is forwarded to a device that needs a
- 	 * checksum, correct the pointers and force checksumming.
- 	 */
- 	if (skb_checksum_setup(skb))
- 		goto out_kfree_skb;
-
 	/* GSO will handle the following emulations directly. */
 	if (netif_needs_gso(dev, skb))
 		goto gso;
@@ -1848,19 +1799,6 @@
 	}
 #endif
 
-#ifdef CONFIG_XEN
-	switch (skb->ip_summed) {
-	case CHECKSUM_UNNECESSARY:
-		skb->proto_data_valid = 1;
-		break;
-	case CHECKSUM_PARTIAL:
-		/* XXX Implement me. */
-	default:
-		skb->proto_data_valid = 0;
-		break;
-	}
-#endif
-
 	list_for_each_entry_rcu(ptype, &ptype_all, list) {
 		if (!ptype->dev || ptype->dev == skb->dev) {
 			if (pt_prev) 
@@ -3625,7 +3563,6 @@
 EXPORT_SYMBOL(net_enable_timestamp);
 EXPORT_SYMBOL(net_disable_timestamp);
 EXPORT_SYMBOL(dev_get_flags);
-EXPORT_SYMBOL(skb_checksum_setup);
 
 #if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
 EXPORT_SYMBOL(br_handle_frame_hook);
diff -ur linux-2.6.20.noarch/net/core/skbuff.c linux-2.6.20.i686/net/core/skbuff.c
--- linux-2.6.20.noarch/net/core/skbuff.c	2007-04-03 15:26:15.000000000 +1000
+++ linux-2.6.20.i686/net/core/skbuff.c	2007-03-30 21:01:02.000000000 +1000
@@ -484,10 +484,6 @@
 	C(local_df);
 	n->cloned = 1;
 	n->nohdr = 0;
-#ifdef CONFIG_XEN
-	C(proto_data_valid);
-	C(proto_csum_blank);
-#endif
 	C(pkt_type);
 	C(ip_summed);
 	C(priority);
diff -ur linux-2.6.20.noarch/net/ipv4/netfilter/ip_nat_proto_tcp.c linux-2.6.20.i686/net/ipv4/netfilter/ip_nat_proto_tcp.c
--- linux-2.6.20.noarch/net/ipv4/netfilter/ip_nat_proto_tcp.c	2007-04-03 15:26:15.000000000 +1000
+++ linux-2.6.20.i686/net/ipv4/netfilter/ip_nat_proto_tcp.c	2007-03-30 21:01:02.000000000 +1000
@@ -129,15 +129,8 @@
 	if (hdrsize < sizeof(*hdr))
 		return 1;
 
-#ifdef CONFIG_XEN
-	if ((*pskb)->proto_csum_blank)
-		nf_csum_replace4(&hdr->check, oldip, newip);
-	else
-#endif
-	{
 	nf_proto_csum_replace4(&hdr->check, *pskb, oldip, newip, 1);
 	nf_proto_csum_replace2(&hdr->check, *pskb, oldport, newport, 0);
-	}
 	return 1;
 }
 
diff -ur linux-2.6.20.noarch/net/ipv4/netfilter/ip_nat_proto_udp.c linux-2.6.20.i686/net/ipv4/netfilter/ip_nat_proto_udp.c
--- linux-2.6.20.noarch/net/ipv4/netfilter/ip_nat_proto_udp.c	2007-04-03 15:26:15.000000000 +1000
+++ linux-2.6.20.i686/net/ipv4/netfilter/ip_nat_proto_udp.c	2007-03-30 21:01:02.000000000 +1000
@@ -115,16 +115,8 @@
 	}
 
 	if (hdr->check || (*pskb)->ip_summed == CHECKSUM_PARTIAL) {
-#ifdef CONFIG_XEN
-		if ((*pskb)->proto_csum_blank)
-			nf_csum_replace4(&hdr->check, oldip, newip);
-		else
-#endif
-		{
 		nf_proto_csum_replace4(&hdr->check, *pskb, oldip, newip, 1);
 		nf_proto_csum_replace2(&hdr->check, *pskb, *portptr, newport, 0);
-		}
-
 		if (!hdr->check)
 			hdr->check = CSUM_MANGLED_0;
 	}
diff -ur linux-2.6.20.noarch/net/ipv4/xfrm4_output.c linux-2.6.20.i686/net/ipv4/xfrm4_output.c
--- linux-2.6.20.noarch/net/ipv4/xfrm4_output.c	2007-04-03 15:26:15.000000000 +1000
+++ linux-2.6.20.i686/net/ipv4/xfrm4_output.c	2007-03-30 21:01:02.000000000 +1000
@@ -18,8 +18,6 @@
 #include <net/xfrm.h>
 #include <net/icmp.h>
 
-extern int skb_checksum_setup(struct sk_buff *skb);
-
 static int xfrm4_tunnel_check_size(struct sk_buff *skb)
 {
 	int mtu, ret = 0;
@@ -49,10 +47,6 @@
 	struct dst_entry *dst = skb->dst;
 	struct xfrm_state *x = dst->xfrm;
 	int err;
-	
-	err = skb_checksum_setup(skb);
-	if (err)
-		goto error_nolock;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		err = skb_checksum_help(skb);
