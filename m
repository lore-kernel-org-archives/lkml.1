Return-Path: <linux-kernel-owner+w=401wt.eu-S2993112AbXCIPed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993112AbXCIPed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993113AbXCIPed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:34:33 -0500
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:4808 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993112AbXCIPed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:34:33 -0500
Date: Fri, 9 Mar 2007 16:33:10 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>
Subject: dev_printk and new-style class devices
Message-Id: <20070309163310.b78263ed.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, all,

As the new-style class devices (as opposed to old-style struct
class_device) are becoming more widely used, I noticed that the
dev_printk-based functions are not working properly with these.
New-style class devices have no driver nor bus, almost by definition,
and as a result dev_driver_string(), which is used as the first
parameter of dev_printk, resolves to an empty string. This causes
entries like the following to show in my logs:

 i2c-2: adapter [SMBus stub driver] registered

Notice the unaesthetical leading whitespace. In order to fix this
problem, I suggest that we extend dev_driver_string to deal with
new-style class devices:

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/base/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.21-rc3.orig/drivers/base/core.c	2007-02-28 09:48:19.000000000 +0100
+++ linux-2.6.21-rc3/drivers/base/core.c	2007-03-09 16:01:07.000000000 +0100
@@ -57,7 +57,8 @@ bool is_lanana_major(unsigned int major)
 const char *dev_driver_string(struct device *dev)
 {
 	return dev->driver ? dev->driver->name :
-			(dev->bus ? dev->bus->name : "");
+			(dev->bus ? dev->bus->name :
+			(dev->class ? dev->class->name : ""));
 }
 EXPORT_SYMBOL(dev_driver_string);

In the case above, the message in the logs now looks like:

i2c-adapter i2c-2: adapter [SMBus stub driver] registered

Which is much better IMHO. Greg, what do you think?

Thanks,
-- 
Jean Delvare
