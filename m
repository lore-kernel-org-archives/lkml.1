Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbZBDSov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbZBDSov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758160AbZBDShZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:25 -0500
Received: from kroah.org ([198.145.64.141]:51099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754529AbZBDShS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:18 -0500
Date: Wed, 4 Feb 2009 10:34:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
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
       alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes@sipsolutions.net>,
       linville@tuxdriver.com, Larry.Finger@lwfinger.net,
       Christian Lamparter <chunkeey@web.de>
Subject: [patch 21/33] p54: fix lm87 checksum endianness
Message-ID: <20090204183457.GV13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="p54-fix-lm87-checksum-endianness.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit c91276592695e13d1b52eab572551017cbf96ee7 upstream

This fixes the checksum calculation for lm87 firmwares
on big endian platforms, the device treats the data as
an array of 32-bit little endian values so the driver
needs to do that as well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Christian Lamparter <chunkeey@web.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

---
 drivers/net/wireless/p54/p54usb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -222,13 +222,13 @@ static void p54u_tx_3887(struct ieee8021
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 
-static __le32 p54u_lm87_chksum(const u32 *data, size_t length)
+static __le32 p54u_lm87_chksum(const __le32 *data, size_t length)
 {
 	u32 chk = 0;
 
 	length >>= 2;
 	while (length--) {
-		chk ^= *data++;
+		chk ^= le32_to_cpu(*data++);
 		chk = (chk >> 5) ^ (chk << 3);
 	}
 
@@ -247,7 +247,7 @@ static void p54u_tx_lm87(struct ieee8021
 	if (!data_urb)
 		return;
 
-	hdr->chksum = p54u_lm87_chksum((u32 *)data, len);
+	hdr->chksum = p54u_lm87_chksum((__le32 *) data, len);
 	hdr->device_addr = data->req_id;
 
 	usb_fill_bulk_urb(data_urb, priv->udev,

