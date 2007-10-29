Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbXJ2HSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbXJ2HSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbXJ2HSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:18:16 -0400
Received: from ns120.gr8dns.org ([193.108.181.120]:40419 "EHLO mail.gr8dns.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXJ2HSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:18:15 -0400
X-Greylist: delayed 1534 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 03:18:15 EDT
Date: Sun, 28 Oct 2007 23:51:53 -0700
From: Dirk Hohndel <hohndel@linux.intel.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] INPUT: fix hidinput_connect ignoring retval from input_register_device
Message-ID: <20071029065153.GA9490@bigserver.hohndel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[INPUT] hidinput_connect incorrectly ignored return value from input_register_device

Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>

---
 drivers/hid/hid-input.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index dd332f2..c8640e7 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1186,13 +1186,19 @@ int hidinput_connect(struct hid_device *hid)
 				 * UGCI) cram a lot of unrelated inputs into the
 				 * same interface. */
 				hidinput->report = report;
-				input_register_device(hidinput->input);
+				if (input_register_device(hidinput->input)) {
+					input_free_device(hidinput->input);
+					return -1;
+				}
 				hidinput = NULL;
 			}
 		}
 
 	if (hidinput)
-		input_register_device(hidinput->input);
+		if (input_register_device(hidinput->input)) {
+			input_free_device(hidinput->input);
+			return -1;
+		}
 
 	return 0;
 }
-- 
gitgui.0.8.4.g8d863

