Return-Path: <linux-kernel-owner+w=401wt.eu-S934476AbXHWWlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476AbXHWWlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765943AbXHWWag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:30:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33343 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385AbXHWWad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:30:33 -0400
Date: Thu, 23 Aug 2007 15:28:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andreas Jellinghaus <aj@ciphirelabs.com>
Subject: [patch 28/28] usb: add PRODUCT, TYPE to usb-interface events
Message-ID: <20070823222801.GB18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-add-product-type-to-usb-interface-events.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kay Sievers <kay.sievers@vrfy.org>

This fixes a regression for userspace programs that were relying on these events.


Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andreas Jellinghaus <aj@ciphirelabs.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/message.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1344,6 +1344,30 @@ static int usb_if_uevent(struct device *
 	usb_dev = interface_to_usbdev(intf);
 	alt = intf->cur_altsetting;
 
+#ifdef CONFIG_USB_DEVICEFS
+	if (add_uevent_var(envp, num_envp, &i,
+			   buffer, buffer_size, &length,
+			   "DEVICE=/proc/bus/usb/%03d/%03d",
+			   usb_dev->bus->busnum, usb_dev->devnum))
+		return -ENOMEM;
+#endif
+
+	if (add_uevent_var(envp, num_envp, &i,
+			   buffer, buffer_size, &length,
+			   "PRODUCT=%x/%x/%x",
+			   le16_to_cpu(usb_dev->descriptor.idVendor),
+			   le16_to_cpu(usb_dev->descriptor.idProduct),
+			   le16_to_cpu(usb_dev->descriptor.bcdDevice)))
+		return -ENOMEM;
+
+	if (add_uevent_var(envp, num_envp, &i,
+			   buffer, buffer_size, &length,
+			   "TYPE=%d/%d/%d",
+			   usb_dev->descriptor.bDeviceClass,
+			   usb_dev->descriptor.bDeviceSubClass,
+			   usb_dev->descriptor.bDeviceProtocol))
+		return -ENOMEM;
+
 	if (add_uevent_var(envp, num_envp, &i,
 		   buffer, buffer_size, &length,
 		   "INTERFACE=%d/%d/%d",

-- 
