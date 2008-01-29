Return-Path: <linux-kernel-owner+w=401wt.eu-S1765534AbYA2TRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765534AbYA2TRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYA2TRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:17:41 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40850 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbYA2TRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:17:40 -0500
Subject: Re: [BUG] 2.6.24-git usb reset problems
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <479F774B.60303@panasas.com>
References: <Pine.LNX.4.44L0.0801291032210.4229-100000@iolanthe.rowland.org>
	 <1201624455.3069.10.camel@localhost.localdomain>
	 <479F7009.3020306@panasas.com>
	 <1201632515.3069.28.camel@localhost.localdomain>
	 <479F774B.60303@panasas.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 14:17:20 -0500
Message-Id: <1201634240.3069.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 20:58 +0200, Boaz Harrosh wrote:
> > Your new code does
> > 
> > int partial; <- stack uninitialised
> > sb_stor_bulk_transfer_sglist(..., &partial, ...);
> > scsi_set_resid(srb, scsi_bufflen(srb) - partial);
> > 
> > If the function doesn't touch partial, as it doesn't in the error legs,
> > resid now gets set with rubbish.
> > 
> > Actually, my code is still wrong .. we have to set it to
> > scsi_bufflen(srb) - scsi_resid(srb) so that it comes back the same if
> > left untouched.
> > 
> >> I have such a device and I get one reset but then every thing works nice.
> >> This is with debug on. I'll try to make it fail.
> > 
> > James
> > 
> > 
> Sorry I still don't see it.
> 
> original code did sb_stor_bulk_transfer_sg(..., &srp->resid, ...)
> 
> but sb_stor_bulk_transfer_sg does the:
>  int partial; <- stack uninitialised
>  sb_stor_bulk_transfer_sglist(..., &partial, ...);
> 
> and then unconditionally sets *residual = length_left;
> I do not see an "error legs" case in sb_stor_bulk_transfer_sg().

This is really programming 101. This:

static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned
int pipe,
		struct scatterlist *sg, int num_sg, unsigned int length,
		unsigned int *act_len)
{
	int result;

	/* don't submit s-g requests during abort/disconnect processing */
	if (us->flags & ABORTING_OR_DISCONNECTING)
		return USB_STOR_XFER_ERROR;

The return USB_STOR_XFER_ERROR; is called an error leg.  It returns
without updating *act_len thus leaving &partial uninitialised.

James


