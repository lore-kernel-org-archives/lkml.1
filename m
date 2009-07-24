Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbZGXRkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbZGXRkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 13:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZGXRkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 13:40:32 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:53615 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbZGXRka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 13:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XWA7Rjw1x/PJxTQyJKPlSabHTDf2znJHSaynoABypVJATpF9/INWfRrOo8bYfVCBXs
         Zt7S/Z51DnO6MjicGI0kAgJFdSLHyh8j42aRomEuJjDHU+vdHvZIVwiDLm3TlHu0LQBm
         77HE84V/Ac5kynSEBlPGiuEnge0u3YhN/bJjU=
MIME-Version: 1.0
In-Reply-To: <F06EB2894F3F0D45AD9BEA7246DE9C900E542FE2@WCSEXCMBS1.ad.wabtec.com>
References: <F06EB2894F3F0D45AD9BEA7246DE9C900E542FE2@WCSEXCMBS1.ad.wabtec.com>
Date: Fri, 24 Jul 2009 12:40:28 -0500
Message-ID: <808c8e9d0907241040i2783d27aw948aa239f521336c@mail.gmail.com>
Subject: Re: FW: [PATCH] cs5535_gpio: Fix root triggerable integer underflow
From: Ben Gardner <gardner.ben@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

> This patch fixes a possible root triggerable (I hope the device is only
> readable by root?) integer underflow.
> Well, it's not really an underflow, but as loff_t is a signed type, the
> range check at the start of the function is incomplete. It needs to
> check for <0, too.
> Otherwise the loop below will poke into random memory and I/O space.
> This could be used to crash the machine, at least.
>
> This patch is only compiletested, because I do not have the hardware.
>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>
> ---
>
> I'm not sure if this bug is exploitable. I _guess_ the device is only
> readable by root
> on a standard setup.

The cs5525_gpio driver uses the default seek, which doesn't allow
negative position values.
So, I don't think it necessary to check for negative values.

Ben

> ---
>  drivers/char/cs5535_gpio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.orig/drivers/char/cs5535_gpio.c
> +++ linux-2.6/drivers/char/cs5535_gpio.c
> @@ -124,21 +124,21 @@ static ssize_t cs5535_gpio_write(struct
>  static ssize_t cs5535_gpio_read(struct file *file, char __user *buf,
>                                size_t len, loff_t *ppos)
>  {
>        u32     m = iminor(file->f_path.dentry->d_inode);
>        u32     base = gpio_base + cs5535_lowhigh_base(m);
>        int     rd_bit = 1 << (m & 0x0f);
>        int     i;
>        char    ch;
>        ssize_t count = 0;
>
> -       if (*ppos >= ARRAY_SIZE(rm))
> +       if (*ppos < 0 || *ppos >= ARRAY_SIZE(rm))
>                return 0;
>
>        for (i = *ppos; (i < (*ppos + len)) && (i < ARRAY_SIZE(rm));
> i++) {
>                ch = (inl(base + rm[i].rd_offset) & rd_bit) ?
>                     rm[i].on : rm[i].off;
>
>                if (put_user(ch, buf+count))
>                        return -EFAULT;
>
>                count++;
>
> --
> Greetings, Michael.
