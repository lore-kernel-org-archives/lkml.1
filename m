Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbXFSVdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbXFSVdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXFSVdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:33:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:53942 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbXFSVdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BG8d7DEDn1D7nvaEk3mzzrNeoGJl8UCnMao0I+82O5hWwB1x69wTf6uj1jTcE/4wynQ5mr1s1Tw+tF7riWmquvtWWz4zS6xwOLrsuC9ds3X1f1AXUWPhlZacVBVEHskfP7Bx3rwc7d3yzyYr49gTfcga8+m86rGNI5w8wWO+3g4=
Message-ID: <392557440706191433h37aa0629w1e3c05693d25bcf9@mail.gmail.com>
Date: Wed, 20 Jun 2007 08:33:01 +1100
From: Konstantin <konstantin.sharlaimov@gmail.com>
To: "Sergey Vlasov" <vsu@altlinux.ru>
Subject: Re: [PATCH 2.6.21.3] ppp_mppe: account for osize too small errors in mppe_decompress()
Cc: "Paul Mackerras" <paulus@samba.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070619184148.201f2521.vsu@altlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46654796.3060800@gmail.com>
	 <20070619184148.201f2521.vsu@altlinux.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for pointing this out. It seems that we would need to allocate
this extra byte somewhere in kernel ppp code.

However, I am not very familiar with that part of the code yet, and
I'll appreciate any help with finding parts of code where obuffer for
mppe_decompress is allocated.

On 6/20/07, Sergey Vlasov <vsu@altlinux.ru> wrote:
> On Tue, 05 Jun 2007 22:23:02 +1100 Konstantin Sharlaimov wrote:
>
> > Prevent mppe_decompress() from generating "osize too small" errors when checking
> > for output buffer size. When receiving a packet of mru size the output buffer
> > for decrypted data is 1 byte too small since mppe_decompress() tries to account
> > for possible PFC, however later in code it is assumed no PFC.
> >
> > Adjusting the check prevented there errors from occurring.
> >
> > Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
> > ---
> > --- linux-2.6.21.3/drivers/net/ppp_mppe.c.orig        2007-06-01 20:57:04.000000000 +1100
> > +++ linux-2.6.21.3/drivers/net/ppp_mppe.c     2007-06-05 21:46:30.000000000 +1100
> > @@ -493,14 +493,14 @@ mppe_decompress(void *arg, unsigned char
> >
> >       /*
> >        * Make sure we have enough room to decrypt the packet.
> > -      * Note that for our test we only subtract 1 byte whereas in
> > -      * mppe_compress() we added 2 bytes (+MPPE_OVHD);
> > -      * this is to account for possible PFC.
> > +      * To account for possible PFC we should only subtract 1
> > +      * byte whereas in mppe_compress() we added 2 bytes (+MPPE_OVHD);
> > +      * However, we assume no PFC, thus subtracting 2 bytes.
> >        */
> > -     if (osize < isize - MPPE_OVHD - 1) {
> > +     if (osize < isize - MPPE_OVHD - 2) {
> >               printk(KERN_DEBUG "mppe_decompress[%d]: osize too small! "
> >                      "(have: %d need: %d)\n", state->unit,
> > -                    osize, isize - MPPE_OVHD - 1);
> > +                    osize, isize - MPPE_OVHD - 2);
> >               return DECOMP_ERROR;
> >       }
> >       osize = isize - MPPE_OVHD - 2;  /* assume no PFC */
>
> Seems that this patch is not correct - even though the comment above
> says "assume no PFC", the subsequent code actually supports PFC:
>
>         /*
>          * Do PFC decompression.
>          * This would be nicer if we were given the actual sk_buff
>          * instead of a char *.
>          */
>         if ((obuf[0] & 0x01) != 0) {
>                 obuf[1] = obuf[0];
>                 obuf[0] = 0;
>                 obuf++;
>                 osize++;
>         }
>
> Therefore, depending on the packet contents, the decompressor may
> really need that extra byte in the output buffer, and changing the
> check may cause buffer overflows.
>
>
