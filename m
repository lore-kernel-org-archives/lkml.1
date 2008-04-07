Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYDGXHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYDGXHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYDGXHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:07:01 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:58907 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbYDGXHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:07:00 -0400
From: Trent Piepho <tpiepho@freescale.net>
To: linux-kernel@vger.kernel.org
Cc: Trent Piepho <tpiepho@freescale.com>, Jan Dittmer <jdittmer@ppp0.net>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: [PATCH] fakephp: Return success, not ENODEV, when bus rescan is triggered
Date: Mon,  7 Apr 2008 16:04:16 -0700
Message-Id: <1207609456-27104-1-git-send-email-tpiepho@freescale.net>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trent Piepho <tpiepho@freescale.com>

The 'power' attribute of the fakephp driver originally only let one turn a
slot off.  If one tried to turn a slot on (echo 1 > .../power), it would
return ENODEV, as fakephp did not support this function.

An old (pre-git) patch changed this:
2004/11/11 16:33:31-08:00 jdittmer
[PATCH] fakephp: add pci bus rescan ability
http://article.gmane.org/gmane.linux.kernel/251183

Now writing "1" to the power attribute has the effect of triggering a bus
rescan, but it still returns ENODEV, probably an oversight in the above
patch.

Using the BusyBox echo will not produce an error message, but will
trigger *two* bus rescans (and return an exit code of 1):
~ # strace echo -n 1 > /sys/bus/pci/slots/0000:00:00.0/power
...
write(1, "1", 1)                        = -1 ENODEV (No such device)
write(1, "1", 1)                        = -1 ENODEV (No such device)
exit(1)                                 = ?

Using cp gives a write error, even though the write did happen and a rescan
was triggered:
~ # echo -n 1 > tmp ; cp tmp /sys/bus/pci/slots/0000:00:00.0/power
cp: Write Error: No such device

It seems much better to return success instead of failure.  The actual
status of the bus rescan is hard to return.  It happens asynchronously in a
work thread, so the sysfs store functions returns before any status is
ready (the whole point of the work queue).  And even if it didn't do this,
the rescan doesn't have any clear status to return.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
CC: Jan Dittmer <jdittmer@ppp0.net>
CC: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/pci/hotplug/fakephp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 94b6401..e0bbf21 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -293,7 +293,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 	/* mis-use enable_slot for rescanning of the pci bus */
 	cancel_work_sync(&pci_rescan_work);
 	queue_work(dummyphp_wq, &pci_rescan_work);
-	return -ENODEV;
+	return 0;
 }
 
 /* find the hotplug_slot for the pci_dev */
-- 
1.5.4.1

