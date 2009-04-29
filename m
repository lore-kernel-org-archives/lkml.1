Return-Path: <linux-kernel-owner+w=401wt.eu-S1761644AbZD2WZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644AbZD2WZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbZD2WVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:17 -0400
Received: from kroah.org ([198.145.64.141]:40285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757924AbZD2WVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:24 2009
Message-Id: <20090429220924.343650646@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:10 -0700
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
       alan@lxorguk.ukuu.org.uk, Tilman Schmidt <tilman@imap.cc>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/58] bas_gigaset: correctly allocate USB interrupt transfer buffer
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=bas_gigaset-correctly-allocate-usb-interrupt-transfer-buffer.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

[ Upstream commit 170ebf85160dd128e1c4206cc197cce7d1424705 ]

Every USB transfer buffer has to be allocated individually by kmalloc.

Impact: bugfix, no functional change

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Tested-by: Kolja Waschk <kawk@users.sourceforge.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/bas-gigaset.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -46,6 +46,9 @@ MODULE_PARM_DESC(cidmode, "Call-ID mode"
 /* length limit according to Siemens 3070usb-protokoll.doc ch. 2.1 */
 #define IF_WRITEBUF 264
 
+/* interrupt pipe message size according to ibid. ch. 2.2 */
+#define IP_MSGSIZE 3
+
 /* Values for the Gigaset 307x */
 #define USB_GIGA_VENDOR_ID      0x0681
 #define USB_3070_PRODUCT_ID     0x0001
@@ -110,7 +113,7 @@ struct bas_cardstate {
 	unsigned char		*rcvbuf;	/* AT reply receive buffer */
 
 	struct urb		*urb_int_in;	/* URB for interrupt pipe */
-	unsigned char		int_in_buf[3];
+	unsigned char		*int_in_buf;
 
 	spinlock_t		lock;		/* locks all following */
 	int			basstate;	/* bitmap (BS_*) */
@@ -657,7 +660,7 @@ static void read_int_callback(struct urb
 	}
 
 	/* drop incomplete packets even if the missing bytes wouldn't matter */
-	if (unlikely(urb->actual_length < 3)) {
+	if (unlikely(urb->actual_length < IP_MSGSIZE)) {
 		dev_warn(cs->dev, "incomplete interrupt packet (%d bytes)\n",
 			 urb->actual_length);
 		goto resubmit;
@@ -2127,6 +2130,7 @@ static void gigaset_reinitbcshw(struct b
 static void gigaset_freecshw(struct cardstate *cs)
 {
 	/* timers, URBs and rcvbuf are disposed of in disconnect */
+	kfree(cs->hw.bas->int_in_buf);
 	kfree(cs->hw.bas);
 	cs->hw.bas = NULL;
 }
@@ -2232,6 +2236,12 @@ static int gigaset_probe(struct usb_inte
 		}
 		hostif = interface->cur_altsetting;
 	}
+	ucs->int_in_buf = kmalloc(IP_MSGSIZE, GFP_KERNEL);
+	if (!ucs->int_in_buf) {
+		kfree(ucs);
+		pr_err("out of memory\n");
+		return 0;
+	}
 
 	/* Reject application specific interfaces
 	 */
@@ -2290,7 +2300,7 @@ static int gigaset_probe(struct usb_inte
 	usb_fill_int_urb(ucs->urb_int_in, udev,
 			 usb_rcvintpipe(udev,
 					(endpoint->bEndpointAddress) & 0x0f),
-			 ucs->int_in_buf, 3, read_int_callback, cs,
+			 ucs->int_in_buf, IP_MSGSIZE, read_int_callback, cs,
 			 endpoint->bInterval);
 	if ((rc = usb_submit_urb(ucs->urb_int_in, GFP_KERNEL)) != 0) {
 		dev_err(cs->dev, "could not submit interrupt URB: %s\n",


