Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYIMTtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYIMTtJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 15:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYIMTs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 15:48:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:48148 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYIMTs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 15:48:58 -0400
Date: Sat, 13 Sep 2008 12:48:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: zaitcev@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] usbmon: fix tiny race exposed by the fastboot patches
Message-ID: <20080913124858.529fb8e2@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] usbmon: fix tiny race exposed by the fastboot patches

usbmon registers the notifier chain, takes the bus lock
and then goes to scan the existing devices for hooking up.

unfortunately, if usb_mon gets initialized while USB bus discovery is going on,
it's possible that usbmon gets a notifier on one cpu (which runs without USB locks),
and the scan is going on and also finds the new bus, resulting in a double sysfs
registration, which then produces a WARNING.

Pete Zaitcev did the bug diagnostics on this one

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/usb/mon/mon_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/mon/mon_main.c b/drivers/usb/mon/mon_main.c
index 442d807..5e0ab42 100644
--- a/drivers/usb/mon/mon_main.c
+++ b/drivers/usb/mon/mon_main.c
@@ -361,12 +361,12 @@ static int __init mon_init(void)
 	}
 	// MOD_INC_USE_COUNT(which_module?);
 
-	usb_register_notify(&mon_nb);
 
 	mutex_lock(&usb_bus_list_lock);
 	list_for_each_entry (ubus, &usb_bus_list, bus_list) {
 		mon_bus_init(ubus);
 	}
+	usb_register_notify(&mon_nb);
 	mutex_unlock(&usb_bus_list_lock);
 	return 0;
 
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
