Return-Path: <linux-kernel-owner+w=401wt.eu-S1764588AbYA2Pgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764588AbYA2Pgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbYA2PgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:36:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55843 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752565AbYA2PgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:36:20 -0500
Date: Tue, 29 Jan 2008 10:36:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
In-Reply-To: <479F18D3.9030709@panasas.com>
Message-ID: <Pine.LNX.4.44L0.0801291032210.4229-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Boaz Harrosh wrote:

> --- a/drivers/usb/storage/transport.c
> +++ b/drivers/usb/storage/transport.c
> @@ -462,18 +462,24 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
>   * Common used function. Transfer a complete command
>   * via usb_stor_bulk_transfer_sglist() above. Set cmnd resid
>   */
> -int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
> -		      struct scsi_cmnd* srb)
> +int usb_stor_bulk_srb_length(struct us_data* us, unsigned int pipe,
> +		      struct scsi_cmnd* srb, unsigned length)
>  {
>  	unsigned int partial;
>  	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
> -				      scsi_sg_count(srb), scsi_bufflen(srb),
> +				      scsi_sg_count(srb), length,
>  				      &partial);
>  
>  	scsi_set_resid(srb, scsi_bufflen(srb) - partial);
>  	return result;
>  }
>  
> +int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
> +		struct scsi_cmnd* srb)
> +{
> +	return usb_stor_bulk_srb_length(us, pipe, srb, scsi_bufflen(srb));
> +}
> +

I don't like this patch very much.  Why add another layer of 
indirection when the two subroutines do hardly any work?  Leave 
usb_stor_bulk_srb() the way it was, and add usb_stor_bulk_srb_length() 
as a separate routine that simply calls usb_stor_bulk_transfer_sglist() 
and scsi_set_resid().

BTW, the standard coding style calls for a blank line after the list of 
local variables at the start of a function or block.

Alan Stern

