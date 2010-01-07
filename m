Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086Ab0AGVTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0AGVTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047Ab0AGVS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:18:58 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:44686 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab0AGVS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xQs8e4tBHTvVwh9krRCZPq4BBx65GlRsBvNRyZMK2yRyeeCCKvdpRcG60wisobIO5b
         Co6YkYkpglVgmgR/1pi0rZL5IMEjiMYhluZxDYrrRC6tj4bYLUWXdT6beT/1MGCKI/87
         6/FpgtWLDAB24rjTmbc5sqVTQvq5LvBAyYM78=
MIME-Version: 1.0
In-Reply-To: <1262888625.10429.23.camel@Joe-Laptop.home>
References: <BD79186B4FD85F4B8E60E381CAEE19090208954A@mi8nycmail19.Mi8.com>
	 <1262888625.10429.23.camel@Joe-Laptop.home>
Date: Thu, 7 Jan 2010 22:18:55 +0100
Message-ID: <e2d7436a1001071318l75750b29uece2a61884538d5b@mail.gmail.com>
Subject: Re: [PATCH] lib/vsprintf.c: Add %pMF to format FDDI bit reversed MAC 
	addresses
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       David Miller <davem@davemloft.net>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/7 Joe Perches <joe@perches.com>:
[...]
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index d4996cf..36959cc 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -25,6 +25,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/uaccess.h>
>  #include <linux/ioport.h>
> +#include <linux/bitrev.h>
>  #include <net/addrconf.h>
>
>  #include <asm/page.h>          /* for PAGE_SIZE */
> @@ -675,17 +676,37 @@ static char *resource_string(char *buf, char *end, struct resource *res,
>        return string(buf, end, sym, spec);
>  }
>
> +static u8 mac_byte(u8 val)
> +{
> +       return val;
> +}
> +
> +static u8 mac_byte_rev(u8 val)
> +{
> +       return bitrev8(val);
> +}
> +
>  static char *mac_address_string(char *buf, char *end, u8 *addr,
>                                struct printf_spec spec, const char *fmt)
>  {
>        char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
>        char *p = mac_addr;
>        int i;
> +       u8 (*mac_byte_fn)(u8 val);
> +       char separator;
> +
> +       if (fmt[1] == 'F') {            /* FDDI canonical format */
> +               mac_byte_fn = mac_byte_rev;
> +               separator = '-';
> +       } else {
> +               mac_byte_fn = mac_byte;
> +               separator  = ':';
> +       }
>
>        for (i = 0; i < 6; i++) {
> -               p = pack_hex_byte(p, addr[i]);
> +               p = pack_hex_byte(p, mac_byte_fn(addr[i]));
>                if (fmt[0] == 'M' && i != 5)
> -                       *p++ = ':';
> +                       *p++ = separator;
>        }
>        *p = '\0';
>
[...]

Something like the following might be smaller and faster - no
functions and their calls (just an idea);

int rev = (fmt[1] == 'F');
...
p = pack_hex_byte(p, rev ? bitrev8(addr[i]) : addr[i]);

Best Regards,
Micha³ Miros³aw
