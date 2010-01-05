Return-Path: <linux-kernel-owner+w=401wt.eu-S932201Ab0AEUMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab0AEUMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005Ab0AEUMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:12:38 -0500
Received: from kroah.org ([198.145.64.141]:49980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460Ab0AEUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:00 2010
Message-Id: <20100105200300.793515648@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [14/39] USB: emi62: fix crash when trying to load EMI 6|2 firmware
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/emi62.c
+++ b/drivers/usb/misc/emi62.c
@@ -167,7 +167,7 @@ static int emi62_load_firmware (struct u
 			err("%s - error loading firmware: error = %d", __func__, err);
 			goto wraperr;
 		}
-	} while (i > 0);
+	} while (rec);
 
 	/* Assert reset (stop the CPU in the EMI) */
 	err = emi62_set_reset(dev,1);


