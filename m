Return-Path: <linux-kernel-owner+w=401wt.eu-S1762541AbXFENEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762541AbXFENEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbXFENEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:04:14 -0400
Received: from 25.mail-out.ovh.net ([213.186.37.103]:45699 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757061AbXFENEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:04:14 -0400
Date: 5 Jun 2007 13:04:07 -0000
To: linus.walleij@ericsson.com, arvidjaar@mail.ru
Subject: RE: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
X-IlohaMail-Blah: samuel@sortiz.org
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: OVH (On: ssl0.ovh.net)
Message-ID: <JweoxZIu.1181048647.6373490.samuel@sortiz.org>
In-Reply-To: <A6D19A13FE030A409EC4362C172E091F016F51B1@eseldmw101.eemea.ericsson.se>
From: "Samuel Ortiz" <samuel@sortiz.org>
Bounce-To: "Samuel Ortiz" <samuel@sortiz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "ambx1@neo.rr.com" <ambx1@neo.rr.com>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/5/2007, "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
wrote:

>Sam wrote:
>
>> Andrey, in addition to Bjorn's patch, could you also apply 
>> this one and try again:
>> 
>> diff --git a/drivers/net/irda/smsc-ircc2.c 
>> b/drivers/net/irda/smsc-ircc2.c index 31c6233..800562a 100644
>> --- a/drivers/net/irda/smsc-ircc2.c
>> +++ b/drivers/net/irda/smsc-ircc2.c
>> @@ -2463,7 +2463,7 @@ static struct 
>> smsc_ircc_subsystem_configuration subsystem_
>>                 .subvendor = 0x1179,
>>                 .subdevice = 0xffff, /* 0xffff is "any" */
>>                 .sir_io = 0x02e8,
>> -               .fir_io = 0x02f8,
>> +               .fir_io = 0x100,
>
>You don't need to alter the defaults for the Toshiba ALi, the 
>preconfigure will respect the settings from the commandline,
>e.g. modprobe smsc-ircc2 ircc_fir=0x100,ircc_sir=0x02e8.
True, that's faster.


>BUT this value just won't work: we don't know how to tell the ALi 1533
>to use any other ports than 0x130,0x178,0x03f8,0x02f8 or 0x02e8.
Oh, that's right. I didn't look carefully enough at
preconfigure_ali_port()...


>The code in preconfigure_ali_port() is from the smscinit tool
>and I have no idea of how that was initially developed (reverse
>engineering likely). Since 0x0130 and 0x170 seem to be the same setting,
>0x100 could be equal to one of the others as well so I would
>try feeding some different ircc_fir=x settings and see what happens.
>From the PnP output that Andrey sent, it seems that 0x130 might work.
If not, I guess it's worth trying at 0x100 while assuming it's the same
register setting as 0x130 or 0x178, so basically applying this patch on
top of Bjorn's one:

diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index 31c6233..0657228 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -2742,6 +2742,7 @@ static void __init preconfigure_ali_port(struct
pci_dev *d
        unsigned char tmpbyte;

        switch(port) {
+       case 0x0100:
        case 0x0130:
        case 0x0178:
                reg = 0xb0;

and then a modprobe smsc-ircc2 ircc_fir=0x100,ircc_sir=0x02e8

Cheers,
Samuel.
