Return-Path: <linux-kernel-owner+w=401wt.eu-S935752AbXGRSCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935752AbXGRSCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935359AbXGRSCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:02:12 -0400
Received: from smtp3.Stanford.EDU ([171.67.20.26]:57383 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935704AbXGRSCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:02:07 -0400
Subject: Re: v2.6.21.5-rt19 (sched_getaffinity?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU, Gabriel C <nix.or.die@googlemail.com>,
       Carsten Emde <carsten.emde@osadl.org>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.Stanford.EDU>,
       Steven Rostedt <rostedt@goodmis.org>,
       RT-Users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rui Nuno Capela <rncbc@rncbc.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <20070718071852.GB1516@elte.hu>
References: <1183758545.20747.34.camel@cmn3.stanford.edu>
	 <20070707092401.GB21234@elte.hu>
	 <1183934205.11854.11.camel@cmn3.stanford.edu>
	 <46917678.70700@googlemail.com>
	 <Pine.LNX.4.63.0707082047130.12404@cmn3.stanford.edu>
	 <1183957703.12681.4.camel@cmn3.stanford.edu>
	 <20070717193223.GJ26283@elte.hu>
	 <1184702217.21931.19.camel@cmn3.stanford.edu>
	 <20070717201242.GB2426@elte.hu>
	 <1184716305.21931.39.camel@cmn3.stanford.edu>
	 <20070718071852.GB1516@elte.hu>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 11:02:00 -0700
Message-Id: <1184781720.29703.11.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 09:18 +0200, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
> > > does lockdep pinpoint anything?
> > 
> > Lots of stuff, and at the end the lock report for the problem. 
> > Hopefully some of this will help... I have attached the whole bootup 
> > sequence as logged in /var/log/messages.
> 
> yeah, it pinpointed the bug. It seems to be an interaction between 
> RCU-preempt (Paul Cc:-ed) and sched_mc_power_savings_store(): 
> detach_destroy_domains() uses synchronize_sched() which uses 
> getaffinity, which takes sched_hotcpu_mutex, and 
> arch_reinit_sched_domains does it too - see the lockdep report below. 
> I've added a quick workaround below as well, which should keep your box 
> from hanging.

I can confirm that flash9 does not hang with the patch. 
Thanks!!!
I presume the same would apply to 2.6.21.x and, say, rt21. I'll test.

But (of course, there's always a but somewhere) I just experienced a
complete hang - 2.6.22.1-rt4 with the little patch. This time there was
something in the logs, maybe it will help? This was when finishing the
install of an additional kernel module rpm package (ipw3945 drivers). 

-- Fernando

--------
Jul 18 10:48:15 localhost kernel: BUG: sleeping function called from
invalid context modprobe(5001) at kernel/rtmutex.c:636
Jul 18 10:48:15 localhost kernel: in_atomic():1 [00000001],
irqs_disabled():0
Jul 18 10:48:15 localhost kernel:  [<c0405f34>] show_trace_log_lvl
+0x1a/0x2f
Jul 18 10:48:15 localhost kernel:  [<c0406a09>] show_trace+0x12/0x14
Jul 18 10:48:15 localhost kernel:  [<c0406a71>] dump_stack+0x16/0x18
Jul 18 10:48:15 localhost kernel:  [<c0423bfc>] __might_sleep+0xeb/0xf2
Jul 18 10:48:15 localhost kernel:  [<c0617242>] __rt_spin_lock+0x24/0x40
Jul 18 10:48:15 localhost kernel:  [<c0617266>] rt_spin_lock+0x8/0xa
Jul 18 10:48:15 localhost kernel:  [<c04621c9>] get_zone_pcp+0x23/0x33
Jul 18 10:48:15 localhost kernel:  [<c0462702>] free_hot_cold_page
+0xcf/0x148
Jul 18 10:48:15 localhost kernel:  [<c04627b2>] free_hot_page+0xa/0xc
Jul 18 10:48:15 localhost kernel:  [<c0462a82>] __free_pages+0x25/0x30
Jul 18 10:48:15 localhost kernel:  [<c0462ab6>] free_pages+0x29/0x2b
Jul 18 10:48:15 localhost kernel:  [<c047abf3>] quicklist_trim+0xd0/0xf5
Jul 18 10:48:15 localhost kernel:  [<c041f5d9>] check_pgt_cache
+0x1e/0x20
Jul 18 10:48:15 localhost kernel:  [<c046aedf>] free_pgtables+0x52/0x147
Jul 18 10:48:15 localhost kernel:  [<c046cdf7>] unmap_region+0xe6/0x135
Jul 18 10:48:15 localhost kernel:  [<c046d764>] do_munmap+0x153/0x1b4
Jul 18 10:48:15 localhost kernel:  [<c046f3de>] do_mremap+0x413/0x4c3
Jul 18 10:48:15 localhost kernel:  [<c046f4c4>] sys_mremap+0x36/0x56
Jul 18 10:48:15 localhost kernel:  [<c0404fca>] syscall_call+0x7/0xb
Jul 18 10:48:15 localhost kernel:  =======================
Jul 18 10:48:16 localhost kernel: BUG: sleeping function called from
invalid context head(5652) at kernel/rtmutex.c:636
Jul 18 10:48:16 localhost kernel: in_atomic():1 [00000001],
irqs_disabled():0
Jul 18 10:48:16 localhost kernel:  [<c0405f34>] show_trace_log_lvl
+0x1a/0x2f
Jul 18 10:48:16 localhost kernel:  [<c0406a09>] show_trace+0x12/0x14
Jul 18 10:48:16 localhost kernel:  [<c0406a71>] dump_stack+0x16/0x18
Jul 18 10:48:16 localhost kernel:  [<c0423bfc>] __might_sleep+0xeb/0xf2
Jul 18 10:48:16 localhost kernel:  [<c0617242>] __rt_spin_lock+0x24/0x40
Jul 18 10:48:16 localhost kernel:  [<c0617266>] rt_spin_lock+0x8/0xa
Jul 18 10:48:16 localhost kernel:  [<c04621c9>] get_zone_pcp+0x23/0x33
Jul 18 10:48:16 localhost kernel:  [<c0462702>] free_hot_cold_page
+0xcf/0x148
Jul 18 10:48:16 localhost kernel:  [<c04627b2>] free_hot_page+0xa/0xc
Jul 18 10:48:16 localhost kernel:  [<c0462a82>] __free_pages+0x25/0x30
Jul 18 10:48:16 localhost kernel:  [<c0462ab6>] free_pages+0x29/0x2b
Jul 18 10:48:16 localhost kernel:  [<c047abf3>] quicklist_trim+0xd0/0xf5
Jul 18 10:48:16 localhost kernel:  [<c041f5d9>] check_pgt_cache
+0x1e/0x20
Jul 18 10:48:16 localhost kernel:  [<c046aedf>] free_pgtables+0x52/0x147
Jul 18 10:48:16 localhost kernel:  [<c046cdf7>] unmap_region+0xe6/0x135
Jul 18 10:48:16 localhost kernel:  [<c046d764>] do_munmap+0x153/0x1b4
Jul 18 10:48:16 localhost kernel:  [<c046d7f5>] sys_munmap+0x30/0x3f
Jul 18 10:48:16 localhost kernel:  [<c0404fca>] syscall_call+0x7/0xb
Jul 18 10:48:16 localhost kernel:  =======================
Jul 18 10:50:22 localhost syslogd 1.4.2: restart.


