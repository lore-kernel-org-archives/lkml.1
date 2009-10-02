Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZJBBxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZJBBxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZJBBdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:14 -0400
Received: from kroah.org ([198.145.64.141]:33134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbZJBBdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:14 2009
Message-Id: <20091002012414.379059249@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Guus Sliepen <guus@sliepen.org>
Subject: [053/136] USB: usbtmc: sanity checks for DEV_DEP_MSG_IN urbs
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-usbtmc-sanity-checks-for-dev_dep_msg_in-urbs.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Guus Sliepen <guus@sliepen.org>

commit 665d7662d15441b4b3e54131a9418a1a198d0d31 upstream.

According to the specifications, an instrument should not return more data in a
DEV_DEP_MSG_IN urb than requested.  However, some instruments can send more
than requested. This could cause the kernel to write the extra data past the
end of the buffer provided by read().

Fix this by checking that the value of the TranserSize field is not larger than
the urb itself and not larger than the size of the userspace buffer. Also
correctly decrement the remaining size of the buffer when userspace read()s
more than USBTMC_SIZE_IOBUFFER.

Signed-off-by: Guus Sliepen <guus@sliepen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/usbtmc.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -367,13 +367,13 @@ static ssize_t usbtmc_read(struct file *
 {
 	struct usbtmc_device_data *data;
 	struct device *dev;
-	unsigned long int n_characters;
+	u32 n_characters;
 	u8 *buffer;
 	int actual;
-	int done;
-	int remaining;
+	size_t done;
+	size_t remaining;
 	int retval;
-	int this_part;
+	size_t this_part;
 
 	/* Get pointer to private data structure */
 	data = filp->private_data;
@@ -455,6 +455,18 @@ static ssize_t usbtmc_read(struct file *
 			       (buffer[6] << 16) +
 			       (buffer[7] << 24);
 
+		/* Ensure the instrument doesn't lie about it */
+		if(n_characters > actual - 12) {
+			dev_err(dev, "Device lies about message size: %zu > %zu\n", n_characters, actual - 12);
+			n_characters = actual - 12;
+		}
+
+		/* Ensure the instrument doesn't send more back than requested */
+		if(n_characters > this_part) {
+			dev_err(dev, "Device returns more than requested: %zu > %zu\n", done + n_characters, done + this_part);
+			n_characters = this_part;
+		}
+
 		/* Copy buffer to user space */
 		if (copy_to_user(buf + done, &buffer[12], n_characters)) {
 			/* There must have been an addressing problem */
@@ -465,6 +477,8 @@ static ssize_t usbtmc_read(struct file *
 		done += n_characters;
 		if (n_characters < USBTMC_SIZE_IOBUFFER)
 			remaining = 0;
+		else
+			remaining -= n_characters;
 	}
 
 	/* Update file position value */


