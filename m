Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbZFIK1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbZFIK1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760761AbZFIKUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:03 -0400
Received: from kroah.org ([198.145.64.141]:55007 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760762AbZFIKUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:01 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:03 2009
Message-Id: <20090609094102.849740736@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:34 -0700
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
       alan@lxorguk.ukuu.org.uk, Neil Horman <nhorman@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 46/87] e1000: add missing length check to e1000 receive routine
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=e1000-add-missing-length-check-to-e1000-receive-routine.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit ea30e11970a96cfe5e32c03a29332554573b4a10 upstream.

	Patch to fix bad length checking in e1000.  E1000 by default does two
things:

1) Spans rx descriptors for packets that don't fit into 1 skb on recieve
2) Strips the crc from a frame by subtracting 4 bytes from the length prior to
doing an skb_put

Since the e1000 driver isn't written to support receiving packets that span
multiple rx buffers, it checks the End of Packet bit of every frame, and
discards it if its not set.  This places us in a situation where, if we have a
spanning packet, the first part is discarded, but the second part is not (since
it is the end of packet, and it passes the EOP bit test).  If the second part of
the frame is small (4 bytes or less), we subtract 4 from it to remove its crc,
underflow the length, and wind up in skb_over_panic, when we try to skb_put a
huge number of bytes into the skb.  This amounts to a remote DOS attack through
careful selection of frame size in relation to interface MTU.  The fix for this
is already in the e1000e driver, as well as the e1000 sourceforge driver, but no
one ever pushed it to e1000.  This is lifted straight from e1000e, and prevents
small frames from causing the underflow described above

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -4027,8 +4027,9 @@ static bool e1000_clean_rx_irq(struct e1000_adapter *adapter,
 		                 PCI_DMA_FROMDEVICE);
 
 		length = le16_to_cpu(rx_desc->length);
-
-		if (unlikely(!(status & E1000_RXD_STAT_EOP))) {
+		/* !EOP means multiple descriptors were used to store a single
+		 * packet, also make sure the frame isn't just CRC only */
+		if (unlikely(!(status & E1000_RXD_STAT_EOP) || (length <= 4))) {
 			/* All receives must fit into a single buffer */
 			E1000_DBG("%s: Receive packet consumed multiple"
 				  " buffers\n", netdev->name);


