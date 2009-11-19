Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZKSROr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZKSROr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZKSROq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:14:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61673 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZKSROq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:14:46 -0500
Message-ID: <4B057D09.4060207@tec-venture.de>
Date: Thu, 19 Nov 2009 18:14:49 +0100
From: Andre Herms <andre.herms@tec-venture.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] USB: usbtmc: repeat usb_bulk_msg until whole message is transfered
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18wsuxnCfLOvJ6SyqVxqWdXuOGB7k9SPgLcB57
 kCOB3+YN/osNbbS0nglPNBiM2LxLGAVBP1afO6FTVpUfwjlFlM
 m2bcCqxOPHU7/TX5q+aJER6zHOFDltL0V5IUVsZp0M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_bulk_msg() transfers only bytes up to the maximum packet size.
It must be repeated by the usbtmc driver until all bytes of a TMC message
are transfered.

Without this patch, ETIMEDOUT is reported when writing TMC messages
larger than the maximum USB bulk size and the transfer remains incomplete.
The user will notice that the device hangs and must be reset by either closing
the application or pulling the plug.

Signed-off-by: Andre Herms <andre.herms@tec-venture.de>
---
 drivers/usb/class/usbtmc.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 2473cf0..d9461c9 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -562,10 +562,16 @@ static ssize_t usbtmc_write(struct file *filp, const char __user *buf,
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
-- 
1.6.5.2

