Return-Path: <linux-kernel-owner+w=401wt.eu-S1761183AbYGRWOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbYGRWOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbYGRWLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:39 -0400
Received: from styx.suse.cz ([82.119.242.94]:55542 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759970AbYGRWLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:36 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 08/12] ipwireless: Constify buffer variables
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:11:35 +0200
Message-ID: <20080718221135.19195.76732.stgit@ds.suse.cz>
In-Reply-To: <20080718220840.19195.4140.stgit@ds.suse.cz>
References: <20080718220840.19195.4140.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/hardware.c |   26 ++++++++++++++------------
 drivers/char/pcmcia/ipwireless/hardware.h |    2 +-
 drivers/char/pcmcia/ipwireless/tty.c      |    2 +-
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index ff2093d..814ea32 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -30,11 +30,11 @@
 static void ipw_send_setup_packet(struct ipw_hardware *hw);
 static void handle_received_SETUP_packet(struct ipw_hardware *ipw,
 					 unsigned int address,
-					 unsigned char *data, int len,
+					 const unsigned char *data, int len,
 					 int is_last);
 static void ipwireless_setup_timer(unsigned long data);
 static void handle_received_CTRL_packet(struct ipw_hardware *hw,
-		unsigned int channel_idx, unsigned char *data, int len);
+		unsigned int channel_idx, const unsigned char *data, int len);
 
 /*#define TIMING_DIAGNOSTICS*/
 
@@ -615,8 +615,10 @@ static void pool_free(struct ipw_hardware *hw, struct ipw_rx_packet *packet)
 }
 
 static void queue_received_packet(struct ipw_hardware *hw,
-				  unsigned int protocol, unsigned int address,
-				  unsigned char *data, int length, int is_last)
+				  unsigned int protocol,
+				  unsigned int address,
+				  const unsigned char *data, int length,
+				  int is_last)
 {
 	unsigned int channel_idx = address - 1;
 	struct ipw_rx_packet *packet = NULL;
@@ -760,10 +762,10 @@ static void ipw_receive_data_work(struct work_struct *work_rx)
 
 static void handle_received_CTRL_packet(struct ipw_hardware *hw,
 					unsigned int channel_idx,
-					unsigned char *data, int len)
+					const unsigned char *data, int len)
 {
-	struct ipw_control_packet_body *body =
-		(struct ipw_control_packet_body *) data;
+	const struct ipw_control_packet_body *body =
+		(const struct ipw_control_packet_body *) data;
 	unsigned int changed_mask;
 
 	if (len != sizeof(struct ipw_control_packet_body)) {
@@ -805,13 +807,13 @@ static void handle_received_CTRL_packet(struct ipw_hardware *hw,
 }
 
 static void handle_received_packet(struct ipw_hardware *hw,
-				   union nl_packet *packet,
+				   const union nl_packet *packet,
 				   unsigned short len)
 {
 	unsigned int protocol = packet->hdr.protocol;
 	unsigned int address = packet->hdr.address;
 	unsigned int header_length;
-	unsigned char *data;
+	const unsigned char *data;
 	unsigned int data_len;
 	int is_last = packet->hdr.packet_rank & NL_LAST_PACKET;
 
@@ -1288,7 +1290,7 @@ static void *alloc_ctrl_packet(int header_size,
 }
 
 int ipwireless_send_packet(struct ipw_hardware *hw, unsigned int channel_idx,
-			    unsigned char *data, unsigned int length,
+			    const unsigned char *data, unsigned int length,
 			    void (*callback) (void *cb, unsigned int length),
 			    void *callback_data)
 {
@@ -1522,10 +1524,10 @@ static void ipw_send_setup_packet(struct ipw_hardware *hw)
 
 static void handle_received_SETUP_packet(struct ipw_hardware *hw,
 					 unsigned int address,
-					 unsigned char *data, int len,
+					 const unsigned char *data, int len,
 					 int is_last)
 {
-	union ipw_setup_rx_msg *rx_msg = (union ipw_setup_rx_msg *) data;
+	const union ipw_setup_rx_msg *rx_msg = (const union ipw_setup_rx_msg *) data;
 
 	if (address != ADDR_SETUP_PROT) {
 		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
diff --git a/drivers/char/pcmcia/ipwireless/hardware.h b/drivers/char/pcmcia/ipwireless/hardware.h
index e21d23a..90a8590 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.h
+++ b/drivers/char/pcmcia/ipwireless/hardware.h
@@ -41,7 +41,7 @@ int ipwireless_set_RTS(struct ipw_hardware *hw, unsigned int channel_idx,
 		int state);
 int ipwireless_send_packet(struct ipw_hardware *hw,
 			    unsigned int channel_idx,
-			    unsigned char *data,
+			    const unsigned char *data,
 			    unsigned int length,
 			    void (*packet_sent_callback) (void *cb,
 							  unsigned int length),
diff --git a/drivers/char/pcmcia/ipwireless/tty.c b/drivers/char/pcmcia/ipwireless/tty.c
index 42f3815..b141450 100644
--- a/drivers/char/pcmcia/ipwireless/tty.c
+++ b/drivers/char/pcmcia/ipwireless/tty.c
@@ -259,7 +259,7 @@ static int ipw_write(struct tty_struct *linux_tty,
 	}
 
 	ret = ipwireless_send_packet(tty->hardware, IPW_CHANNEL_RAS,
-			       (unsigned char *) buf, count,
+			       buf, count,
 			       ipw_write_packet_sent_callback, tty);
 	if (ret == -1) {
 		mutex_unlock(&tty->ipw_tty_mutex);

