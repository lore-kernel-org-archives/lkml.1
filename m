Return-Path: <linux-kernel-owner+w=401wt.eu-S933808AbXCOUZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbXCOUZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933837AbXCOUZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:25:51 -0400
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:49120 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933808AbXCOUZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:25:50 -0400
X-Greylist: delayed 4144 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 16:25:50 EDT
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Improve error recovery in serial mouse driver
From: Peter Osterlund <petero2@telia.com>
Date: 15 Mar 2007 20:16:42 +0100
Message-ID: <m3k5xiqput.fsf@telia.com>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If bytes get lost in the communication with a serial mouse using the
MS protocol, the kernel driver could do a better job getting back in
sync. The first byte in a packet has bit 6 set, and no other bytes
have that bit set. Therefore, if a byte is received with bit 6 cleared
when the driver thinks it is at byte 0 in the packet, the driver thinks
wrong and the byte should just be ignored.

This fix prevents spurious left/right button events when the serial
communication is disturbed by a CPU-hungry real-time process.

Signed-off-by: Peter Osterlund <petero2@telia.com>
---

 drivers/input/mouse/sermouse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/sermouse.c b/drivers/input/mouse/sermouse.c
index a85d747..24bed4b 100644
--- a/drivers/input/mouse/sermouse.c
+++ b/drivers/input/mouse/sermouse.c
@@ -108,6 +108,7 @@ static void sermouse_process_ms(struct sermouse *sermouse, signed char data)
 	signed char *buf = sermouse->buf;
 
 	if (data & 0x40) sermouse->count = 0;
+	else if (sermouse->count == 0) return;
 
 	switch (sermouse->count) {
 

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
