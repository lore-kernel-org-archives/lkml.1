Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbYF1KbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbYF1KbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 06:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbYF1Kar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 06:30:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:38469 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755421AbYF1Kap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 06:30:45 -0400
Message-ID: <486612CC.3060505@ru.mvista.com>
Date: Sat, 28 Jun 2008 14:30:36 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with	preemptable
 hardirqs
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <20080628005436.GA1956@polina.dev.rtsoft.ru>
In-Reply-To: <20080628005436.GA1956@polina.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Anton Vorontsov wrote:
> IDE interrupt handler relies on the fact that, if necessary, hardirqs
> will re-trigger on ISR exit. The assumption is valid for level sensitive
> interrupts.
>   

   It's valid for both edge and level triggered interrupts.

> But some hardware (namely ULi M5228 in the ULi M1575 "Super South Brige")
> behaves in a strange way: it asserts interrupts as edge sensitive. And
> because preemptable IRQ handler disables PIC's interrupt, PIC will likely
> miss it.
>   

   Unmasking an IRQ should re-enable an edge detector in a PIC (or that 
detector should even be independent from mask). So, unless an IRQ signal 
is a short pulse (which shouldn't be the case for IDE) it shouldn't be 
missed.

> This patch fixes following issue:
>
> ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc8) at  PCI slot 0001:03:1f.0
> ALI15X3: 100% native mode on irq 18
> ide0: BM-DMA at 0x1120-0x1127, BIOS settings: hda:PIO, hdb:PIO
> ide1: BM-DMA at 0x1128-0x112f, BIOS settings: hdc:PIO, hdd:PIO
> hda: Optiarc DVD RW AD-7190A, ATAPI CD/DVD-ROM drive
> hda: UDMA/66 mode selected
> ide0 at 0x1100-0x1107,0x110a on irq 18
> ide-cd: cmd 0x5a timed out
> hda: lost interrupt
> hda: ATAPI 12X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
> Uniform CD-ROM driver Revision: 3.20
> ide-cd: cmd 0x3 timed out
> hda: lost interrupt
> ide-cd: cmd 0x3 timed out
> hda: lost interrupt
> ...
>
> It would be great to re-configure the ULi bridge or ULi IDE controller
> to behave sanely, but no one knows how or if this is possible at all
> (no available specifications).
>
> So.. to workaround the issue IDE interrupt handler should re-check for
> any pending IRQs. This isn't bulletproof solution, but it works and this
> is the best one we can do

   I remembered a pssible issue with such code: it's possible that BSY 
bit will be cleared before INTRQ assertion (this is a race not spotted 
for a long time by the ATA standards -- and an observed behavior, at 
least of some ATAPI drives), thus a status register read won't clear the 
"interrupt pending" condition within drive.

MBR, Sergei


