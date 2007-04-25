Return-Path: <linux-kernel-owner+w=401wt.eu-S1423307AbXDYImt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423307AbXDYImt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423298AbXDYImt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:42:49 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:2933 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423304AbXDYImr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rG2rc8KQ/jNE4PyDKTqYbi5kMRlisCvysg8ePHxLhj/MKScw0GenC0N4j6NsPqOdpWYug9ig4bwVRaKWvCi3kayz7NdwjQUIVHIpXdg3HeEq18zZOlWFzApd9fumVqZ5ryb1QEeNsEb9Or8TbbSWq7J0qwe+khDgo7sOuf/X4Js=
Message-ID: <462F1481.8010807@gmail.com>
Date: Wed, 25 Apr 2007 17:42:41 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175 init_sched_clock()
References: <462E4C4D.9020806@gmail.com> <20070425011654.222a2b4b.akpm@linux-foundation.org>
In-Reply-To: <20070425011654.222a2b4b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> [    2.953862] RIP: 0010:[<ffffffff803ae98b>]  [<ffffffff803ae98b>] scsi_schedule_eh+0xa/0x57
>> [    3.058672]  [<ffffffff803e1e01>] ata_port_schedule_eh+0x4c/0x50
>> [    3.064725]  [<ffffffff803e1ea7>] ata_port_abort+0xa2/0xae
>> [    3.070248]  [<ffffffff803e1ef9>] ata_port_freeze+0x46/0x57
>> [    3.075853]  [<ffffffff803e4c39>] ahci_interrupt+0x300/0x47a
>> [    3.081552]  [<ffffffff8020eb83>] handle_IRQ_event+0x27/0x57
>> [    3.087253]  [<ffffffff8029a021>] handle_edge_irq+0xee/0x133
>> [    3.092960]  [<ffffffff8025f4e1>] do_IRQ+0x6d/0xd5
>> [    3.097793]  [<ffffffff80255071>] ret_from_intr+0x0/0xa
>> [    3.103059]  [<ffffffff8024e88b>] mwait_idle+0x46/0x4b
>> [    3.108231]  [<ffffffff802422f4>] cpu_idle+0x87/0xaa
>> [    3.113227]  [<ffffffff8025c988>] rest_init+0x49/0x4b
>> [    3.118322]  [<ffffffff805dca5d>] start_kernel+0x291/0x29c
>> [    3.123837]  [<ffffffff805dc13a>] _sinittext+0x13a/0x141
>>
> 
> So we took an AHCI interrupt when ata_port.scsi_host was still NULL.
> 
> It appears that ATA is presently requesting its IRQ before allocating all
> the resources which are needed to handle an interrupt.  Does this
> (resource-leaky) patch fix things?

No, that would break host probing.  The port is in frozen (controller
initialized and IRQs masked off) state, so it's not allowed to take
interrupt.  If interrupt triggers at this point, it's low level driver
bug.  Berck, how reliably can you reproduce this problem?  Can you post
the result of 'lspci -nn'?

-- 
tejun
