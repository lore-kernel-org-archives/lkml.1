Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbYGKNOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbYGKNOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYGKNOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:14:33 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:50912 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYGKNOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:14:32 -0400
X-Greylist: delayed 1606 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2008 09:14:31 EDT
Date: Fri, 11 Jul 2008 14:47:35 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: shemminger@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] bridge: send correct MTU value in PMTU
Message-ID: <20080711124735.GA16996@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Score: 0.2 (/)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (0.2 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	1.6 TVD_RCVD_IP            TVD_RCVD_IP
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 5dbf601dd3e3110f39de424f56b52b4d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

When bridging interfaces with different MTUs, the bridge correctly
chooses
the minimum of the MTUs of the physical devices as the bridges MTU. But
when a frame is passed which fits through the incoming, but not through
the
outgoing interface, a "Fragmentation Needed" packet is generated.
However, the propagated MTU is hardcoded to 1500, which is wrong in this
situation. The sender will repeat the packet again with the same frame
size,
and the same problem will occur again.

Instead of sending 1500, the (correct) MTU value of the bridge is now
sent via PMTU. To achieve this, the corresponding rtable structure is
stored in its net_bridge structure.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/bridge/br_device.c    |    5 ++++-
 net/bridge/br_if.c        |   31 +++++++++++++++++++++++++++++++
 net/bridge/br_netfilter.c |   45 ++++++++++++-----------------------------=
----
 net/bridge/br_private.h   |    4 ++++
 4 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index bf77873..a52075b 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -76,10 +76,13 @@ static int br_dev_stop(struct net_device *dev)
=20
 static int br_change_mtu(struct net_device *dev, int new_mtu)
 {
-	if (new_mtu < 68 || new_mtu > br_min_mtu(netdev_priv(dev)))
+	struct net_bridge *br =3D netdev_priv(dev);
+	if (new_mtu < 68 || new_mtu > br_min_mtu(br))
 		return -EINVAL;
=20
 	dev->mtu =3D new_mtu;
+	/* remember the MTU in the rtable for PMTU */
+	br->fake_rtable.u.dst.metrics[RTAX_MTU - 1] =3D new_mtu;
 	return 0;
 }
=20
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f38cc53..b8d438d 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -170,6 +170,34 @@ static void del_br(struct net_bridge *br)
 	unregister_netdevice(br->dev);
 }
=20
+/* We need these fake structures to make netfilter happy --
+ * lots of places assume that skb->dst !=3D NULL, which isn't
+ * all that unreasonable.
+ *
+ * Currently, we fill in the PMTU entry because netfilter
+ * refragmentation needs it, and the rt_flags entry because
+ * ipt_REJECT needs it.  Future netfilter modules might
+ * require us to fill additional fields. */
+struct net_device __fake_net_device =3D {
+	.hard_header_len	=3D ETH_HLEN,
+#ifdef CONFIG_NET_NS
+	.nd_net			=3D &init_net,
+#endif
+};
+
+struct rtable __fake_rtable =3D {
+	.u =3D {
+		.dst =3D {
+			.__refcnt		=3D ATOMIC_INIT(1),
+			.dev			=3D &__fake_net_device,
+			.path			=3D &__fake_rtable.u.dst,
+			.metrics		=3D {[RTAX_MTU - 1] =3D 1500},
+			.flags			=3D DST_NOXFRM,
+		}
+	},
+	.rt_flags	=3D 0,
+};
+
 static struct net_device *new_bridge_dev(const char *name)
 {
 	struct net_bridge *br;
@@ -204,6 +232,9 @@ static struct net_device *new_bridge_dev(const char *na=
me)
 	br->topology_change =3D 0;
 	br->topology_change_detected =3D 0;
 	br->ageing_time =3D 300 * HZ;
+	memcpy(&br->fake_rtable, &__fake_rtable, sizeof(__fake_rtable));
+	br->fake_rtable.u.dst.path =3D &br->fake_rtable.u.dst;
+
 	INIT_LIST_HEAD(&br->age_list);
=20
 	br_stp_timer_init(br);
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index bb90cd7..9d6a578 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -101,33 +101,12 @@ static inline __be16 pppoe_proto(const struct sk_buff=
 *skb)
 	 pppoe_proto(skb) =3D=3D htons(PPP_IPV6) && \
 	 brnf_filter_pppoe_tagged)
=20
-/* We need these fake structures to make netfilter happy --
- * lots of places assume that skb->dst !=3D NULL, which isn't
- * all that unreasonable.
- *
- * Currently, we fill in the PMTU entry because netfilter
- * refragmentation needs it, and the rt_flags entry because
- * ipt_REJECT needs it.  Future netfilter modules might
- * require us to fill additional fields. */
-static struct net_device __fake_net_device =3D {
-	.hard_header_len	=3D ETH_HLEN,
-#ifdef CONFIG_NET_NS
-	.nd_net			=3D &init_net,
-#endif
-};
+static inline struct rtable *bridge_parent_rtable(const struct net_device =
*dev)
+{
+	struct net_bridge_port *port =3D rcu_dereference(dev->br_port);
=20
-static struct rtable __fake_rtable =3D {
-	.u =3D {
-		.dst =3D {
-			.__refcnt		=3D ATOMIC_INIT(1),
-			.dev			=3D &__fake_net_device,
-			.path			=3D &__fake_rtable.u.dst,
-			.metrics		=3D {[RTAX_MTU - 1] =3D 1500},
-			.flags			=3D DST_NOXFRM,
-		}
-	},
-	.rt_flags	=3D 0,
-};
+	return port ? &port->br->fake_rtable: &__fake_rtable;
+}
=20
 static inline struct net_device *bridge_parent(const struct net_device *de=
v)
 {
@@ -226,8 +205,8 @@ static int br_nf_pre_routing_finish_ipv6(struct sk_buff=
 *skb)
 	}
 	nf_bridge->mask ^=3D BRNF_NF_BRIDGE_PREROUTING;
=20
-	skb->rtable =3D &__fake_rtable;
-	dst_hold(&__fake_rtable.u.dst);
+	skb->rtable =3D bridge_parent_rtable(nf_bridge->physindev);
+	dst_hold(&skb->rtable->u.dst);
=20
 	skb->dev =3D nf_bridge->physindev;
 	nf_bridge_push_encap_header(skb);
@@ -391,8 +370,8 @@ bridged_dnat:
 			skb->pkt_type =3D PACKET_HOST;
 		}
 	} else {
-		skb->rtable =3D &__fake_rtable;
-		dst_hold(&__fake_rtable.u.dst);
+		skb->rtable =3D bridge_parent_rtable(nf_bridge->physindev);
+		dst_hold(&skb->rtable->u.dst);
 	}
=20
 	skb->dev =3D nf_bridge->physindev;
@@ -611,8 +590,8 @@ static unsigned int br_nf_local_in(unsigned int hook, s=
truct sk_buff *skb,
 				   const struct net_device *out,
 				   int (*okfn)(struct sk_buff *))
 {
-	if (skb->rtable =3D=3D &__fake_rtable) {
-		dst_release(&__fake_rtable.u.dst);
+	if (skb->rtable =3D=3D bridge_parent_rtable(in)) {
+		dst_release(&skb->rtable->u.dst);
 		skb->rtable =3D NULL;
 	}
=20
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c11b554..c0e9a7e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -17,6 +17,7 @@
=20
 #include <linux/netdevice.h>
 #include <linux/if_bridge.h>
+#include <net/route.h>	/* struct rtable, RTAX_MTU */
=20
 #define BR_HASH_BITS 8
 #define BR_HASH_SIZE (1 << BR_HASH_BITS)
@@ -95,6 +96,7 @@ struct net_bridge
 	struct hlist_head		hash[BR_HASH_SIZE];
 	struct list_head		age_list;
 	unsigned long			feature_mask;
+	struct rtable 			fake_rtable;
=20
 	/* STP */
 	bridge_id			designated_root;
@@ -202,6 +204,8 @@ extern void br_netfilter_fini(void);
 #define br_netfilter_init()	(0)
 #define br_netfilter_fini()	do { } while(0)
 #endif
+extern struct rtable __fake_rtable;
+extern struct net_device __fake_net_device;
=20
 /* br_stp.c */
 extern void br_log_state(const struct net_bridge_port *p);
--=20
1.5.6.2


--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFId1Znrzg/fFk7axYRAnahAJ9M0RHjlvq37QjkpmFAeSFEeZx6wgCfeokq
Jp/CYvUBY/M6Lttwa5OpC8g=
=VsJ8
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
