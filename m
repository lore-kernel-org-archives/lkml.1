Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbZADPa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbZADPa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZADPaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:30:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44097 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZADPaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:30:20 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:30:03 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 09/11] firewire: cdev: restrict broadcast write requests to
 Units Space
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.0035010cb99b6d5a@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't want random users write to Memory Space (e.g. PCs with physical
DMA filters down) or to core CSRs like Reset_Start.

This does not protect SBP-2 target CSRs.  But properly behaving SBP-2
targets ignore broadcast write requests to these registers, and the
maximum damage which can happen with laxer targets is DOS.  But there
are ways to create DOS situations anyway if there are devices with weak
device file permissions (like audio/video devices) present at the same
bus as an SBP-2 target.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -1245,6 +1245,10 @@ static int ioctl_send_broadcast_request(
 		return -EINVAL;
 	}
 
+	/* Security policy: Only allow accesses to Units Space. */
+	if (request->offset < CSR_REGISTER_BASE + CSR_CONFIG_ROM_END)
+		return -EACCES;
+
 	return init_request(client, request, LOCAL_BUS | 0x3f, SCODE_100);
 }
 

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

