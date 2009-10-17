Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbZJQUc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbZJQUc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 16:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbZJQUc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 16:32:29 -0400
Received: from imp03.mtu.ru ([62.5.255.20]:57947 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbZJQUc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 16:32:28 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Oct 2009 16:32:27 EDT
Message-ID: <4ADA29AA.9070907@aknet.ru>
Date: Sun, 18 Oct 2009 00:31:38 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [patch] fix driver_register() return value
Content-Type: multipart/mixed;
 boundary="------------080102020303010301070606"
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080102020303010301070606
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg.

In this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=16dc42e018c2868211b4928f20a957c0c216126c
the check was added for another
driver to already claim the same
device on the same bus. But the
returned error code was wrong:
to modprobe, the -EEXIST means
that _this_ driver is already
installed. It therefore doesn't
produce the needed error message
when _another_ driver is trying
to register for the same device.
Returning -EBUSY fixes the problem.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

--------------080102020303010301070606
Content-Type: text/x-patch;
 name="drv_busy.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="drv_busy.diff"

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index ed2ebd3..f367885 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -236,7 +236,7 @@ int driver_register(struct device_driver *drv)
 		put_driver(other);
 		printk(KERN_ERR "Error: Driver '%s' is already registered, "
 			"aborting...\n", drv->name);
-		return -EEXIST;
+		return -EBUSY;
 	}
 
 	ret = bus_add_driver(drv);

--------------080102020303010301070606--
