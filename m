Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZJKQRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZJKQRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 12:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbZJKQRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 12:17:20 -0400
Received: from mail.pc-doctor.com ([66.224.119.10]:59216 "EHLO
	mail.pc-doctor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbZJKQRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 12:17:19 -0400
Date: Sun, 11 Oct 2009 09:16:38 -0700 (PDT)
From: Ben Efros <ben@pc-doctor.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josua Dietze <digidietze@draisberghof.de>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-ID: <7550119.564321255277798089.JavaMail.root@mail.pc-doctor.com>
In-Reply-To: <26767470.564301255277612694.JavaMail.root@mail.pc-doctor.com>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.148.190.25]
X-Mailer: Zimbra 5.0.18_GA_3011.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3011.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Alan Stern" <stern@rowland.harvard.edu> wrote:
> On Sun, 11 Oct 2009, Benjamin Herrenschmidt wrote:
> 
> > 
> > > Further REQUEST SENSE commands therefore requested 96 bytes of
> data
> > > instead of the standard 18 bytes.  With LUN 0 this worked okay. 
> But 
> > > with LUN 1 it didn't; the device reported a failure of the REQUEST
> 
> > > SENSE.  This is what caused usb-storage to issue the device
> reset.
> > > 
> > > After the reset usb-storage continued to ask for 96 bytes of
> sense
> > > data, and LUN 1 continued to fail the commands.  Hence the
> repeated
> > > resets.
> > 
> > Maybe a better approach would be to go back to 18 bytes when it
> fails,
> > what do you think ?
> 
> We certainly could do that.  But should we turn off the SANE_SENSE
> flag 
> at the same time?

No I don't think its a good idea to turn off SANE_SENSE in this situation.  Here is a patch similar to Ben Herrenschmidt's but will not turn off SANE_SENSE just because a transport failure.


Retry with short sense when SANE_SENSE fails.

 Signed-off-by: Ben Efros <ben@pc-doctor.com>

--- linux-2.6.31.1/drivers/usb/storage/transport.c        2009-09-24 08:45:25.000000000 -0700
+++ linux-2.6.31.1.new/drivers/usb/storage/transport.c        2009-10-11 08:06:26.000000000 -0700
@@ -696,7 +696,7 @@ void usb_stor_invoke_transport(struct sc
                 /* device supports and needs bigger sense buffer */
                 if (us->fflags & US_FL_SANE_SENSE)
                         sense_size = ~0;
-
+Retry_Sense:
                 US_DEBUGP("Issuing auto-REQUEST_SENSE\n");
 
                 scsi_eh_prep_cmnd(srb, &ses, NULL, 0, sense_size);
@@ -723,6 +723,12 @@ void usb_stor_invoke_transport(struct sc
                 if (temp_result != USB_STOR_TRANSPORT_GOOD) {
                         US_DEBUGP("-- auto-sense failure\n");
 
+                        if ((us->fflags & US_FL_SANE_SENSE) &&
+                            sense_size != US_SENSE_SIZE) {
+                                sense_size = US_SENSE_SIZE;
+                                US_DEBUGP("-- retry without SANE_SENSE\n");
+                                goto Retry_Sense;
+                        }
                         /* we skip the reset if this happens to be a
                          * multi-target device, since failure of an
                          * auto-sense is perfectly valid


