Return-Path: <linux-kernel-owner+w=401wt.eu-S935175AbYETWmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935175AbYETWmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934929AbYETWhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:37:04 -0400
Received: from ns1.suse.de ([195.135.220.2]:53685 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935066AbYETWhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:37:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 12/13] USB: Core: fix race in device_create
Date: Tue, 20 May 2008 15:34:59 -0700
Message-Id: <1211322900-12705-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520223237.GA12383@suse.de>
References: <20080520223237.GA12383@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race from when a device is created with device_create() and
then the drvdata is set with a call to dev_set_drvdata() in which a
sysfs file could be open, yet the drvdata will be NULL, causing all
sorts of bad things to happen.

This patch fixes the problem by using the new function,
device_create_drvdata().

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/hcd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index bf10e9c..09a53e7 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -818,12 +818,12 @@ static int usb_register_bus(struct usb_bus *bus)
 	set_bit (busnum, busmap.busmap);
 	bus->busnum = busnum;
 
-	bus->dev = device_create(usb_host_class, bus->controller, MKDEV(0, 0),
-				 "usb_host%d", busnum);
+	bus->dev = device_create_drvdata(usb_host_class, bus->controller,
+					 MKDEV(0, 0), bus,
+					 "usb_host%d", busnum);
 	result = PTR_ERR(bus->dev);
 	if (IS_ERR(bus->dev))
 		goto error_create_class_dev;
-	dev_set_drvdata(bus->dev, bus);
 
 	/* Add it to the local list of buses */
 	list_add (&bus->bus_list, &usb_bus_list);
-- 
1.5.5.1

