Return-Path: <linux-kernel-owner+w=401wt.eu-S1764917AbZCaXc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764917AbZCaXc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763776AbZCaXVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:10 -0400
Received: from sous-sol.org ([216.99.217.87]:33231 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763663AbZCaXVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:06 -0400
Message-Id: <20090331231442.805548084@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 11/45] USB: gadget: fix rndis regression
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=usb-gadget-fix-rndis-regression.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

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

