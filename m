Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbYA2TaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbYA2TaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYA2TaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:30:00 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:43628 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbYA2T36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:29:58 -0500
Message-ID: <479F7E79.1040301@panasas.com>
Date: Tue, 29 Jan 2008 21:28:57 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
References: <Pine.LNX.4.44L0.0801291032210.4229-100000@iolanthe.rowland.org>	 <1201624455.3069.10.camel@localhost.localdomain>	 <479F7009.3020306@panasas.com>	 <1201632515.3069.28.camel@localhost.localdomain>	 <479F774B.60303@panasas.com> <1201634240.3069.33.camel@localhost.localdomain>
In-Reply-To: <1201634240.3069.33.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008 at 21:17 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2008-01-29 at 20:58 +0200, Boaz Harrosh wrote:
>>> Your new code does
>>>
>>> int partial; <- stack uninitialised
>>> sb_stor_bulk_transfer_sglist(..., &partial, ...);
>>> scsi_set_resid(srb, scsi_bufflen(srb) - partial);
>>>
>>> If the function doesn't touch partial, as it doesn't in the error legs,
>>> resid now gets set with rubbish.
>>>
>>> Actually, my code is still wrong .. we have to set it to
>>> scsi_bufflen(srb) - scsi_resid(srb) so that it comes back the same if
>>> left untouched.
>>>
>>>> I have such a device and I get one reset but then every thing works nice.
>>>> This is with debug on. I'll try to make it fail.
>>> James
>>>
>>>
>> Sorry I still don't see it.
>>
>> original code did sb_stor_bulk_transfer_sg(..., &srp->resid, ...)
>>
>> but sb_stor_bulk_transfer_sg does the:
>>  int partial; <- stack uninitialised
>>  sb_stor_bulk_transfer_sglist(..., &partial, ...);
>>
>> and then unconditionally sets *residual = length_left;
>> I do not see an "error legs" case in sb_stor_bulk_transfer_sg().
> 
> This is really programming 101. This:
> 
> static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned
> int pipe,
> 		struct scatterlist *sg, int num_sg, unsigned int length,
> 		unsigned int *act_len)
> {
> 	int result;
> 
> 	/* don't submit s-g requests during abort/disconnect processing */
> 	if (us->flags & ABORTING_OR_DISCONNECTING)
> 		return USB_STOR_XFER_ERROR;
> 
> The return USB_STOR_XFER_ERROR; is called an error leg.  It returns
> without updating *act_len thus leaving &partial uninitialised.
> 
> James
> 
Yes you are right this is a bug, but it is a bug that was there before.
perhaps the stack is just different now then what it used to be.

Jens could you please try that:

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index d9f4912..b18a5e6 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -465,7 +465,7 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
 int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
 		      struct scsi_cmnd* srb)
 {
-	unsigned int partial;
+	unsigned int partial = 0;
 	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
 				      scsi_sg_count(srb), scsi_bufflen(srb),
 				      &partial);

