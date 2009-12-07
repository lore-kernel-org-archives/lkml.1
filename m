Return-Path: <linux-kernel-owner+w=401wt.eu-S934515AbZLGA35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515AbZLGA35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934448AbZLGA3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:29:48 -0500
Received: from kroah.org ([198.145.64.141]:34367 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758429AbZLGANB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:47 2009
Message-Id: <20091207000647.094897781@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Pete Zaitcev <zaitcev@redhat.com>
Subject: [042/119] USB: usbmon: fix bug in mon_buff_area_shrink
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=usb-usbmon-fix-bug-in-mon_buff_area_shrink.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit fca94748c5136ff390eadc443871b82f1f77dcd6 upstream.

This patch (as1299b) fixes a bug in an error-handling path of usbmon's
binary interface.  The storage area for URB data is divided into
fixed-size blocks.  If an URB's data can't be copied, the area
reserved for it should be decreased to the size of the truncated
information (rounded up to a block boundary).  Rounding up the amount
to be removed and subtracting it from the reserved size is definitely
the wrong thing to do.

Also, when the data for an isochronous URB can't be copied, we can
still copy the isoc packet descriptors.  In fact the current code does
copy the descriptors, but then sets the capture length to 0 so they
remain inaccessible.  The capture length should be reduced to the
length of the descriptors, not set to 0.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/mon/mon_bin.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -350,12 +350,12 @@ static unsigned int mon_buff_area_alloc_
 
 /*
  * Return a few (kilo-)bytes to the head of the buffer.
- * This is used if a DMA fetch fails.
+ * This is used if a data fetch fails.
  */
 static void mon_buff_area_shrink(struct mon_reader_bin *rp, unsigned int size)
 {
 
-	size = (size + PKT_ALIGN-1) & ~(PKT_ALIGN-1);
+	/* size &= ~(PKT_ALIGN-1);  -- we're called with aligned size */
 	rp->b_cnt -= size;
 	if (rp->b_in < size)
 		rp->b_in += rp->b_size;
@@ -442,6 +442,7 @@ static void mon_bin_event(struct mon_rea
 	unsigned int urb_length;
 	unsigned int offset;
 	unsigned int length;
+	unsigned int delta;
 	unsigned int ndesc, lendesc;
 	unsigned char dir;
 	struct mon_bin_hdr *ep;
@@ -546,8 +547,10 @@ static void mon_bin_event(struct mon_rea
 	if (length != 0) {
 		ep->flag_data = mon_bin_get_data(rp, offset, urb, length);
 		if (ep->flag_data != 0) {	/* Yes, it's 0x00, not '0' */
-			ep->len_cap = 0;
-			mon_buff_area_shrink(rp, length);
+			delta = (ep->len_cap + PKT_ALIGN-1) & ~(PKT_ALIGN-1);
+			ep->len_cap -= length;
+			delta -= (ep->len_cap + PKT_ALIGN-1) & ~(PKT_ALIGN-1);
+			mon_buff_area_shrink(rp, delta);
 		}
 	} else {
 		ep->flag_data = data_tag;


