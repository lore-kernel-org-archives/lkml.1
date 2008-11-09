Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYKIMzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYKIMzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 07:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbYKIMy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 07:54:56 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:47727 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266AbYKIMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 07:54:54 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8BANRqFknZiMww/2dsb2JhbAAIyEeDWA
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] Video/UVC: Fix unaligned exceptions in uvc video driver.
Date: Sun, 9 Nov 2008 13:55:04 +0100
User-Agent: KMail/1.9.9
Cc: linux-uvc-devel@lists.berlios.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
References: <1225963052-6657-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1225963052-6657-1-git-send-email-cooloney@kernel.org>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811091355.05074.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan, Michael,

Thanks for the patch.

On Thursday 06 November 2008, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>
> buffer can be odd aligned on some NOMMU machine such as Blackfin

The comment is a bit misleading. Buffers can be odd-aligned independently off 
the machine type. The issue comes from machines that can't access unaligned 
memory. Something like "Fix access to unaligned memory" would be better.

> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/media/video/uvc/uvc_driver.c |   37
> +++++++++++++++++---------------- 1 files changed, 19 insertions(+), 18
> deletions(-)
>
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index d7ad060..9b4f469 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -31,6 +31,7 @@
>  #include <linux/videodev2.h>
>  #include <linux/vmalloc.h>
>  #include <linux/wait.h>
> +#include <asm/unaligned.h>
>  #include <asm/atomic.h>
>
>  #include <media/v4l2-common.h>
> @@ -432,20 +433,20 @@ static int uvc_parse_format(struct uvc_device *dev,
>
>  		frame->bFrameIndex = buffer[3];
>  		frame->bmCapabilities = buffer[4];
> -		frame->wWidth = le16_to_cpup((__le16 *)&buffer[5]);
> -		frame->wHeight = le16_to_cpup((__le16 *)&buffer[7]);
> -		frame->dwMinBitRate = le32_to_cpup((__le32 *)&buffer[9]);
> -		frame->dwMaxBitRate = le32_to_cpup((__le32 *)&buffer[13]);
> +		frame->wWidth = le16_to_cpu(get_unaligned((__le16 *) &buffer[5]));

What about using get_unaligned_le16 and get_unaligned_le32 directly ? Lines 
would be shorter and could be kept behind the 80 columns limit more easily.

Tell me if you want to resubmit or if I should make the modification myself 
(including the patch description).

> +		frame->wHeight = le16_to_cpu(get_unaligned((__le16 *) &buffer[7]));
> +		frame->dwMinBitRate = le32_to_cpu(get_unaligned((__le32 *) &buffer[9]));
> +		frame->dwMaxBitRate = le32_to_cpu(get_unaligned((__le32 *)
> &buffer[13])); if (ftype != VS_FRAME_FRAME_BASED) {
>  			frame->dwMaxVideoFrameBufferSize =
> -				le32_to_cpup((__le32 *)&buffer[17]);
> +				le32_to_cpu(get_unaligned((__le32 *) &buffer[17]));
>  			frame->dwDefaultFrameInterval =
> -				le32_to_cpup((__le32 *)&buffer[21]);
> +				le32_to_cpu(get_unaligned((__le32 *) &buffer[21]));
>  			frame->bFrameIntervalType = buffer[25];
>  		} else {
>  			frame->dwMaxVideoFrameBufferSize = 0;
>  			frame->dwDefaultFrameInterval =
> -				le32_to_cpup((__le32 *)&buffer[17]);
> +				le32_to_cpu(get_unaligned((__le32 *) &buffer[17]));
>  			frame->bFrameIntervalType = buffer[21];
>  		}
>  		frame->dwFrameInterval = *intervals;
> @@ -468,7 +469,7 @@ static int uvc_parse_format(struct uvc_device *dev,
>  		 * some other divisions by zero which could happen.
>  		 */
>  		for (i = 0; i < n; ++i) {
> -			interval = le32_to_cpup((__le32 *)&buffer[26+4*i]);
> +			interval = le32_to_cpu(get_unaligned((__le32 *) &buffer[26+4*i]));
>  			*(*intervals)++ = interval ? interval : 1;
>  		}
>
> @@ -814,7 +815,7 @@ static int uvc_parse_vendor_control(struct uvc_device
> *dev, memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
>  		unit->extension.bNumControls = buffer[20];
>  		unit->extension.bNrInPins =
> -			le16_to_cpup((__le16 *)&buffer[21]);
> +			le16_to_cpu(get_unaligned((__le16 *) &buffer[21]));
>  		unit->extension.baSourceID = (__u8 *)unit + sizeof *unit;
>  		memcpy(unit->extension.baSourceID, &buffer[22], p);
>  		unit->extension.bControlSize = buffer[22+p];
> @@ -858,8 +859,8 @@ static int uvc_parse_standard_control(struct uvc_device
> *dev, return -EINVAL;
>  		}
>
> -		dev->uvc_version = le16_to_cpup((__le16 *)&buffer[3]);
> -		dev->clock_frequency = le32_to_cpup((__le32 *)&buffer[7]);
> +		dev->uvc_version = le16_to_cpu(get_unaligned((__le16 *) &buffer[3]));
> +		dev->clock_frequency = le32_to_cpu(get_unaligned((__le32 *)
> &buffer[7]));
>
>  		/* Parse all USB Video Streaming interfaces. */
>  		for (i = 0; i < n; ++i) {
> @@ -886,7 +887,7 @@ static int uvc_parse_standard_control(struct uvc_device
> *dev, /* Make sure the terminal type MSB is not null, otherwise it
>  		 * could be confused with a unit.
>  		 */
> -		type = le16_to_cpup((__le16 *)&buffer[4]);
> +		type = le16_to_cpu(get_unaligned((__le16 *) &buffer[4]));
>  		if ((type & 0xff00) == 0) {
>  			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
>  				"interface %d INPUT_TERMINAL %d has invalid "
> @@ -928,11 +929,11 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, term->camera.bControlSize = n;
>  			term->camera.bmControls = (__u8 *)term + sizeof *term;
>  			term->camera.wObjectiveFocalLengthMin =
> -				le16_to_cpup((__le16 *)&buffer[8]);
> +				le16_to_cpu(get_unaligned((__le16 *) &buffer[8]));
>  			term->camera.wObjectiveFocalLengthMax =
> -				le16_to_cpup((__le16 *)&buffer[10]);
> +				le16_to_cpu(get_unaligned((__le16 *) &buffer[10]));
>  			term->camera.wOcularFocalLength =
> -				le16_to_cpup((__le16 *)&buffer[12]);
> +				le16_to_cpu(get_unaligned((__le16 *) &buffer[12]));
>  			memcpy(term->camera.bmControls, &buffer[15], n);
>  		} else if (UVC_ENTITY_TYPE(term) == ITT_MEDIA_TRANSPORT_INPUT) {
>  			term->media.bControlSize = n;
> @@ -968,7 +969,7 @@ static int uvc_parse_standard_control(struct uvc_device
> *dev, /* Make sure the terminal type MSB is not null, otherwise it
>  		 * could be confused with a unit.
>  		 */
> -		type = le16_to_cpup((__le16 *)&buffer[4]);
> +		type = le16_to_cpu(get_unaligned((__le16 *) &buffer[4]));
>  		if ((type & 0xff00) == 0) {
>  			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
>  				"interface %d OUTPUT_TERMINAL %d has invalid "
> @@ -1042,7 +1043,7 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, unit->type = buffer[2];
>  		unit->processing.bSourceID = buffer[4];
>  		unit->processing.wMaxMultiplier =
> -			le16_to_cpup((__le16 *)&buffer[5]);
> +			le16_to_cpu(get_unaligned((__le16 *) &buffer[5]));
>  		unit->processing.bControlSize = buffer[7];
>  		unit->processing.bmControls = (__u8 *)unit + sizeof *unit;
>  		memcpy(unit->processing.bmControls, &buffer[8], n);
> @@ -1078,7 +1079,7 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
>  		unit->extension.bNumControls = buffer[20];
>  		unit->extension.bNrInPins =
> -			le16_to_cpup((__le16 *)&buffer[21]);
> +			le16_to_cpu(get_unaligned((__le16 *) &buffer[21]));
>  		unit->extension.baSourceID = (__u8 *)unit + sizeof *unit;
>  		memcpy(unit->extension.baSourceID, &buffer[22], p);
>  		unit->extension.bControlSize = buffer[22+p];

Cheers,

Laurent Pinchart
