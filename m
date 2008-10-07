Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYJGN5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYJGN5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYJGN53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:57:29 -0400
Received: from sidv0150.hsr.ch ([152.96.52.150]:36223 "EHLO strongswan.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYJGN52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:57:28 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2008 09:57:28 EDT
To: davem@davemloft.net
Subject: [PATCH] xfrm: NAT mapping notifications via netlink
Cc: linux-kernel@vger.kernel.org
Message-Id: <20081007133844.27788EFB39@strongswan.org>
Date: Tue,  7 Oct 2008 15:38:44 +0200 (CEST)
From: martin@strongswan.org (Martin Willi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in NAT mappings are detected during UDP decapsulation and
notified via the PF_KEY interface to userspace.
This patch adds similar notifications to the native xfrm netlink
interface.

Signed-off-by: Martin Willi <martin@strongswan.org>

--- a/include/linux/xfrm.h	2008-10-07 10:38:17.000000000 +0200
+++ b/include/linux/xfrm.h	2008-10-07 10:46:41.000000000 +0200
@@ -199,6 +199,9 @@
 #define XFRM_MSG_NEWSPDINFO XFRM_MSG_NEWSPDINFO
 	XFRM_MSG_GETSPDINFO,
 #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
+
+	XFRM_MSG_MAPPING,
+#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
 	__XFRM_MSG_MAX
 };
 #define XFRM_MSG_MAX (__XFRM_MSG_MAX - 1)
@@ -428,6 +431,15 @@
 	__u16				new_family;
 };
 
+struct xfrm_user_mapping {
+	struct xfrm_usersa_id		id;
+	__u32				reqid;
+	xfrm_address_t			old_saddr;
+	xfrm_address_t			new_saddr;
+	__be16				old_sport;
+	__be16				new_sport;
+};
+
 #ifndef __KERNEL__
 /* backwards compatibility for userspace */
 #define XFRMGRP_ACQUIRE		1
@@ -454,6 +466,8 @@
 #define XFRMNLGRP_REPORT	XFRMNLGRP_REPORT
 	XFRMNLGRP_MIGRATE,
 #define XFRMNLGRP_MIGRATE	XFRMNLGRP_MIGRATE
+	XFRMNLGRP_MAPPING,
+#define XFRMNLGRP_MAPPING	XFRMNLGRP_MAPPING
 	__XFRMNLGRP_MAX
 };
 #define XFRMNLGRP_MAX	(__XFRMNLGRP_MAX - 1)
--- a/net/xfrm/xfrm_user.c	2008-10-07 10:38:17.000000000 +0200
+++ b/net/xfrm/xfrm_user.c	2008-10-07 10:46:41.000000000 +0200
@@ -1881,6 +1881,7 @@
 	[XFRM_MSG_MIGRATE     - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_id),
 	[XFRM_MSG_GETSADINFO  - XFRM_MSG_BASE] = sizeof(u32),
 	[XFRM_MSG_GETSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
+	[XFRM_MSG_MAPPING     - XFRM_MSG_BASE] = XMSGSIZE(xfrm_user_mapping),
 };
 
 #undef XMSGSIZE
@@ -1931,6 +1932,7 @@
 	[XFRM_MSG_MIGRATE     - XFRM_MSG_BASE] = { .doit = xfrm_do_migrate    },
 	[XFRM_MSG_GETSADINFO  - XFRM_MSG_BASE] = { .doit = xfrm_get_sadinfo   },
 	[XFRM_MSG_GETSPDINFO  - XFRM_MSG_BASE] = { .doit = xfrm_get_spdinfo   },
+	[XFRM_MSG_MAPPING     - XFRM_MSG_BASE] = { .doit = NULL               },
 };
 
 static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
@@ -2470,6 +2472,57 @@
 	return nlmsg_multicast(xfrm_nl, skb, 0, XFRMNLGRP_REPORT, GFP_ATOMIC);
 }
 
+static inline size_t xfrm_mapping_msgsize(void)
+{
+	return NLMSG_ALIGN(sizeof(struct xfrm_user_mapping));
+}
+
+static int build_mapping(struct sk_buff *skb, struct xfrm_state *x,
+			 xfrm_address_t *new_saddr, __be16 new_sport)
+{
+	struct xfrm_user_mapping *um;
+	struct nlmsghdr *nlh;
+
+	nlh = nlmsg_put(skb, 0, 0, XFRM_MSG_MAPPING, sizeof(*um), 0);
+	if (nlh == NULL)
+		return -EMSGSIZE;
+
+	um = nlmsg_data(nlh);
+	
+	memcpy(&um->id.daddr, &x->id.daddr, sizeof(um->id.daddr));
+	um->id.spi = x->id.spi;
+	um->id.family = x->props.family;
+	um->id.proto = x->id.proto;
+	memcpy(&um->new_saddr, new_saddr, sizeof(um->new_saddr));
+	memcpy(&um->old_saddr, &x->props.saddr, sizeof(um->old_saddr));
+	um->new_sport = new_sport;
+	um->old_sport = x->encap->encap_sport;
+	um->reqid = x->props.reqid;
+
+	return nlmsg_end(skb, nlh);
+}
+
+static int xfrm_send_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr,
+			     __be16 sport)
+{
+	struct sk_buff *skb;
+
+	if (x->id.proto != IPPROTO_ESP)
+		return -EINVAL;
+
+	if (!x->encap)
+		return -EINVAL;
+
+	skb = nlmsg_new(xfrm_mapping_msgsize(), GFP_ATOMIC);
+	if (skb == NULL)
+		return -ENOMEM;
+
+	if (build_mapping(skb, x, ipaddr, sport) < 0)
+		BUG();
+
+	return nlmsg_multicast(xfrm_nl, skb, 0, XFRMNLGRP_MAPPING, GFP_ATOMIC);
+}
+
 static struct xfrm_mgr netlink_mgr = {
 	.id		= "netlink",
 	.notify		= xfrm_send_state_notify,
@@ -2478,6 +2531,7 @@
 	.notify_policy	= xfrm_send_policy_notify,
 	.report		= xfrm_send_report,
 	.migrate	= xfrm_send_migrate,
+	.new_mapping	= xfrm_send_mapping,
 };
 
 static int __init xfrm_user_init(void)
