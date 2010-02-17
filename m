Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0BQKnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:43:00 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:45632 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0BQKm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:42:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ld8vL/1w1pL/RQ6TpOZoJ42W5rnNitQ0j5cxOOdB0CJ0EGbWyMA1i8C0IHsxxsPJ5Z
         qXBqHWLKpEQWUcbQM+p4YlRz2VTWflchpcZS4tAv6bqBjc8NwO4cJwWc11bCMdxXV5GM
         5uztqZiG3nCZSgLXAPwCybsSv4P/dNZi/jKSM=
Message-ID: <4B7BC9F2.6050703@gmail.com>
Date: Wed, 17 Feb 2010 11:50:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Joe Perches <joe@perches.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: misplaced parenthesis
References: <Pine.LNX.4.44L0.1002161047240.1716-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002161047240.1716-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a misplaced parenthesis the usbat_write_block() return value was not
stored, but a boolean. USB_STOR_TRANSPORT_NO_SENSE and USB_STOR_TRANSPORT_ERROR
were returned as USB_STOR_TRANSPORT_FAILED.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>> in drivers/usb/storage/transport.h line 100 note the definitions:
>>
>> #define USB_STOR_TRANSPORT_GOOD    0   /* Transport good, command good     */
>> #define USB_STOR_TRANSPORT_FAILED  1   /* Transport good, command failed   */
>> #define USB_STOR_TRANSPORT_NO_SENSE 2  /* Command failed, no auto-sense    */
>> #define USB_STOR_TRANSPORT_ERROR   3   /* Transport bad (i.e. device dead) */

> It seems pretty clear that your patch was correct and the parens were 
> misplaced.  In usb-storage, transport routines like 
> usbat_hp8200e_transport() are supposed to return one of the 
> USB_STOR_TRANSPORT_* codes, not a Boolean value.
> 
> I do agree with Joe that it would be better form to separate the 
> function call and the "if" into two statements, as in your second 
> version above.

Ok, thanks for comments, This should fix and separate the assignment as desired.

Roel

diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index b62a288..bd3f415 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -1628,10 +1628,10 @@ static int usbat_hp8200e_transport(struct scsi_cmnd *srb, struct us_data *us)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	if ( (result = usbat_multiple_write(us, 
-			registers, data, 7)) != USB_STOR_TRANSPORT_GOOD) {
+	result = usbat_multiple_write(us, registers, data, 7);
+
+	if (result != USB_STOR_TRANSPORT_GOOD)
 		return result;
-	}
 
 	/*
 	 * Write the 12-byte command header.
@@ -1643,12 +1643,11 @@ static int usbat_hp8200e_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * AT SPEED 4 IS UNRELIABLE!!!
 	 */
 
-	if ((result = usbat_write_block(us,
-			USBAT_ATA, srb->cmnd, 12,
-				(srb->cmnd[0]==GPCMD_BLANK ? 75 : 10), 0) !=
-			     USB_STOR_TRANSPORT_GOOD)) {
+	result = usbat_write_block(us, USBAT_ATA, srb->cmnd, 12,
+				   srb->cmnd[0] == GPCMD_BLANK ? 75 : 10, 0);
+
+	if (result != USB_STOR_TRANSPORT_GOOD)
 		return result;
-	}
 
 	/* If there is response data to be read in then do it here. */
 

