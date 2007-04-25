Return-Path: <linux-kernel-owner+w=401wt.eu-S1423327AbXDYI4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423327AbXDYI4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423326AbXDYI4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:56:11 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423323AbXDYI4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:56:06 -0400
Date: Wed, 25 Apr 2007 01:55:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175
 init_sched_clock()
Message-Id: <20070425015559.e6ed537c.akpm@linux-foundation.org>
In-Reply-To: <462F1481.8010807@gmail.com>
References: <462E4C4D.9020806@gmail.com>
	<20070425011654.222a2b4b.akpm@linux-foundation.org>
	<462F1481.8010807@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 17:42:41 +0900 Tejun Heo <htejun@gmail.com> wrote:

> Andrew Morton wrote:
> >> [    2.953862] RIP: 0010:[<ffffffff803ae98b>]  [<ffffffff803ae98b>] scsi_schedule_eh+0xa/0x57
> >> [    3.058672]  [<ffffffff803e1e01>] ata_port_schedule_eh+0x4c/0x50
> >> [    3.064725]  [<ffffffff803e1ea7>] ata_port_abort+0xa2/0xae
> >> [    3.070248]  [<ffffffff803e1ef9>] ata_port_freeze+0x46/0x57
> >> [    3.075853]  [<ffffffff803e4c39>] ahci_interrupt+0x300/0x47a
> >> [    3.081552]  [<ffffffff8020eb83>] handle_IRQ_event+0x27/0x57
> >> [    3.087253]  [<ffffffff8029a021>] handle_edge_irq+0xee/0x133
> >> [    3.092960]  [<ffffffff8025f4e1>] do_IRQ+0x6d/0xd5
> >> [    3.097793]  [<ffffffff80255071>] ret_from_intr+0x0/0xa
> >> [    3.103059]  [<ffffffff8024e88b>] mwait_idle+0x46/0x4b
> >> [    3.108231]  [<ffffffff802422f4>] cpu_idle+0x87/0xaa
> >> [    3.113227]  [<ffffffff8025c988>] rest_init+0x49/0x4b
> >> [    3.118322]  [<ffffffff805dca5d>] start_kernel+0x291/0x29c
> >> [    3.123837]  [<ffffffff805dc13a>] _sinittext+0x13a/0x141
> >>
> > 
> > So we took an AHCI interrupt when ata_port.scsi_host was still NULL.
> > 
> > It appears that ATA is presently requesting its IRQ before allocating all
> > the resources which are needed to handle an interrupt.  Does this
> > (resource-leaky) patch fix things?
> 
> No, that would break host probing.  The port is in frozen (controller
> initialized and IRQs masked off) state, so it's not allowed to take
> interrupt.

Sounds dodgy.  What happens if the IRQ line is shared with some other
device?  We'll enter ahci_interrupt().  We've alread set up ->port_map and
->n_ports so we're wholly dependent upon that read from HOST_IRQ_STAT
returning zeroes.

        /* sigh.  0xffffffff is a valid return from h/w */

if that happens we're dead, aren't we?


>  If interrupt triggers at this point, it's low level driver
> bug.  Berck, how reliably can you reproduce this problem?  Can you post
> the result of 'lspci -nn'?

Berck doesn't apepar to be sharing that IRQ, so it'll be something else.

However do note that if CONFIG_DEBUG_SHIRQ is enabled, request_irq() will
deliberately run the handler, to catch buggy drivers.

