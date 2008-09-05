Return-Path: <linux-kernel-owner+w=401wt.eu-S1751676AbYIEQbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbYIEQbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYIEQbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:31:35 -0400
Received: from h155.mvista.com ([63.81.120.155]:60743 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753136AbYIEQbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:31:34 -0400
Message-ID: <48C15F07.6000501@ru.mvista.com>
Date: Fri, 05 Sep 2008 20:32:07 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: =?UTF-8?B?Ik1hc291ZCBTaGFyYmlhbmkgXCLZhdiz2LnZiNivINi02LHYqNuM2KfZhtuM?=
	 =?UTF-8?B?XCIi?= <masouds@masoud.ir>,
       bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: HPT374 detection crash with 74811f355f4f69a187fa74892dcf2a684b84ce99
References: <1a9da18c0809041610tb3f2a58r6acd6f10a3d50a91@mail.gmail.com> <48C15B52.6020508@ru.mvista.com>
In-Reply-To: <48C15B52.6020508@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I just wrote:

>> Hi there, Looks like your commit 74811f355f4f69a187fa74892dcf2a684b84ce99
>>  (hpt366: convert to use ->host_priv)

>    Thanks for doing the bisection.

>> has caused the following crash:

>    Oops, we did it again. :-)

    Already seeing Bart's mistake, see below:

>> (Full dmesg follows, as captured from a serial console)

>> [   22.555200] hpt366: HPT374 chipset detected
>> [   22.559489] hpt366 0000:03:06.0: IDE controller (0x1103:0x0008 rev 0x07)
>> [   22.566278] HPT366_IDE 0000:03:06.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
>> [   22.573729] usb 1-2: new full speed USB device using uhci_hcd and address 4
>> [   22.580726] pci 0000:03:06.1: PCI INT A -> GSI 28 (level, low) -> IRQ 28
>> [   22.587529] hpt366 0000:03:06.0: DPLL base: 48 MHz, f_CNT: 142, assuming 33 MHz PCI
>> [   22.602705] hpt366 0000:03:06.0: using 50 MHz DPLL clock
>> [   22.608181] hpt366 0000:03:06.0: 100% native mode on irq 28
>> [   22.613831] hpt366 0000:03:06.1: no clock data saved by BIOS

>    Aha, HPT374 workaround for reading BIOS clock data didn't get executed.

>> [   22.731015] usb 1-2: configuration #1 chosen from 1 choice
>> [   22.737191] ata2.00: ATA-6: ST3120022A, 3.04, max UDMA/100
>> [   22.738880] hub 1-2:1.0: USB hub found
>> [   22.746597] ata2.00: 234441648 sectors, multi 16: LBA48
>> [   22.747804] hpt366 0000:03:06.1: DPLL base: 33 MHz, f_CNT: 139, assuming

>    Uh, I wonder where did it get those 33 MHz DPLL base -- there's 
> simply no such base.  Looks like memory addressed by .host_priv got 
> corrupt...

    No, that's just wrong pointer arithmetics there:

        struct hpt_info *info = host->host_priv + (hwif->dev == host->dev[1]);

The 'host_priv' is declared as 'void *', hence in case the condition abobe is 
true, there will be added only 1 to host->host_priv, not sizeof(struct 
hpt_info) as it should've been...

MBR, Sergei

