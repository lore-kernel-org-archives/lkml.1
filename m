Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbYDBG2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbYDBG2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 02:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYDBG23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 02:28:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbYDBG22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 02:28:28 -0400
Message-ID: <47F32789.2070703@redhat.com>
Date: Wed, 02 Apr 2008 02:28:25 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dave Jones <davej@codemonkey.org.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: GFP_ATOMIC page allocation failures.
References: <20080401235609.GA6947@codemonkey.org.uk> <200804021228.16875.nickpiggin@yahoo.com.au> <20080402013551.GA8361@codemonkey.org.uk>
In-Reply-To: <20080402013551.GA8361@codemonkey.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Wed, Apr 02, 2008 at 12:28:16PM +1100, Nick Piggin wrote:
>  > On Wednesday 02 April 2008 10:56, Dave Jones wrote:
>  > > I found a few ways to cause pages and pages of spew to dmesg
>  > > of the following form..
>  > >
>  > > rhythmbox: page allocation failure. order:3, mode:0x4020
>  > > Pid: 4299, comm: rhythmbox Not tainted 2.6.25-0.172.rc7.git4.fc9.x86_64 #1
>  > >
>  > > Call Trace:
>  > >  <IRQ>  [<ffffffff810862dc>] __alloc_pages+0x3a3/0x3c3
>  > >  [<ffffffff812a58df>] ? trace_hardirqs_on_thunk+0x35/0x3a
>  > >  [<ffffffff8109fd94>] alloc_pages_current+0x100/0x109
>  > >  [<ffffffff810a6fd5>] new_slab+0x4a/0x249
>  > >  [<ffffffff810a776a>] __slab_alloc+0x251/0x4e0
>  > >  [<ffffffff8121c322>] ? __netdev_alloc_skb+0x31/0x4f
>  > >  [<ffffffff810a8736>] __kmalloc_node_track_caller+0x8a/0xe2
>  > >  [<ffffffff8121c322>] ? __netdev_alloc_skb+0x31/0x4f
>  > >  [<ffffffff8121b5db>] __alloc_skb+0x6f/0x135
>  > >  [<ffffffff8121c322>] __netdev_alloc_skb+0x31/0x4f
>  > >  [<ffffffff8814e5b4>] :e1000e:e1000_alloc_rx_buffers+0xb7/0x1dc
>  > >  [<ffffffff8814eada>] :e1000e:e1000_clean_rx_irq+0x271/0x307
>  > >  [<ffffffff8814c71a>] :e1000e:e1000_clean+0x66/0x205
>  > >  [<ffffffff8121eeb8>] net_rx_action+0xd9/0x20e
>  > >  [<ffffffff81038757>] __do_softirq+0x70/0xf1
>  > >  [<ffffffff8100d25c>] call_softirq+0x1c/0x28
>  > >  [<ffffffff8100e485>] do_softirq+0x39/0x8a
>  > >  [<ffffffff81038290>] irq_exit+0x4e/0x8f
>  > >  [<ffffffff8100e781>] do_IRQ+0x145/0x167
>  > >  [<ffffffff8100c5e6>] ret_from_intr+0x0/0xf
>  > >  <EOI>  [<ffffffff812a5ed8>] ? _spin_unlock_irqrestore+0x42/0x47
>  > >  [<ffffffff8102a040>] ? __wake_up+0x43/0x50
>  > >  [<ffffffff81056b7f>] ? wake_futex+0x47/0x53
>  > >  [<ffffffff810584cf>] ? do_futex+0x697/0xc57
>  > >  [<ffffffff8102fbc4>] ? hrtick_set+0xa1/0xfc
>  > >  [<ffffffff81058b84>] ? sys_futex+0xf5/0x113
>  > >  [<ffffffff810133e7>] ? syscall_trace_enter+0xb5/0xb9
>  > >  [<ffffffff8100c1d0>] ? tracesys+0xd5/0xda
>  > >
>  > > Given that we seem to recover from these events without negative effects
>  > > (ie, no apps get oom-killed), is there any value to actually flooding
>  > > syslog with this stuff ?
>  > 
>  > It's nice to have. Perhaps it could just be hardlimited to print
>  > say 10 times, and maybe we could have a vmstat counter to keep
>  > count after that.
> 
> As an end-user, that's still 10 times too many.
> What is anyone expect to do with these traces ?
> 
> multi-page atomic allocations fail sometimes, we shouldn't be
> surprised by this.  As long as the code that tries to do them
> is aware of this, is there a problem ?
> 
> 	Dave
> 

I agree that this spew is quite excessive, but it's there for a reason. 
  Some code does *not* handle this failure gracefully, and may put the 
machine in a state where it is subsequently unable to report/log errors 
from the calling code.  If that happens, I'd like to see some sort of 
dying gasp.

Limiting this to once per boot should suffice for debugging purposes. 
Even if you manage to concoct a bug that always survives the first 
failure, you should be able to take the hint when you keep seeing this 
in dmesg.

-- Chris
