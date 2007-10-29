Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbXJ2XBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbXJ2XBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbXJ2XBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:01:46 -0400
Received: from ns120.gr8dns.org ([193.108.181.120]:58779 "EHLO mail.gr8dns.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbXJ2XBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:01:45 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 19:01:44 EDT
Date: Mon, 29 Oct 2007 15:50:51 -0700
From: Dirk Hohndel <hohndel@linux.intel.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Jeff Garzik <jeff@garzik.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from
	input_register_device
Message-ID: <20071029225051.GA1473@linux.intel.com>
References: <20071029152050.GA23411@bigserver.hohndel.org> <Pine.LNX.4.64.0710291827140.18815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710291827140.18815@twin.jikos.cz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry - mail config screwup caused this to bounce for the more restrictive
of the recipient addresses, including the mailing lists, so resending again]

On Mon, Oct 29, 2007 at 06:28:36PM +0100, Jiri Kosina wrote:                                                                                                                 
>                                                                                                                                                                            
> > Would something like this work?                                                                                                                                          
>                                                                                                                                                                            
> Yes, I think that this patch is in principle fine, modulo the redundant                                                                                                    
> NULL-ptr checks.                                                                                                                                                           
                                                                                                                                                                             
Thanks everyone with helping me to get this right! Which I hope this one is :-)                                                                                              
                                                                                                                                                                             
/D                                                                                                                                                                           


[PATCH] hidinput_connect ignores retval from input_register_device

signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>

---
 drivers/hid/hid-input.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index dd332f2..aa9b52d 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1152,7 +1152,7 @@ int hidinput_connect(struct hid_device *hid)
 					kfree(hidinput);
 					input_free_device(input_dev);
 					err_hid("Out of memory during hid input probe");
-					return -1;
+					goto out_unwind;
 				}
 
 				input_set_drvdata(input_dev, hid);
@@ -1186,15 +1186,25 @@ int hidinput_connect(struct hid_device *hid)
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
+		goto out_cleanup;
 
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

