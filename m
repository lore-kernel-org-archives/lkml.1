Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYAUWvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYAUWvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYAUWvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:51:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:4882 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYAUWvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:51:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XRFlFezxU6CoQVZR8Un3ICW8RA0X6qw4V7o22IsaYtWSO0wnDFOX1+YVojyIOQgipyCCfHBHlINatvihjldXq26IAeShqFiIEEFBJYZ2YA5SSX/D1YF0BCbjBpAkcGazbt/RCyN40y0JwmfpwsYj8vgyJ94TJg8CSO62kKAoWO4=
Message-ID: <479521F7.9050701@gmail.com>
Date: Mon, 21 Jan 2008 23:51:35 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?w5h5dmluZCBBYWJsaW5n?= <Oyvind.Aabling@uni-c.dk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/moxa.c, kernel 2.6.23.14
References: <Pine.LNX.4.64.0801202145230.18101@dbs1.uni-c.dtu.dk>
In-Reply-To: <Pine.LNX.4.64.0801202145230.18101@dbs1.uni-c.dtu.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2008 10:45 PM, Øyvind Aabling wrote:
> moxa.c changes to MOXA_GET_CONF ioctl breaks moxaload (userspace
> application for firmware download to MOXA Intellio CPU boards).
> 
> Attached (and included inline below) is a patch to solve a problem
> introduced by changes to struct moxa_board_conf in drivers/char/moxa.c.
> 
> AFAICS from the changelogs, moxa.c was rewritten to a new API in 2.6.21,
> but I've only tested it (and moxaload) on kernels up to 2.6.19.2
> (where it works) and on 2.6.22.6 and various later kernels,
> including the latest (2.6.23.14), where it doesn't work.
> 
> Steps to reproduce:
> 
> Call the moxaload program (from MOXA) to download the firmware.

Thanks for pointing this out.

> moxaload will fail on most systems (all the ones I've tried), because it
> thinks there is a memory conflict, although this behaviour will depend
> on the exact contents of struct moxa_board_conf (in drivers/char/moxa.c).
> 
> The problem is, that moxaload uses the MOXA_GET_CONF ioctl,
> which returns (verbatim) the contents of struct moxa_board_conf,
> the structure (and contents) of which has changed heavily.
> 
> This patch corrects this problem by reverting the behaviour of the
> MOXA_GET_CONF ioctl, so it returns the info that moxaload expects.
> 
> I'm not on the kernel list, so please CC:
> me with any questions and/or comments.
> 
> To Jiri Slaby <jirislaby@gmail.com>:
> 
> I've CC'ed this to you, although linux/MAINTAINERS doesn't
> mention you as the maintainer of moxa.c, since the changelogs
> seems to indicate, that you're the current maintainer.
> 
> linux/MAINTAINERS mentions you (Jiri) as the maintainer
> of mxser, but that is the driver for other MOXA
> boards, so I hope that I've guessed right ...

Yeah, at least I know what's the problem about :).

> --- linux-2.6.23.14/drivers/char/moxa.c    2008-01-14 21:49:56.000000000 
> +0100
> +++ linux/drivers/char/moxa.c    2008-01-20 18:30:15.000000000 +0100
> @@ -109,6 +109,8 @@
>      int busType;
> 
>      int loadstat;
> +    unsigned short busNum;
> +    unsigned short devNum;
> 
>      void __iomem *basemem;
>      void __iomem *intNdx;
> @@ -116,6 +118,16 @@
>      void __iomem *intTable;
>  } moxa_boards[MAX_BOARDS];
> 
> +/* Used by userspace application moxaload (firmware download) */
> +static struct moxa_board_info {
> +    int boardType;
> +    int numPorts;
> +    unsigned long baseAddr;
> +    int busType;
> +    unsigned short busNum;
> +    unsigned short devNum;
> +} moxa_board_info[MAX_BOARDS];
> +

Hrm, too ugly (sadly as same as it was).

- not 32/64 bit compatible due to the ulong there.
- not exported to the world via include/linux (the reason why I removed it, they 
use something, which they know nothing about).
- I would rather see true firmware loading.

Would you be willing to test such a patch for point no. 3?

>  struct mxser_mstatus {
>      tcflag_t cflag;
>      int cts;
> @@ -304,6 +316,9 @@
>          goto err;
> 
>      board->boardType = board_type;
> +    board->baseAddr = pci_resource_start(pdev, 2);

you missed isa cards...

> +    board->busNum = pdev->bus->number;
> +    board->devNum = PCI_SLOT(pdev->devfn);
>      switch (board_type) {
>      case MOXA_BOARD_C218_ISA:
>      case MOXA_BOARD_C218_PCI:
> @@ -1494,8 +1509,16 @@
>      }
>      switch (cmd) {
>      case MOXA_GET_CONF:
> -        if(copy_to_user(argp, &moxa_boards, MAX_BOARDS *
> -                sizeof(struct moxa_board_conf)))
> +        for (i = 0; i < MAX_BOARDS; i++) {
> +            moxa_board_info[i].boardType = moxa_boards[i].boardType;
> +            moxa_board_info[i].numPorts  = moxa_boards[i].numPorts;
> +            moxa_board_info[i].baseAddr  = moxa_boards[i].baseAddr;
> +            moxa_board_info[i].busType   = moxa_boards[i].busType;
> +            moxa_board_info[i].busNum    = moxa_boards[i].busNum;
> +            moxa_board_info[i].devNum    = moxa_boards[i].devNum;
> +        }
> +        if(copy_to_user(argp, &moxa_board_info, MAX_BOARDS *
> +                sizeof(struct moxa_board_info)))
>              return -EFAULT;
>          return (0);
>      case MOXA_INIT_DRIVER:

thanks,
--js
