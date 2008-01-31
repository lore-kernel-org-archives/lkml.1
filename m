Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbYAaGvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbYAaGvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 01:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYAaGuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 01:50:52 -0500
Received: from eth6155.nsw.adsl.internode.on.net ([59.167.247.10]:60697 "EHLO
	sac.g2microsystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751061AbYAaGuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 01:50:51 -0500
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 01:50:50 EST
Message-ID: <47A16C47.5090703@g2microsystems.com>
Date: Thu, 31 Jan 2008 17:35:51 +1100
From: Farbod Nejati <farbodn@g2microsystems.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>,
       Pierre Ossman <drzeus-list@drzeus.cx>
CC: Philip Ryan <Philip.Ryan@g2microsystems.com>, linux-kernel@vger.kernel.org,
       "Chad O'Neill" <chad@g2microsystems.com>,
       Tom McDermott <tom.mcdermott@g2microsystems.com>
Subject: SDIO driver not receiving responses
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com> <1201630213-31900-2-git-send-email-hskinnemoen@atmel.com> <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

I'm having problems with the latest mmc_core.ko and sdhci.ko for 2.6.24. 
I've used both my development SDIO client and an off-the-shelf SDIO WIFI 
card. I have a Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter 
(rev 21).

The mmc_send_io_op_cond() function call in core.c::mmc_rescan() is 
returning with a -110 (a timeout error). I traced this deeper and 
noticed that CMD5 is being sent out via sdhci.c::sdhci_send_command() (I 
verified this using a logic analyser, the host *is* transmitting a CMD5 
[IO_SEND_OP_COND] packet in the correct format). However, when the 
client responds with the IO_SEND_OP_COND Response R4 (SD mode), it does 
not seem to be received by the host. Again, I verified using the logic 
analyser that the response is as would be expected. An IRQ *is* 
triggered, however it is 0x00018000 (SDHCI_INT_TIMEOUT|SDHCI_INT_ERROR). 
I'm not too familiar with Linux kernel programming but I suspect that 
whatever is waiting for a valid response is giving up instead and 
triggering the above-mentioned interrupt instead.

# lspci -v -s 15:00.2 -xxx
15:00.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 
SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
        Subsystem: Lenovo Unknown device 20c8
        Flags: medium devsel, IRQ 23
        Memory at f8101800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
00: 80 11 22 08 02 00 10 02 21 00 05 08 00 40 80 00
10: 00 18 10 f8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 c8 20
30: 00 00 00 00 80 00 00 00 00 00 00 00 0b 03 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 01 00 02 fe 00 40 00 48 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 c8 20
b0: 04 00 02 00 00 00 00 00 00 00 00 00 a0 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: a1 21 e0 01 00 00 00 00 40 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 d0 00 20 02 00 00 00 00

*** An interesting thing is, when I try to printk() values in the above 
table through the driver, I don't get identical values. I do this using 
the following code:
        for (i = 0; i < 16; i++)
        {
                for (k = 0; k < 16; k++)
                {
                        printk("%02x ", readb(host->ioaddr + (i*16) + k));
                }
                printk("\n");
        }

Why would the output of the above code differ from the one produced by 
lspci -xxx. Could this have something to do with this issue???

host->ioaddr is set to 0xF8A84800 (which is the output of 
ioremap_nocache(0xF8101800, 256)

Sections of /var/log/messages:
sdhci: SDHCI controller found at 0000:15:00.2 [1180:0822] (rev 21)
sdhci [sdhci_probe()]: found 1 slot(s)
ACPI: PCI Interrupt 0000:15:00.2[C] -> GSI 18 (level, low) -> IRQ 22
sdhci [sdhci_probe_slot()]: slot 0 at 0xf8101800, irq 22


I'm fresh out of ideas on this one and would greatly appreciate some 
hints or assistance. I'm happy to provide any further information if needed.

Regards
Farbod Nejati
