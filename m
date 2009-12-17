Return-Path: <linux-kernel-owner+w=401wt.eu-S1761661AbZLQBnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661AbZLQBnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936074AbZLQBnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:43:23 -0500
Received: from kroah.org ([198.145.64.141]:47820 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763092AbZLQBUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:06 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:01 2009
Message-Id: <20091217011601.125726102@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andre Herms <andre.herms@tec-venture.de>
Subject: [25/90] USB: usbtmc: repeat usb_bulk_msg until whole message is transfered
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andre Herms <andre.herms@tec-venture.de>

commit ec412b92dbe3ea839716853eea058d1bcc5e6ca4 upstream.

usb_bulk_msg() transfers only bytes up to the maximum packet size.
It must be repeated by the usbtmc driver until all bytes of a TMC message
are transfered.

Without this patch, ETIMEDOUT is reported when writing TMC messages
larger than the maximum USB bulk size and the transfer remains incomplete.
The user will notice that the device hangs and must be reset by either closing
the application or pulling the plug.

Signed-off-by: Andre Herms <andre.herms@tec-venture.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/usbtmc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -545,10 +545,16 @@ static ssize_t usbtmc_write(struct file 
 		n_bytes = roundup(12 + this_part, 4);
 		memset(buffer + 12 + this_part, 0, n_bytes - (12 + this_part));
 
-		retval = usb_bulk_msg(data->usb_dev,
-				      usb_sndbulkpipe(data->usb_dev,
-						      data->bulk_out),
-				      buffer, n_bytes, &actual, USBTMC_TIMEOUT);
+		do {
+			retval = usb_bulk_msg(data->usb_dev,
+					      usb_sndbulkpipe(data->usb_dev,
+							      data->bulk_out),
+					      buffer, n_bytes,
+					      &actual, USBTMC_TIMEOUT);
+			if (retval != 0)
+				break;
+			n_bytes -= actual;
+		} while (n_bytes);
 
 		data->bTag_last_write = data->bTag;
 		data->bTag++;


