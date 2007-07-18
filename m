Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXGRHUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXGRHUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXGRHTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:19:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49746 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbXGRHTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:19:54 -0400
Date: Wed, 18 Jul 2007 09:18:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Carsten Emde <carsten.emde@osadl.org>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.Stanford.EDU>,
       Steven Rostedt <rostedt@goodmis.org>,
       RT-Users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rui Nuno Capela <rncbc@rncbc.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: v2.6.21.5-rt19 (sched_getaffinity?)
Message-ID: <20070718071852.GB1516@elte.hu>
References: <1183758545.20747.34.camel@cmn3.stanford.edu> <20070707092401.GB21234@elte.hu> <1183934205.11854.11.camel@cmn3.stanford.edu> <46917678.70700@googlemail.com> <Pine.LNX.4.63.0707082047130.12404@cmn3.stanford.edu> <1183957703.12681.4.camel@cmn3.stanford.edu> <20070717193223.GJ26283@elte.hu> <1184702217.21931.19.camel@cmn3.stanford.edu> <20070717201242.GB2426@elte.hu> <1184716305.21931.39.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184716305.21931.39.camel@cmn3.stanford.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> > does lockdep pinpoint anything?
> 
> Lots of stuff, and at the end the lock report for the problem. 
> Hopefully some of this will help... I have attached the whole bootup 
> sequence as logged in /var/log/messages.

yeah, it pinpointed the bug. It seems to be an interaction between 
RCU-preempt (Paul Cc:-ed) and sched_mc_power_savings_store(): 
detach_destroy_domains() uses synchronize_sched() which uses 
getaffinity, which takes sched_hotcpu_mutex, and 
arch_reinit_sched_domains does it too - see the lockdep report below. 
I've added a quick workaround below as well, which should keep your box 
from hanging.

	Ingo

=============================================
[ INFO: possible recursive locking detected ]
[ 2.6.22-0182.rt4.3.fc7.ccrmart #1
---------------------------------------------
sched-powersave/3251 is trying to acquire lock:
 (sched_hotcpu_mutex){--..}, at: [<c0424a37>] sched_getaffinity+0x14/0x94

but task is already holding lock:
 (sched_hotcpu_mutex){--..}, at: [<c04245a5>] arch_reinit_sched_domains+0xe/0x33

other info that might help us debug this:
1 lock held by sched-powersave/3251:
 #0:  (sched_hotcpu_mutex){--..}, at: [<c04245a5>] arch_reinit_sched_domains+0xe/0x33

stack backtrace:
 [<c040600c>] show_trace_log_lvl+0x1a/0x2f
 [<c0406ae8>] show_trace+0x12/0x14
 [<c0406b50>] dump_stack+0x16/0x18
 [<c0446f46>] __lock_acquire+0x172/0xb67
 [<c0447d03>] lock_acquire+0x56/0x6f
 [<c061d414>] _mutex_lock+0x2b/0x38
 [<c0424a37>] sched_getaffinity+0x14/0x94
 [<c0460841>] __synchronize_sched+0x11/0x5f
 [<c0423fa8>] detach_destroy_domains+0x2c/0x30
 [<c04245af>] arch_reinit_sched_domains+0x18/0x33
 [<c0424606>] sched_power_savings_store+0x3c/0x49
 [<c0424634>] sched_mc_power_savings_store+0xe/0x10
 [<c0561f11>] sysdev_class_store+0x20/0x25
 [<c04bbc6c>] sysfs_write_file+0xaf/0xd0
 [<c048183c>] vfs_write+0xaf/0x163
 [<c0481e8a>] sys_write+0x3d/0x61
 [<c040501a>] syscall_call+0x7/0xb
 =======================
thinkpad_acpi: ThinkPad ACPI Extras v0.14

--------------------->
Index: linux-rt.q/kernel/sched.c
===================================================================
--- linux-rt.q.orig/kernel/sched.c
+++ linux-rt.q/kernel/sched.c
@@ -6699,7 +6699,6 @@ static void detach_destroy_domains(const
 
 	for_each_cpu_mask(i, *cpu_map)
 		cpu_attach_domain(NULL, i);
-	synchronize_sched();
 	arch_destroy_sched_domains(cpu_map);
 }
 


