Return-Path: <linux-kernel-owner+w=401wt.eu-S1764092AbXE2H5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764092AbXE2H5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 03:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXE2H53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 03:57:29 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbXE2H52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 03:57:28 -0400
Date: Tue, 29 May 2007 00:56:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org, Jarek Poplawski <jarkao2@o2.pl>,
       Jason Wessel <jason.wessel@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
Subject: Re: [2.6.21.1] soft lockup when removing netconsole module
Message-Id: <20070529005628.f7f3abc6.akpm@linux-foundation.org>
In-Reply-To: <20070526154011.GB3735@vanheusden.com>
References: <20070526154011.GB3735@vanheusden.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007 17:40:12 +0200 Folkert van Heusden <folkert@vanheusden.com> wrote:

> When trying to remove the netconsole module, I got the following kernel
> output after a while (couple of minutes iirc):
> 
> [525720.117293] BUG: soft lockup detected on CPU#1!
> [525720.117353]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
> [525720.117439]  [<c1004d7b>] show_trace+0x12/0x14
> [525720.117526]  [<c1004e75>] dump_stack+0x16/0x18
> [525720.117613]  [<c104dd5b>] softlockup_tick+0xa6/0xc2
> [525720.117694]  [<c1026855>] run_local_timers+0x12/0x14
> [525720.117738]  [<c1026669>] update_process_times+0x72/0xa1
> [525720.117744]  [<c1038673>] tick_sched_timer+0x53/0xb6
> [525720.117748]  [<c1033d62>] hrtimer_interrupt+0x189/0x1e3
> [525720.117753]  [<c100e9e2>] local_apic_timer_interrupt+0x55/0x5b
> [525720.117761]  [<c100ea12>] smp_apic_timer_interrupt+0x2a/0x39
> [525720.117766]  [<c1004a3f>] apic_timer_interrupt+0x33/0x38
> [525720.117770]  [<c120f4b1>] mutex_lock+0x8/0xa
> [525720.117775]  [<c102d2f0>] flush_workqueue+0x2f/0x8f
> [525720.117780]  [<c102d7a0>] cancel_rearming_delayed_workqueue+0x29/0x2b
> [525720.117785]  [<c102d7b1>] cancel_rearming_delayed_work+0xf/0x11
> [525720.117790]  [<c11be143>] netpoll_cleanup+0x75/0xa5
> [525720.117794]  [<f893712d>] cleanup_netconsole+0x17/0x1a [netconsole]
> [525720.117804]  [<c1041f11>] sys_delete_module+0x12f/0x14f
> [525720.117809]  [<c1003f74>] syscall_call+0x7/0xb
> [525720.117812]  =======================
> 
> Also the rmmod hangs and would not exit even with kill -9. It also
> sucks up 100% cpu.

Jason recently posted a mystery patch without telling us what problem it
fixed.

It looks like you just found it: cancel_rearming_delayed_work() will hang
if the work isn't actually pending.  Please test this:


From: Jason Wessel <jason.wessel@windriver.com>

Do not call cancel_rearming_delayed_work() if there is no
pending work.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netpoll.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN net/core/netpoll.c~a net/core/netpoll.c
--- a/net/core/netpoll.c~a
+++ a/net/core/netpoll.c
@@ -784,8 +784,10 @@ void netpoll_cleanup(struct netpoll *np)
 			if (atomic_dec_and_test(&npinfo->refcnt)) {
 				skb_queue_purge(&npinfo->arp_tx);
 				skb_queue_purge(&npinfo->txq);
-				cancel_rearming_delayed_work(&npinfo->tx_work);
-				flush_scheduled_work();
+				if (delayed_work_pending(&npinfo->tx_work)) {
+					cancel_rearming_delayed_work(&npinfo->tx_work);
+					flush_scheduled_work();
+				}
 
 				kfree(npinfo);
 			}
_

