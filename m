Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYAVWv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYAVWv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYAVWvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:51:50 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34068 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbYAVWvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:51:49 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 22 Jan 2008 23:51:27 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.24-rc7 to 2.6.24-rc8 possible regression
To: Peter Zijlstra <peterz@infradead.org>
cc: Denys Fedoryshchenko <denys@visp.net.lb>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <1201019283.6341.28.camel@lappy>
Message-ID: <tkrat.fcd947ba88aa56a8@s5r6.in-berlin.de>
References: <20080121160255.M12670@visp.net.lb> 
 <47952094.9050102@s5r6.in-berlin.de> <20080122110448.M46928@visp.net.lb> 
 <4796189F.8070506@s5r6.in-berlin.de> <1201019283.6341.28.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Cc: Davide and akpm)

On 22 Jan, Peter Zijlstra wrote:
> 
> On Tue, 2008-01-22 at 17:23 +0100, Stefan Richter wrote:
>> Denys Fedoryshchenko wrote:
>> > No, i am using vanilla kernel. It is one of production machines, and as i 
>> > know screen is not using epoll.
>> 
>> OK, but the trace shows that it is the epoll recursion again.
>> 
>> > I will try to apply on all my production machines this patch. Sorry if it is 
>> > related.
>> 
>> Well, let's hope that the lockdep annotation or whatever other fix gets
>> into mainline sooner than later.  Which reminds me to test my setup
>> again which appeared to be able to reproduce the __wake_up recursion on
>> my command...
> 
> Would be appreciated, I have been waiting on testing feedback because
> I'm not fully certain here.
> 
> Curious though that this gets reported frequently the last few weeks,
> afaics this problem is way old.

Here is a report against Fedora's 2.6.23-0.222.rc9.git4.fc8, filed in
October:  https://bugzilla.redhat.com/show_bug.cgi?id=323411

I did several tests with a pristine 2.6.24-rc8 now.  The lockdep warning
below is 100% reliably triggered by grabbing video from a DV camcorder
with dvgrab v3 via firewire-core's character device file ABI.

Also, this warning is 100% reliably suppressed by your annotation patch.
I will reply to this message with this patch for kind consideration by
those concerned. :-)


=============================================
[ INFO: possible recursive locking detected ]
2.6.24-rc8 #1
---------------------------------------------
swapper/0 is trying to acquire lock:
 (&q->lock){++..}, at: [<ffffffff8022aef7>] __wake_up+0x22/0x4e

but task is already holding lock:
 (&q->lock){++..}, at: [<ffffffff8022aef7>] __wake_up+0x22/0x4e

other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (&q->lock){++..}, at: [<ffffffff8022aef7>] __wake_up+0x22/0x4e

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.24-rc8 #1

Call Trace:
 <IRQ>  [<ffffffff8024ec38>] __lock_acquire+0x1c5/0xc68
 [<ffffffff8024faa1>] lock_acquire+0x51/0x6c
 [<ffffffff8022aef7>] __wake_up+0x22/0x4e
 [<ffffffff8041499b>] _spin_lock_irqsave+0x37/0x47
 [<ffffffff8022aef7>] __wake_up+0x22/0x4e
 [<ffffffff802a926e>] ep_poll_safewake+0x86/0xc5
 [<ffffffff802aa15a>] ep_poll_callback+0xc1/0xcb
 [<ffffffff80228d4d>] __wake_up_common+0x41/0x74
 [<ffffffff8022af0d>] __wake_up+0x38/0x4e
 [<ffffffff8806888c>] :firewire_core:fw_core_handle_request+0x1b0/0x1eb
 [<ffffffff8807301f>] :firewire_ohci:handle_ar_packet+0xfb/0x10f
 [<ffffffff88073f01>] :firewire_ohci:ar_context_tasklet+0xd6/0xe7
 [<ffffffff80236328>] tasklet_action+0x5d/0xb0
 [<ffffffff80236229>] __do_softirq+0x5d/0xe0
 [<ffffffff8021dc2f>] ack_apic_level+0x10/0xdc
 [<ffffffff8020c9fc>] call_softirq+0x1c/0x28
 [<ffffffff8020e839>] do_softirq+0x31/0x94
 [<ffffffff8023616c>] irq_exit+0x45/0x51
 [<ffffffff8020e954>] do_IRQ+0xb8/0xd8
 [<ffffffff8020bcc6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8021c2da>] lapic_next_event+0x0/0xa
 [<ffffffff8022cde9>] sched_clock_idle_wakeup_event+0x46/0x63
 [<ffffffff8805a746>] :processor:acpi_idle_enter_simple+0x179/0x1df
 [<ffffffff8805a73c>] :processor:acpi_idle_enter_simple+0x16f/0x1df
 [<ffffffff803b4608>] cpuidle_idle_call+0x79/0xad
 [<ffffffff803b458f>] cpuidle_idle_call+0x0/0xad
 [<ffffffff8020a5e4>] cpu_idle+0x95/0xcc
 [<ffffffff80571a8a>] start_kernel+0x2d3/0x2df
 [<ffffffff80571115>] _sinittext+0x115/0x11c



-- 
Stefan Richter
-=====-==--- ---= =-==-
http://arcgraph.de/sr/

