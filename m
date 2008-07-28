Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbYG1O4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbYG1O4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbYG1Oxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:53:35 -0400
Received: from styx.suse.cz ([82.119.242.94]:42510 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756615AbYG1Oxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:53:33 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 12/12] ipwireless: Preallocate received packet buffers with
	MRU size
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
       dsterba@suse.cz
Date: Mon, 28 Jul 2008 16:53:32 +0200
Message-ID: <20080728145332.13378.80871.stgit@ds.suse.cz>
In-Reply-To: <20080728145124.13378.39300.stgit@ds.suse.cz>
References: <20080728145124.13378.39300.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipwireless: Preallocate received packet buffers with MRU size

Packets are assembled from link size (~300 bytes) up to PPP MRU
(1500 by default). Try to preallocate full size rather than
repeatedly advance buffer size by 256 bytes.

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/hardware.c |    3 ++-
 drivers/char/pcmcia/ipwireless/network.c  |    5 +++++
 drivers/char/pcmcia/ipwireless/network.h  |    1 +
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index d1e69de..7d500f8 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -567,7 +567,8 @@ static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
 			spin_unlock_irqrestore(&hw->lock, flags);
 			list_del(&packet->queue);
 		} else {
-			static int min_capacity = 256;
+			const int min_capacity =
+				ipwireless_ppp_mru(hw->network + 2);
 			int new_capacity;
 
 			spin_unlock_irqrestore(&hw->lock, flags);
diff --git a/drivers/char/pcmcia/ipwireless/network.c b/drivers/char/pcmcia/ipwireless/network.c
index 2b07af0..590762a 100644
--- a/drivers/char/pcmcia/ipwireless/network.c
+++ b/drivers/char/pcmcia/ipwireless/network.c
@@ -499,3 +499,8 @@ int ipwireless_ppp_unit_number(struct ipw_network *network)
 
 	return ret;
 }
+
+int ipwireless_ppp_mru(const struct ipw_network *network)
+{
+	return network->mru;
+}
diff --git a/drivers/char/pcmcia/ipwireless/network.h b/drivers/char/pcmcia/ipwireless/network.h
index ccacd26..561f765 100644
--- a/drivers/char/pcmcia/ipwireless/network.h
+++ b/drivers/char/pcmcia/ipwireless/network.h
@@ -48,5 +48,6 @@ void ipwireless_ppp_open(struct ipw_network *net);
 void ipwireless_ppp_close(struct ipw_network *net);
 int ipwireless_ppp_channel_index(struct ipw_network *net);
 int ipwireless_ppp_unit_number(struct ipw_network *net);
+int ipwireless_ppp_mru(const struct ipw_network *net);
 
 #endif

