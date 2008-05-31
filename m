Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbYEaRgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbYEaRgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 13:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYEaRgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 13:36:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48074 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYEaRgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 13:36:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 31 May 2008 19:36:06 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: use of uninitialized data in AR handler
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.b906081cc9520c69@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

header_length and payload_length are filled with random data if an
unknown tcode was read from the AR buffer (i.e. if the AR buffer
contained invalid data).

We still need a better strategy to recover from this, but at least
handle_ar_packet now doesn't return out of bound buffer addresses
anymore.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -548,6 +548,11 @@ static __le32 *handle_ar_packet(struct a
 		p.header_length = 12;
 		p.payload_length = 0;
 		break;
+
+	default:
+		/* FIXME: Stop context, discard everything, and restart? */
+		p.header_length = 0;
+		p.payload_length = 0;
 	}
 
 	p.payload = (void *) buffer + p.header_length;

-- 
Stefan Richter
-=====-==--- -=-= =====
http://arcgraph.de/sr/

