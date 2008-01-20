Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYATAov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYATAov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 19:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYATAoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 19:44:44 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:58296 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbYATAon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 19:44:43 -0500
Date: Sat, 19 Jan 2008 18:44:40 -0600
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] W1: w1_therm.c is flagging 0C etc as invalid
Message-ID: <20080120004440.GA3738@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sat, 19 Jan 2008 18:44:41 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d05074b1beb66d40283228bd226f7244407375bb
Author: David Fries <david@fries.net>
Date:   Sat Jan 19 18:06:49 2008 -0600

The extra rom[0] check is flagging valid temperatures as invalid when
there is already a CRC data transmission check.

w1_therm_read_bin()
	if (rom[8] == crc && rom[0])
		verdict = 1;

Requiring rom[0] to be non-zero will flag as invalid temperature
conversions when the low byte is zero, specifically the temperatures
0C, 16C, 32C, 48C, -16C, -32C, and -48C.

The CRC check is produced on the device for the previous 8 bytes and
is required to ensure the data integrity in transmission.  I don't see
why the extra check for rom[0] being non-zero is in there.  Evgeniy
Polyakov didn't know either.  Just for a check I unplugged the sensor,
executed a temperature conversion, and read the results.  The read
was all ff's, which also failed the CRC, so it doesn't need to protect
against a disconnected sensor.

I have more extensive patches in the work, but these two trivial ones
will do for today.  I would like to hear from people who use the
ds2490 USB to one wire dongle.  1 if you would be willing to test the
patches as I currently only have the one sensor on a short parisite
powered wire, 2 if there is any cheap sources for the ds2490.

Signed-off-by: David Fries <david@fries.net>

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index feed89e..112f4ec 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -204,7 +204,7 @@ static ssize_t w1_therm_read_bin(struct kobject *kobj,
 
 				crc = w1_calc_crc8(rom, 8);
 
-				if (rom[8] == crc && rom[0])
+				if (rom[8] == crc)
 					verdict = 1;
 			}
 		}

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
