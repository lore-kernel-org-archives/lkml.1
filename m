Return-Path: <linux-kernel-owner+w=401wt.eu-S934544AbZDHTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544AbZDHTua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764916AbZDHTuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:50:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51104 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763555AbZDHTuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:50:07 -0400
Message-ID: <49DCFFE5.7080807@garzik.org>
Date: Wed, 08 Apr 2009 15:49:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dustin Harrison <d.harrison@sutus.com>, Tejun Heo <htejun@gmail.com>
CC: Sagar Borikar <sagar.borikar@gmail.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] sata_sil: disable DMA engine in ->freeze
References: <20090407232247.GA16086@havoc.gtf.org>	 <20090407232331.GA16190@havoc.gtf.org> <3fb94e50904072213n637525b1w4b032544dcef3618@mail.gmail.com> <49DC3357.3030703@garzik.org> <49DCFCEE.7040000@sutus.com>
In-Reply-To: <49DCFCEE.7040000@sutus.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dustin Harrison wrote:
> Jeff Garzik wrote:
>> Sagar Borikar wrote:
>>> This patch works for our platform.
>>
>> Did you try both patches together?  Both are required for the solution.
>>
> Thanks for updating the patch Jeff.  I see you spotted the reason why I 
> didn't put the code into sil_freeze.  I tested your patch and it 
> prevented the kernel panic.  I now get the following output, which seems 
> to be correct to me.
> 
> WARNING: at drivers/ata/libata-core.c:5209 ata_qc_complete()

hum, my patch would indeed trigger this WARN_ON_ONCE() in ata_qc_complete():

         if (ap->ops->error_handler) {
                 struct ata_device *dev = qc->dev;
                 struct ata_eh_info *ehi = &dev->link->eh_info;

                 WARN_ON_ONCE(ap->pflags & ATA_PFLAG_FROZEN);

Tejun, was that WARN_ON() originally added to detect spurious callers? 
Or, completions after the EH started?

AFAICS, libata still owns the qc's at this point, so it should not be a 
problem to complete them when the port is frozen.

	Jeff




> Call Trace:
> [<80107ed0>] dump_stack+0x8/0x34
> [<802f92e0>] ata_qc_complete+0x58/0x114
> [<80303aec>] ata_port_abort+0xc4/0x104
> [<80306870>] sil_interrupt+0x340/0x384
> [<80146cc0>] handle_IRQ_event+0x54/0xb8
> [<80146dc0>] __do_IRQ+0x9c/0x11c
> [<80102670>] ll_sutuspci_irq+0xe8/0x158
> [<8010161c>] do_extended_irq+0xa0/0x104
> [<80102b94>] ret_from_irq+0x0/0x4
> [<8029c4fc>] both_aligned+0x1c/0x64
> [<8014a9a4>] file_read_actor+0xac/0x154
> [<8014a564>] do_generic_mapping_read+0x210/0x5a4
> [<8014ce98>] generic_file_aio_read+0x180/0x1d4
> [<8016cba4>] do_sync_read+0xc4/0x128
> [<8016ccbc>] vfs_read+0xb4/0x154
> [<8016d02c>] sys_read+0x54/0x98
> [<8010a620>] stack_done+0x20/0x3c
