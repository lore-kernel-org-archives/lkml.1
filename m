Return-Path: <linux-kernel-owner+w=401wt.eu-S967456AbXEHMF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967456AbXEHMF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967452AbXEHMFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:05:54 -0400
Received: from ozlabs.org ([203.10.76.45]:35348 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967438AbXEHMFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:05:52 -0400
Subject: [PATCH] lguest: two net bugfixes
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       James Morris <jmorris@namei.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 21:22:53 +1000
Message-Id: <1178623374.7286.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) Bridging via host is broken: we need to set "promisc" bit in MAC
   address published by the host so the guest sends us everything.
   Thanks James Morris for the report (I don't use bridging).

2) Lguest network device uses 0 to mean "noone at this slot".  It used to
   use 0xFF, and one spot was missed.  Minor: it just means we'll have a
   useless extra transmit for broadcast packets.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c |    2 ++
 drivers/net/lguest_net.c      |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -r 999a9058a151 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Tue May 08 19:49:33 2007 +1000
+++ b/Documentation/lguest/lguest.c	Tue May 08 21:04:51 2007 +1000
@@ -860,6 +860,10 @@ static void setup_tun_net(const char *ar
 
 	/* We are peer 0, ie. first slot. */
 	configure_device(ipfd, ifr.ifr_name, ip, dev->mem);
+
+	/* Set "promisc" bit: we want every single packet. */
+	*((u8 *)dev->mem) |= 0x1;
+
 	close(ipfd);
 
 	verbose("device %p: tun net %u.%u.%u.%u\n",
diff -r 999a9058a151 drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c	Tue May 08 19:49:33 2007 +1000
+++ b/drivers/net/lguest_net.c	Tue May 08 21:03:47 2007 +1000
@@ -249,7 +249,7 @@ static int lguestnet_close(struct net_de
 	struct lguestnet_info *info = dev->priv;
 
 	/* Clear all trace: others might deliver packets, we'll ignore it. */
-	memset(&info->peer[info->me], 0xFF, sizeof(info->peer[info->me]));
+	memset(&info->peer[info->me], 0, sizeof(info->peer[info->me]));
 
 	/* Deregister sg lists. */
 	hcall(LHCALL_BIND_DMA, peer_key(info, info->me), __pa(info->dma), 0);




