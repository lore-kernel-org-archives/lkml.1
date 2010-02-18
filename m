Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab0BRAxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:53:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36012 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab0BRAxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:53:00 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 18 Feb 2010 01:52:45 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/3] firewire: core: don't fail device creation in case of too
 large config ROM blocks
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.206fe651745e1dd7@s5r6.in-berlin.de>
Message-ID: <tkrat.040d1f77b4f1ddb4@s5r6.in-berlin.de>
References: <tkrat.206fe651745e1dd7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It never happened yet, but better safe than sorry:  If a device's config
ROM contains a block which overlaps the boundary at 0xfffff00007ff, just
ignore that one block instead of refusing to add the device
representation.  That way, upper layers (kernelspace or userspace
drivers) might still be able to use the device to some degree.

That's better than total inaccessibility of the device.  Worse, the core
would have logged only a generic "giving up on config rom" message which
could only be debugged by feeding a firewire-ohci debug logging session
through a config ROM interpreter, IOW would likely remain undiagnosed.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6.33-rc8/drivers/firewire/core-device.c
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/core-device.c
+++ linux-2.6.33-rc8/drivers/firewire/core-device.c
@@ -588,15 +588,19 @@ static int read_bus_info_block(struct fw
 		if (read_rom(device, generation, i, &rom[i]) != RCODE_COMPLETE)
 			goto out;
 		end = i + (rom[i] >> 16) + 1;
-		i++;
-		if (end > READ_BIB_ROM_SIZE)
+		if (end > READ_BIB_ROM_SIZE) {
 			/*
-			 * This block extends outside standard config
-			 * area (and the array we're reading it
-			 * into).  That's broken, so ignore this
-			 * device.
+			 * This block extends outside the config ROM which is
+			 * a firmware bug.  Ignore this whole block, i.e.
+			 * simply set a fake block length of 0.
 			 */
-			goto out;
+			fw_error("skipped invalid ROM block %x at %llx\n",
+				 rom[i],
+				 i * 4 | CSR_REGISTER_BASE | CSR_CONFIG_ROM);
+			rom[i] = 0;
+			end = i;
+		}
+		i++;
 
 		/*
 		 * Now read in the block.  If this is a directory

-- 
Stefan Richter
-=====-==-=- --=- =--=-
http://arcgraph.de/sr/

