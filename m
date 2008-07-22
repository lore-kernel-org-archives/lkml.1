Return-Path: <linux-kernel-owner+w=401wt.eu-S1761153AbYGVFtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153AbYGVFtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758157AbYGVFbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:31:25 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:8052 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854AbYGVFbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:31:23 -0400
Date: Mon, 21 Jul 2008 23:31:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -	device
 152d:2338
In-reply-to: <20080722051110.GA8303@notebook.homenet.local>
To: Tomas Styblo <tripie@cpan.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net,
       Alan Stern <stern@rowland.harvard.edu>
Message-id: <488570A5.8000602@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.eWQqoO1e4Mdhu8SK5jzMFAI/3NU@ifi.uio.no>
 <4884E585.2050104@shaw.ca> <20080722051110.GA8303@notebook.homenet.local>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Styblo wrote:
> * Robert Hancock <hancockr@shaw.ca> [Mon, 21 Jul 2008]:
>> I'm not sure this is a good approach. More that this code right above in 
>> usb_stor_invoke_transport, which your code undoes the effect of for this 
>> device, doesn't seem right:
>>
>> 	/* If things are really okay, then let's show that.  Zero
>> 	 * out the sense buffer so the higher layers won't realize
>> 	 * we did an unsolicited auto-sense. */
>> 	if (result == USB_STOR_TRANSPORT_GOOD &&
>> 		/* Filemark 0, ignore EOM, ILI 0, no sense */
>> 			(srb->sense_buffer[2] & 0xaf) == 0 &&
>> 		/* No ASC or ASCQ */
>> 			srb->sense_buffer[12] == 0 &&
>> 			srb->sense_buffer[13] == 0) {
>> 		srb->result = SAM_STAT_GOOD;
>> 		srb->sense_buffer[0] = 0x0;
>> 	}
>>
> 
> The patch doesn't exactly undo the effect of the code above,
> because the value of _result_ is different. When this problem

Yes, you and Alan are right, that code only triggers on a good result.

> happens, the condition above is false, _result_ is
> USB_STOR_TRANSPORT_FAILED and scsi_get_resid(srb) > 0, but the
> chipset doesn't report any error (NO_SENSE,ASC==0,ASCQ==0). That's
> why I think there's something wrong with the chipset. 

I'm assuming what triggers the transport failure is it getting a 
US_BULK_STAT_FAIL result from the transfer inside 
usb_stor_Bulk_transport. It could be there's some condition in the chip 
that causes that error, yet doesn't provide any sense data.

In any case, given that your code apparently fixes the corruption it 
seems that srb->result is being set to SAM_STAT_CHECK_CONDITION, but the 
DID_ERROR and SUGGEST_RETRY flags are not being set. Presumably then the 
  SCSI layer looks at the sense data and says "hmm, nothing to worry 
about here" and carries on.

I think we do need something like your patch, though it should likely be 
moved inside the if (need_auto_sense) check, and I don't see a reason to 
limit to this device ID only.

> 
> There are Windows users on various message boards who report the
> same problem with this chipset - a kind of silent data corruption
> that occurs only when copying large amounts of data.
> 
> But as I said I know little about SCSI and USB. I tried to locate
> and fix the problem, but I can't tell whether the current error
> handling code is written according to the relevant standards.
> 
> A more generic approach would certainly be better than hardcoded
> device ids. Perhaps this check should be enabled for all devices?
> Why not?


