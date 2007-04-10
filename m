Return-Path: <linux-kernel-owner+w=401wt.eu-S965104AbXDJMYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbXDJMYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 08:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965153AbXDJMYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 08:24:07 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:3492 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965104AbXDJMYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 08:24:05 -0400
Date: Tue, 10 Apr 2007 14:23:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Christian Kujau <christian@g-house.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: w83l785ts: Couldn't read value from register
Message-ID: <20070410142301.5af0905b@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0704092012090.3963@sheep.housecafe.de>
References: <Pine.LNX.4.64.0704092012090.3963@sheep.housecafe.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Christian,

On Mon, 9 Apr 2007 20:21:57 +0100 (BST), Christian Kujau wrote:
> I've got this Asus A7N8X-X board and when using lm-sensors, these 
> messages occasionally show up in my kernel logs:
> 
> w83l785ts 1-002e: Couldn't read value from register 0x53. Please report.

Is it always this same register failing, or 0x27 too?

How frequently do the failures happen? Is there any pattern in the time
at which the failures happen?

> ...and reporting is what I do with this email :)
> Please see .config, dmidecode and more right here:
> http://nerdbynature.de/bits/w83l785ts/

Thanks for reporting. I didn't remember I had put this request in the
source code ;) Unfortunately this motherboard is famous for these read
errors. I still don't know what is causing them, BTW. Could be
concurrent access by ACPI or SMM, or maybe the W83L785TS-S chip is weak
and/or improperly wired on the board. I seem to remember that the board
has an Asus ASB100 hardware monitoring chip too, and that this one
doesn't have read failures? This suggests that the problem is really
with the W83L785TS-S itself and not the SMBus master.

Can you please add your /proc/ioports and /proc/acpi/dsdt files to the
location above? I'd like to take a look.

> I suppose the message is informational anyway, since sensors(1) is 
> working fine.

On read error, the driver will present the previous reading to
user-space. So it is expected that you don't notice anything.

> Perhaps we can silence the printk to only show up when 
> some debug-option is toggled?

No, informational messages are _already_ only printed when debugging is
enabled. The message you reported is printed when all the retries were
exhausted without success. The hope was that it wouldn't happen, and in
fact we didn't have any report for a couple years now.

There probably isn't much we can do, except increasing the delay or the
retry count, and hope it'll be sufficient. Can you please try the
following patch and see if it helps?


Wait longer between read retries.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/hwmon/w83l785ts.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.21-rc6.orig/drivers/hwmon/w83l785ts.c	2007-02-10 13:41:27.000000000 +0100
+++ linux-2.6.21-rc6/drivers/hwmon/w83l785ts.c	2007-04-10 14:16:50.000000000 +0200
@@ -1,7 +1,7 @@
 /*
  * w83l785ts.c - Part of lm_sensors, Linux kernel modules for hardware
  *               monitoring
- * Copyright (C) 2003-2004  Jean Delvare <khali@linux-fr.org>
+ * Copyright (C) 2003-2007  Jean Delvare <khali@linux-fr.org>
  *
  * Inspired from the lm83 driver. The W83L785TS-S is a sensor chip made
  * by Winbond. It reports a single external temperature with a 1 deg
@@ -298,12 +298,13 @@ static u8 w83l785ts_read_value(struct i2
 				"0x%02x.\n", value, reg);
 			return value;
 		}
-		dev_dbg(&client->dev, "Read failed, will retry in %d.\n", i);
-		msleep(i);
+		dev_dbg(&client->dev, "Read failed, will retry in %d ms\n",
+			i*4);
+		msleep(i*4);
 	}
 
-	dev_err(&client->dev, "Couldn't read value from register 0x%02x. "
-		"Please report.\n", reg);
+	dev_err(&client->dev, "Couldn't read value from register 0x%02x\n",
+		reg);
 	return defval;
 }
 

-- 
Jean Delvare
