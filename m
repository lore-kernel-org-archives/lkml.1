Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbZG1XIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbZG1XIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbZG1XEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:04:00 -0400
Received: from kroah.org ([198.145.64.141]:42942 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006AbZG1XDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:03:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:42 2009
Message-Id: <20090728225942.430664487@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       Aric Blumer <aric@sdgsystems.net>
Subject: [patch 10/37] USB: RNDIS gadget, fix issues talking from PXA
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=usb-rndis-gadget-fix-issues-talking-from-pxa.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Brownell <dbrownell@users.sourceforge.net>

commit 4e19f220d4e84f5728cb7edde36352ab425cfba4 upstream.

The reworked Ethernet gadget has an RNDIS interop problem when used
with the CDC subset driver ... e.g. on PXA 2xx and 3xx hardware,
which currently has a hard time talking to MS-Windows hosts.

The issue is that Microsoft requires USB_CLASS_COMM.  Fix by tweaking
the CDC subset driver to not switch to USB_CLASS_VENDOR_SPEC if RNDIS
is used in some other device configuration.

[ UPDATED:  some "statements" were comma-terminated; fix that. ]

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Aric Blumer <aric@sdgsystems.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/ether.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -273,15 +273,16 @@ static int __init eth_bind(struct usb_co
 		/* CDC Subset */
 		eth_config_driver.label = "CDC Subset/SAFE";
 
-		device_desc.idVendor = cpu_to_le16(SIMPLE_VENDOR_NUM),
-		device_desc.idProduct = cpu_to_le16(SIMPLE_PRODUCT_NUM),
-		device_desc.bDeviceClass = USB_CLASS_VENDOR_SPEC;
+		device_desc.idVendor = cpu_to_le16(SIMPLE_VENDOR_NUM);
+		device_desc.idProduct = cpu_to_le16(SIMPLE_PRODUCT_NUM);
+		if (!has_rndis())
+			device_desc.bDeviceClass = USB_CLASS_VENDOR_SPEC;
 	}
 
 	if (has_rndis()) {
 		/* RNDIS plus ECM-or-Subset */
-		device_desc.idVendor = cpu_to_le16(RNDIS_VENDOR_NUM),
-		device_desc.idProduct = cpu_to_le16(RNDIS_PRODUCT_NUM),
+		device_desc.idVendor = cpu_to_le16(RNDIS_VENDOR_NUM);
+		device_desc.idProduct = cpu_to_le16(RNDIS_PRODUCT_NUM);
 		device_desc.bNumConfigurations = 2;
 	}
 


