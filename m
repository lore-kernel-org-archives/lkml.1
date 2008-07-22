Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbYGVFLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbYGVFLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYGVFLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:11:14 -0400
Received: from li26-190.members.linode.com ([67.18.89.190]:50489 "EHLO
	notebook.homenet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756027AbYGVFLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:11:12 -0400
Date: Tue, 22 Jul 2008 07:11:10 +0200
From: Tomas Styblo <tripie@cpan.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -
	device 152d:2338
Message-ID: <20080722051110.GA8303@notebook.homenet.local>
References: <fa.eWQqoO1e4Mdhu8SK5jzMFAI/3NU@ifi.uio.no> <4884E585.2050104@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4884E585.2050104@shaw.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Robert Hancock <hancockr@shaw.ca> [Mon, 21 Jul 2008]:
>
> I'm not sure this is a good approach. More that this code right above in 
> usb_stor_invoke_transport, which your code undoes the effect of for this 
> device, doesn't seem right:
>
> 	/* If things are really okay, then let's show that.  Zero
> 	 * out the sense buffer so the higher layers won't realize
> 	 * we did an unsolicited auto-sense. */
> 	if (result == USB_STOR_TRANSPORT_GOOD &&
> 		/* Filemark 0, ignore EOM, ILI 0, no sense */
> 			(srb->sense_buffer[2] & 0xaf) == 0 &&
> 		/* No ASC or ASCQ */
> 			srb->sense_buffer[12] == 0 &&
> 			srb->sense_buffer[13] == 0) {
> 		srb->result = SAM_STAT_GOOD;
> 		srb->sense_buffer[0] = 0x0;
> 	}
>

The patch doesn't exactly undo the effect of the code above,
because the value of _result_ is different. When this problem
happens, the condition above is false, _result_ is
USB_STOR_TRANSPORT_FAILED and scsi_get_resid(srb) > 0, but the
chipset doesn't report any error (NO_SENSE,ASC==0,ASCQ==0). That's
why I think there's something wrong with the chipset. 

There are Windows users on various message boards who report the
same problem with this chipset - a kind of silent data corruption
that occurs only when copying large amounts of data.

But as I said I know little about SCSI and USB. I tried to locate
and fix the problem, but I can't tell whether the current error
handling code is written according to the relevant standards.

A more generic approach would certainly be better than hardcoded
device ids. Perhaps this check should be enabled for all devices?
Why not?



-- 
Tomas Styblo <tripie@cpan.org>
