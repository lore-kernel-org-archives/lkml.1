Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbYDBH5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbYDBH5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYDBH5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:57:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbYDBH5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:57:14 -0400
Date: Wed, 2 Apr 2008 00:56:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Snook <csnook@redhat.com>
Cc: Dave Jones <davej@codemonkey.org.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: GFP_ATOMIC page allocation failures.
Message-Id: <20080402005646.f8df1c1b.akpm@linux-foundation.org>
In-Reply-To: <47F32789.2070703@redhat.com>
References: <20080401235609.GA6947@codemonkey.org.uk>
	<200804021228.16875.nickpiggin@yahoo.com.au>
	<20080402013551.GA8361@codemonkey.org.uk>
	<47F32789.2070703@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Apr 2008 02:28:25 -0400 Chris Snook <csnook@redhat.com> wrote:

> Dave Jones wrote:
> > On Wed, Apr 02, 2008 at 12:28:16PM +1100, Nick Piggin wrote:
> >  > On Wednesday 02 April 2008 10:56, Dave Jones wrote:
> >  > > I found a few ways to cause pages and pages of spew to dmesg
> >  > > of the following form..
> >  > >
> >  > > rhythmbox: page allocation failure. order:3, mode:0x4020
> >  > > Pid: 4299, comm: rhythmbox Not tainted 2.6.25-0.172.rc7.git4.fc9.x86_64 #1
> >  > >
> >  > > Call Trace:
> >  > >  <IRQ>  [<ffffffff810862dc>] __alloc_pages+0x3a3/0x3c3
> >  > >  [<ffffffff812a58df>] ? trace_hardirqs_on_thunk+0x35/0x3a
> >  > >  [<ffffffff8109fd94>] alloc_pages_current+0x100/0x109
> >  > >  [<ffffffff810a6fd5>] new_slab+0x4a/0x249
> >  > >  [<ffffffff810a776a>] __slab_alloc+0x251/0x4e0
> >  > >  [<ffffffff8121c322>] ? __netdev_alloc_skb+0x31/0x4f
> >  > >  [<ffffffff810a8736>] __kmalloc_node_track_caller+0x8a/0xe2
> >  > >  [<ffffffff8121c322>] ? __netdev_alloc_skb+0x31/0x4f
> >  > >  [<ffffffff8121b5db>] __alloc_skb+0x6f/0x135
> >  > >  [<ffffffff8121c322>] __netdev_alloc_skb+0x31/0x4f
> >  > >  [<ffffffff8814e5b4>] :e1000e:e1000_alloc_rx_buffers+0xb7/0x1dc
> >  > >  [<ffffffff8814eada>] :e1000e:e1000_clean_rx_irq+0x271/0x307
> >  > >  [<ffffffff8814c71a>] :e1000e:e1000_clean+0x66/0x205
> >  > >  [<ffffffff8121eeb8>] net_rx_action+0xd9/0x20e
> >  > >  [<ffffffff81038757>] __do_softirq+0x70/0xf1
> >  > >  [<ffffffff8100d25c>] call_softirq+0x1c/0x28
> >  > >  [<ffffffff8100e485>] do_softirq+0x39/0x8a
> >  > >  [<ffffffff81038290>] irq_exit+0x4e/0x8f
> >  > >  [<ffffffff8100e781>] do_IRQ+0x145/0x167
> >  > >  [<ffffffff8100c5e6>] ret_from_intr+0x0/0xf
> >  > >  <EOI>  [<ffffffff812a5ed8>] ? _spin_unlock_irqrestore+0x42/0x47
> >  > >  [<ffffffff8102a040>] ? __wake_up+0x43/0x50
> >  > >  [<ffffffff81056b7f>] ? wake_futex+0x47/0x53
> >  > >  [<ffffffff810584cf>] ? do_futex+0x697/0xc57
> >  > >  [<ffffffff8102fbc4>] ? hrtick_set+0xa1/0xfc
> >  > >  [<ffffffff81058b84>] ? sys_futex+0xf5/0x113
> >  > >  [<ffffffff810133e7>] ? syscall_trace_enter+0xb5/0xb9
> >  > >  [<ffffffff8100c1d0>] ? tracesys+0xd5/0xda
> >  > >
> >  > > Given that we seem to recover from these events without negative effects
> >  > > (ie, no apps get oom-killed), is there any value to actually flooding
> >  > > syslog with this stuff ?
> >  > 
> >  > It's nice to have. Perhaps it could just be hardlimited to print
> >  > say 10 times, and maybe we could have a vmstat counter to keep
> >  > count after that.
> > 
> > As an end-user, that's still 10 times too many.
> > What is anyone expect to do with these traces ?
> > 
> > multi-page atomic allocations fail sometimes, we shouldn't be
> > surprised by this.  As long as the code that tries to do them
> > is aware of this, is there a problem ?
> > 
> > 	Dave
> > 
> 
> I agree that this spew is quite excessive, but it's there for a reason. 
>   Some code does *not* handle this failure gracefully, and may put the 
> machine in a state where it is subsequently unable to report/log errors 
> from the calling code.  If that happens, I'd like to see some sort of 
> dying gasp.
> 
> Limiting this to once per boot should suffice for debugging purposes. 
> Even if you manage to concoct a bug that always survives the first 
> failure, you should be able to take the hint when you keep seeing this 
> in dmesg.

The appropriate thing to do here is to convert known-good drivers (such as
e1000[e]) to use __GFP_NOWARN.

Unfortunately netdev_alloc_skb() went and assumed GFP_ATOMIC, but I guess
we can dive below the covers and use __netdev_alloc_skb():



From: Andrew Morton <akpm@linux-foundation.org>

We get rather a lot of reports of page allocation warnings coming out of
e1000.  But this driver is know to handle them properly so let's suppress
them.

Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000.h      |    4 ++++
 drivers/net/e1000/e1000_main.c |   10 +++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-suppress-page-allocation-failure-warnings drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-suppress-page-allocation-failure-warnings
+++ a/drivers/net/e1000/e1000_main.c
@@ -4296,7 +4296,7 @@ e1000_clean_rx_irq(struct e1000_adapter 
 		 * of reassembly being done in the stack */
 		if (length < copybreak) {
 			struct sk_buff *new_skb =
-			    netdev_alloc_skb(netdev, length + NET_IP_ALIGN);
+			    e1000_alloc_skb(netdev, length + NET_IP_ALIGN);
 			if (new_skb) {
 				skb_reserve(new_skb, NET_IP_ALIGN);
 				skb_copy_to_linear_data_offset(new_skb,
@@ -4585,7 +4585,7 @@ e1000_alloc_rx_buffers(struct e1000_adap
 			goto map_skb;
 		}
 
-		skb = netdev_alloc_skb(netdev, bufsz);
+		skb = e1000_alloc_skb(netdev, bufsz);
 		if (unlikely(!skb)) {
 			/* Better luck next round */
 			adapter->alloc_rx_buff_failed++;
@@ -4598,7 +4598,7 @@ e1000_alloc_rx_buffers(struct e1000_adap
 			DPRINTK(RX_ERR, ERR, "skb align check failed: %u bytes "
 					     "at %p\n", bufsz, skb->data);
 			/* Try again, without freeing the previous */
-			skb = netdev_alloc_skb(netdev, bufsz);
+			skb = e1000_alloc_skb(netdev, bufsz);
 			/* Failed allocation, critical failure */
 			if (!skb) {
 				dev_kfree_skb(oldskb);
@@ -4720,8 +4720,8 @@ e1000_alloc_rx_buffers_ps(struct e1000_a
 				rx_desc->read.buffer_addr[j+1] = ~cpu_to_le64(0);
 		}
 
-		skb = netdev_alloc_skb(netdev,
-		                       adapter->rx_ps_bsize0 + NET_IP_ALIGN);
+		skb = e1000_alloc_skb(netdev,
+					adapter->rx_ps_bsize0 + NET_IP_ALIGN);
 
 		if (unlikely(!skb)) {
 			adapter->alloc_rx_buff_failed++;
diff -puN drivers/net/e1000/e1000.h~e1000-suppress-page-allocation-failure-warnings drivers/net/e1000/e1000.h
--- a/drivers/net/e1000/e1000.h~e1000-suppress-page-allocation-failure-warnings
+++ a/drivers/net/e1000/e1000.h
@@ -358,5 +358,9 @@ extern void e1000_power_up_phy(struct e1
 extern void e1000_set_ethtool_ops(struct net_device *netdev);
 extern void e1000_check_options(struct e1000_adapter *adapter);
 
+static inline void *e1000_alloc_skb(struct net_device *dev, unsigned int length)
+{
+	return __netdev_alloc_skb(dev, length, GFP_ATOMIC|__GFP_NOWARN);
+}
 
 #endif /* _E1000_H_ */
_

