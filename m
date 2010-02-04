Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab0BDR3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:29:54 -0500
Received: from kroah.org ([198.145.64.141]:34822 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933297Ab0BDRWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:08 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:14 2010
Message-Id: <20100204171513.770478536@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [45/74] sky2: Fix oops in sky2_xmit_frame() after TX timeout
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit 9db2f1bec36805e57a003f7bb90e003815d96de8 ]

During TX timeout procedure dev could be awoken too early, e.g. by
sky2_complete_tx() called from sky2_down(). Then sky2_xmit_frame()
can run while buffers are freed causing an oops. This patch fixes it
by adding netif_device_present() test in sky2_tx_complete().

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=14925

With debugging by: Mike McCormack <mikem@ring3k.org>

Reported-by: Berck E. Nash <flyboy@gmail.com>
Tested-by: Berck E. Nash <flyboy@gmail.com>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1806,7 +1806,8 @@ static void sky2_tx_complete(struct sky2
 	sky2->tx_cons = idx;
 	smp_mb();
 
-	if (tx_avail(sky2) > MAX_SKB_TX_LE + 4)
+	/* Wake unless it's detached, and called e.g. from sky2_down() */
+	if (tx_avail(sky2) > MAX_SKB_TX_LE + 4 && netif_device_present(dev))
 		netif_wake_queue(dev);
 }
 


