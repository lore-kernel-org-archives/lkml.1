Return-Path: <linux-kernel-owner+w=401wt.eu-S1761860AbZAWBX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761860AbZAWBX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbZAWBPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:22 -0500
Received: from kroah.org ([198.145.64.141]:50664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755943AbZAWBPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:05 -0500
Date: Thu, 22 Jan 2009 17:12:26 -0800
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
       alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
       Linux wireless <linux-wireless@vger.kernel.org>,
       Christian Lamparter <chunkeey@web.de>
Subject: [patch 27/46] p54usb: fix traffic stalls / packet drop
Message-ID: <20090123011226.GB19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="p54usb-fix-traffic-stalls-packet-drop.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@web.de>

commit 00627f229c9807e4cb825a7ce36b886e2adf2229 upstream.

All p54usb devices need a explicit termination packet, in oder to finish the pending transfer properly.
Else, the firmware could freeze, or simply drop the frame.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54usb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -215,6 +215,8 @@ static void p54u_tx_3887(struct ieee8021
 	usb_fill_bulk_urb(data_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), data, len,
 		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+	addr_urb->transfer_flags |= URB_ZERO_PACKET;
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_submit_urb(addr_urb, GFP_ATOMIC);
 	usb_submit_urb(data_urb, GFP_ATOMIC);
@@ -252,6 +254,7 @@ static void p54u_tx_lm87(struct ieee8021
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr,
 		len + sizeof(*hdr), free_on_tx ? p54u_tx_free_cb : p54u_tx_cb,
 		dev);
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
@@ -294,11 +297,13 @@ static void p54u_tx_net2280(struct ieee8
 	usb_fill_bulk_urb(int_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
 		p54u_tx_free_cb, dev);
+	int_urb->transfer_flags |= URB_ZERO_PACKET;
 	usb_submit_urb(int_urb, GFP_ATOMIC);
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr, len + sizeof(*hdr),
 		free_on_tx ? p54u_tx_free_cb : p54u_tx_cb, dev);
+	data_urb->transfer_flags |= URB_ZERO_PACKET;
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 

