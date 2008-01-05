Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYAEPnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYAEPnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYAEPm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:42:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:53283 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbYAEPm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=n0CNNCXUDn83ESdhhnI0Up5Dp0tUlFTtCz98JgngYK7Tb0SJ6egBRjYGOp7d9BeZ/Ecnr0+DhkZ7G+hTzzSEmHgWmhSfkTnU1btROseZ0gxVjwURK8mvQAYx/Uk/SERp+pB8Wbh5OovyG5zjp2a7smt7cG55nggUWtGu+iknx1A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [RESEND PATCH 08/10] ide-floppy: mv idefloppy_{should_,}report_error
Date: Sat, 5 Jan 2008 16:54:23 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-8-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-9-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1199366409-26016-9-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801051654.23662.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-floppy.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 2c139e7..fd5fe7b 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -544,7 +544,7 @@ static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
>  }
>  
>  /* Supresses error messages resulting from Medium not present */
> -static inline int idefloppy_should_report_error(idefloppy_t *floppy)
> +static inline int idefloppy_report_error(idefloppy_t *floppy)

wait, this function does indeed check if it _should_ report the error
(it doesn't report it itself)... however...

>  {
>  	if (floppy->sense_key == 0x02 &&
>  	    floppy->asc       == 0x3a &&
> @@ -587,7 +587,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive, idefloppy_pc_t *pc
>  		 */
>  		if (!test_bit(PC_ABORT, &pc->flags)) {
>  			if (!test_bit(PC_SUPPRESS_ERROR, &pc->flags)) {
> -				if (idefloppy_should_report_error(floppy))
> +				if (idefloppy_report_error(floppy))
>  					printk(KERN_ERR "ide-floppy: %s: I/O error, "
>  					       "pc = %2x, key = %2x, "
>  					       "asc = %2x, ascq = %2x\n",
> @@ -809,7 +809,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
>  
>  	if (rq->errors >= ERROR_MAX) {
>  		if (floppy->failed_pc != NULL) {
> -			if (idefloppy_should_report_error(floppy))
> +			if (idefloppy_report_error(floppy))
>  				printk(KERN_ERR "ide-floppy: %s: I/O error,"
>  					" pc = %2x, key = %2x, asc = %2x,"
>  					" ascq = %2x\n",

if you move the printk() into the function the new name would suddenly
make sense! :)

it may be also worth to remove 'inline' from idefloppy_report_error()
while at it (this function is not performance critical and this should
cut some bytes from the driver binary)
