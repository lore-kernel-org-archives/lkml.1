Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbZJBBkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbZJBBkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbZJBBkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:40:08 -0400
Received: from kroah.org ([198.145.64.141]:33500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbZJBBeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:25 2009
Message-Id: <20091002012425.109388046@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [114/136] USB: xhci: Set -EREMOTEIO when xHC gives bad transfer length.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-set-eremoteio-when-xhc-gives-bad-transfer-length.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 2f697f6cbff155b3ce4053a50cdf00b5be4dda11 upstream.

The xHCI hardware reports the number of bytes untransferred for a given
transfer buffer.  If the hardware reports a bytes untransferred value
greater than the submitted buffer size, we want to play it safe and say no
data was transferred.  If the driver considers a short packet to be an
error, remember to set -EREMOTEIO.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1104,6 +1104,11 @@ static int handle_tx_event(struct xhci_h
 							"of %d bytes left\n",
 							TRB_LEN(event->transfer_len));
 					td->urb->actual_length = 0;
+					if (td->urb->transfer_flags &
+							URB_SHORT_NOT_OK)
+						status = -EREMOTEIO;
+					else
+						status = 0;
 				}
 				/* Don't overwrite a previously set error code */
 				if (status == -EINPROGRESS) {
@@ -1187,6 +1192,10 @@ td_cleanup:
 					urb->transfer_buffer_length,
 					urb->actual_length);
 			urb->actual_length = 0;
+			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
+				status = -EREMOTEIO;
+			else
+				status = 0;
 		}
 		list_del(&td->td_list);
 		/* Was this TD slated to be cancelled but completed anyway? */


