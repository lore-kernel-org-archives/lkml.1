Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZDUV3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZDUV3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZDUV3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:29:00 -0400
Received: from xenotime.net ([72.52.64.118]:53627 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752492AbZDUV27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:28:59 -0400
Message-ID: <49EE3AD2.7030100@xenotime.net>
Date: Tue, 21 Apr 2009 14:29:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       mdharm-usb@one-eyed-alien.net, linux-usb <linux-usb@vger.kernel.org>,
       usb-storage@lists.one-eyed-alien.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC][PATCH] fix sign extension with 1.5TB usb-storage LBD=y
References: <1240347174.10627.20.camel@nimitz> <20090421211858.GA1926@parisc-linux.org>
In-Reply-To: <20090421211858.GA1926@parisc-linux.org>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Apr 21, 2009 at 01:52:54PM -0700, Dave Hansen wrote:
>> This is with current git as of this morning, which is at v2.6.30-rc2.
>>
>> I have a 1.5TB USB device which gets a bit angry when I plug it in.  It
>> ends up with a scsi_disk->capacity of ffffffffaea87b30.  I tracked it
>> down to the lba calculation in read_capacity_10():
>>
>> 	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
>>  		(buffer[2] << 8) | buffer[3];
>>
>> lba is getting all 0xf's in its high 32 bits.  It seems odd that this
>> would happen since 'buffer' is an 'unsigned char', but that is
>> apparently what is going on.  Note that this isn't an issue 32-bit
>> kernels compiled with CONFIG_LBD=n since there's no more bits into which
>> the sign could be extended.
> 
> I think I know ... unsigned char gets promoted to signed int since it will
> fit.  then signed int gets cast to unsigned long long, sign-extending.  C's
> promotion rules have always felt a bit wacky to me.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 3fcb64b..db60e96 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1402,7 +1402,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>>  
>>  	sector_size =	(buffer[4] << 24) | (buffer[5] << 16) |
>>  			(buffer[6] << 8) | buffer[7];
>> -	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
>> +	lba =	((sector_t)buffer[0] << 24) | (buffer[1] << 16) |
>>  		(buffer[2] << 8) | buffer[3];
> 
> this certainly fixes your problem.  I'd prefer this patch instead, just
> because I find the cast unaesthetic ...
> 
> ----
> 
> Fix READ CAPACITY 10 with drives over 1TB
> 
> Shifting an unsigned char implicitly casts it to a signed int.  This
> caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
> which was not supported by at least one drive.  Making 'lba' an unsigned
> int ensures that sign extension will not occur.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3fcb64b..c856b1b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1373,7 +1373,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  	int sense_valid = 0;
>  	int the_result;
>  	int retries = 3;
> -	sector_t lba;
> +	unsigned lba;

sector_t is either unsigned long or u64, depending on CONFIG_LBD.
Are you saying (implying) that the higher-order bits of it don't matter here?
If so, I'd just like for that to be clear(er).


>  	unsigned sector_size;
>  
>  	do {
> @@ -1413,7 +1413,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		return -EOVERFLOW;
>  	}
>  
> -	sdkp->capacity = lba + 1;
> +	sdkp->capacity = (sector_t)lba + 1;
>  	return sector_size;
>  }
>  
> 

