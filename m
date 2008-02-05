Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbYBEUxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbYBEUxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbYBEUxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:53:34 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:39919 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761328AbYBEUxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:53:33 -0500
From: Sven Wegener <sven.wegener@stealer.net>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ipvs: Make wrr "no available servers" error message rate-limited
Date: Tue,  5 Feb 2008 21:30:21 +0100
Message-Id: <1202243421-2774-1-git-send-email-sven.wegener@stealer.net>
X-Mailer: git-send-email 1.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No available servers is more an error message than something informational. It
should also be rate-limited, else we're going to flood our logs on a busy
director, if all real servers are out of order with a weight of zero.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---

Actually, do we need this message at all? The wrr scheduler is the only one
printing an error message in such a case.

 net/ipv4/ipvs/ip_vs_wrr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/ipvs/ip_vs_wrr.c b/net/ipv4/ipvs/ip_vs_wrr.c
index 749fa04..85c680a 100644
--- a/net/ipv4/ipvs/ip_vs_wrr.c
+++ b/net/ipv4/ipvs/ip_vs_wrr.c
@@ -22,6 +22,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/net.h>
 
 #include <net/ip_vs.h>
 
@@ -169,7 +170,7 @@ ip_vs_wrr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb)
 				 */
 				if (mark->cw == 0) {
 					mark->cl = &svc->destinations;
-					IP_VS_INFO("ip_vs_wrr_schedule(): "
+					IP_VS_ERR_RL("ip_vs_wrr_schedule(): "
 						   "no available servers\n");
 					dest = NULL;
 					goto out;
-- 
1.5.3.7

