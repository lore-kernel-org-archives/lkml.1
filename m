Return-Path: <linux-kernel-owner+w=401wt.eu-S937019AbZAPXPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937019AbZAPXPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934112AbZAPXOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:14:45 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5113 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933995AbZAPXOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:14:43 -0500
Message-ID: <497114A5.3030401@caviumnetworks.com>
Date: Fri, 16 Jan 2009 15:13:41 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20090116152721.GA6994@havoc.gtf.org> <20090116093101.6d77b69b.akpm@linux-foundation.org> <4970DE4A.8030900@caviumnetworks.com>
In-Reply-To: <4970DE4A.8030900@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 23:13:41.0472 (UTC) FILETIME=[12218600:01C97830]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney wrote:
> Andrew Morton wrote:
>> On Fri, 16 Jan 2009 10:27:21 -0500 Jeff Garzik <jeff@garzik.org> wrote:

> [...]
>>>
>>> +static irqreturn_t octeon_cf_interrupt(int irq, void *dev_instance)
>>> +{
>>> +    struct ata_host *host = dev_instance;
>>> +    struct octeon_cf_port *cf_port;
>>> +    int i;
>>> +    unsigned int handled = 0;
>>> +    unsigned long flags;
>>> +
>>> +    spin_lock_irqsave(&host->lock, flags);
>>
>> Would spin_lock() suffice here?
> 
> I have to think about that one.
> 

The answer is an empirically determined No.

After switching to a spin_lock() as you suggested, I get:

BUG: spinlock recursion on CPU#0, pata_octeon_cf/700
  lock: a80000041e8bd218, .magic: dead4ead, .owner: pata_octeon_cf/700, 
.owner_cpu: 0
Call Trace:
[<ffffffffc000c3ec>] dump_stack+0x8/0x34
[<ffffffffc01b9a14>] _raw_spin_lock+0xdc/0x1b0
[<ffffffffc0211680>] ata_scsi_queuecmd+0x40/0x2d8
[<ffffffffc01f4358>] scsi_dispatch_cmd+0x108/0x280
[<ffffffffc01fa778>] scsi_request_fn+0x3a0/0x4a0
[<ffffffffc019a2ec>] blk_invoke_request_fn+0xd4/0x1c0
[<ffffffffc019a9f8>] blk_run_queue+0x28/0x48
[<ffffffffc01f9b74>] scsi_run_queue+0xf4/0x398
[<ffffffffc01faafc>] scsi_next_command+0x3c/0x58
[<ffffffffc01fb7e4>] scsi_io_completion+0x344/0x520
[<ffffffffc019f8a8>] blk_done_softirq+0x98/0xb8
[<ffffffffc004dc18>] __do_softirq+0xd8/0x1f8
[<ffffffffc004ddc0>] do_softirq+0x88/0xa0
[<ffffffffc004e084>] irq_exit+0xac/0xd0
[<ffffffffc0011090>] plat_irq_dispatch+0x100/0x200
[<ffffffffc0000980>] ret_from_irq+0x0/0x4
[<ffffffffc019fa84>] __blk_complete_request+0x114/0x140
[<ffffffffc020f1a8>] ata_scsi_qc_complete+0x1b8/0x400
[<ffffffffc0219dec>] ata_sff_hsm_move+0x10c/0x860
[<ffffffffc021cb20>] octeon_cf_dma_finished+0x188/0x228
[<ffffffffc021ccd8>] octeon_cf_delayed_finish+0x118/0x138
[<ffffffffc005cf94>] run_workqueue+0xcc/0x1a8
[<ffffffffc005d448>] worker_thread+0x60/0xd0
[<ffffffffc0062058>] kthread+0x58/0xa8
[<ffffffffc001a020>] kernel_thread_helper+0x10/0x18

Apparently scsi_io_completion() is called from a softirq, so calls to 
ata_sff_hsm_move() must be done with interrupts disabled so that a 
softirq on the same CPU doesn't deadlock with itself.

I am sure you all will correct me if my interpretation of the trace is 
incorrect.

David Daney
