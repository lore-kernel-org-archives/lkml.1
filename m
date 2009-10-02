Return-Path: <linux-kernel-owner+w=401wt.eu-S932328AbZJBBwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbZJBBwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbZJBBdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:15 -0400
Received: from kroah.org ([198.145.64.141]:33139 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbZJBBdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:13 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:14 2009
Message-Id: <20091002012414.565396768@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Hennerich <hennerich@blackfin.uclinux.org>
Subject: [054/136] USB: sl811-hcd: Fix device disconnect:
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-sl811-hcd-fix-device-disconnect.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hennerich, Michael <Michael.Hennerich@analog.com>

commit eb661bc88252e5c6dc69df732e77e42981dd4d8b upstream.

SL811 Device detected after removal used to be working in linux-2.6.22
but then broke somewhere between 2.6.22 and 2.6.28. Current
hub_port_connect_change() in drivers/usb/core/hub.c won't call
usb_disconnect() in case the SL811 driver sets portstatus
USB_PORT_FEAT_CONNECTION upon removal.
AFAIK the SL811 has only a combined Device Insert/Remove
detection bit, therefore use a count to distinguish insert or remove.


Signed-Off-By: Michael Hennerich <hennerich@blackfin.uclinux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/sl811-hcd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -719,8 +719,12 @@ retry:
 		/* port status seems weird until after reset, so
 		 * force the reset and make khubd clean up later.
 		 */
-		sl811->port1 |= (1 << USB_PORT_FEAT_C_CONNECTION)
-				| (1 << USB_PORT_FEAT_CONNECTION);
+		if (sl811->stat_insrmv & 1)
+			sl811->port1 |= 1 << USB_PORT_FEAT_CONNECTION;
+		else
+			sl811->port1 &= ~(1 << USB_PORT_FEAT_CONNECTION);
+
+		sl811->port1 |= 1 << USB_PORT_FEAT_C_CONNECTION;
 
 	} else if (irqstat & SL11H_INTMASK_RD) {
 		if (sl811->port1 & (1 << USB_PORT_FEAT_SUSPEND)) {


