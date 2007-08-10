Return-Path: <linux-kernel-owner+w=401wt.eu-S940695AbXHJSxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940695AbXHJSxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbXHJSww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:52:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756624AbXHJSwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:52:50 -0400
Date: Fri, 10 Aug 2007 11:51:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Jeff Garzik" <jgarzik@pobox.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.23-rc2-mm2 -- When suspending, "INFO: inconsistent lock
 state" -- 8139too issue?
Message-Id: <20070810115155.50b70b36.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0708101132k7c247264w39ddc48c463c80ac@mail.gmail.com>
References: <a44ae5cd0708101132k7c247264w39ddc48c463c80ac@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 14:32:27 -0400
"Miles Lane" <miles.lane@gmail.com> wrote:

> [ INFO: inconsistent lock state ]
> 2.6.23-rc2-mm2 #10
> ---------------------------------
> inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> ifconfig/8425 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&tp->lock){++..}, at: [<f882f65a>] rtl8139_interrupt+0x22/0x37e [8139too]
> {in-hardirq-W} state was registered at:
>   [<c0133ede>] __lock_acquire+0x3f0/0xb6f
>   [<c01346be>] lock_acquire+0x61/0x7d
>   [<c03127b4>] _spin_lock+0x23/0x32
>   [<f882f65a>] rtl8139_interrupt+0x22/0x37e [8139too]
>   [<c0143f96>] handle_IRQ_event+0x1a/0x46
>   [<c0144f2f>] handle_fasteoi_irq+0x72/0xab
>   [<c0105b82>] do_IRQ+0xab/0xd5
>   [<ffffffff>] 0xffffffff
> irq event stamp: 1551
> hardirqs last  enabled at (1551): [<c0161db2>] kfree+0xb9/0xc3
> hardirqs last disabled at (1550): [<c0161d5c>] kfree+0x63/0xc3
> softirqs last  enabled at (1530): [<c02a6510>] dev_deactivate+0x86/0x9f
> softirqs last disabled at (1528): [<c03127ce>] _spin_lock_bh+0xb/0x37
> 
> other info that might help us debug this:
> 1 lock held by ifconfig/8425:
>  #0:  (rtnl_mutex){--..}, at: [<c03116b7>] mutex_lock+0x1c/0x1f
> 
> stack backtrace:
>  [<c0104c92>] show_trace_log_lvl+0x12/0x25
>  [<c0105476>] show_trace+0xd/0x10
>  [<c010557a>] dump_stack+0x15/0x17
>  [<c0132af2>] print_usage_bug+0x10a/0x117
>  [<c01332fc>] mark_lock+0x1e0/0x3fa
>  [<c0133f59>] __lock_acquire+0x46b/0xb6f
>  [<c01346be>] lock_acquire+0x61/0x7d
>  [<c03127b4>] _spin_lock+0x23/0x32
>  [<f882f65a>] rtl8139_interrupt+0x22/0x37e [8139too]
>  [<c0144453>] free_irq+0xc0/0xe9
>  [<f88308f0>] rtl8139_close+0xa0/0x130 [8139too]
>  [<c0299767>] dev_close+0x4d/0x6a
>  [<c0298a70>] dev_change_flags+0x9f/0x152
>  [<c02d057d>] devinet_ioctl+0x209/0x505
>  [<c02d0e9a>] inet_ioctl+0x86/0xa4
>  [<c028fa47>] sock_ioctl+0x1a6/0x1c4
>  [<c016e532>] do_ioctl+0x22/0x67
>  [<c016e7c9>] vfs_ioctl+0x252/0x265
>  [<c016e808>] sys_ioctl+0x2c/0x48
>  [<c0103cea>] sysenter_past_esp+0x5f/0x99
>  =======================
> ACPI: PCI interrupt for device 0000:01:00.0 disabled
> ACPI: PCI interrupt for device 0000:01:06.0 disabled
> ieee80211_crypt: unregistered algorithm 'NULL'
> Syncing filesystems ... done.
> Freezing user space processes ... (elapsed 0.00 seconds) done.
> 

OK, what's happened here is that lockdep has decided that 8139too's
tp->lock is a taken-from-interrupts lock.  Then it sees that lock being
taken from regular old process context and it says "hey, if an interrupt
were to happen now, you'd deadlock".

The offending callsite is free_irq():

#ifdef CONFIG_DEBUG_SHIRQ
	if (handler) {
		/*
		 * It's a shared IRQ -- the driver ought to be prepared for it
		 * to happen even now it's being freed, so let's make sure....
		 * We do this after actually deregistering it, to make sure that
		 * a 'real' IRQ doesn't run in parallel with our fake
		 */
		handler(irq, dev_id);
	}
#endif

Ingo: recommendations, please?  Put a local_irq_save() around it?
