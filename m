Return-Path: <linux-kernel-owner+w=401wt.eu-S1762848AbXGWRFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848AbXGWRFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758381AbXGWRFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:05:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439AbXGWRFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:05:32 -0400
Message-ID: <46A4DFD2.2010501@redhat.com>
Date: Mon, 23 Jul 2007 13:05:22 -0400
From: Chris Lalancette <clalance@redhat.com>
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
Subject: [PATCH]: Add command-line option to i8042 to completely disable it
Content-Type: multipart/mixed;
 boundary="------------090206090200010202010802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090206090200010202010802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

(I tried to send this patch to linux-input@, but it seems to be currently having
some problems, so I'm going directly to LKML).

Certain (broken) pieces of South Bridge hardware will respond to
i8042_read_status() on boot with 0x0, despite there not being a real i8042
controller hooked up in the south bridge.  This can cause the detection for the
i8042 to return a "phantom" device, which hangs up later initialization.  Note
that using "i8042.nokbd" and/or "i8042.noaux" do not help with this, since this
shows up during i8042_controller_check() (before either of those options are
checked).  This patch adds a command-line option "i8042.disable", which just
completely disables any checking for the i8042 controller.

Signed-off-by: Chris Lalancette <clalance@redhat.com>




--------------090206090200010202010802
Content-Type: text/x-patch;
 name="linux-2.6-i8042-serio-disable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6-i8042-serio-disable.patch"

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 3888dc3..a13039c 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -27,6 +27,10 @@ MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
 MODULE_DESCRIPTION("i8042 keyboard and mouse controller driver");
 MODULE_LICENSE("GPL");
 
+static unsigned int i8042_disable;
+module_param_named(disable, i8042_disable, bool, 0);
+MODULE_PARM_DESC(disable, "Do not probe i8042 at all.");
+
 static unsigned int i8042_nokbd;
 module_param_named(nokbd, i8042_nokbd, bool, 0);
 MODULE_PARM_DESC(nokbd, "Do not probe or use KBD port.");
@@ -1194,6 +1198,11 @@ static int __init i8042_init(void)
 {
 	int err;
 
+	if (i8042_disable) {
+		printk(KERN_ERR "i8042.c: Controller disabled by kernel command-line\n");
+		return -ENODEV;
+	}
+
 	dbg_init();
 
 	err = i8042_platform_init();



--------------090206090200010202010802--
