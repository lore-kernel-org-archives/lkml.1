Return-Path: <linux-kernel-owner+w=401wt.eu-S1765004AbZD3RMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765004AbZD3RMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764288AbZD3RH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:28 -0400
Received: from kroah.org ([198.145.64.141]:56226 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764174AbZD3RHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:40 2009
Message-Id: <20090430165740.067797234@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 12/88] USB: gadget: fix rndis regression
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0011-USB-gadget-fix-rndis-regression.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Brownell <dbrownell@users.sourceforge.net>

upstream commit: 090b90118207e786d2990310d063fda5d52cce6e

Restore some code that was wrongly dropped from the RNDIS
driver, and caused interop problems observed with OpenMoko.

The issue is with hardware which needs help conforming to part
of the USB 2.0 spec (section 8.5.3.2); some can automagically
send a ZLP in response to an unexpected IN, but not all chips
will do that.  We don't need to check the packet length ourselves
the way earlier code did, since the UDC must already check it.
But we do need to tell the UDC when it must force a short packet
termination of the data stage.

(Based on a patch from Aric D. Blumer <aric at sdgsystems.com>)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/gadget/f_rndis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -437,7 +437,7 @@ invalid:
 		DBG(cdev, "rndis req%02x.%02x v%04x i%04x l%d\n",
 			ctrl->bRequestType, ctrl->bRequest,
 			w_value, w_index, w_length);
-		req->zero = 0;
+		req->zero = (value < w_length);
 		req->length = value;
 		value = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
 		if (value < 0)


