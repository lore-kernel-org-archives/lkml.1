Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbXFSOFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbXFSOFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbXFSOF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:05:28 -0400
Received: from h155.mvista.com ([63.81.120.155]:37604 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754840AbXFSOF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:05:26 -0400
Message-ID: <4677E30B.4020101@ru.mvista.com>
Date: Tue, 19 Jun 2007 18:07:07 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: linas@austin.ibm.com
Cc: Stuart_Hayes@Dell.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
References: <20070618175713.GD5836@austin.ibm.com> <DFEF91B22ED07447AB6AA4B237F913F9B18A05@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9B18A05@ausx3mpc125.aus.amer.dell.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Stuart_Hayes@Dell.com wrote:
> I think reading the IDE status register clears the interrupt in the IDE
> device, which might be causing the drive to think it's OK to generate
> another interrupt.

    This is not how IDE drives are supposed to act -- they won't proceed any 
further until "interrupt pending" condition is cleared, so these aren't 
supposed to be "stacked". This behavior however is not strictly specified by 
ATA standards IIRC, but I can't readily imagine such situaltion anyway unless 
tagged command queueing  (which is not supported by IDE core) and/or ATAPI 
command overlapping is in action...

>  This could either cause it to get stuck trying to
> service an interrupt that is never getting cleared as you suggested, or
> possibly when the next IRQ comes in the IDE IRQ handler gets stuck
> waiting for a spinlock that the code you're looking at already owns...?

    I could also imagine the HPT366 chip going mad and stalling the reads if 
the taskfile regs forever because of the incomplete DMA or even the drive 
going mad and not replying to I/O cycles with proper -IORDY handshake (i.e. 
holding it low all the time)...

> Perhaps a printk in the IDE IRQ handler would be informative?  It
> wouldn't help you figure out how it got where it is, but it might help
> you figure out why the system is hanging.

> Stuart

> -----Original Message-----
> From: linux-ide-owner@vger.kernel.org
> [mailto:linux-ide-owner@vger.kernel.org] On Behalf Of Linas Vepstas
> Sent: Monday, June 18, 2007 12:57 PM
> To: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [BUG] ide dma_timer_expiry, then hard lockup

> I've got a hard lockup in the ide subsystem, probably due to some irq
> spew or something like that.
> 
> I've just bought a brand new Maxtor 320GB disk driver for the insane
> price of $70 US to replace another failing drive. It works well under
> light load; I was able to copy about 60GB to it. However, under heavy
> load, such as reconstruction of an MD
> RAID-1 array, it'll lock up the kernel.  Which means that my system
> won't boot :-(
> 
> I'm running 2.6.21.1, although the problem seems to occur in 2.6.19 and
> 2.6.18 too; its been there a while; I vageuly remember similar problems
> in 2.6.5 or 2.6.10.
> 
> I get an
> "hdc: dma_timer_expiry: dma status == 0x21" 

    This means "DMA not complete".

> and 10 seconds later,

    The above condition causes another, 10 sec timeout...

> "hdc: DMA Timeout error"

> at which point the system is locked up hard.
> Magic sysreq does not work at all. The hard drive activity light stays
> fully lit.  Inserting printk's into the kernel, I find the hang to be in
> a surprising place: 

> ide_dma_timeout_retry() in ide-io.c 
>   prints the "hdc: DMA Timeout error" then calls
>   HWIF(drive)->ide_dma_end(drive);
>     which returns, and then calls 
>   hwif->INB(IDE_STATUS_REG) which is needed as an argument to
> ide_error()

> But this hangs! -- The INB never returns.
> Now:  hwif->INB = ide_inb; in ide-iops.c

> So putting a printk into ide_inb() shows that
> the printk before the readb() is printed, and the
> printk after the readb is not (!!)

> I find this rather surpriseing, as I can't imagine how the
> readb can fail. My current vague theory is that doing this
> readb makes the hard drive go really nuts, and it probably

    As I said, this is not the only way how it all might have gone nuts... :-)

> ties some interrupt line high, and so the linux kernel 
> gets stuck trying to handle the irq flood. I just don't know
> enough about the i386 architecture, or about interrupts, to 
> prove or disprove this.

> Any suggestions, experiments, experimental patches, data gathering,
> etc. is welcome. The sooner, the better... 

> --linas

MBR, Sergei
