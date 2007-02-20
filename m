Return-Path: <linux-kernel-owner+w=401wt.eu-S1161024AbXBTWmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161024AbXBTWmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161028AbXBTWmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:42:04 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:55782 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161015AbXBTWmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:42:01 -0500
Date: Tue, 20 Feb 2007 16:41:59 -0600
To: Jeff Garzik <jeff@garzik.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kou.ishizaki@toshiba.co.jp, arnd@arndb.de,
       Jens Osterkamp <jens@de.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 10/12]: spidernet: transmit race
Message-ID: <20070220224159.GJ28895@austin.ibm.com>
References: <20070220221314.GU923@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220221314.GU923@austin.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Multiple threads performing a transmit can race into
the spidernet tx ring cleanup code. This puts the 
relevant check under a lock.

Signed-off-by: Linas Vepstas <lins@austin.ibm.com>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>

----
 drivers/net/spider_net.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.20-git16/drivers/net/spider_net.c
===================================================================
--- linux-2.6.20-git16.orig/drivers/net/spider_net.c	2007-02-20 15:02:46.000000000 -0600
+++ linux-2.6.20-git16/drivers/net/spider_net.c	2007-02-20 15:02:48.000000000 -0600
@@ -803,8 +803,12 @@ spider_net_release_tx_chain(struct spide
 	unsigned long flags;
 	int status;
 
-	while (chain->tail != chain->head) {
+	while (1) {
 		spin_lock_irqsave(&chain->lock, flags);
+		if (chain->tail == chain->head) {
+			spin_unlock_irqrestore(&chain->lock, flags);
+			return 0;
+		}
 		descr = chain->tail;
 		hwdescr = descr->hwdescr;
 
