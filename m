Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYKRPlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYKRPlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYKRPle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:41:34 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:3307 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbYKRPld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:41:33 -0500
X-IronPort-AV: E=Sophos;i="4.33,625,1220241600"; 
   d="txt'?bz2'66?scan'66,208,49,66";a="62716303"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C94994.0F6E6B37"
Subject: RE: [PATCH] USB/ISP1760: Fix for unaligned exceptions
Date: Tue, 18 Nov 2008 15:41:01 -0000
Message-ID: <8A42379416420646B9BFAC9682273B6D06966B66@limkexm3.ad.analog.com>
In-Reply-To: <49229E64.2010907@linutronix.de>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB/ISP1760: Fix for unaligned exceptions
Thread-Index: AclJbH74FEUviKv6R+GY+E+cQMHOdgAIr7ng
References: <1227000131-19145-1-git-send-email-cooloney@kernel.org> <49229E64.2010907@linutronix.de>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
       "Bryan Wu" <cooloney@kernel.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 18 Nov 2008 15:41:03.0993 (UTC) FILETIME=[10A3D690:01C94994]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C94994.0F6E6B37
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Sebastian,

>The link [1] you sent me reports an unaligned access which occurred
here.
>So I thing the access to *src should be either a get_unaligned helper
or a
>byte read loop like I did it in the read path.

It's not just that single spot.
I've seen unaligned pointers with count > 3 coming from various drivers.

Here just two examples:

1) The generic Bluetooth USB driver: CONFIG_BT_HCIUSB =20
Bluez-utils: hcitool scan:

priv_write_copy: src =3D 00efaa09, dst =3D 203c1200, len =3D 13

Full trace attached.

2) RTL8150 based USB Ethernet adapter: CONFIG_USB_RTL8150
dhcpcd:

priv_read_copy: src =3D 00ea4812, dst =3D 203d8000, len =3D 64

This trace was taken with the unaligned workaround for lengths < 4.

I wonder if it's only us (NOMMU) seeing these odd aligned buffers?

-Michael



>-----Original Message-----
>From: Sebastian Andrzej Siewior [mailto:bigeasy@linutronix.de]
>Sent: Tuesday, November 18, 2008 11:52 AM
>To: Bryan Wu
>Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Michael
>Hennerich
>Subject: Re: [PATCH] USB/ISP1760: Fix for unaligned exceptions
>
>Bryan Wu wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/usb/host/isp1760-hcd.c |   67
++++++++++++++++++++++++++++------
>-----
>>  1 files changed, 48 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/usb/host/isp1760-hcd.c
b/drivers/usb/host/isp1760-
>hcd.c
>> index 8017f1c..00bece2 100644
>> --- a/drivers/usb/host/isp1760-hcd.c
>> +++ b/drivers/usb/host/isp1760-hcd.c
>> @@ -136,12 +136,21 @@ static void priv_read_copy(struct isp1760_hcd
>*priv, u32 *src,
>>  		return;
>>  	}
>>
>> -	while (len >=3D 4) {
>> -		*src =3D __raw_readl(dst);
>> -		len -=3D 4;
>> -		src++;
>> -		dst++;
>> -	}
>> +	if (unlikely((u32)src & 0x3)) {
>> +		while (len >=3D 4) {
>> +			put_unaligned(__raw_readl(dst), src);
>> +			len -=3D 4;
>> +			src++;
>> +			dst++;
>> +		}
>> +	} else {
>> +		while (len >=3D 4) {
>> +			*src =3D __raw_readl(dst);
>> +			len -=3D 4;
>> +			src++;
>> +			dst++;
>> +		}
>> +	}
>>
>>  	if (!len)
>>  		return;
>> @@ -159,25 +168,45 @@ static void priv_read_copy(struct isp1760_hcd
>*priv, u32 *src,
>>  		len--;
>>  		buff8++;
>>  	}
>> +
>>  }
>>
>>  static void priv_write_copy(const struct isp1760_hcd *priv, const
u32
>*src,
>>  		__u32 __iomem *dst, u32 len)
>>  {
>> -	while (len >=3D 4) {
>> -		__raw_writel(*src, dst);
>> -		len -=3D 4;
>> -		src++;
>> -		dst++;
>> -	}
>>
>> -	if (!len)
>> -		return;
>> -	/* in case we have 3, 2 or 1 by left. The buffer is allocated
and the
>> -	 * extra bytes should not be read by the HW
>> -	 */
>> -
>> -	__raw_writel(*src, dst);
>The link [1] you sent me reports an unaligned access which occurred
here.
>So I thing the access to *src should be either a get_unaligned helper
or a
>byte read loop like I did it in the read path.
>The r8a66597 is doing the same thing (as you suggest) for one SH
machine.
>However, I'm not convinced to fix it that way: The buffer should be
>properly aligned by the driver. Unless there is HW which requires
>unaligned data, I would prefer just to fix this unaligned access.
>According to the thread in [1] a similar patch fixed it for the user
until
>he dropped into another bug.
>
>> +	if (unlikely((u32)src & 0x3)) {
>> +		while (len >=3D 4) {
>> +			__raw_writel(get_unaligned(src), dst);
>> +			len -=3D 4;
>> +			src++;
>> +			dst++;
>> +		}
>> +
>> +		if (!len)
>> +			return;
>> +		/* in case we have 3, 2 or 1 by left. The buffer is
allocated
>and the
>> +		 * extra bytes should not be read by the HW
>> +		 */
>> +
>> +		__raw_writel(get_unaligned(src), dst);
>> +
>> +	} else{
>> +		while (len >=3D 4) {
>> +			__raw_writel(*src, dst);
>> +			len -=3D 4;
>> +			src++;
>> +			dst++;
>> +		}
>> +
>> +		if (!len)
>> +			return;
>> +		/* in case we have 3, 2 or 1 by left. The buffer is
allocated
>and the
>> +		 * extra bytes should not be read by the HW
>> +		 */
>> +
>> +		__raw_writel(*src, dst);
>> +	}
>>  }
>>
>>  /* memory management of the 60kb on the chip from 0x1000 to 0xffff
*/
>
>[1]
>http://blackfin.uclinux.org/gf/project/uclinux-
>dist/forum/?action=3DForumBrowse&_forum_action=3DMessageReply&message_id=
=3D64
889
>
>Sebastian

------_=_NextPart_001_01C94994.0F6E6B37
Content-Type: application/octet-stream;
	name="dumps.tar.bz2"
Content-Transfer-Encoding: base64
Content-Description: dumps.tar.bz2
Content-Disposition: attachment;
	filename="dumps.tar.bz2"

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
RThQkEOrB44=

------_=_NextPart_001_01C94994.0F6E6B37--
