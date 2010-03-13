Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358Ab0CMWOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 17:14:39 -0500
Received: from legolas.restena.lu ([158.64.1.34]:40444 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab0CMWOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 17:14:36 -0500
Date: Sat, 13 Mar 2010 23:13:55 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>
Cc: <linux-input@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
Subject: [PATCH] hid: Register debugfs entries before adding device
Message-ID: <20100313231355.61c75c30@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.1003131635170.19476-100000@netrider.rowland.org>
References: <20100313203953.0f3436b3@neptune.home>
 <Pine.LNX.4.44L0.1003131635170.19476-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 March 2010 Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> If the device_add() fails, you should undo the hid_debug_register() 
> call.

Well I was wondering why hid_debug_register() was called no matter what
device_add() returned but didn't dig around what happened when
hid_add_device() would return an error.

Looking a few lines further, hid_remove_device() just unregisters debugfs
entries when status has HID_STAT_ADDED so it definitely makes sense to
do the proper cleanup (and hid_remove_device() is the only once calling
hid_debug_unregister())

So patch for both below:




Register debugfs entries before calling device_add() so debugfs entries
are already present when HID driver's probe function gets called on device
hotplug.
Also undo debugfs entry registration if device_add() fails so status
HID_STAT_ADDED and debugfs registration status remain consistent and
we don't leak the debugfs entries.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
---


diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eabe5f8..709b4d0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1759,11 +1759,12 @@ int hid_add_device(struct hid_device *hdev)
 	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
 		     hdev->vendor, hdev->product, atomic_inc_return(&id));
 
+	hid_debug_register(hdev, dev_name(&hdev->dev));
 	ret = device_add(&hdev->dev);
 	if (!ret)
 		hdev->status |= HID_STAT_ADDED;
-
-	hid_debug_register(hdev, dev_name(&hdev->dev));
+	else
+		hid_debug_unregister(hdev);
 
 	return ret;
 }
