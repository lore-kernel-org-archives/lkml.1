Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYCKHCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYCKHCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 03:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYCKHCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 03:02:39 -0400
Received: from const.mimas.ru ([88.200.217.78]:33690 "EHLO const.mimas.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbYCKHCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 03:02:38 -0400
Message-ID: <47D62E8B.1060504@const.mimas.ru>
Date: Tue, 11 Mar 2008 11:02:35 +0400
From: Constantin Baranov <const@const.mimas.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.12) Gecko/20080212 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc4] usb: add support for Motorola ROKR Z6 cellphone
 in mass storage mode
References: <47D5804A.2020000@const.mimas.ru> <20080310190158.GI2820@one-eyed-alien.net> <47D59173.9000902@const.mimas.ru> <20080311063019.GA1756@one-eyed-alien.net>
In-Reply-To: <20080311063019.GA1756@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have just copied identification strings from the phone.
FIX_INQUIRY causes kernel to use vendor/product strings from
unusual_devs.h instead of from device's inquiry data.
And I'd like not to change the reality without any reason.

Matthew Dharm wrote:
> One last question:
> 
> If it's a ROKR Z6, why does the string in unusual_devs.h say "MSnc."?
> 
> Matt
> 
> On Mon, Mar 10, 2008 at 11:52:19PM +0400, Constantin Baranov wrote:
>> Yes. These three flags corresponds to three different bugs
>> discussed in linux-usb-users@lists.sourceforge.net
>> (http://www.mail-archive.com/linux-usb-users@lists.sourceforge.net/msg19167.html)
>>
>> FIX_INQUIRY: Device always sends PQ=1 in inquiry data, so SCSI subsystem
>> stops to create sd device.
>> FIX_CAPACITY: Device tells wrong size of internal memory card
>> (real size + 1). If one would try to read/write "phantom" sector then
>> phone hang up and reboot.
>> BULK_IGNORE_TAG: Sometimes device sends wrong tags causing computer to
>> reset endpoint. This may corrupt phone's filesystem in particular.
>>
>> Matthew Dharm wrote:
>>> Are all 3 flags truly needed?
>>>
>>> Matt
>>>
>>> On Mon, Mar 10, 2008 at 10:39:06PM +0400, Constantin Baranov wrote:
>>>> From: Constantin Baranov <const@tltsu.ru>
>>>>
>>>> Motorola ROKR Z6 cellphone has bugs in its USB, so it is impossible to use
>>>> it as mass storage. Patch describes new "unusual" USB device for it with
>>>> FIX_INQUIRY and FIX_CAPACITY flags and new BULK_IGNORE_TAG flag.
>>>> Last flag relaxes check for equality of bcs->Tag and us->tag in
>>>> usb_stor_Bulk_transport routine.
>>>>
>>>> Signed-off-by: Constantin Baranov <const@tltsu.ru>
>>>> ---
>>>>  drivers/usb/storage/transport.c    |    3 ++-
>>>>  drivers/usb/storage/unusual_devs.h |   10 ++++++++++
>>>>  include/linux/usb_usual.h          |    4 +++-
>>>>  3 files changed, 15 insertions(+), 2 deletions(-)
>>>>
>>>> diff -upr linux-2.6.25-rc4/drivers/usb/storage/transport.c
>>>> linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/transport.c
>>>> --- linux-2.6.25-rc4/drivers/usb/storage/transport.c	2008-03-10
>>>> 22:09:11.000000000 +0400
>>>> +++ linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/transport.c
>>>> 2008-03-10 22:11:24.000000000 +0400
>>>> @@ -1009,7 +1009,8 @@ int usb_stor_Bulk_transport(struct scsi_
>>>>  	US_DEBUGP("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
>>>>  			le32_to_cpu(bcs->Signature), bcs->Tag,
>>>>  			residue, bcs->Status);
>>>> -	if (bcs->Tag != us->tag || bcs->Status > US_BULK_STAT_PHASE) {
>>>> +	if (!(bcs->Tag == us->tag || (us->flags & US_FL_BULK_IGNORE_TAG)) ||
>>>> +		bcs->Status > US_BULK_STAT_PHASE) {
>>>>  		US_DEBUGP("Bulk logical error\n");
>>>>  		return USB_STOR_TRANSPORT_ERROR;
>>>>  	}
>>>> diff -upr linux-2.6.25-rc4/drivers/usb/storage/unusual_devs.h
>>>> linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/unusual_devs.h
>>>> --- linux-2.6.25-rc4/drivers/usb/storage/unusual_devs.h	2008-03-10
>>>> 22:09:11.000000000 +0400
>>>> +++ linux-2.6.25-rc4-motorokr_z6/drivers/usb/storage/unusual_devs.h
>>>> 2008-03-10 22:10:40.000000000 +0400
>>>> @@ -1589,6 +1589,16 @@ UNUSUAL_DEV(  0x22b8, 0x4810, 0x0001, 0x
>>>>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>>>>  		US_FL_FIX_CAPACITY),
>>>>
>>>> +/*
>>>> + * Patch by Constantin Baranov <const@tltsu.ru>
>>>> + * Report by Andreas Koenecke
>>>> + */
>>>> +UNUSUAL_DEV(  0x22b8, 0x6426, 0x0101, 0x0101,
>>>> +		"Motorola",
>>>> +		"MSnc.",
>>>> +		US_SC_DEVICE, US_PR_DEVICE, NULL,
>>>> +		US_FL_FIX_INQUIRY | US_FL_FIX_CAPACITY | US_FL_BULK_IGNORE_TAG),
>>>> +
>>>>  /* Reported by Radovan Garabik <garabik@kassiopeia.juls.savba.sk> */
>>>>  UNUSUAL_DEV(  0x2735, 0x100b, 0x0000, 0x9999,
>>>>  		"MPIO",
>>>> diff -upr linux-2.6.25-rc4/include/linux/usb_usual.h
>>>> linux-2.6.25-rc4-motorokr_z6/include/linux/usb_usual.h
>>>> --- linux-2.6.25-rc4/include/linux/usb_usual.h	2008-03-10
>>>> 22:09:12.000000000 +0400
>>>> +++ linux-2.6.25-rc4-motorokr_z6/include/linux/usb_usual.h	2008-03-10
>>>> 22:10:40.000000000 +0400
>>>> @@ -50,7 +50,9 @@
>>>>  	US_FLAG(CAPACITY_HEURISTICS,	0x00001000)		\
>>>>  		/* sometimes sizes is too big */		\
>>>>  	US_FLAG(MAX_SECTORS_MIN,0x00002000)			\
>>>> -		/* Sets max_sectors to arch min */
>>>> +		/* Sets max_sectors to arch min */		\
>>>> +	US_FLAG(BULK_IGNORE_TAG,0x00004000)			\
>>>> +		/* Ignore tag mismatch in bulk operations */
>>>>
>>>>
>>>>  #define US_FLAG(name, value)	US_FL_##name = value ,
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

