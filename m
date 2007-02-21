Return-Path: <linux-kernel-owner+w=401wt.eu-S1751096AbXBUBk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096AbXBUBk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXBUBkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:40:14 -0500
Received: from ns.suse.de ([195.135.220.2]:42339 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbXBUBkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:40:08 -0500
Date: Tue, 20 Feb 2007 17:38:46 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Chuck Ebbert <cebbert@redhat.com>, Linus Torvalds <torvalds@osdl.org>
Subject: [patch 19/21] net, 8139too.c: fix netpoll deadlock
Message-ID: <20070221013846.GT30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-8139too.c-fix-netpoll-deadlock.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ingo Molnar <mingo@elte.hu>

[PATCH] net, 8139too.c: fix netpoll deadlock

fix deadlock in the 8139too driver: poll handlers should never forcibly
enable local interrupts, because they might be used by netpoll/printk
from IRQ context.

  =================================
  [ INFO: inconsistent lock state ]
  2.6.19 #11
  ---------------------------------
  inconsistent {softirq-on-W} -> {in-softirq-W} usage.
  swapper/1 [HC0[0]:SC1[1]:HE1:SE0] takes:
   (&npinfo->poll_lock){-+..}, at: [<c0350a41>] net_rx_action+0x64/0x1de
  {softirq-on-W} state was registered at:
    [<c0134c86>] mark_lock+0x5b/0x39c
    [<c0135012>] mark_held_locks+0x4b/0x68
    [<c01351e9>] trace_hardirqs_on+0x115/0x139
    [<c02879e6>] rtl8139_poll+0x3d7/0x3f4
    [<c035c85d>] netpoll_poll+0x82/0x32f
    [<c035c775>] netpoll_send_skb+0xc9/0x12f
    [<c035cdcc>] netpoll_send_udp+0x253/0x25b
    [<c0288463>] write_msg+0x40/0x65
    [<c011cead>] __call_console_drivers+0x45/0x51
    [<c011cf16>] _call_console_drivers+0x5d/0x61
    [<c011d4fb>] release_console_sem+0x11f/0x1d8
    [<c011d7d7>] register_console+0x1ac/0x1b3
    [<c02883f8>] init_netconsole+0x55/0x67
    [<c010040c>] init+0x9a/0x24e
    [<c01049cf>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff
  irq event stamp: 819992
  hardirqs last  enabled at (819992): [<c0350a16>] net_rx_action+0x39/0x1de
  hardirqs last disabled at (819991): [<c0350b1e>] net_rx_action+0x141/0x1de
  softirqs last  enabled at (817552): [<c01214e4>] __do_softirq+0xa3/0xa8
  softirqs last disabled at (819987): [<c0106051>] do_softirq+0x5b/0xc9

  other info that might help us debug this:
  no locks held by swapper/1.

  stack backtrace:
   [<c0104d88>] dump_trace+0x63/0x1e8
   [<c0104f26>] show_trace_log_lvl+0x19/0x2e
   [<c010532d>] show_trace+0x12/0x14
   [<c0105343>] dump_stack+0x14/0x16
   [<c0134980>] print_usage_bug+0x23c/0x246
   [<c0134d33>] mark_lock+0x108/0x39c
   [<c01356a7>] __lock_acquire+0x361/0x9ed
   [<c0136018>] lock_acquire+0x56/0x72
   [<c03aff1f>] _spin_lock+0x35/0x42
   [<c0350a41>] net_rx_action+0x64/0x1de
   [<c0121493>] __do_softirq+0x52/0xa8
   [<c0106051>] do_softirq+0x5b/0xc9
   [<c0121338>] irq_exit+0x3c/0x48
   [<c0106163>] do_IRQ+0xa4/0xbd
   [<c01047c6>] common_interrupt+0x2e/0x34
   [<c011db92>] vprintk+0x2c0/0x309
   [<c011dbf6>] printk+0x1b/0x1d
   [<c01003f2>] init+0x80/0x24e
   [<c01049cf>] kernel_thread_helper+0x7/0x10
   =======================

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/8139too.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.19.4.orig/drivers/net/8139too.c
+++ linux-2.6.19.4/drivers/net/8139too.c
@@ -2129,14 +2129,15 @@ static int rtl8139_poll(struct net_devic
 	}
 
 	if (done) {
+		unsigned long flags;
 		/*
 		 * Order is important since data can get interrupted
 		 * again when we think we are done.
 		 */
-		local_irq_disable();
+		local_irq_save(flags);
 		RTL_W16_F(IntrMask, rtl8139_intr_mask);
 		__netif_rx_complete(dev);
-		local_irq_enable();
+		local_irq_restore(flags);
 	}
 	spin_unlock(&tp->rx_lock);
 

--
