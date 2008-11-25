Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbYKYSF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbYKYSF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYKYSFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 13:05:15 -0500
Received: from ryu.zarb.org ([212.85.158.22]:45828 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYKYSFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:05:14 -0500
Subject: [PATCH] hysdn: Fix writing outside the field on 64 bits
From: Pascal Terjan <pterjan@mandriva.com>
To: kkeil@suse.de
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Mandriva
Date: Tue, 25 Nov 2008 19:05:13 +0100
Message-Id: <1227636313.21706.2.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.1-1mdv2009.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ifa_local is assumed to be unsigned long which lead to writing the address at dev->dev_addr-2 instead of +2

noticed thanks to gcc:

drivers/isdn/hysdn/hysdn_net.c: In function â€˜net_openâ€™:
drivers/isdn/hysdn/hysdn_net.c:91: warning: array subscript is below array bounds

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
---
 drivers/isdn/hysdn/hysdn_net.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hysdn/hysdn_net.c b/drivers/isdn/hysdn/hysdn_net.c
index cfa8fa5..7358712 100644
--- a/drivers/isdn/hysdn/hysdn_net.c
+++ b/drivers/isdn/hysdn/hysdn_net.c
@@ -83,12 +83,12 @@ net_open(struct net_device *dev)
 
 	/* Fill in the MAC-level header (if not already set) */
 	if (!card->mac_addr[0]) {
-		for (i = 0; i < ETH_ALEN - sizeof(unsigned long); i++)
+		for (i = 0; i < ETH_ALEN; i++)
 			dev->dev_addr[i] = 0xfc;
 		if ((in_dev = dev->ip_ptr) != NULL) {
 			struct in_ifaddr *ifa = in_dev->ifa_list;
 			if (ifa != NULL)
-				memcpy(dev->dev_addr + (ETH_ALEN - sizeof(unsigned long)), &ifa->ifa_local, sizeof(unsigned long));
+				memcpy(dev->dev_addr + (ETH_ALEN - sizeof(ifa->ifa_local)), &ifa->ifa_local, sizeof(ifa->ifa_local));
 		}
 	} else
 		memcpy(dev->dev_addr, card->mac_addr, ETH_ALEN);
-- 
1.6.0.4

