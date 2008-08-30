Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYH3RZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYH3RZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 13:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYH3RYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 13:24:51 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47533 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbYH3RYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 13:24:51 -0400
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <48B9546B.4010004@simon.arlott.org.uk>
References: <48B9546B.4010004@simon.arlott.org.uk>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 12:24:50 -0500
Message-Id: <1220117091.3615.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-scsi is the correct list for this, cc's added

On Sat, 2008-08-30 at 15:08 +0100, Simon Arlott wrote:
> The capacity printk'd in bytes is divided by 1000000,
> whereas 1048576 would be more consistent with the rest
> of the OS and disk-related utilities ('df' etc.).
> 
> This change replaces the (sz - (sz/625 - 974))/1950
> calculation with a simple right shift by 11 bits
> (/2048).
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> ---
>  drivers/scsi/sd.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e5e7d78..e6fd6fd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1441,10 +1441,8 @@ got_data:
>  		sector_t mb = sz;
>  
>  		blk_queue_hardsect_size(queue, hard_sector);
> -		/* avoid 64-bit division on 32-bit platforms */
> -		sector_div(sz, 625);
> -		mb -= sz - 974;
> -		sector_div(mb, 1950);
> +		/* Convert to megabytes (/2048) */
> +		mb = sz >> 11;
>  
>  		sd_printk(KERN_NOTICE, sdkp,
>  			  "%llu %d-byte hardware sectors (%llu MB)\n",

No, this is wrong.  By mandated standards the manufacturers are allowed
to calculate MB by dividing by 10^6.  This is a fiddle to allow them to
make their drives look slightly bigger.  However, we want the printed
information to match that written on the drive, so in this printk, we
use the manufacturer standard for calculation (and then do everything
else in bytes so we don't have to bother with it ever again).

James


