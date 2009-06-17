Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbZFQScz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbZFQScz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759636AbZFQScp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:32:45 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58358 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759564AbZFQSco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:32:44 -0400
X-Greylist: delayed 641 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2009 14:32:43 EDT
Message-ID: <4A39343C.7030908@mev.co.uk>
Date: Wed, 17 Jun 2009 19:21:48 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Ian Abbott <ian.abbott@mev.co.uk>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Gianluca Palli <gpalli@deis.unibo.it>, David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: staging driver s626 clashes with philips SAA7146 media/dvb based
 cards
References: <200906161701.45234.herton@mandriva.com.br> <200906161830.02308.herton@mandriva.com.br> <4A38E0D8.1000202@mev.co.uk> <200906171345.19815.herton@mandriva.com.br>
In-Reply-To: <200906171345.19815.herton@mandriva.com.br>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herton Ronaldo Krzesinski wrote:
> Em Quarta-feira 17 Junho 2009, às 09:26:00, Ian Abbott escreveu:
>> Herton Ronaldo Krzesinski wrote:
>>> Em Terça-feira 16 Junho 2009, às 17:51:21, Greg KH escreveu:
>>>> On Tue, Jun 16, 2009 at 05:01:44PM -0300, Herton Ronaldo Krzesinski wrote:
>>>>> Hi,
>>>>>
>>>>> The s626 (comedi) driver in staging conflicts with philips SAA7146
>>>>> media/dvb based cards, because it claims the same vendor:device pci id
>>>>> for all subdevice/subvendor ids. What happens is that for people that
>>>>> have a philips SAA7146 based card, s626 if available gets loaded by udev
>>>>> and makes system freeze (https://qa.mandriva.com/show_bug.cgi?id=51445).
>>>> So a PCI device that does different things has the same device ids?
>>>> ick, stupid vendors...
>>>>
>>>>> Looks like s626 shouldn't claim all 1131:7146 devices, either by
>>>>> specifying specific subdevice/subvendor ids specific to s626 devices or
>>>>> doing additional checks in its probe/attach function.
>>>> If you can propose the proper sub ids, or the needed checks, please send
>>>> a patch.
>>> Can't propose proper sub ids here etc., as I don't know about/don't have s626
>>> device, s626 author is CC'ed here to check this. But I could send a patch to
>>> disable just the build of s626 if acceptable/desired for the moment.
>> The Windows driver (<http://www.sensoray.com/downloads/sdk626.zip>) has
>> this in the models section of the INF file:
>>
>> %sx26.DeviceDesc%=sxdrv.Device,PCI\VEN_1131&DEV_7146&SUBSYS_02726000
>>
>> And it looks like the correct device because this the strings section
>> contains:
>>
>> sx26.DeviceDesc=   "Sensoray Model 626 Analog/Digital I/O"
>>
>> Interpreting the above information gives us:
>>
>> PCI Vendor ID = 0x1131
>> PCI Device ID = 0x7146
>> PCI Subvendor ID = 0x6000
>> PCI Subdevice ID = 0x0272 (626)
>>
>> The Linux SDK for this board
>> (<http://www.sensoray.com/downloads/s626-1.0.1.tar.gz> has the same info
>> in the s626core.h file.
>
> Ok thanks. So lets limit s626 by its subvendor:subdevice id, patch follows:
>
> From 6f4d2430959a378ab754c5dbd3903fdcf33abe36 Mon Sep 17 00:00:00 2001
> From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Date: Wed, 17 Jun 2009 13:31:15 -0300
> Subject: [PATCH] Staging: comedi: use subvendor:subdevice ids for its pci id device table
>
> The current s626 comedi driver in staging conflicts with philips SAA7146
> media/dvb based cards, because it claims the same vendor:device pci id
> for all subdevice/subvendor ids. What happens is that for people that
> have a philips SAA7146 based card, s626 if available gets loaded by udev
> and makes system freeze (https://qa.mandriva.com/show_bug.cgi?id=51445).
>
> The s626 driver shouldn't claim all 1131:7146 devices. Fix this by
> specifying specific known subvendor:subdevice ids in its pci id table
> list.
>
> Reference: http://lkml.org/lkml/2009/6/16/552
>
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> ---
>  drivers/staging/comedi/drivers/s626.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index 30dec9d..b4b7713 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -110,9 +110,13 @@ static const struct s626_board s626_boards[] = {
>  #define PCI_VENDOR_ID_S626 0x1131
>  #define PCI_DEVICE_ID_S626 0x7146
>
> +/*
> + * Note: always specify subvendor:subdevice ids in table below, to avoid
> + * clash with Philips SAA7146 media/dvb based cards which have same
> + * vendor:device ids as S626
> + */
>  static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
> -       {PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> -               0},
> +       {PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, 0x6000, 0x0272, 0, 0, 0},
>         {0}
>  };
>
> --
> 1.6.3.2

There are also a couple of calls to pci_get_device() that need changing
to pci_get_subsys() in the s626_attach() function (so it also might be
worth #define'ing the subsys numbers to avoid repeating these magic
numbers).

--
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-


