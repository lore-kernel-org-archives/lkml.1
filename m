Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZDVHeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZDVHeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZDVHeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:34:23 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:21404 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750870AbZDVHeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:34:22 -0400
Message-ID: <49EEC82B.5040603@panasas.com>
Date: Wed, 22 Apr 2009 10:32:59 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       mdharm-usb@one-eyed-alien.net, linux-usb <linux-usb@vger.kernel.org>,
       usb-storage@lists.one-eyed-alien.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>, viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] fix sign extension with 1.5TB usb-storage LBD=y
References: <1240347174.10627.20.camel@nimitz>	 <20090421211858.GA1926@parisc-linux.org> <1240351210.10627.30.camel@nimitz>
In-Reply-To: <1240351210.10627.30.camel@nimitz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2009 07:33:05.0693 (UTC) FILETIME=[93710CD0:01C9C31C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2009 01:00 AM, Dave Hansen wrote:
> Here's a patch implementing Al's suggestion.  Not quite as trivial as
> Matthew's, but even nicer aesthetically.  (Description stolen from
> Matthew's patch).  I have verified that this fixes my issue.
> 
> --
> 
> Shifting an unsigned char implicitly casts it to a signed int.  This
> caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
> which was not supported by at least one drive.  Using the
> get_unaligned_be*() helpers keeps us from having to worry about how the
> extension might occur.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3fcb64b..c50142b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -50,6 +50,7 @@
>  #include <linux/string_helpers.h>
>  #include <linux/async.h>
>  #include <asm/uaccess.h>
> +#include <asm/unaligned.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -1344,12 +1345,8 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		return -EINVAL;
>  	}
>  
> -	sector_size =	(buffer[8] << 24) | (buffer[9] << 16) |
> -			(buffer[10] << 8) | buffer[11];
> -	lba =  (((u64)buffer[0] << 56) | ((u64)buffer[1] << 48) |
> -		((u64)buffer[2] << 40) | ((u64)buffer[3] << 32) |
> -		((u64)buffer[4] << 24) | ((u64)buffer[5] << 16) |
> -		((u64)buffer[6] << 8) | (u64)buffer[7]);
> +	sector_size = get_unaligned_be32(&buffer[8]);
> +	lba =  get_unaligned_be64(&buffer[0]);

These are actually aligned access it might be worth sacrificing a cast
to be32/64 for sake of speed.

>  
>  	sd_read_protection_type(sdkp, buffer);
>  
> @@ -1400,10 +1397,8 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		return -EINVAL;
>  	}
>  
> -	sector_size =	(buffer[4] << 24) | (buffer[5] << 16) |
> -			(buffer[6] << 8) | buffer[7];
> -	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
> -		(buffer[2] << 8) | buffer[3];
> +	sector_size = get_unaligned_be32(&buffer[4]);
> +	lba = get_unaligned_be32(&buffer[0]);
>  

Here too, both are actually aligned.

>  	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
>  		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
> 
> 
> -- Dave
> 

I'm not 100% convinced just a thought.
Boaz
