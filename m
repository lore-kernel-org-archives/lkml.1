Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZGWVbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZGWVbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZGWVbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:31:13 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:55101 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbZGWVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:31:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SxXPZxESxW/rP00qtYqsqYO18yiji7h0wPnbfQssWevCju0WMjoNUP/422RKCTdBlx
         JQ8PLBWSrnoEnkaTUpbMBFfk0JLcao4T3TZ1OrVlXOoQKPZQiLiCKNsotKYcXlo9Zqtr
         6bdaigSpu2EwDQCyo7SaqejkCzesUdXLfr2aA=
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix for Acer  Bluetooth Optical Rechargeable Mouse
Date: Thu, 23 Jul 2009 18:30:57 -0300
User-Agent: KMail/1.11.4 (Linux/2.6.30.2-lvs; KDE/4.2.4; x86_64; ; )
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200907170301.43807.lamarque@gmail.com> <20090723132810.6a7aa3dc.akpm@linux-foundation.org>
In-Reply-To: <20090723132810.6a7aa3dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907231830.57719.lamarque@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi,

Em Quinta-feira 23 Julho 2009, Andrew Morton escreveu:
> On Fri, 17 Jul 2009 03:01:43 -0300
>
> Lamarque Vieira Souza <lamarque@gmail.com> wrote:
> > 	This patch works around one problem with my Acer Bluetooth Optical
> > Rechargeable Mouse where the cursor gets stuck at screen's upper-left
> > corner. Even my notebook's touchpad is not able to move cursor when the
> > bluetooth mouse is connected to my Acer Ferrari 4005 notebook. Using
> > input session instead of hid session solves this problem although the
> > cursor still moves a little sluggishly with the bluetooth mouse, cursor
> > moves correctly using the touchpad. My bluetooth mouse used to work well
> > (no sluggish) until kernel 2.6.21, since then the problems are getting
> > worse with each kernel release (it got sluggish in 2.6.22 and this this
> > upper-left corner problem appeared in 2.6.28 or 2.6.27).

	By the way, I have found that bug 
http://bugzilla.kernel.org/show_bug.cgi?id=13314 is the cause of the sluggish 
in my mouse.

> The patch also adds a new general quirk infrastructure to the hidp
> core.  That's worth noting in the changelog!  I added this:
>
>    The patch adds a general quirk handling framework to the HIDP
>    core and then uses this framework to implement a quirk for this
>    device.

	Ok, that is better.

> > linux-2.6.30.1-lvs/net/bluetooth/hidp/core.c
> > --- linux-2.6.30.1-orig/net/bluetooth/hidp/core.c	2009-07-16
> > 23:53:04.697925121 -0300
> > +++ linux-2.6.30.1-lvs/net/bluetooth/hidp/core.c	2009-07-17
> > 02:35:03.969927384 -0300
> > @@ -73,6 +73,43 @@ static unsigned char hidp_keycode[256] =
> >
> >  static unsigned char hidp_mkeyspat[] = { 0x01, 0x01, 0x01, 0x01, 0x01,
> > 0x01 };
> >
> > +/* HIDP device quirks */
> > +enum {
> > +	HIDP_QUIRK_USE_INPUT_SESSION
> > +};
> > +
> > +struct quirk_id {
> > +	__u16 vendor;
> > +	__u16 product;
> > +	unsigned long quirks;
> > +};
> > +
> > +static const struct quirk_id hidp_quirks[] = {
> > +	{
> > +		/* Lamarque: Acer Bluetooth Optical Rechargeable Mouse
> > +		 * does not work properly with hid session since 2.6.27. */
> > +		.vendor = 0x0458,
> > +		.product = 0x0058,
> > +		.quirks = 1 << HIDP_QUIRK_USE_INPUT_SESSION
> > +	},
> > +
> > +	{ /* end: all zeroes */ }
> > +};
> > +
> > +static int quirk_test_bit(__u16 vendor, __u16 product, int quirk)
> > +{
> > +	const struct quirk_id *q = &hidp_quirks[0];
> > +
> > +	while (q->vendor != vendor && q->product != product &&
> > +	       q->vendor && q->product)
> > +		q++;
> > +
> > +	if (q->vendor == vendor && q->product == product)
> > +		return test_bit(quirk, &q->quirks);
> > +
> > +	return 0;
> > +}
>
> Looks OK, but...
>
> It's a bit neater (IMO) and probably more efficient to replace the
> null-terminated search with a fixed-size one, using ARRAY_SIZE().
>
> How does this look?

	It really looks better. Thanks for the tip about ARRAY_SIZE.

> static const struct quirk_id hidp_quirks[] = {
> 	{
> 		/* Lamarque: Acer Bluetooth Optical Rechargeable Mouse
> 		 * does not work properly with hid session since 2.6.27. */
> 		.vendor = 0x0458,
> 		.product = 0x0058,
> 		.quirks = 1 << HIDP_QUIRK_USE_INPUT_SESSION
> 	},
> };
>
> static int quirk_test_bit(__u16 vendor, __u16 product, int quirk)
> {
> 	int i;
>
> 	for (i = 0; i < ARRAY_SIZE(hidp_quirks); i++) {
> 		const struct quirk_id *q = hidp_quirks + i;
>
> 		if (q->vendor == vendor && q->product == product)
> 			return test_bit(quirk, &q->quirks);
> 	}
>
> 	return 0;
> }
>
>
>
> Incremental patch:
>
> ---
> a/net/bluetooth/hidp/core.c~bluetooth-fix-for-acer-bluetooth-optical-rechar
>geable-mouse-fix +++ a/net/bluetooth/hidp/core.c
> @@ -92,20 +92,18 @@ static const struct quirk_id hidp_quirks
>  		.product = 0x0058,
>  		.quirks = 1 << HIDP_QUIRK_USE_INPUT_SESSION
>  	},
> -
> -	{ /* end: all zeroes */ }
>  };
>
>  static int quirk_test_bit(__u16 vendor, __u16 product, int quirk)
>  {
> -	const struct quirk_id *q = &hidp_quirks[0];
> +	int i;
>
> -	while (q->vendor != vendor && q->product != product &&
> -	       q->vendor && q->product)
> -		q++;
> +	for (i = 0; i < ARRAY_SIZE(hidp_quirks); i++) {
> +		const struct quirk_id *q = hidp_quirks + i;
>
> -	if (q->vendor == vendor && q->product == product)
> -		return test_bit(quirk, &q->quirks);
> +		if (q->vendor == vendor && q->product == product)
> +			return test_bit(quirk, &q->quirks);
> +	}
>
>  	return 0;
>  }
> _


-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/
