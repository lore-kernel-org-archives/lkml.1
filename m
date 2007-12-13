Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbXLMAUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbXLMAUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 19:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbXLMAUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 19:20:41 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:8996 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbXLMAUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 19:20:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T5NTQyhOM+quaqWJjyu1sHJKalUbWnpQ9vC6XBB+nzLxDYQiFl3Kb4A3GYKWgU3UNPelZv2VuR9CAmPdsUA5ksSvwUIs3Q6TDd40/NH5lKHzixK4tYOyxtjtUIKQ7DTyqjStEypV+04u9W/WP2yk/5+Yo4cXxOlxmQ0W6RX3OnM=
Message-ID: <57e2b00712121620n6667fae7w2d4fb615113e4b27@mail.gmail.com>
Date: Thu, 13 Dec 2007 00:20:39 +0000
From: "Byron Bradley" <byron.bbradley@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add support for the S-35390A RTC chip.
Cc: linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com, timtimred@foonas.org
In-Reply-To: <20071212002333.dd4508dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1196979027-2589-1-git-send-email-byron.bbradley@gmail.com>
	 <20071212002333.dd4508dc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 8:23 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu,  6 Dec 2007 22:10:27 +0000 Byron Bradley <byron.bbradley@gmail.com> wrote:
>
> > This adds basic get/set time support for the Seiko Instruments
> > S-35390A. This chip communicates using I2C and is used on the
> > QNAP TS-109/TS-209 NAS devices.
> >
>
> A nice looking little driver.
>
> > +static inline char reverse(char x)
> > +{
> > +     x = ((x >> 1) & 0x55) | ((x << 1) & 0xaa);
> > +     x = ((x >> 2) & 0x33) | ((x << 2) & 0xcc);
> > +     return (x >> 4) | (x << 4);
> > +}
>
> Please take a peek in include/linux/bitrev.h ;)

Thanks Andrew, I knew there must have been a function to do this
somewhere but all I could find were the swab functions.

> Could you review and runtime test this please?
>
> --- a/drivers/rtc/rtc-s35390a.c~rtc-add-support-for-the-s-35390a-rtc-chip-fix
> +++ a/drivers/rtc/rtc-s35390a.c
> @@ -12,6 +12,7 @@
>  #include <linux/module.h>
>  #include <linux/rtc.h>
>  #include <linux/i2c.h>
> +#include <linux/bitrev.h>
>  #include <linux/bcd.h>
>
>  #define S35390A_CMD_STATUS1    0
> @@ -121,13 +122,6 @@ static int s35390a_reg2hr(struct s35390a
>         return hour;
>  }
>
> -static inline char reverse(char x)
> -{
> -       x = ((x >> 1) & 0x55) | ((x << 1) & 0xaa);
> -       x = ((x >> 2) & 0x33) | ((x << 2) & 0xcc);
> -       return (x >> 4) | (x << 4);
> -}
> -
>  static int s35390a_set_datetime(struct i2c_client *client, struct rtc_time *tm)
>  {
>         struct s35390a  *s35390a = i2c_get_clientdata(client);
> @@ -149,7 +143,7 @@ static int s35390a_set_datetime(struct i
>
>         /* This chip expects the bits of each byte to be in reverse order */
>         for (i = 0; i < 7; ++i)
> -               buf[i] = reverse(buf[i]);
> +               buf[i] = bitrev8(buf[i]);
>
>         err = s35390a_set_reg(s35390a, S35390A_CMD_TIME1, buf, sizeof(buf));
>
> @@ -168,7 +162,7 @@ static int s35390a_get_datetime(struct i
>
>         /* This chip returns the bits of each byte in reverse order */
>         for (i = 0; i < 7; ++i)
> -               buf[i] = reverse(buf[i]);
> +               buf[i] = bitrev8(buf[i]);
>
>         tm->tm_sec = BCD2BIN(buf[S35390A_BYTE_SECS]);
>         tm->tm_min = BCD2BIN(buf[S35390A_BYTE_MINS]);
> _

The above patch works as expected.

Thanks,

-- 
Byron Bradley
