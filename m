Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbXF2NJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbXF2NJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761063AbXF2NI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:08:57 -0400
Received: from mail.screens.ru ([213.234.233.54]:45443 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXF2NI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:08:56 -0400
Date: Fri, 29 Jun 2007 17:09:55 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Mack <daniel@qanu.de>, Holger Waechtler <holger@qanu.de>
Subject: Re: 2.6.22-rc6 spurious hangs
Message-ID: <20070629130955.GA284@tv-sign.ru>
References: <4683BF16.40905@gmx.de> <20070628144741.GA437@tv-sign.ru> <4683CC89.80406@gmx.de> <20070628150826.GA487@tv-sign.ru> <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de> <20070628181044.GA613@tv-sign.ru> <4684B132.2070405@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4684B132.2070405@gmx.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Thomas Sattler wrote:
>
> >> Jun 28 19:23:03 pearl cinergyt2_query_rc+0x0/0x2e9 [cinergyT2]
> > 
> > cinergyt2_query_rc() hangs. I'll try to look tomorrov, but I know nothing
> > about drivers/media/dvb/.
> 
> Does this mean the problem is in the cinergyt2 driver? I'm having similar
> problems with another box but with different hardware. While my laptop is
> used as a test system the other one is used as a 'productive' TV-recorder.
> I hoped we could trace the bug on the test system and fix the productive
> one at the same time. :-/

Yes, I think cinergyt2 is buggy.

> Jun 28 23:02:42 pearl events/0      S 00000280     0     5      2 (L-TLB)
> Jun 28 23:02:42 pearl c1d4ded0 00000096 55136d42 00000280 c0302fa1 c1d4ad10 55136d42 00000280
> Jun 28 23:02:42 pearl c1d5c170 f737cd40 c1d4deec f56eca50 00000246 c1d4df0c c0303b81 00000000
> Jun 28 23:02:42 pearl 00000002 c0303c94 00000280 c1d4ab80 f56eca7c f56eca7c c1d4ab80 f56eca50
> Jun 28 23:02:42 pearl Call Trace:
> Jun 28 23:02:42 pearl [<c0303b81>] __mutex_lock_interruptible_slowpath+0x192/0x293
> Jun 28 23:02:42 pearl [<c0303c94>] mutex_lock_interruptible+0x12/0x15
> Jun 28 23:02:42 pearl [<f96ae120>] cinergyt2_query_rc+0x2d/0x2e9 [cinergyT2]
> Jun 28 23:02:42 pearl [<c012a79b>] run_workqueue+0x7f/0x130
> Jun 28 23:02:42 pearl [<c012b036>] worker_thread+0xb7/0xc5
> Jun 28 23:02:42 pearl [<c012d577>] kthread+0x39/0x5e
> Jun 28 23:02:42 pearl [<c010485b>] kernel_thread_helper+0x7/0x10


> Jun 28 23:02:42 pearl dvbd          D 00000281     0  5643      1 (NOTLB)
> Jun 28 23:02:42 pearl f6fd1e28 00000086 0a067524 00000281 c0543800 c1d5c300 0a067524 00000281
> Jun 28 23:02:42 pearl 00000000 f737cd40 f6fd1e38 00c3fba6 f6fd1e90 f6fd1e70 c0303704 f6fd1f00
> Jun 28 23:02:42 pearl 000458ee f702cf28 c05442a8 00c3fba6 c0124e58 c1d5c170 c0543800 c03036ff
> Jun 28 23:02:42 pearl Call Trace:
> Jun 28 23:02:42 pearl [<c0303704>] schedule_timeout+0x6e/0x8c
> Jun 28 23:02:42 pearl [<c03032b7>] wait_for_completion_timeout+0x72/0xcf
> Jun 28 23:02:42 pearl [<c012a9a4>] flush_cpu_workqueue+0x9d/0x19a
> Jun 28 23:02:42 pearl [<c012ad6e>] flush_workqueue+0x12/0x15
> Jun 28 23:02:42 pearl [<c012ad7e>] flush_scheduled_work+0xd/0xf
> Jun 28 23:02:42 pearl [<f96ae011>] cinergyt2_release+0x4c/0xa4 [cinergyT2]
> Jun 28 23:02:42 pearl [<c0160159>] __fput+0xaf/0x14b
> Jun 28 23:02:42 pearl [<c016020b>] fput+0x16/0x18
> Jun 28 23:02:42 pearl [<c015ddf3>] filp_close+0x54/0x5c
> Jun 28 23:02:42 pearl [<c015edcb>] sys_close+0x6e/0xa6
> Jun 28 23:02:42 pearl [<c0103c4e>] sysenter_past_esp+0x5f/0x99

cinergyt2_release() does flush_scheduled_work() under cinergyt2->sem.
flush_scheduled_work() hangs because cinergyt2_query_rc() waits for
the same cinergyt2->sem.

->disconnect_pending is used without any locks/barriers, perhaps this
is the reason.

I'll try to look further tomorrow. In any case, cinergyT2 should not
use flush_scheduled_work() at all.

Oleg.

