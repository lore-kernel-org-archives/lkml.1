Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXCDW2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXCDW2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 17:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbXCDW2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 17:28:18 -0500
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:52475 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbXCDW2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 17:28:17 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu  scheduler
Date: Mon, 5 Mar 2007 09:27:52 +1100
User-Agent: KMail/1.9.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703050849.29674.kernel@kolivas.org> <45EB45F7.3050208@simon.arlott.org.uk>
In-Reply-To: <45EB45F7.3050208@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703050927.52563.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 09:19, Simon Arlott wrote:
> On 04/03/07 21:49, Con Kolivas wrote:
> > On Monday 05 March 2007 07:35, Al Boldi wrote:
> >> Con Kolivas wrote:
> >>> This means that if you heavily load up your machine without the use of
> >>> 'nice' then your interactive tasks _will_ slow down proportionately to
> >>> the amount of cpu you use. So doing make -j4 for example will make any
> >>> other task started in taht presence run precisely 1/5th speed, but they
> >>> will still be responsive, have low latency (and audio shouldn't skip
> >>> for example).
> >>
> >> That's just what it did, but when you "nice make -j4", things (gears)
> >> start to stutter.  Is that due to the staircase?
> >
> > gears isn't an interactive task. Apart from using it as a background load
> > to check for starvation because it loads up the cpu fully (which a gpu
> > intensive but otherwise simple app like this should _not_ do) graphics
> > card drivers and interrupts and so on, I wouldn't put much credence on
> > gears as anything else. However I suspect that gears will still get a
> > fair share of the cpu on RSDL which almost never happens on any other
> > scheduler.
>
> If I run glxgears, thunderbird/firefox become really slow to
> respond/display and cpu usage isn't even at 100%. I had thunderbird lagging
> on keyboard character repeat earlier but can't reproduce that now even with
> glxgears - however firefox lags really badly on keyboard input with
> glxgears running.

Hi Simon

You're hitting a nasty udev bug here that is unrelated to the cpu scheduler 
and almost certainly responsible for your bad behaviour. 

[   39.314953] =================================
[   39.315068] [ INFO: inconsistent lock state ]
[   39.315120] 2.6.21-rc2-git #161
[   39.315167] ---------------------------------
[   39.315217] inconsistent {softirq-on-R} -> {in-softirq-W} usage.
[   39.315271] udevd/1424 [HC0[0]:SC1[2]:HE1:SE0] takes:
[   39.315323]  (&ndev->lock){-+-?}, at: [<b04a57c4>] 
ipv6_add_addr+0x164/0x1e0
[   39.315525] {softirq-on-R} state was registered at:
[   39.315576]   [<b013f8d2>] __lock_acquire+0x622/0xbb0
[   39.315731]   [<b01402e2>] lock_acquire+0x62/0x80
[   39.315883]   [<b050fc55>] _read_lock+0x35/0x50
[   39.316043]   [<b050c1e0>] sctp_v6_copy_addrlist+0x30/0xc0
[   39.316197]   [<b04f9cd2>] sctp_get_local_addr_list+0x32/0x60
[   39.316358]   [<b06de1f0>] sctp_init+0x2c0/0x550
[   39.316516]   [<b06bcc55>] do_initcalls+0x35/0x120
[   39.316687]   [<b06bcd5c>] do_basic_setup+0x1c/0x30
[   39.316840]   [<b06bcdbf>] init+0x3f/0x90
[   39.316994]   [<b0104d87>] kernel_thread_helper+0x7/0x10
[   39.317150]   [<ffffffff>] 0xffffffff
[   39.317300] irq event stamp: 1976
[   39.317348] hardirqs last  enabled at (1976): [<b014087e>] 
debug_check_no_locks_freed+0xbe/0xd0
[   39.317481] hardirqs last disabled at (1975): [<b01407ea>] 
debug_check_no_locks_freed+0x2a/0xd0
[   39.317618] softirqs last  enabled at (1808): [<b0435557>] 
release_sock+0x57/0xb0
[   39.317751] softirqs last disabled at (1853): [<b0125277>] 
do_softirq+0x47/0x50
[   39.317884] 
[   39.317885] other info that might help us debug this:
[   39.317978] 3 locks held by udevd/1424:
[   39.318026]  #0:  (&mm->mmap_sem){----}, at: [<b0116ae6>] 
do_page_fault+0xb6/0x5a0
[   39.318263]  #1:  (&npinfo->poll_lock){-+..}, at: [<b043cf28>] 
net_rx_action+0x158/0x1a0
[   39.318500]  #2:  (&tp->rx_lock){-+..}, at: [<b034ef7e>] 
rtl8139_poll+0x3e/0x120
[   39.318742] 
[   39.318743] stack backtrace:
[   39.318833]  [<b0104f4a>] show_trace_log_lvl+0x1a/0x30
[   39.318924]  [<b0104f72>] show_trace+0x12/0x20
[   39.319009]  [<b0105086>] dump_stack+0x16/0x20
[   39.319094]  [<b013e4d1>] print_usage_bug+0x151/0x160
[   39.319180]  [<b013e9a3>] mark_lock+0x4c3/0x580
[   39.319265]  [<b013f8b0>] __lock_acquire+0x600/0xbb0
[   39.319354]  [<b01402e2>] lock_acquire+0x62/0x80
[   39.319439]  [<b050fff5>] _write_lock+0x35/0x50
[   39.319526]  [<b04a57c4>] ipv6_add_addr+0x164/0x1e0
[   39.319612]  [<b04a76a2>] addrconf_prefix_rcv+0x2b2/0x560
[   39.319707]  [<b04b39b1>] ndisc_router_discovery+0x431/0x600
[   39.319798]  [<b04b4552>] ndisc_rcv+0x92/0xc0
[   39.319883]  [<b04b98b0>] icmpv6_rcv+0x2b0/0x2d0
[   39.319971]  [<b04a4975>] ip6_input+0x1a5/0x3c0
[   39.320057]  [<b04a4f3a>] ip6_mc_input+0x3a/0x60
[   39.320145]  [<b04a45ab>] ipv6_rcv+0x15b/0x380
[   39.320231]  [<b043cc31>] netif_receive_skb+0x271/0x2f0
[   39.320318]  [<b034ebb2>] rtl8139_rx+0x142/0x340
[   39.320405]  [<b034ef99>] rtl8139_poll+0x59/0x120
[   39.320494]  [<b043ce59>] net_rx_action+0x89/0x1a0
[   39.320580]  [<b01251d2>] __do_softirq+0x52/0xb0
[   39.320666]  [<b0125277>] do_softirq+0x47/0x50
[   39.320754]  [<b0125335>] irq_exit+0x75/0x80
[   39.320843]  [<b0106931>] do_IRQ+0x41/0x80
[   39.320929]  [<b0104be2>] common_interrupt+0x2e/0x34
[   39.321016]  [<b0510634>] error_code+0x74/0x7c
[   39.321103]  =======================

Also this patch was actually for 2.6.20 and you seem to have applied it to 
2.6.21-rc2. I haven't even checked that it cleanly applies to that kernel.

-- 
-ck
