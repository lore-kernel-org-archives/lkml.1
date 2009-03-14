Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbZCNA0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbZCNA0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZCNASp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:45 -0400
Received: from kroah.org ([198.145.64.141]:46825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752865AbZCNASm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:42 2009
Message-Id: <20090314000742.172279014@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:30 -0700
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 22/96] USB: usb_get_string should check the descriptor type
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=usb-usb_get_string-should-check-the-descriptor-type.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 67f5a4ba9741fcef3f4db3509ad03565d9e33af2 upstream.

This patch (as1218) fixes a problem with a radio-control joystick used
in the "walkera 4#3" helicopter.  This device responds to the initial
Get-String-Descriptor request for string 0 (which is really the list
of supported languages) by sending its config descriptor!  The
usb_get_string() routine needs to check whether it got the right
type of descriptor.

Oddly enough, this sort of check is already present in
usb_get_descriptor().  The patch changes the error code from -EPROTO
to -ENODATA, because -EPROTO shows up in so many other contexts to
indicate a hardware failure rather than a firmware error.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Guillermo Jarabo <williamjap@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/message.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -651,7 +651,7 @@ int usb_get_descriptor(struct usb_device
 		if (result <= 0 && result != -ETIMEDOUT)
 			continue;
 		if (result > 1 && ((u8 *)buf)[1] != type) {
-			result = -EPROTO;
+			result = -ENODATA;
 			continue;
 		}
 		break;
@@ -694,8 +694,13 @@ static int usb_get_string(struct usb_dev
 			USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
 			(USB_DT_STRING << 8) + index, langid, buf, size,
 			USB_CTRL_GET_TIMEOUT);
-		if (!(result == 0 || result == -EPIPE))
-			break;
+		if (result == 0 || result == -EPIPE)
+			continue;
+		if (result > 1 && ((u8 *) buf)[1] != USB_DT_STRING) {
+			result = -ENODATA;
+			continue;
+		}
+		break;
 	}
 	return result;
 }


