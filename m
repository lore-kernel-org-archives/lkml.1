Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXJ2Iuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXJ2Iuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbXJ2IuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:50:07 -0400
Received: from ns120.gr8dns.org ([193.108.181.120]:41294 "EHLO mail.gr8dns.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbXJ2IuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:50:05 -0400
Date: Mon, 29 Oct 2007 01:49:17 -0700
From: Dirk Hohndel <hohndel@linux.intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from input_register_device
Message-ID: <20071029084917.GA12968@bigserver.hohndel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4725916A.7010505@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 03:53:14AM -0400, Jeff Garzik wrote:
>
>  You would also want to kfree(hidinput) on failure too.

Oops, of course. Thanks for catching that. Here's the updated patch

/D


[INPUT] hidinput_connect incorrectly ignored return value from input_register_device

Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>

---
 drivers/hid/hid-input.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index dd332f2..880161b 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1186,13 +1186,21 @@ int hidinput_connect(struct hid_device *hid)
 				 * UGCI) cram a lot of unrelated inputs into the
 				 * same interface. */
 				hidinput->report = report;
-				input_register_device(hidinput->input);
+				if (input_register_device(hidinput->input)) {
+					input_free_device(hidinput->input);
+					kfree(hidinput);
+					return -1;
+				}
 				hidinput = NULL;
 			}
 		}
 
 	if (hidinput)
-		input_register_device(hidinput->input);
+		if (input_register_device(hidinput->input)) {
+			input_free_device(hidinput->input);
+			kfree(hidinput);
+			return -1;
+		}
 
 	return 0;
 }
-- 
gitgui.0.8.4.g8d863


