Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487Ab0AEAyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0AEAyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309Ab0AEAyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:54:14 -0500
Received: from kroah.org ([198.145.64.141]:34150 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab0AEAey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/97] USB: emi62: fix crash when trying to load EMI 6|2 firmware
Date: Mon,  4 Jan 2010 16:32:33 -0800
Message-Id: <1262651630-7354-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

commit ac06c06770bb8761b1f1f9bdf2f5420fa6d3e9fa upstream.

While converting emi62 to use request_firmware(), the driver was also
changed to use the ihex helper functions.  However, this broke the loading
of the FPGA firmware because the code tries to access the addr field of
the EOF record which works with a plain array that has an empty last
record but not with the ihex helper functions where the end of the data is
signaled with a NULL record pointer, resulting in:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<f80d248c>] emi62_load_firmware+0x33c/0x740 [emi62]

This can be fixed by changing the loop condition to test the return value
of ihex_next_binrec() directly (like in emi26.c).

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: Der Mickster <retroeffective@gmail.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/misc/emi62.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/misc/emi62.c b/drivers/usb/misc/emi62.c
index 602ee05..59860b3 100644
--- a/drivers/usb/misc/emi62.c
+++ b/drivers/usb/misc/emi62.c
@@ -167,7 +167,7 @@ static int emi62_load_firmware (struct usb_device *dev)
 			err("%s - error loading firmware: error = %d", __func__, err);
 			goto wraperr;
 		}
-	} while (i > 0);
+	} while (rec);
 
 	/* Assert reset (stop the CPU in the EMI) */
 	err = emi62_set_reset(dev,1);
-- 
1.6.6

