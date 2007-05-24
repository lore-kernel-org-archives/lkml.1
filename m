Return-Path: <linux-kernel-owner+w=401wt.eu-S1751756AbXEXPIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbXEXPIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXEXPIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:08:01 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:18313 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbXEXPH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gc7tFiWiJeYMViY2kZvwpxLFmbmj1B9/cXwZyMONut0pbJF939qU6c39LR/oCO8IgXta5iTWof02LQaPJXV4NP4LWCnVMGWluw+2Lm9vFZFJorSjlkNce8H4KPnEwFedd7JWvRlePujyx6hSpNyXSt9EB3Ho7BeCy05s5aetQ7Q=
Message-ID: <4af2d03a0705240807s2cc2435eqd4ed88d5423d7741@mail.gmail.com>
Date: Thu, 24 May 2007 17:07:51 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       video4linux-list@redhat.com
In-Reply-To: <d9def9db0705240724p59a48160l8a2338f4d44b0ef6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2172422218943432279@wsc.cz>
	 <d9def9db0705240724p59a48160l8a2338f4d44b0ef6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> Hi Jiri,
>
> On 5/24/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > Well, no objections on v4l list, try to merge it. Any further comments will
> > be
> > appreciated.
> >
> > --
> >
> > stk11xx, add a new webcam driver
> >
> > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> >
[...]
> > +/*
> > + * Bayer conversion
> > + */
> > +
> > +#define STK11XX_AVG2(x,y) (u8)(((int)x + (int)y) / 2)
> > +#define STK11XX_AVG4(a,b,c,d) (u8)(((int)a + (int)b + (int)c + (int)d) / 4)
> > +
> > +static void stk11xx_bayer_to_rgb(u8 *rgb, const u8 *bayer,
> > +                       const int width, const int height)
>
> hmm.. this is probably to support xawtv/tvtime?
> It would be better to do that in userspace, but the argument which
> seems to be against it is that userspace applications often don't
> support bayer.

Exactly.  This would make the webcam driver unusable. Another one,
which awaits RGB is camstream, which also I use. After moving all
major used userspace apps to something like pwlib, this may be wiped
out.

> > +{
> > +     unsigned int x, y, nwidth, nheight;
> > +
> > +     nheight = height / factor;
> > +     nwidth = width / factor;
> > +
> > +     for (y = 0; y < nheight; y++) {
> > +             for (x = 0; x < nwidth; x++) {
> > +                     /* R */
> > +                     out[y * nwidth * 3 + x * 3 + 0] =
> > +                         in[y * factor * width * 3 + x * factor * 3 + 0];
> > +                     /* G */
> > +                     out[y * nwidth * 3 + x * 3 + 1] =
> > +                         in[y * factor * width * 3 + x * factor * 3 + 1];
> > +                     /* B */
> > +                     out[y * nwidth * 3 + x * 3 + 2] =
> > +                         in[y * factor * width * 3 + x * factor * 3 + 2];
> > +             }
> > +     }
> > +}
> > +
> > +static void stk11xx_correct_brightness(u8 *rgb, unsigned int width,
> > +                             unsigned int height, int brightness)
> > +{
>
> same here, why do you want to have that in kernelspace?

not sure who from userspace can do this nowadays. Will check.

> > +/*
> > + * The configuration of device is composed of 12 steps.
> > + * This function is called by the initialization process.
> > + *
> > + * We don't know the meaning of these steps! We only replay the USB log.
> > + */
> > +static int stk1135_configure_device(struct stk11xx *dev, int step)
> > +{
> > +     int value;
> > +
> > +     /*      0,    1,    2,    3,    4,    5,    6,    7,    8,    9,
> > +                 10,   11,   12,   13 */
> > +
> > +     const u8 values_001B[] = {
> > +             0x0E, 0x03, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x07,
> > +                 0x07, 0x07, 0x07, 0x07
> > +     };
> > +     const u8 values_001C[] = {
> > +             0x06, 0x02, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x06, 0x06,
> > +                 0x06, 0x06, 0x06, 0x07
> > +     };
> > +     const u8 values_0202[] = {
> > +             0x1E, 0x0A, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E,
> > +                 0x1E, 0x1E, 0x1E, 0x1E
> > +     };
> > +     const u8 values_0110[] = {
> > +             0x07, 0x00, 0x00, 0x00, 0x00, 0x3E, 0x3E, 0x00, 0x04, 0x00,
> > +                 0x00, 0x00, 0x00, 0x00
> > +     };
> > +     const u8 values_0112[] = {
> > +             0x07, 0x00, 0x00, 0x00, 0x00, 0x09, 0x09, 0x00, 0x04, 0x00,
> > +                 0x00, 0x00, 0x00, 0x00
> > +     };
> > +     const u8 values_0114[] = {
> > +             0x87, 0x80, 0x80, 0x80, 0x80, 0xBE, 0xBE, 0x80, 0x84, 0x80,
> > +                 0x80, 0x80, 0x80, 0x80
> > +     };
> > +     const u8 values_0116[] = {
> > +             0xE7, 0xE0, 0xE0, 0xE0, 0xE0, 0xE9, 0xE9, 0xE0, 0xE4, 0xE0,
> > +                 0xE0, 0xE0, 0xE0, 0xE0
> > +     };
> > +     const u8 values_0100[] = {
> > +             0x20, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x23, 0x20,
> > +                 0x20, 0x20, 0x20, 0x20
> > +     };
> > +
> > +     dev_dbg(&dev->udev->dev, "stk1135_configure_device: %d\n", step);
> > +
> > +     stk11xx_write_registry(dev, 0x0000, 0x0024);
> > +     stk11xx_write_registry(dev, 0x0002, 0x0068);
> > +     stk11xx_write_registry(dev, 0x0003, 0x0080);
> > +     stk11xx_write_registry(dev, 0x0005, 0x0000);
> > +
> > +     stk11xx_write_registry(dev, 0x0007, 0x0003);
> > +     stk11xx_write_registry(dev, 0x000d, 0x0000);
> > +     stk11xx_write_registry(dev, 0x000f, 0x0002);
> > +     stk11xx_write_registry(dev, 0x0300, 0x0012);
> > +     stk11xx_write_registry(dev, 0x0350, 0x0041);
> > +
> > +     stk11xx_write_registry(dev, 0x0351, 0x0000);
> > +     stk11xx_write_registry(dev, 0x0352, 0x0000);
> > +     stk11xx_write_registry(dev, 0x0353, 0x0000);
> > +     stk11xx_write_registry(dev, 0x0018, 0x0010);
> > +     stk11xx_write_registry(dev, 0x0019, 0x0000);
> > +
> > +     stk11xx_write_registry(dev, 0x001b, values_001B[step]);
> > +     stk11xx_write_registry(dev, 0x001c, values_001C[step]);
> > +     stk11xx_write_registry(dev, 0x0300, 0x0080);
> > +     stk11xx_write_registry(dev, 0x001a, 0x0004);
> > +     stk11xx_write_registry(dev, 0x0202, values_0202[step]);
> > +
> > +     stk11xx_write_registry(dev, 0x0110, values_0110[step]);
> > +     stk11xx_write_registry(dev, 0x0111, 0x0000);
> > +     stk11xx_write_registry(dev, 0x0112, values_0112[step]);
> > +     stk11xx_write_registry(dev, 0x0113, 0x0000);
> > +     stk11xx_write_registry(dev, 0x0114, values_0114[step]);
> > +
>
> if possible some error checking would be nice here, if you unplug the
> device you'll rely on the underlying subsystem to handle your errors I
> don't think that's a good way to go.
> Did you test unplugging your device while it's in use with mplayer/xawtv/..?

hmm, no. It's physically impossible -- it's built in. Is there any
possibility of sw unplugging, e.g. writing something somewhere to
/proc or /sys?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
