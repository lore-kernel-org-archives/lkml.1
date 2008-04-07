Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbYDGUdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbYDGUdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYDGUcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:32:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57260 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbYDGUcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:32:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 7 Apr 2008 22:32:33 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update 2] firewire: fw-ohci: don't append to AT context when
 its not active
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
In-Reply-To: <200804071254.00197.jwilson@redhat.com>
Message-ID: <tkrat.953b0a6b5de4794b@s5r6.in-berlin.de>
References: <200804041705.16864.jwilson@redhat.com>
 <200804071228.15292.jwilson@redhat.com>
 <tkrat.18969adb4d4aaefb@s5r6.in-berlin.de>
 <200804071254.00197.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarod Wilson <jwilson@redhat.com>

I finally tracked down the issues with this JMicron PCI-e card in my
possession to a failure to comply with section 7.2.3.2 of the OHCI 1.1
specification (thanks to Kristian for the pointer to illustrate that it
is indeed a flaw in this card, not the driver). The controller should
simply flush the packets we've appended to its AT queue if a bus reset
occurs before they've been transmitted and we'll try again, but
something goes wrong and the controller winds up hung.

However, we can avoid the problem by simply checking if the
IntEvent.busReset register had been set before we try appending to the
AT context. When busReset is set, the AT context is completely halted
until busReset is cleared, so there's no point in appending AT packets
until the register is cleared. So at_context_queue_packet() now checks
for busReset being set, and bails with an RCODE_GENERATION packet ack,
which results in us trying to append the packet again after recognizing
the fact there has been a bus reset, and clearing busReset.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

Split out busReset event logging to do it safer as a separate patch.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -950,8 +950,19 @@ at_context_queue_packet(struct context *
 				     DESCRIPTOR_IRQ_ALWAYS |
 				     DESCRIPTOR_BRANCH_ALWAYS);
 
-	/* FIXME: Document how the locking works. */
-	if (ohci->generation != packet->generation) {
+	/*
+	 * If the controller and packet generations don't match, we need to
+	 * bail out and try again.  If IntEvent.busReset is set, the AT context
+	 * is halted, so appending to the context and trying to run it is
+	 * futile.  Most controllers do the right thing and just flush the AT
+	 * queue (per section 7.2.3.2 of the OHCI 1.1 specification), but
+	 * some controllers (like a JMicron JMB381 PCI-e) misbehave and wind
+	 * up stalling out.  So we just bail out in software and try again
+	 * later, and everyone is happy.
+	 * FIXME: Document how the locking works.
+	 */
+	if (ohci->generation != packet->generation ||
+	    reg_read(ohci, OHCI1394_IntEventSet) & OHCI1394_busReset) {
 		if (packet->payload_length > 0)
 			dma_unmap_single(ohci->card.device, payload_bus,
 					 packet->payload_length, DMA_TO_DEVICE);

-- 
Stefan Richter
-=====-==--- -=-- --===
http://arcgraph.de/sr/

