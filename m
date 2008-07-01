Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYGATk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYGATk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYGATkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:40:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYGATkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:40:45 -0400
Date: Tue, 1 Jul 2008 15:40:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?iso-8859-1?q?J=FCrgen_Mell?= <j.mell@t-online.de>
cc: LKML <linux-kernel@vger.kernel.org>, rostedt@goodmis.org
Subject: Re: BUG messages with real-time kernel 2.6.25.8-rt7
In-Reply-To: <200807011947.48725.j.mell@t-online.de>
Message-ID: <Pine.LNX.4.58.0807011507510.27372@gandalf.stny.rr.com>
References: <200807011947.48725.j.mell@t-online.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 1 Jul 2008, Jürgen Mell wrote:

>
> I am getting this bug message from a real-time kernel 2.6.25.8-rt7:
>
> Jul  1 07:58:30 cwc-003 kernel: BUG: sleeping function called from invalid
> context IRQ-15(416) at arch/x86/mm/highmem_32.c:8
> Jul  1 07:58:30 cwc-003 kernel: in_atomic():0 [00000000], irqs_disabled():1
> Jul  1 07:58:30 cwc-003 kernel: Pid: 416, comm: IRQ-15 Not tainted
> 2.6.25.8-rt7-hws #2
> Jul  1 07:58:30 cwc-003 kernel:  [<c01125f5>] kmap+0x44/0x54
> Jul  1 07:58:30 cwc-003 kernel:  [<f88507fd>] ata_hsm_move+0x3d5/0x666

[...]

>
> Any ideas how to fix this? If you need any more information or if I can
> test something, please let me know.

I found the problem. In PREEMPT_RT we define kmap_atomic to kmap since we
don't disable interrutps with spin_lock_irqsave nor do we disable
preemption.

In drivers/ata/libata-core.c we have:


		/* FIXME: use bounce buffer */
		local_irq_save(flags);
		buf = kmap_atomic(page, KM_IRQ0);


But PREEMPT_RT even kmap_atomic will call "might_sleep". So the fix here
is for us to get rid of the local_irq_save. Perhaps simply add a
spin_lock_irqsave(local_lock) here.

Thanks for the report.

-- Steve

