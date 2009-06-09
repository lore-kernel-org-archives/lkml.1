Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbZFIKSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbZFIKSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbZFIKQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:16:11 -0400
Received: from kroah.org ([198.145.64.141]:59835 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760080AbZFIKQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:16:09 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:55 2009
Message-Id: <20090609094054.855388660@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Finn Thain <fthain@telegraphics.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 12/87] mac8390: fix regression caused during net_device_ops conversion
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=mac8390-fix-regression-caused-during-net_device_ops-conversion.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 217cbfa856dc1cbc2890781626c4032d9e3ec59f ]

Changeset ca17584bf2ad1b1e37a5c0e4386728cc5fc9dabc ("mac8390: update
to net_device_ops") broke mac8390 by adding 8390.o to the link. That
meant that lib8390.c was included twice, once in mac8390.c and once in
8390.c, subject to different macros. This patch reverts that by
avoiding the wrappers in 8390.c. They seem to be of no value since
COMPAT_NET_DEV_OPS is going away soon.

Tested with a Kinetics EtherPort card.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/Makefile  |    2 +-
 drivers/net/mac8390.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/mac8390.c
+++ b/drivers/net/mac8390.c
@@ -304,7 +304,7 @@ struct net_device * __init mac8390_probe
 	if (!MACH_IS_MAC)
 		return ERR_PTR(-ENODEV);
 
-	dev = alloc_ei_netdev();
+	dev = ____alloc_ei_netdev(0);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
@@ -481,10 +481,10 @@ void cleanup_module(void)
 static const struct net_device_ops mac8390_netdev_ops = {
 	.ndo_open 		= mac8390_open,
 	.ndo_stop		= mac8390_close,
-	.ndo_start_xmit		= ei_start_xmit,
-	.ndo_tx_timeout		= ei_tx_timeout,
-	.ndo_get_stats		= ei_get_stats,
-	.ndo_set_multicast_list = ei_set_multicast_list,
+	.ndo_start_xmit		= __ei_start_xmit,
+	.ndo_tx_timeout		= __ei_tx_timeout,
+	.ndo_get_stats		= __ei_get_stats,
+	.ndo_set_multicast_list = __ei_set_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_change_mtu		= eth_change_mtu,
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -100,7 +100,7 @@ obj-$(CONFIG_HAMACHI) += hamachi.o
 obj-$(CONFIG_NET) += Space.o loopback.o
 obj-$(CONFIG_SEEQ8005) += seeq8005.o
 obj-$(CONFIG_NET_SB1000) += sb1000.o
-obj-$(CONFIG_MAC8390) += mac8390.o 8390.o
+obj-$(CONFIG_MAC8390) += mac8390.o
 obj-$(CONFIG_APNE) += apne.o 8390.o
 obj-$(CONFIG_PCMCIA_PCNET) += 8390.o
 obj-$(CONFIG_HP100) += hp100.o


