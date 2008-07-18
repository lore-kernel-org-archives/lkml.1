Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbYGRWO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbYGRWO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbYGRWLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:48 -0400
Received: from styx.suse.cz ([82.119.242.94]:55555 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759417AbYGRWLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:46 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 10/12] ipwireless: Increase PPP outgoing queue size
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:11:45 +0200
Message-ID: <20080718221145.19195.81885.stgit@ds.suse.cz>
In-Reply-To: <20080718220840.19195.4140.stgit@ds.suse.cz>
References: <20080718220840.19195.4140.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase default size of PPP outgoing queue. Currently set to 1, which
means that a packet quickly following another pushed by PPP must wait
until hardware actually sends the previous and PPP has to be waken up
by ppp_wakeup(). This slows down upstream.

Now PPP can push more packets at once which get buffered inside driver
and pushed immediatelly to hardware when previous packet is out.

Experiments show that size = 10 is quite good for all connection types
(GPRS/EDGE/UMTS) and gains 4 KB/sec of upload for UMTS for batch uploads.
Need for higher queue size than 10 occures in only < 0.1 % of cases.

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/main.c    |    4 ++--
 drivers/char/pcmcia/ipwireless/network.c |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/main.c b/drivers/char/pcmcia/ipwireless/main.c
index 7169a0d..5eca7a9 100644
--- a/drivers/char/pcmcia/ipwireless/main.c
+++ b/drivers/char/pcmcia/ipwireless/main.c
@@ -49,7 +49,7 @@ static void ipwireless_detach(struct pcmcia_device *link);
 /* Debug mode: more verbose, print sent/recv bytes */
 int ipwireless_debug;
 int ipwireless_loopback;
-int ipwireless_out_queue = 1;
+int ipwireless_out_queue = 10;
 
 module_param_named(debug, ipwireless_debug, int, 0);
 module_param_named(loopback, ipwireless_loopback, int, 0);
@@ -57,7 +57,7 @@ module_param_named(out_queue, ipwireless_out_queue, int, 0);
 MODULE_PARM_DESC(debug, "switch on debug messages [0]");
 MODULE_PARM_DESC(loopback,
 		"debug: enable ras_raw channel [0]");
-MODULE_PARM_DESC(out_queue, "debug: set size of outgoing queue [1]");
+MODULE_PARM_DESC(out_queue, "debug: set size of outgoing PPP queue [10]");
 
 /* Executes in process context. */
 static void signalled_reboot_work(struct work_struct *work_reboot)
diff --git a/drivers/char/pcmcia/ipwireless/network.c b/drivers/char/pcmcia/ipwireless/network.c
index 28d9fd7..2b07af0 100644
--- a/drivers/char/pcmcia/ipwireless/network.c
+++ b/drivers/char/pcmcia/ipwireless/network.c
@@ -75,7 +75,7 @@ static void notify_packet_sent(void *callback_data, unsigned int packet_length)
 			spin_unlock_irqrestore(&network->lock, flags);
 			ppp_output_wakeup(network->ppp_channel);
 			if (ipwireless_debug)
-				printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+				printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
 				       ": ppp unblocked\n");
 		} else
 			spin_unlock_irqrestore(&network->lock, flags);
@@ -144,6 +144,8 @@ static int ipwireless_ppp_start_xmit(struct ppp_channel *ppp_channel,
 		 */
 		network->ppp_blocked = 1;
 		spin_unlock_irqrestore(&network->lock, flags);
+		if (ipwireless_debug)
+			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME ": ppp blocked\n");
 		return 0;
 	}
 }

