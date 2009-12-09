Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZLISAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZLISAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZLISAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:00:34 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62769 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZLISAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:00:33 -0500
MIME-Version: 1.0
In-Reply-To: <20091209175553.GA25451@pengutronix.de>
References: <200912082330.nB8NU4IO016215@imap1.linux-foundation.org> 
	<fa686aa40912081638m734e97c3r2c3f412898d293b@mail.gmail.com> 
	<20091209074533.GB8136@pengutronix.de> <fa686aa40912090708g45879802l6cea7b401b1434e3@mail.gmail.com> 
	<20091209153241.GB1389@pengutronix.de> <20091209175553.GA25451@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 9 Dec 2009 11:00:19 -0700
X-Google-Sender-Auth: bb5c16685172a877
Message-ID: <fa686aa40912091000h16942fe9m239997ca3f2d9e4a@mail.gmail.com>
Subject: Re: + spi-imx-correct-check-for-platform_get_irq-failing.patch added 
	to -mm tree
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, daniel@caiaq.de,
       dbrownell@users.sourceforge.net, s.hauer@pengutronix.de,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/9 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> On Wed, Dec 09, 2009 at 04:32:41PM +0100, Uwe Kleine-König wrote:
>> On Wed, Dec 09, 2009 at 08:08:19AM -0700, Grant Likely wrote:
>> > (resend because I forgot to cc the mailing list)
>> >
>> > 2009/12/9 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>> > > Hello Grant,
>> > >
>> > > On Tue, Dec 08, 2009 at 05:38:57PM -0700, Grant Likely wrote:
>> > >> > diff -puN drivers/spi/spi_imx.c~spi-imx-correct-check-for-platform_get_irq-failing drivers/spi/spi_imx.c
>> > >> > --- a/drivers/spi/spi_imx.c~spi-imx-correct-check-for-platform_get_irq-failing
>> > >> > +++ a/drivers/spi/spi_imx.c
>> > >> > @@ -554,7 +554,7 @@ static int __init spi_imx_probe(struct p
>> > >> >        }
>> > >> >
>> > >> >        spi_imx->irq = platform_get_irq(pdev, 0);
>> > >> > -       if (!spi_imx->irq) {
>> > >> > +       if (spi_imx->irq < 0) {
>> > >>
>> > >> This changes the old behaviour.  Is that what you intended?  '<= 0' perhaps?
>> > > Yes, the old check was wrong.  What if the irq to use is 0?  I thought
>> > > the commit log to be understandable.  platform_get_irq returns -ENXIO on
>> > > error and an irq number on success.  So 0 has to be interpreted as valid
>> > > irq, not an error.
>> >
>> > 0 is not a valid IRQ
>> Hmm, on my x86 I have:
>>
>>       $ grep '\<0:' /proc/interrupts
>>          0:      24330   IO-APIC-edge      timer
>>
>> arm/davinci starts at 0, too.  As does arm/ns9xxx.  arm/pxa seems to
>> start at 1.  realview starts at 1, too.  So four out of five make are
>> wrong?  Seems like a big area for cleanup.
> I've read a bit and I think the best for a driver writer (i.e. the role
> I have when changing drivers/spi/spi_imx.c) is to accept what
> platform_get_irq returns to me.  If the platform specified
>
>        struct resource mydevicesresources[] = {
>                ...
>                {
>                        .start = 0,
>                        .end = 0,
>                        .flags = IORESOURCE_IRQ,
>                },
>                ...
>        };
>
> then the best thing to do is to take irq0, isn't it.  So as
> platform_get_irq is implemented as
>
>        int platform_get_irq(struct platform_device *dev, unsigned int num)
>        {
>                struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);
>
>                return r ? r->start : -ENXIO;
>        }
>
> testing for <0 seems right to me.

Regardless.  I won't accept that change for a theoretical use case.
In the general case I'll maintain the pattern that irq 0 is invalid
unless it is the only way to get around a real problem.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
