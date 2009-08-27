Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZH0TWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZH0TWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 15:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZH0TWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 15:22:42 -0400
Received: from claw.goop.org ([74.207.240.146]:44436 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZH0TWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 15:22:42 -0400
Message-ID: <4A96DD03.2080808@goop.org>
Date: Thu, 27 Aug 2009 12:22:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Schmidt <mschmidt@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH] xenfb: connect to backend before registering fb
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As soon as the framebuffer is registered, our methods may be called by the
kernel. This leads to a crash as xenfb_refresh() gets called before we have
the irq.

Connect to the backend before registering our framebuffer with the kernel.

[ Fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=14059 ]

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 15502d5..54cd916 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -454,6 +454,10 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 
 	xenfb_init_shared_page(info, fb_info);
 
+	ret = xenfb_connect_backend(dev, info);
+	if (ret < 0)
+		goto error;
+
 	ret = register_framebuffer(fb_info);
 	if (ret) {
 		fb_deferred_io_cleanup(fb_info);
@@ -464,10 +468,6 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	}
 	info->fb_info = fb_info;
 
-	ret = xenfb_connect_backend(dev, info);
-	if (ret < 0)
-		goto error;
-
 	xenfb_make_preferred_console();
 	return 0;
 


