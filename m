Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZKTHxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZKTHxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZKTHxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:53:43 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48621 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091AbZKTHxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:53:42 -0500
X-Sasl-enc: YstpVJsvc+h8f0G6ELF3vpFfWw7XO4W7mDmMo3jMljGg 1258703628
Message-ID: <4B064B08.8090901@ladisch.de>
Date: Fri, 20 Nov 2009 08:53:44 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Der Mickster <retroeffective@gmail.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] emi62: fix crash when trying to load EMI 6|2 firmware
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While converting emi62 to use request_firmware(), the driver was
also changed to use the ihex helper functions. However, this broke
the loading of the FPGA firmware because the code tries to access
the addr field of the EOF record which works with a plain array that
has an empty last record but not with the ihex helper functions
where the end of the data is signaled with a NULL record pointer,
resulting in:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<f80d248c>] emi62_load_firmware+0x33c/0x740 [emi62]

This can be fixed by changing the loop condition to test the return
value of ihex_next_binrec() directly (like in emi26.c).

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: Der Mickster <retroeffective@gmail.com>
Acked-By: David Woodhouse <David.Woodhouse@intel.com>
Cc: <stable@kernel.org>

--- sad-penguin/drivers/usb/misc/emi62.c
+++ happy-penguin/drivers/usb/misc/emi62.c
@@ -167,7 +167,7 @@ static int emi62_load_firmware (struct u
 			err("%s - error loading firmware: error = %d", __func__, err);
 			goto wraperr;
 		}
-	} while (i > 0);
+	} while (rec);
 
 	/* Assert reset (stop the CPU in the EMI) */
 	err = emi62_set_reset(dev,1);
