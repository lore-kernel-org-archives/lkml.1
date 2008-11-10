Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYKJKvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYKJKvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbYKJKvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:51:24 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:20261 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYKJKvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:51:23 -0500
X-IronPort-AV: E=Sophos;i="4.33,574,1220241600"; 
   d="scan'208";a="62321798"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Video/UVC: Fix unaligned exceptions in uvc video driver.
Date: Mon, 10 Nov 2008 10:51:19 -0000
Message-ID: <8A42379416420646B9BFAC9682273B6D065BA534@limkexm3.ad.analog.com>
In-Reply-To: <200811091355.05074.laurent.pinchart@skynet.be>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Video/UVC: Fix unaligned exceptions in uvc video driver.
Thread-Index: AclCatlXUFoXG2hyQxicPSoTSftr6QAqyXvA
References: <1225963052-6657-1-git-send-email-cooloney@kernel.org> <200811091355.05074.laurent.pinchart@skynet.be>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>,
       "Bryan Wu" <cooloney@kernel.org>
Cc: <linux-uvc-devel@lists.berlios.de>, <video4linux-list@redhat.com>,
       <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 10 Nov 2008 10:51:21.0571 (UTC) FILETIME=[449ABB30:01C94322]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Laurent Pinchart [mailto:laurent.pinchart@skynet.be]
>Sent: Sunday, November 09, 2008 1:55 PM
>To: Bryan Wu
>Cc: linux-uvc-devel@lists.berlios.de; video4linux-list@redhat.com;
linux-
>kernel@vger.kernel.org; Michael Hennerich
>Subject: Re: [PATCH] Video/UVC: Fix unaligned exceptions in uvc video
>driver.
>
>Hi Bryan, Michael,
>
>Thanks for the patch.
>
>On Thursday 06 November 2008, Bryan Wu wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> buffer can be odd aligned on some NOMMU machine such as Blackfin
>
>The comment is a bit misleading. Buffers can be odd-aligned
independently
>off
>the machine type. The issue comes from machines that can't access
unaligned
>memory. Something like "Fix access to unaligned memory" would be
better.
>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/media/video/uvc/uvc_driver.c |   37
>> +++++++++++++++++---------------- 1 files changed, 19 insertions(+),
18
>> deletions(-)
>>
>> diff --git a/drivers/media/video/uvc/uvc_driver.c
>> b/drivers/media/video/uvc/uvc_driver.c index d7ad060..9b4f469 100644
>> --- a/drivers/media/video/uvc/uvc_driver.c
>> +++ b/drivers/media/video/uvc/uvc_driver.c
>> @@ -31,6 +31,7 @@
>>  #include <linux/videodev2.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/wait.h>
>> +#include <asm/unaligned.h>
>>  #include <asm/atomic.h>
>>
>>  #include <media/v4l2-common.h>
>> @@ -432,20 +433,20 @@ static int uvc_parse_format(struct uvc_device
*dev,
>>
>>  		frame->bFrameIndex = buffer[3];
>>  		frame->bmCapabilities = buffer[4];
>> -		frame->wWidth = le16_to_cpup((__le16 *)&buffer[5]);
>> -		frame->wHeight = le16_to_cpup((__le16 *)&buffer[7]);
>> -		frame->dwMinBitRate = le32_to_cpup((__le32
*)&buffer[9]);
>> -		frame->dwMaxBitRate = le32_to_cpup((__le32
*)&buffer[13]);
>> +		frame->wWidth = le16_to_cpu(get_unaligned((__le16 *)
>&buffer[5]));
>
>What about using get_unaligned_le16 and get_unaligned_le32 directly ?
Lines
>would be shorter and could be kept behind the 80 columns limit more
easily.
>
>Tell me if you want to resubmit or if I should make the modification
myself
>(including the patch description).

Laurent,

Well - I just used the same style already used in various other places
in the uvc driver. - Just wanted to be consistent.

If you don't mind doing the changes (including the patch description),
please go ahead.

Thanks and best regards,
Michael

>
>> +		frame->wHeight = le16_to_cpu(get_unaligned((__le16 *)
>&buffer[7]));
>> +		frame->dwMinBitRate = le32_to_cpu(get_unaligned((__le32
*)
>&buffer[9]));
>> +		frame->dwMaxBitRate = le32_to_cpu(get_unaligned((__le32
*)
>> &buffer[13])); if (ftype != VS_FRAME_FRAME_BASED) {
>>  			frame->dwMaxVideoFrameBufferSize =
>> -				le32_to_cpup((__le32 *)&buffer[17]);
>> +				le32_to_cpu(get_unaligned((__le32 *)
&buffer[17]));
>>  			frame->dwDefaultFrameInterval =
>> -				le32_to_cpup((__le32 *)&buffer[21]);
>> +				le32_to_cpu(get_unaligned((__le32 *)
&buffer[21]));
>>  			frame->bFrameIntervalType = buffer[25];
>>  		} else {
>>  			frame->dwMaxVideoFrameBufferSize = 0;
>>  			frame->dwDefaultFrameInterval =
>> -				le32_to_cpup((__le32 *)&buffer[17]);
>> +				le32_to_cpu(get_unaligned((__le32 *)
&buffer[17]));
>>  			frame->bFrameIntervalType = buffer[21];
>>  		}
>>  		frame->dwFrameInterval = *intervals;
>> @@ -468,7 +469,7 @@ static int uvc_parse_format(struct uvc_device
*dev,
>>  		 * some other divisions by zero which could happen.
>>  		 */
>>  		for (i = 0; i < n; ++i) {
>> -			interval = le32_to_cpup((__le32
*)&buffer[26+4*i]);
>> +			interval = le32_to_cpu(get_unaligned((__le32 *)
>&buffer[26+4*i]));
>>  			*(*intervals)++ = interval ? interval : 1;
>>  		}
>>
>> @@ -814,7 +815,7 @@ static int uvc_parse_vendor_control(struct
uvc_device
>> *dev, memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
>>  		unit->extension.bNumControls = buffer[20];
>>  		unit->extension.bNrInPins =
>> -			le16_to_cpup((__le16 *)&buffer[21]);
>> +			le16_to_cpu(get_unaligned((__le16 *)
&buffer[21]));
>>  		unit->extension.baSourceID = (__u8 *)unit + sizeof
*unit;
>>  		memcpy(unit->extension.baSourceID, &buffer[22], p);
>>  		unit->extension.bControlSize = buffer[22+p];
>> @@ -858,8 +859,8 @@ static int uvc_parse_standard_control(struct
>uvc_device
>> *dev, return -EINVAL;
>>  		}
>>
>> -		dev->uvc_version = le16_to_cpup((__le16 *)&buffer[3]);
>> -		dev->clock_frequency = le32_to_cpup((__le32
*)&buffer[7]);
>> +		dev->uvc_version = le16_to_cpu(get_unaligned((__le16 *)
>&buffer[3]));
>> +		dev->clock_frequency = le32_to_cpu(get_unaligned((__le32
*)
>> &buffer[7]));
>>
>>  		/* Parse all USB Video Streaming interfaces. */
>>  		for (i = 0; i < n; ++i) {
>> @@ -886,7 +887,7 @@ static int uvc_parse_standard_control(struct
>uvc_device
>> *dev, /* Make sure the terminal type MSB is not null, otherwise it
>>  		 * could be confused with a unit.
>>  		 */
>> -		type = le16_to_cpup((__le16 *)&buffer[4]);
>> +		type = le16_to_cpu(get_unaligned((__le16 *)
&buffer[4]));
>>  		if ((type & 0xff00) == 0) {
>>  			uvc_trace(UVC_TRACE_DESCR, "device %d
videocontrol "
>>  				"interface %d INPUT_TERMINAL %d has
invalid "
>> @@ -928,11 +929,11 @@ static int uvc_parse_standard_control(struct
>> uvc_device *dev, term->camera.bControlSize = n;
>>  			term->camera.bmControls = (__u8 *)term + sizeof
*term;
>>  			term->camera.wObjectiveFocalLengthMin =
>> -				le16_to_cpup((__le16 *)&buffer[8]);
>> +				le16_to_cpu(get_unaligned((__le16 *)
&buffer[8]));
>>  			term->camera.wObjectiveFocalLengthMax =
>> -				le16_to_cpup((__le16 *)&buffer[10]);
>> +				le16_to_cpu(get_unaligned((__le16 *)
&buffer[10]));
>>  			term->camera.wOcularFocalLength =
>> -				le16_to_cpup((__le16 *)&buffer[12]);
>> +				le16_to_cpu(get_unaligned((__le16 *)
&buffer[12]));
>>  			memcpy(term->camera.bmControls, &buffer[15], n);
>>  		} else if (UVC_ENTITY_TYPE(term) ==
ITT_MEDIA_TRANSPORT_INPUT)
>{
>>  			term->media.bControlSize = n;
>> @@ -968,7 +969,7 @@ static int uvc_parse_standard_control(struct
>uvc_device
>> *dev, /* Make sure the terminal type MSB is not null, otherwise it
>>  		 * could be confused with a unit.
>>  		 */
>> -		type = le16_to_cpup((__le16 *)&buffer[4]);
>> +		type = le16_to_cpu(get_unaligned((__le16 *)
&buffer[4]));
>>  		if ((type & 0xff00) == 0) {
>>  			uvc_trace(UVC_TRACE_DESCR, "device %d
videocontrol "
>>  				"interface %d OUTPUT_TERMINAL %d has
invalid "
>> @@ -1042,7 +1043,7 @@ static int uvc_parse_standard_control(struct
>> uvc_device *dev, unit->type = buffer[2];
>>  		unit->processing.bSourceID = buffer[4];
>>  		unit->processing.wMaxMultiplier =
>> -			le16_to_cpup((__le16 *)&buffer[5]);
>> +			le16_to_cpu(get_unaligned((__le16 *)
&buffer[5]));
>>  		unit->processing.bControlSize = buffer[7];
>>  		unit->processing.bmControls = (__u8 *)unit + sizeof
*unit;
>>  		memcpy(unit->processing.bmControls, &buffer[8], n);
>> @@ -1078,7 +1079,7 @@ static int uvc_parse_standard_control(struct
>> uvc_device *dev, memcpy(unit->extension.guidExtensionCode,
&buffer[4],
>16);
>>  		unit->extension.bNumControls = buffer[20];
>>  		unit->extension.bNrInPins =
>> -			le16_to_cpup((__le16 *)&buffer[21]);
>> +			le16_to_cpu(get_unaligned((__le16 *)
&buffer[21]));
>>  		unit->extension.baSourceID = (__u8 *)unit + sizeof
*unit;
>>  		memcpy(unit->extension.baSourceID, &buffer[22], p);
>>  		unit->extension.bControlSize = buffer[22+p];
>
>Cheers,
>
>Laurent Pinchart
