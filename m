Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbYCLRGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbYCLRGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYCLRGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:06:13 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:52789 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYCLRGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:06:12 -0400
Message-ID: <47D80D60.3060006@panasas.com>
Date: Wed, 12 Mar 2008 19:05:36 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] isd200: Allocate sense_buffer for hacked up scsi_cmnd
References: <Pine.LNX.4.44L0.0803121109210.4595-100000@iolanthe.rowland.org>	 <47D7F5A3.9010004@panasas.com> <1205340884.2941.112.camel@localhost.localdomain>
In-Reply-To: <1205340884.2941.112.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12 2008 at 18:54 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Wed, 2008-03-12 at 17:24 +0200, Boaz Harrosh wrote:
>> On Wed, Mar 12 2008 at 17:10 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
>>> On Wed, 12 Mar 2008, Boaz Harrosh wrote:
>>>
>>>> Since the separation of sense_buffer from scsi_cmnd, Drivers that hack their
>>>> own struct scsi_cmnd like here isd200, must also take care of their own
>>>> sense_buffer.
>>> Did you run this through checkpatch?
>>>
>>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>>>
>>> Alan Stern
>>>
>>> --
>> No I did not, Thanks. Here it is again. 
>> Again this is for 2.6.25 rc-fixes a NULL dereference bugfix!
>>  
>> ---
>> From: Boaz Harrosh <bharrosh@panasas.com>
>> Date: Tue, 11 Mar 2008 17:23:06 +0200
>> Subject: [PATCH] isd200: Allocate sense_buffer for hacked up scsi_cmnd
>>
>> Since the separation of sense_buffer from scsi_cmnd, Drivers that hack their
>> own struct scsi_cmnd like here isd200, must also take care of their own
>> sense_buffer.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/usb/storage/isd200.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
>> index 2ae1e86..ac1764b 100644
>> --- a/drivers/usb/storage/isd200.c
>> +++ b/drivers/usb/storage/isd200.c
>> @@ -294,6 +294,7 @@ struct isd200_info {
>>  	unsigned char MaxLUNs;
>>  	struct scsi_cmnd srb;
>>  	struct scatterlist sg;
>> +	u8 *sense_buffer;
> 
> There's no real need to add this parameter, since all you're doing is
> assigning it to srb.sense_buffer, there's no need to have an extra
> pointer for it.
> 

You are right, thanks.

>>  };
>>  
>>
>> @@ -1469,6 +1470,7 @@ static void isd200_free_info_ptrs(void *info_)
>>  	if (info) {
>>  		kfree(info->id);
>>  		kfree(info->RegsBuf);
>> +		kfree(info->sense_buffer);
>>  	}
>>  }
>>  
>> @@ -1494,11 +1496,13 @@ static int isd200_init_info(struct us_data *us)
>>  				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
>>  		info->RegsBuf = (unsigned char *)
>>  				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
>> -		if (!info->id || !info->RegsBuf) {
>> +		info->sense_buffer = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
>                                         ^ kzalloc is probably best
>> +		if (!info->id || !info->RegsBuf || !info->sense_buffer) {
>>  			isd200_free_info_ptrs(info);
>>  			kfree(info);
> 
> Needs to be a kfree(info->sense_buffer) to avoid leaks if the others
> couldn't allocate ... it also looks like there are missing
> kfree(info->id) and (info->RegsBuf) that fix leaks that aren't part of
> this patch.

No! that's fine. There is no leaks. the call to isd200_free_info_ptrs takes
care of that.

> 
>>  			retStatus = ISD200_ERROR;
>> -		}
>> +		} else
>> +			info->srb.sense_buffer = info->sense_buffer;
>>  	}
>>  
>>  	if (retStatus == ISD200_GOOD) {
> 
> James
> 
> 
Resend as reply to this mail.

Boaz

