Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbYF1BJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbYF1BJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 21:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYF1BJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 21:09:31 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:8804 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753368AbYF1BJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 21:09:30 -0400
Date: Sat, 28 Jun 2008 05:09:28 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with
	preemptable hardirqs
Message-ID: <20080628010928.GA4248@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080623234037.GA6793@polina.dev.rtsoft.ru> <20080623235141.GB17297@elte.hu> <20080624000016.GA12547@polina.dev.rtsoft.ru> <20080625123431.GA25452@polina.dev.rtsoft.ru> <20080628005436.GA1956@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080628005436.GA1956@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 04:54:36AM +0400, Anton Vorontsov wrote:
> IDE interrupt handler relies on the fact that, if necessary, hardirqs
> will re-trigger on ISR exit. The assumption is valid for level sensitive
> interrupts.
> 
> But some hardware (namely ULi M5228 in the ULi M1575 "Super South Brige")
> behaves in a strange way: it asserts interrupts as edge sensitive. And
> because preemptable IRQ handler disables PIC's interrupt, PIC will likely
> miss it.
> 
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

Btw, thanks to Jeff Garzik for mentioning this link:

http://gkernel.sourceforge.net/specs/

Though, from a brief glance there is nothing much useful for this ULi
chip. The only thing I gathered is that IDE controller does not provide
any means of configuring its IRQs behaviour, so it is indeed ULi's bridge
problems. It doesn't change anything, just another data point...

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
