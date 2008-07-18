Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbYGRWNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbYGRWNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbYGRWLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:33 -0400
Received: from styx.suse.cz ([82.119.242.94]:55537 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756515AbYGRWLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:32 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 07/12] ipwireless: Do not return value from sending funcs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:11:30 +0200
Message-ID: <20080718221130.19195.82854.stgit@ds.suse.cz>
In-Reply-To: <20080718220840.19195.4140.stgit@ds.suse.cz>
References: <20080718220840.19195.4140.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

