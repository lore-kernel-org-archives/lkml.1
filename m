Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbXLJAuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbXLJAuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 19:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXLJAuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 19:50:03 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47993 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXLJAuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 19:50:00 -0500
Date: Mon, 10 Dec 2007 01:49:59 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Robert Hancock <hancockr@shaw.ca>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071210004959.GA23280@rhlx01.hs-esslingen.de>
References: <fa.qQhD8aJpiTOFaZqjRYwoaG7YT1c@ifi.uio.no> <fa.yaP86AixGhz5Q7eXSu04pIQp6ho@ifi.uio.no> <fa.c3k8VKWAx4HIo9zXWbL5Ek0oSBw@ifi.uio.no> <fa.C8ACnOhs8bXB++vmugf5F34JcJg@ifi.uio.no> <fa.5o6E6S0UWnARbQPxLe30TvLQIiY@ifi.uio.no> <475AE150.9050306@shaw.ca> <20071209213642.GA27096@rhlx01.hs-esslingen.de> <20071210000429.GA3916@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071210000429.GA3916@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 01:04:31AM +0100, Andreas Mohr wrote:
> IOW, it seems very likely that _GTM on these BIOSes (VIA chipsets) isn't
> actually wrongly implemented but simply expects IDE controller values
> to have been set up ""differently"".
> 
> 
> Or... one could possibly even infer from this that - maybe -
> the _GTM invocation spot is wrong, it should be done somewhere
> different during bootup. Or whatever.

"Whatever" indeed:

There's an ASL Match() for a "PMPT" (Primary Master PorT) PCI register,
and the possible register values are:

                    Package (0x04)
                    {
                        0x20,
                        0x31,
                        0x65,
                        0xA8
                    },

and from

                OperationRegion (CFG2, PCI_Config, 0x40, 0x20)
                Field (CFG2, DWordAcc, NoLock, Preserve)
                {
                            Offset (0x08),·
                    SSPT,   8,·
                    SMPT,   8,·
                    PSPT,   8,·
                    PMPT,   8,·
                            Offset (0x10),·
...
we can infer that at PCI_Config offset 0x48 those values should be located.
However after bootup or resume there are:

# lspci -s 00:11.1 -xxx
00:11.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00: 06 11 71 05 07 00 90 02 06 8a 01 01 00 20 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 e4 00 00 00 00 00 00 00 00 00 00 06 11 71 05
30: 00 00 00 00 c0 00 00 00 00 00 00 00 ff 01 00 00
40: 0b 32 09 0a 18 1c c0 00 99 99 20 20 ff 00 a8 20
50: 07 07 f6 f1 14 03 00 00 a8 a8 a8 a8 00 00 00 00
60: 00 02 00 00 00 00 00 00 00 02 00 00 00 00 00 00
70: 02 01 00 00 00 00 00 00 82 01 00 00 00 00 00 00
80: 00 e0 a1 1f 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 06 00 71 05 06 11 71 05 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 07 00 00 00 00 00 00 00 00 00


As one can see, the relevant values for SSPT, SMPT, PSPT and PMPT are
99 99 20 20, which are not quite entirely valid judging from the array above,
and this is because the secondary port is unused, as can also be seen
from my bootup log:

scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xe400 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xe408 irq 15
ata1.00: ATA-5: WDC WD1200JB-00CRA1, 17.07W17, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA
ata1.01: ATAPI: TOSHIBA DVD-ROM SD-M1612, 1004, max UDMA/33
Switched to high resolution mode on CPU 0
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFF) is beyond end of object [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.GTM_] (Node df80b9a8), AE_AML_PACKAGE_LIM
IT
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1._GTM] (Node df80b8d0), AE_AML_PACKAG
E_LIMIT
ata2: ACPI get timing mode failed (AE 0x300d)


Manually tweaking the values to 20 20 20 20 truly does skip the _GTM failure message on suspend -
only to reappear right on resume due to 99 99 20 20 combo happening again.
If I don't tweak, I get _GTM failure at both suspend and resume.


As such one can conclude that this BIOS is rather very confused when being called for _GTM on an entirely
unused controller port. And this is either because the BIOS is dumb or because ACPI doesn't really
expect anyone to call _GTM on an unused physical port. I'd bet on the latter...
(however I haven't found ACPI 3.0b explicitly mentioning this somewhere yet)

Andreas Mohr
