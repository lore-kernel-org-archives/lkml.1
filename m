Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYAVKX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYAVKX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbYAVKXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:23:49 -0500
Received: from dbs1.uni-c.dtu.dk ([130.225.88.6]:45380 "HELO dbs1.uni-c.dtu.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757039AbYAVKXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:23:48 -0500
From: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Date: Tue, 22 Jan 2008 11:23:45 +0100 (CET)
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/moxa.c, kernel 2.6.23.14
In-Reply-To: <479521F7.9050701@gmail.com>
Message-ID: <Pine.LNX.4.64.0801221042270.19094@dbs1.uni-c.dtu.dk>
References: <Pine.LNX.4.64.0801202145230.18101@dbs1.uni-c.dtu.dk>
 <479521F7.9050701@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511572392-618451797-1200997425=:19094"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511572392-618451797-1200997425=:19094
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 21 Jan 2008, Jiri Slaby wrote:

> On 01/20/2008 10:45 PM, =D8yvind Aabling wrote:
>> moxa.c changes to MOXA_GET_CONF ioctl breaks moxaload (userspace
>> application for firmware download to MOXA Intellio CPU boards).
>>=20
>> Attached (and included inline below) is a patch to solve a problem
>> introduced by changes to struct moxa_board_conf in drivers/char/moxa.c.
>>=20
>> AFAICS from the changelogs, moxa.c was rewritten to a new API in 2.6.21,
>> but I've only tested it (and moxaload) on kernels up to 2.6.19.2
>> (where it works) and on 2.6.22.6 and various later kernels,
>> including the latest (2.6.23.14), where it doesn't work.
>>=20
>> Steps to reproduce:
>>=20
>> Call the moxaload program (from MOXA) to download the firmware.
>
> Thanks for pointing this out.
>
>> moxaload will fail on most systems (all the ones I've tried), because it
>> thinks there is a memory conflict, although this behaviour will depend
>> on the exact contents of struct moxa_board_conf (in drivers/char/moxa.c)=
=2E
>>=20
>> The problem is, that moxaload uses the MOXA_GET_CONF ioctl,
>> which returns (verbatim) the contents of struct moxa_board_conf,
>> the structure (and contents) of which has changed heavily.
>>=20
>> This patch corrects this problem by reverting the behaviour of the
>> MOXA_GET_CONF ioctl, so it returns the info that moxaload expects.
>>=20
>> I'm not on the kernel list, so please CC:
>> me with any questions and/or comments.
>>=20
>> To Jiri Slaby <jirislaby@gmail.com>:
>>=20
>> I've CC'ed this to you, although linux/MAINTAINERS doesn't
>> mention you as the maintainer of moxa.c, since the changelogs
>> seems to indicate, that you're the current maintainer.
>>=20
>> linux/MAINTAINERS mentions you (Jiri) as the maintainer
>> of mxser, but that is the driver for other MOXA
>> boards, so I hope that I've guessed right ...
>
> Yeah, at least I know what's the problem about :).

:-)

>> --- linux-2.6.23.14/drivers/char/moxa.c    2008-01-14 21:49:56.000000000=
=20
>> +0100
>> +++ linux/drivers/char/moxa.c    2008-01-20 18:30:15.000000000 +0100
>> @@ -109,6 +109,8 @@
>>      int busType;
>>
>>      int loadstat;
>> +    unsigned short busNum;
>> +    unsigned short devNum;
>>
>>      void __iomem *basemem;
>>      void __iomem *intNdx;
>> @@ -116,6 +118,16 @@
>>      void __iomem *intTable;
>>  } moxa_boards[MAX_BOARDS];
>>=20
>> +/* Used by userspace application moxaload (firmware download) */
>> +static struct moxa_board_info {
>> +    int boardType;
>> +    int numPorts;
>> +    unsigned long baseAddr;
>> +    int busType;
>> +    unsigned short busNum;
>> +    unsigned short devNum;
>> +} moxa_board_info[MAX_BOARDS];
>> +
>
> Hrm, too ugly (sadly as same as it was).

Well, yes, it's ugly, but anything else breaks moxaload ...

> - not 32/64 bit compatible due to the ulong there.
> - not exported to the world via include/linux (the reason why I removed i=
t,=20
> they use something, which they know nothing about).
> - I would rather see true firmware loading.
>
> Would you be willing to test such a patch for point no. 3?

Yes, I could do that.

I can see your point about the non-portability of it, but
how about this scenario, to provide backwards compatibility:

* We keep the (ugly and non-compatible) MOXA_GET_CONF
   ioctl, to avoid breaking the old moxaload.
   Let's rename it to MOXA_GET_CONF_OLD or MOXA_GET_CONF_BAD in the driver.
* Create a new MOXA_GET_CONF ioctl (with a new
   number, of course), that does it "the right way".
   If you don't like renaming ioctl's, we need a new name for this one.
* Rewrite moxaload to either do a kernel version check
   and use the new ioctl if available or the old if not.
   Or skip that and let it call the new ioctl first.
   If it succeeds (system running a newer kernel): fine, and
   if not (system running an older kernel), use the old ioctl.

The MOXA Intellio driver and moxaload have been "broken" ever since they
were written in 1999, and this way, we don't break anything - you can
use old or new kernel, and old or new moxaload in any combination.

Whaddaya think ?

>>  struct mxser_mstatus {
>>      tcflag_t cflag;
>>      int cts;
>> @@ -304,6 +316,9 @@
>>          goto err;
>>
>>      board->boardType =3D board_type;
>> +    board->baseAddr =3D pci_resource_start(pdev, 2);
>
> you missed isa cards...

Oops, you're right, I don't have any ISA cards,
so I totally forgot about those dinosaurs :-)
The necessary code is available in the old
version of moxa.c, so it's easily fixed.

I guess ISA isn't _quite_ dead yet, although I don't think I have a
single system with ISA cards (or even ISA slots) in it anymore ...

>> +    board->busNum =3D pdev->bus->number;
>> +    board->devNum =3D PCI_SLOT(pdev->devfn);
>>      switch (board_type) {
>>      case MOXA_BOARD_C218_ISA:
>>      case MOXA_BOARD_C218_PCI:
>> @@ -1494,8 +1509,16 @@
>>      }
>>      switch (cmd) {
>>      case MOXA_GET_CONF:
>> -        if(copy_to_user(argp, &moxa_boards, MAX_BOARDS *
>> -                sizeof(struct moxa_board_conf)))
>> +        for (i =3D 0; i < MAX_BOARDS; i++) {
>> +            moxa_board_info[i].boardType =3D moxa_boards[i].boardType;
>> +            moxa_board_info[i].numPorts  =3D moxa_boards[i].numPorts;
>> +            moxa_board_info[i].baseAddr  =3D moxa_boards[i].baseAddr;
>> +            moxa_board_info[i].busType   =3D moxa_boards[i].busType;
>> +            moxa_board_info[i].busNum    =3D moxa_boards[i].busNum;
>> +            moxa_board_info[i].devNum    =3D moxa_boards[i].devNum;
>> +        }
>> +        if(copy_to_user(argp, &moxa_board_info, MAX_BOARDS *
>> +                sizeof(struct moxa_board_info)))
>>              return -EFAULT;
>>          return (0);
>>      case MOXA_INIT_DRIVER:
>
> thanks,
> --js

=D8yvind.

**************************************************************************
* =D8yvind Aabling     E-mail : Oyvind.Aabling@uni-c.dk    /~\ The ASCII   =
*
* UNI-C Lyngby       Phone  : +45 35 87 88 89            \ / Ribbon      *
* DTU Building 304   Phone  : +45 35 87 89 51 (direct)    X  Campaign    *
* DK-2800 LYNGBY     Fax    : +45 35 87 89 90            / \ Against     *
* Denmark                                                    HTML Email! *
**************************************************************************
---511572392-618451797-1200997425=:19094--
