Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZKUP03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZKUP03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZKUPRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:17:25 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:39188 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbZKUPRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:17:24 -0500
Message-ID: <4B080222.50403@simon.arlott.org.uk>
Date: Sat, 21 Nov 2009 15:07:14 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/8] cxacru: check data length is not negative
References: <4B08013B.90403@simon.arlott.org.uk>
In-Reply-To: <4B08013B.90403@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attempting to read data that is not actually
an array of values, the length may be negative
which causes an Oops due to a likely access off
the end of the data array.

This bug should not occur under normal use unless
the device returns an invalid response.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 4a26a6c..8da4a06 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -596,7 +596,7 @@ static int cxacru_cm_get_array(struct cxacru_data *instance, enum cxacru_cm_requ
 	len = ret / 4;
 	for (offb = 0; offb < len; ) {
 		int l = le32_to_cpu(buf[offb++]);
-		if (l > stride || l > (len - offb) / 2) {
+		if (l < 0 || l > stride || l > (len - offb) / 2) {
 			if (printk_ratelimit())
 				usb_err(instance->usbatm, "invalid data length from cm %#x: %d\n",
 					cm, l);
-- 
1.6.3.3

-- 
Simon Arlott

