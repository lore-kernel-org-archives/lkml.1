Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbXJ2PVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbXJ2PVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXJ2PVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:21:39 -0400
Received: from ns120.gr8dns.org ([193.108.181.120]:48074 "EHLO mail.gr8dns.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbXJ2PVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:21:38 -0400
Date: Mon, 29 Oct 2007 08:20:50 -0700
From: Dirk Hohndel <hohndel@linux.intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jikos@jikos.cz>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from input_register_device
Message-ID: <20071029152050.GA23411@bigserver.hohndel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4725F2DF.1060500@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 10:49:03AM -0400, Jeff Garzik wrote:
>  Dmitry Torokhov wrote:
> > On 10/29/07, Jiri Kosina <jikos@jikos.cz> wrote:
> >> On Mon, 29 Oct 2007, Dirk Hohndel wrote:
> >>
> >>> [INPUT] hidinput_connect incorrectly ignored return value from
> >>> input_register_device
> >>> Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>
> >> Will apply
> > Please don't - the fix is completely broken for multi-input devices -
> > if 2nd device fails to register we bail out of hidinput_connect and
> > thus never set HID_CLAIMED_INPUT bit. So when we disconnect device we
> > never call hidinput_disconnect and who knows what will happen after
> > that.
> > hidinput_connect() should properly unwind already registered devices
> > after failure.
> 
>  Then the existing code to handle hidinput and input_dev allocation failure 
>  probably also wants fixing...  Dirk's patch was largely following the same 
>  logic.

I was wondering about that. If I didn't get lost in the structures again, I
think it isn't too hard to simply call out directly to hidinput_disconnect to
do the cleanup / unwind; the &hid->inputs should contain those devices that
have successfully been registered before we failed. 

Actually, the more I look at the code that bails when it runs out of memory,
the more I wonder about that.

	hidinput = kzalloc(sizeof(*hidinput), GFP_KERNEL);
	input_dev = input_allocate_device();
	if (!hidinput || !input_dev) {
		kfree(hidinput);
		input_free_device(input_dev);

This either passes a NULL pointer to kfree or to input_free_device. That's
not nice.

Would something like this work?

[PATCH] hidinput_connect ignores retval from input_register_device

Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>

---
 drivers/hid/hid-input.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index dd332f2..5bff5cc 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1149,10 +1149,12 @@ int hidinput_connect(struct hid_device *hid)
 				hidinput = kzalloc(sizeof(*hidinput), GFP_KERNEL);
 				input_dev = input_allocate_device();
 				if (!hidinput || !input_dev) {
-					kfree(hidinput);
-					input_free_device(input_dev);
+					if (hidinput)
+						kfree(hidinput);
+					if (input_dev)
+						input_free_device(input_dev);
 					err_hid("Out of memory during hid input probe");
-					return -1;
+					goto out_unwind;
 				}
 
 				input_set_drvdata(input_dev, hid);
@@ -1186,15 +1188,25 @@ int hidinput_connect(struct hid_device *hid)
 				 * UGCI) cram a lot of unrelated inputs into the
 				 * same interface. */
 				hidinput->report = report;
-				input_register_device(hidinput->input);
+				if (input_register_device(hidinput->input))
+					goto out_cleanup;
 				hidinput = NULL;
 			}
 		}
 
-	if (hidinput)
-		input_register_device(hidinput->input);
+	if (hidinput && input_register_device(hidinput->input))
+			goto out_cleanup;
 
 	return 0;
+
+out_cleanup:
+	input_free_device(hidinput->input);
+	kfree(hidinput);
+out_unwind:
+	/* unwind the ones we already registered */
+	hidinput_disconnect(hid);
+
+	return -1;
 }
 EXPORT_SYMBOL_GPL(hidinput_connect);
 
-- 
gitgui.0.8.4.g8d863

