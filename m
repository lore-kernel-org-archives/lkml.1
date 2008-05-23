Return-Path: <linux-kernel-owner+w=401wt.eu-S1759883AbYEWVEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883AbYEWVEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 17:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbYEWVE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 17:04:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYEWVEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 17:04:25 -0400
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into
	kernel	image
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org
In-Reply-To: <20080523213147.1b6be3d0@core>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <s5hbq2xul4s.wl%tiwai@suse.de>
	 <1211554711.28967.25.camel@pmac.infradead.org>
	 <20080523163303.492c89e4@core>
	 <1211570047.28967.75.camel@pmac.infradead.org>
	 <1211571743.28967.83.camel@pmac.infradead.org>
	 <20080523213147.1b6be3d0@core>
Content-Type: text/plain
Date: Fri, 23 May 2008 22:04:32 +0100
Message-Id: <1211576672.31212.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 21:31 +0100, Alan Cox wrote:
> It saves us a lot of memory in several cases where the drivers hang onto
> the firmware so I definitely think we should fix the folks assuming they
> can widdle on the firmware. That doesn't look hard to do and could save
> 50K+ on many systems.

Hm, ok. Do you see any better fix than this for cxusb.c ?

--- cxusb.c~	2008-04-13 13:38:13.000000000 +0100
+++ cxusb.c	2008-05-23 22:01:31.000000000 +0100
@@ -23,6 +23,8 @@
  *
  * see Documentation/dvb/README.dvb-usb for more information
  */
+#include <linux/vmalloc.h>
+
 #include "cxusb.h"
 
 #include "cx22702.h"
@@ -695,12 +697,26 @@ static int bluebird_patch_dvico_firmware
 
 		if (fw->data[idoff] == (USB_VID_DVICO & 0xff) &&
 		    fw->data[idoff + 1] == USB_VID_DVICO >> 8) {
-			fw->data[idoff + 2] =
+			struct firmware new_fw;
+			u8 *new_fw_data = vmalloc(fw->size);
+			int ret;
+
+			if (!new_fw_data)
+				return -ENOMEM;
+
+			memcpy(new_fw_data, fw->data, fw->size);
+			new_fw.size = fw->size;
+			new_fw.data = fw->data;
+
+			new_fw_data[idoff + 2] =
 				le16_to_cpu(udev->descriptor.idProduct) + 1;
-			fw->data[idoff + 3] =
+			new_fw_data[idoff + 3] =
 				le16_to_cpu(udev->descriptor.idProduct) >> 8;
 
-			return usb_cypress_load_firmware(udev, fw, CYPRESS_FX2);
+			ret = usb_cypress_load_firmware(udev, &new_fw,
+							CYPRESS_FX2);
+			vfree(new_fw_data);
+			return ret;
 		}
 	}
 

-- 
dwmw2

