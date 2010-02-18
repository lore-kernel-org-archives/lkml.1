Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab0BRAvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:51:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35994 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab0BRAvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:51:10 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 18 Feb 2010 01:50:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/3] firewire: core: fix "giving up on config rom" with
 Panasonic AG-DV2500
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.206fe651745e1dd7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Panasonic AG-DV2500 tape deck contains an invalid entry in its
configuration ROM root directory:  A leaf pointer with the undefined key
ID 0 and an offset that points way out of the standard config ROM area.
This caused firewire-core to dismiss the device with the generic log
message "giving up on config rom for node id...", after which it was of
course impossible to access the tape deck with dvgrab or any other
program.  https://bugzilla.redhat.com/show_bug.cgi?id=449252#c29

The fix is to simply ignore this invalid ROM entry and proceed to read
the valid rest of the ROM.  There is a catch though:  When the kernel
later iterates over the ROM, it would be nasty having to check again for
such too large ROM offsets.  Therefore we manipulate the defective or
unsupported ROM entry to become a harmless immediate entry that won't
have any side effects later (an entry with the value 0x00000000).

Reported-by: George Chriss
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

Index: linux-2.6.33-rc8/drivers/firewire/core-device.c
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/core-device.c
+++ linux-2.6.33-rc8/drivers/firewire/core-device.c
@@ -18,6 +18,7 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/bug.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -580,11 +581,7 @@ static int read_bus_info_block(struct fw
 		 */
 		key = stack[--sp];
 		i = key & 0xffffff;
-		if (i >= READ_BIB_ROM_SIZE)
-			/*
-			 * The reference points outside the standard
-			 * config rom area, something's fishy.
-			 */
+		if (WARN_ON(i >= READ_BIB_ROM_SIZE))
 			goto out;
 
 		/* Read header quadlet for the block to get the length. */
@@ -606,14 +603,29 @@ static int read_bus_info_block(struct fw
 		 * block, check the entries as we read them to see if
 		 * it references another block, and push it in that case.
 		 */
-		while (i < end) {
+		for (; i < end; i++) {
 			if (read_rom(device, generation, i, &rom[i]) !=
 			    RCODE_COMPLETE)
 				goto out;
-			if ((key >> 30) == 3 && (rom[i] >> 30) > 1 &&
-			    sp < READ_BIB_STACK_SIZE)
-				stack[sp++] = i + rom[i];
-			i++;
+
+			if ((key >> 30) != 3 || (rom[i] >> 30) < 2 ||
+			    sp >= READ_BIB_STACK_SIZE)
+				continue;
+			/*
+			 * Offset points outside the ROM.  May be a firmware
+			 * bug or an Extended ROM entry (IEEE 1212-2001 clause
+			 * 7.7.18).  Simply overwrite this pointer here by a
+			 * fake immediate entry so that later iterators over
+			 * the ROM don't have to check offsets all the time.
+			 */
+			if (i + (rom[i] & 0xffffff) >= READ_BIB_ROM_SIZE) {
+				fw_error("skipped unsupported ROM entry %x at %llx\n",
+					 rom[i],
+					 i * 4 | CSR_REGISTER_BASE | CSR_CONFIG_ROM);
+				rom[i] = 0;
+				continue;
+			}
+			stack[sp++] = i + rom[i];
 		}
 		if (length < i)
 			length = i;

-- 
Stefan Richter
-=====-==-=- --=- =--=-
http://arcgraph.de/sr/

