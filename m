Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZKQWkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZKQWkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbZKQWki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:40:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51385 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbZKQWkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:40:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/3] macvlan: export macvlan mode through netlink
Date: Tue, 17 Nov 2009 22:39:10 +0000
Message-Id: <1258497551-25959-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258497551-25959-1-git-send-email-arnd@arndb.de>
References: <1258497551-25959-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/cGjCxXX2qNuUmjRzlk/0JDhR7Wy34UTBO1Vb
 UEVCZ0D4edPJJoH5sKKvzN2Zfl6ERPaVR+qgIRDSVfraPPEMUE
 VZPA9sCUHOW1RYs7uAu6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support all three modes of macvlan at
runtime, extend the existing netlink protocol
to allow choosing the mode per macvlan slave
interface.

This depends on a matching patch to iproute2
in order to become accessible in user land.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/macvlan.c   |   67 +++++++++++++++++++++++++++++++++++++++++-----
 include/linux/if_link.h |   15 ++++++++++
 2 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index fa8b568..731017e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -33,12 +33,6 @@
 
 #define MACVLAN_HASH_SIZE	(1 << BITS_PER_BYTE)
 
-enum macvlan_type {
-	MACVLAN_PRIVATE		= 1,
-	MACVLAN_VEPA		= 2,
-	MACVLAN_BRIDGE		= 4,
-};
-
 struct macvlan_port {
 	struct net_device	*dev;
 	struct hlist_head	vlan_hash[MACVLAN_HASH_SIZE];
@@ -51,7 +45,7 @@ struct macvlan_dev {
 	struct hlist_node	hlist;
 	struct macvlan_port	*port;
 	struct net_device	*lowerdev;
-	enum macvlan_mode	mode;
+	enum ifla_macvlan_mode	mode;
 };
 
 
@@ -112,7 +106,7 @@ static int macvlan_addr_busy(const struct macvlan_port *port,
 static void macvlan_broadcast(struct sk_buff *skb,
 			      const struct macvlan_port *port,
 			      struct net_device *src,
-			      enum macvlan_mode mode)
+			      enum ifla_macvlan_mode mode)
 {
 	const struct ethhdr *eth = eth_hdr(skb);
 	const struct macvlan_dev *vlan;
@@ -553,6 +547,18 @@ static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[])
 		if (!is_valid_ether_addr(nla_data(tb[IFLA_ADDRESS])))
 			return -EADDRNOTAVAIL;
 	}
+
+	if (data && data[IFLA_MACVLAN_MODE]) {
+		u32 mode = nla_get_u32(data[IFLA_MACVLAN_MODE]);
+		switch (mode) {
+		case MACVLAN_MODE_PRIVATE:
+		case MACVLAN_MODE_VEPA:
+		case MACVLAN_MODE_BRIDGE:
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
 	return 0;
 }
 
@@ -617,6 +623,13 @@ static int macvlan_newlink(struct net_device *dev,
 	vlan->dev      = dev;
 	vlan->port     = port;
 
+	vlan->mode     = MACVLAN_MODE_VEPA;
+	if (data && data[IFLA_MACVLAN_MODE]) {
+		u32 mode = nla_get_u32(data[IFLA_MACVLAN_MODE]);
+
+		vlan->mode     = mode;
+	}
+
 	err = register_netdevice(dev);
 	if (err < 0)
 		return err;
@@ -638,6 +651,39 @@ static void macvlan_dellink(struct net_device *dev)
 		macvlan_port_destroy(port->dev);
 }
 
+static int macvlan_changelink(struct net_device *dev,
+		struct nlattr *tb[], struct nlattr *data[])
+{
+	struct macvlan_dev *vlan = netdev_priv(dev);
+	if (data && data[IFLA_MACVLAN_MODE]) {
+		u32 mode = nla_get_u32(data[IFLA_MACVLAN_MODE]);
+		vlan->mode     = mode;
+	}
+
+	return 0;
+}
+
+static size_t macvlan_get_size(const struct net_device *dev)
+{
+	return nla_total_size(4);
+}
+
+static int macvlan_fill_info(struct sk_buff *skb,
+				const struct net_device *dev)
+{
+	struct macvlan_dev *vlan = netdev_priv(dev);
+
+	NLA_PUT_U32(skb, IFLA_MACVLAN_MODE, vlan->mode);	
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static const struct nla_policy macvlan_policy[IFLA_MACVLAN_MAX + 1] = {
+	[IFLA_MACVLAN_MODE] = { .type = NLA_U32 },
+};
+
 static struct rtnl_link_ops macvlan_link_ops __read_mostly = {
 	.kind		= "macvlan",
 	.priv_size	= sizeof(struct macvlan_dev),
@@ -646,6 +692,11 @@ static struct rtnl_link_ops macvlan_link_ops __read_mostly = {
 	.validate	= macvlan_validate,
 	.newlink	= macvlan_newlink,
 	.dellink	= macvlan_dellink,
+	.maxtype	= IFLA_MACVLAN_MAX,
+	.policy		= macvlan_policy,
+	.changelink	= macvlan_changelink,
+	.get_size	= macvlan_get_size,
+	.fill_info	= macvlan_fill_info,
 };
 
 static int macvlan_device_event(struct notifier_block *unused,
diff --git a/include/linux/if_link.h b/include/linux/if_link.h
index 176c518..ef70ebc 100644
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@ -190,4 +190,19 @@ struct ifla_vlan_qos_mapping
 	__u32 to;
 };
 
+/* MACVLAN section */
+enum {
+	IFLA_MACVLAN_UNSPEC,
+	IFLA_MACVLAN_MODE,
+	__IFLA_MACVLAN_MAX,
+};
+
+#define IFLA_MACVLAN_MAX (__IFLA_MACVLAN_MAX - 1)
+
+enum ifla_macvlan_mode {
+	MACVLAN_MODE_PRIVATE = 1, /* don't talk to other macvlans */
+	MACVLAN_MODE_VEPA    = 2, /* talk to other ports through ext bridge */
+	MACVLAN_MODE_BRIDGE  = 4, /* talk to bridge ports directly */
+};
+
 #endif /* _LINUX_IF_LINK_H */
-- 
1.6.3.3

