Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYIEQdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYIEQdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYIEQcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:32:50 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:48802 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbYIEQcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:32:48 -0400
Message-ID: <1a9da18c0809050932x1d42d74co64416bf4ce99d40b@mail.gmail.com>
Date: Fri, 5 Sep 2008 09:32:43 -0700
From: "=?UTF-8?Q?Masoud_Sharbiani?=
	=?UTF-8?Q?_\"=D9=85=D8=B3=D8=B9=D9=88=D8=AF_?=
	=?UTF-8?Q?=D8=B4=D8=B1=D8=A8=DB=8C=D8=A7=D9=86=DB=8C\"?=" 
	<masouds@masoud.ir>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: HPT374 detection crash with 74811f355f4f69a187fa74892dcf2a684b84ce99
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <48C15F07.6000501@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a9da18c0809041610tb3f2a58r6acd6f10a3d50a91@mail.gmail.com>
	 <48C15B52.6020508@ru.mvista.com> <48C15F07.6000501@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 9:32 AM, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> Hello, I just wrote:
>
>>> Hi there, Looks like your commit 74811f355f4f69a187fa74892dcf2a684b84ce99
>>>  (hpt366: convert to use ->host_priv)
>
>>   Thanks for doing the bisection.
>
>>> has caused the following crash:
>
>>   Oops, we did it again. :-)
>
>   Already seeing Bart's mistake, see below:
>
>>> (Full dmesg follows, as captured from a serial console)
>
>>> [   22.555200] hpt366: HPT374 chipset detected
>>> [   22.559489] hpt366 0000:03:06.0: IDE controller (0x1103:0x0008 rev
>>> 0x07)
>>> [   22.566278] HPT366_IDE 0000:03:06.0: PCI INT A -> GSI 28 (level, low)
>>> -> IRQ 28
>>> [   22.573729] usb 1-2: new full speed USB device using uhci_hcd and
>>> address 4
>>> [   22.580726] pci 0000:03:06.1: PCI INT A -> GSI 28 (level, low) -> IRQ
>>> 28
>>> [   22.587529] hpt366 0000:03:06.0: DPLL base: 48 MHz, f_CNT: 142,
>>> assuming 33 MHz PCI
>>> [   22.602705] hpt366 0000:03:06.0: using 50 MHz DPLL clock
>>> [   22.608181] hpt366 0000:03:06.0: 100% native mode on irq 28
>>> [   22.613831] hpt366 0000:03:06.1: no clock data saved by BIOS
>
>>   Aha, HPT374 workaround for reading BIOS clock data didn't get executed.
>
>>> [   22.731015] usb 1-2: configuration #1 chosen from 1 choice
>>> [   22.737191] ata2.00: ATA-6: ST3120022A, 3.04, max UDMA/100
>>> [   22.738880] hub 1-2:1.0: USB hub found
>>> [   22.746597] ata2.00: 234441648 sectors, multi 16: LBA48
>>> [   22.747804] hpt366 0000:03:06.1: DPLL base: 33 MHz, f_CNT: 139,
>>> assuming
>
>>   Uh, I wonder where did it get those 33 MHz DPLL base -- there's simply
>> no such base.  Looks like memory addressed by .host_priv got corrupt...
>
>   No, that's just wrong pointer arithmetics there:
>
>       struct hpt_info *info = host->host_priv + (hwif->dev == host->dev[1]);
>
> The 'host_priv' is declared as 'void *', hence in case the condition abobe
> is true, there will be added only 1 to host->host_priv, not sizeof(struct
> hpt_info) as it should've been...
>

Hey I can try that now....stay tuned.

Masoud
> MBR, Sergei
>
>
