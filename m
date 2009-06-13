Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbZFMR4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbZFMR4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 13:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZFMRzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 13:55:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57504 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241AbZFMRzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 13:55:52 -0400
Subject: [GIT PULL] a couple of SCSI bug fixes from the last update
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Jun 2009 12:55:48 -0500
Message-Id: <1244915748.5323.30.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just fixes up a couple of config based problems in the cnic driver
(which is the broadcom iSCSI base).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog:

Ingo Molnar (1):
      cnic: fix error: implicit declaration of function ‘__symbol_get’

Randy Dunlap (1):
      cnic: fix undefined reference to `ip6_route_output'

and the diffstat:

 drivers/net/cnic.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Full diff below

James

---

diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
index 8d74037..44f77eb 100644
--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -25,6 +25,8 @@
 #include <linux/delay.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
+#include <linux/module.h>
+
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 #define BCM_VLAN 1
 #endif
@@ -1454,6 +1456,7 @@ static inline u16 cnic_get_vlan(struct net_device *dev,
 static int cnic_get_v4_route(struct sockaddr_in *dst_addr,
 			     struct dst_entry **dst)
 {
+#if defined(CONFIG_INET)
 	struct flowi fl;
 	int err;
 	struct rtable *rt;
@@ -1465,12 +1468,15 @@ static int cnic_get_v4_route(struct sockaddr_in *dst_addr,
 	if (!err)
 		*dst = &rt->u.dst;
 	return err;
+#else
+	return -ENETUNREACH;
+#endif
 }
 
 static int cnic_get_v6_route(struct sockaddr_in6 *dst_addr,
 			     struct dst_entry **dst)
 {
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+#if defined(CONFIG_IPV6) || (defined(CONFIG_IPV6_MODULE) && defined(MODULE))
 	struct flowi fl;
 
 	memset(&fl, 0, sizeof(fl));
@@ -1550,7 +1556,7 @@ static int cnic_get_route(struct cnic_sock *csk, struct cnic_sockaddr *saddr)
 	clear_bit(SK_F_IPV6, &csk->flags);
 
 	if (is_v6) {
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+#if defined(CONFIG_IPV6) || (defined(CONFIG_IPV6_MODULE) && defined(MODULE))
 		set_bit(SK_F_IPV6, &csk->flags);
 		err = cnic_get_v6_route(&saddr->remote.v6, &dst);
 		if (err)



