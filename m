Return-Path: <linux-kernel-owner+w=401wt.eu-S934416AbXHWWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416AbXHWWkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933398AbXHWWa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:30:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33325 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385AbXHWWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:30:26 -0400
Date: Thu, 23 Aug 2007 15:27:53 -0700
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
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 26/28] USB: allow retry on descriptor fetch errors
Message-ID: <20070823222753.GZ18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-allow-retry-on-descriptor-fetch-errors.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as964) was suggested by Steffen Koepf.  It makes
usb_get_descriptor() retry on all errors other than ETIMEDOUT, instead
of only on EPIPE.  This helps with some devices.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/message.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -623,12 +623,12 @@ int usb_get_descriptor(struct usb_device
 	memset(buf,0,size);	// Make sure we parse really received data
 
 	for (i = 0; i < 3; ++i) {
-		/* retry on length 0 or stall; some devices are flakey */
+		/* retry on length 0 or error; some devices are flakey */
 		result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
 				USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
 				(type << 8) + index, 0, buf, size,
 				USB_CTRL_GET_TIMEOUT);
-		if (result == 0 || result == -EPIPE)
+		if (result <= 0 && result != -ETIMEDOUT)
 			continue;
 		if (result > 1 && ((u8 *)buf)[1] != type) {
 			result = -EPROTO;

-- 
