Return-Path: <linux-kernel-owner+w=401wt.eu-S1422843AbXD3DAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422843AbXD3DAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 23:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422832AbXD3DAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 23:00:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:4117 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422782AbXD3DAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 23:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=caINv3pmHt7LV/b/uM3TM4oPCQHhSbCSyeNyjDyt9aJCATcWc3qThIi+D/3ZpAj7DonxaHNlYgpBISXb6KKSJpoYLjS/RsCtOROZ0kV7FRJWVPl2p6+EseHQBwMHllf3KisfraLd7nDV3RAKKIHa39EVh8XdiQbfdCcvFhG9VHI=
Message-ID: <46354620.4060902@gmail.com>
Date: Mon, 30 Apr 2007 10:28:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "Berck E. Nash" <flyboy@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175 init_sched_clock()
References: <462E4C4D.9020806@gmail.com> <20070425011654.222a2b4b.akpm@linux-foundation.org> <462F1481.8010807@gmail.com> <20070425085432.GD17130@htj.dyndns.org> <20070425093044.GE17130@htj.dyndns.org> <462FE982.7030906@gmail.com>
In-Reply-To: <462FE982.7030906@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Berck E. Nash wrote:
> Okay, while this patch allows my system to boot, it eventually crashed.
>  Unfortunately, I don't know enough to know if this crash is at all
> related, but it seems like it might be?
> 
> [ 1314.960784] irq 316: nobody cared (try booting with the "irqpoll" option)
> [ 1314.967602]
> [ 1314.967602] Call Trace:
> [ 1314.971566]  [<ffffffff8025dae3>] dump_trace+0xb6/0x3d6
> [ 1314.976809]  [<ffffffff8025de3f>] show_trace+0x3c/0x52
> [ 1314.981963]  [<ffffffff8025de6a>] dump_stack+0x15/0x17
> [ 1314.987118]  [<ffffffff802993c8>] __report_bad_irq+0x38/0x7c
> [ 1314.992790]  [<ffffffff802995db>] note_interrupt+0x1cf/0x215
> [ 1314.998463]  [<ffffffff8029a037>] handle_edge_irq+0x104/0x133
> [ 1315.004231]  [<ffffffff8025f4e1>] do_IRQ+0x6d/0xd5
> [ 1315.009039]  [<ffffffff80255071>] ret_from_intr+0x0/0xa
> [ 1315.014281]  [<ffffffff8024e88b>] mwait_idle+0x46/0x4b
> [ 1315.019433]  [<ffffffff802422f4>] cpu_idle+0x87/0xaa
> [ 1315.024414]  [<ffffffff8025c988>] rest_init+0x49/0x4b
> [ 1315.029489]  [<ffffffff805dca5d>] start_kernel+0x291/0x29c
> [ 1315.034989]  [<ffffffff805dc13a>] _sinittext+0x13a/0x141
> [ 1315.040323]
> [ 1315.041813] handlers:
> [ 1315.044090] [<ffffffff803e4951>] (ahci_interrupt+0x0/0x47a)
> [ 1315.049722] Disabling IRQ #316
> [ 1345.037254] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> frozen
> [ 1345.044333] ata1.00: cmd c8/00:08:ff:53:00/00:00:00:00:00/e2 tag 0
> cdb 0x0 data 4096 in
> [ 1345.044334]          res 40/00:00:76:5a:00/00:00:00:00:00/e0 Emask
> 0x4 (timeout)
> [ 1345.059832] ata3.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
> frozen
> [ 1345.066919] ata3.00: cmd 60/08:00:bb:26:0a/00:00:09:00:00/40 tag 0
> cdb 0x0 data 4096 in
> [ 1345.066920]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [ 1345.389731] ata1: soft resetting port
> [ 1345.396451] ata3: soft resetting port

Hmmm... Once properly initialized, ahci is highly unlikely to cause
runaway IRQs which results in nobody cared.  It has proper IRQ mask and
pending bits allowing the driver to reliably detect when and why the
controller is raising interrupt and disable it if necessary.  Can you
try without the NVIDIA module?

-- 
tejun

