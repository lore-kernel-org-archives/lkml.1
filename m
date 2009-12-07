Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbZLGASy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbZLGASy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758593AbZLGANx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:53 -0500
Received: from kroah.org ([198.145.64.141]:34649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582AbZLGANm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:42 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:56 2009
Message-Id: <20091207000656.155029308@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>
Subject: [086/119] USB: EHCI: dont send Clear-TT-Buffer following a STALL
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=usb-ehci-don-t-send-clear-tt-buffer-following-a-stall.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit c2f6595fbdb408d3d6850cfae590c8fa93e27399 upstream.

This patch (as1304) fixes a regression in ehci-hcd.  Evidently some
hubs don't handle Clear-TT-Buffer requests correctly, so we should
avoid sending them when they don't appear to be absolutely necessary.
The reported symptom is that output on a downstream audio device cuts
out because the hub stops relaying isochronous packets.

The patch prevents Clear-TT-Buffer requests from being sent following
a STALL handshake.  In theory a STALL indicates either that the
downstream device sent a STALL or that no matching TT buffer could be
found.  In either case, the transfer is completed and the TT buffer
does not remain busy, so it doesn't need to be cleared.

Also, the patch fixes a minor flaw in the code that actually sends the
Clear-TT-Buffer requests.  Although the pipe direction isn't really
used for control transfers, it should be a Send rather than a Receive.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Javier Kohen <jkohen@users.sourceforge.net>
CC: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c    |    2 +-
 drivers/usb/host/ehci-q.c |   16 ++++++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -439,7 +439,7 @@ resubmit:
 static inline int
 hub_clear_tt_buffer (struct usb_device *hdev, u16 devinfo, u16 tt)
 {
-	return usb_control_msg(hdev, usb_rcvctrlpipe(hdev, 0),
+	return usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
 			       HUB_CLEAR_TT_BUFFER, USB_RT_PORT, devinfo,
 			       tt, NULL, 0, 1000);
 }
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -475,8 +475,20 @@ halt:
 			 * we must clear the TT buffer (11.17.5).
 			 */
 			if (unlikely(last_status != -EINPROGRESS &&
-					last_status != -EREMOTEIO))
-				ehci_clear_tt_buffer(ehci, qh, urb, token);
+					last_status != -EREMOTEIO)) {
+				/* The TT's in some hubs malfunction when they
+				 * receive this request following a STALL (they
+				 * stop sending isochronous packets).  Since a
+				 * STALL can't leave the TT buffer in a busy
+				 * state (if you believe Figures 11-48 - 11-51
+				 * in the USB 2.0 spec), we won't clear the TT
+				 * buffer in this case.  Strictly speaking this
+				 * is a violation of the spec.
+				 */
+				if (last_status != -EPIPE)
+					ehci_clear_tt_buffer(ehci, qh, urb,
+							token);
+			}
 		}
 
 		/* if we're removing something not at the queue head,


