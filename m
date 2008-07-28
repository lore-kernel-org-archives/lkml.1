Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbYG1OzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbYG1OzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbYG1OxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:53:07 -0400
Received: from styx.suse.cz ([82.119.242.94]:42468 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756285AbYG1OxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:53:06 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 07/12] ipwireless: Do not return value from sending funcs
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
       dsterba@suse.cz
Date: Mon, 28 Jul 2008 16:53:05 +0200
Message-ID: <20080728145305.13378.16161.stgit@ds.suse.cz>
In-Reply-To: <20080728145124.13378.39300.stgit@ds.suse.cz>
References: <20080728145124.13378.39300.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipwireless: Do not return value from sending funcs

Do not return value from do_send_fragment and do_send_packet, it's not used.
The packet size checks are not useful too:

* zero length packet will never be sent, caller always passes packet_header
  size which is either 1 or 3
* MTU check is done in caller, no need to repeat

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/hardware.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index 08423ba..ff2093d 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -400,19 +400,14 @@ static void swap_packet_bitfield_from_le(unsigned char *data)
 #endif
 }
 
-static int do_send_fragment(struct ipw_hardware *hw, unsigned char *data,
+static void do_send_fragment(struct ipw_hardware *hw, unsigned char *data,
 			    unsigned length)
 {
 	unsigned i;
 	unsigned long flags;
 
 	start_timing();
-
-	if (length == 0)
-		return 0;
-
-	if (length > hw->ll_mtu)
-		return -1;
+	BUG_ON(length > hw->ll_mtu);
 
 	if (ipwireless_debug)
 		dump_data_bytes("send", data, length);
@@ -458,11 +453,9 @@ static int do_send_fragment(struct ipw_hardware *hw, unsigned char *data,
 	spin_unlock_irqrestore(&hw->lock, flags);
 
 	end_write_timing(length);
-
-	return 0;
 }
 
-static int do_send_packet(struct ipw_hardware *hw, struct ipw_tx_packet *packet)
+static void do_send_packet(struct ipw_hardware *hw, struct ipw_tx_packet *packet)
 {
 	unsigned short fragment_data_len;
 	unsigned short data_left = packet->length - packet->offset;
@@ -522,8 +515,6 @@ static int do_send_packet(struct ipw_hardware *hw, struct ipw_tx_packet *packet)
 					packet->length);
 		kfree(packet);
 	}
-
-	return 0;
 }
 
 static void ipw_setup_hardware(struct ipw_hardware *hw)

