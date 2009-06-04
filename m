Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZFDOQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZFDOQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbZFDOQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:16:25 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47974 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbZFDOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=Fy+H5dWVI/vsMLg4W1bvwXu2UibIsd+WuKxBEFascLy1brAXQbmqStiZMGyXkKnZWK
         xZ63zB+BmTTx6zizX64Fxmf3oCp7xqZEo8FnTHC1I64K9E4ArrHSu8giLGPsAba4mrjB
         dhm3D4yDMxPtIzQVZlMlxEGBsgA4V/9j41B7g=
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 4 Jun 2009 16:16:21 +0200
Subject: [PATCH 3/8] net/netfilter/ipvs/ip_vs_wrr.c: use lib/gcd.c
MIME-Version: 1.0
X-Length: 2143
To: "Linux-MIPS" <linux-mips@linux-mips.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041616.22786.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the open-coded version of the
greatest common divider to use lib/gcd.c, the latter
also implementing the a < b case.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index 79a6980..5b37675 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -113,6 +113,7 @@ config	IP_VS_RR
  
 config	IP_VS_WRR
         tristate "weighted round-robin scheduling" 
+	select GCD
 	---help---
 	  The weighted robin-robin scheduling algorithm directs network
 	  connections to different real servers based on server weights
diff --git a/net/netfilter/ipvs/ip_vs_wrr.c b/net/netfilter/ipvs/ip_vs_wrr.c
index f7d74ef..8701212 100644
--- a/net/netfilter/ipvs/ip_vs_wrr.c
+++ b/net/netfilter/ipvs/ip_vs_wrr.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/net.h>
+#include <linux/gcd.h>
 
 #include <net/ip_vs.h>
 
@@ -35,20 +36,6 @@ struct ip_vs_wrr_mark {
 };
 
 
-/*
- *    Get the gcd of server weights
- */
-static int gcd(int a, int b)
-{
-	int c;
-
-	while ((c = a % b)) {
-		a = b;
-		b = c;
-	}
-	return b;
-}
-
 static int ip_vs_wrr_gcd_weight(struct ip_vs_service *svc)
 {
 	struct ip_vs_dest *dest;
