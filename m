Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbYBNPQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbYBNPQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbYBNPQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:16:36 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:57975 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759469AbYBNPQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:16:33 -0500
Date: Thu, 14 Feb 2008 16:16:31 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: jkosina@suse.cz, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/6] drivers/hid: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.58.0802141616120.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c 2007-11-08 18:33:32.000000000 +0100
+++ b/drivers/hid/usbhid/hid-core.c 2008-02-13 20:51:00.000000000 +0100
@@ -278,7 +278,7 @@ static int hid_submit_ctrl(struct hid_de
 		usbhid->urbctrl->pipe = usb_rcvctrlpipe(hid_to_usb_dev(hid), 0);
 		maxpacket = usb_maxpacket(hid_to_usb_dev(hid), usbhid->urbctrl->pipe, 0);
 		if (maxpacket > 0) {
-			padlen = (len + maxpacket - 1) / maxpacket;
+			padlen = DIV_ROUND_UP(len, maxpacket);
 			padlen *= maxpacket;
 			if (padlen > usbhid->bufsize)
 				padlen = usbhid->bufsize;
